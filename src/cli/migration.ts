import prisma from "....your prisma client";
import {sha256} from "...some sha256 implementation...";
import {executeSql, runSql} from "@leight-core/server";
import {PrismaClient} from "@prisma/client";
import fs from "node:fs";
import path from "node:path";
import {Umzug} from "umzug";
import {v4} from "uuid";

/**
 *
 */
const EMPTY_MIGRATION = "__empty__";

const ensureMigrationTable = async (prisma: PrismaClient) => {
	try {
		await executeSql(`
			create table _prisma_migrations
			(
				id                  varchar(36)  not null primary key,
				checksum            varchar(64)  not null,
				finished_at         timestamp with time zone,
				migration_name      varchar(255) not null,
				logs                text,
				rolled_back_at      timestamp with time zone,
				started_at          timestamp with time zone default now() not null,
				applied_steps_count integer                  default 0 not null
			);

			alter table _prisma_migrations owner to "puff-smith";
		`, prisma);
	} catch (e) {
	}
};

const umzug = new Umzug({
	migrations: {
		glob: process.cwd() + "/prisma/migrations/**/*.{ts,sql}",
		resolve: params => {
			const {context: prisma} = params;
			const name = path.normalize(params.path!.replace(process.cwd(), ""))
				.replaceAll("\\", "/")
				.replaceAll("/prisma/migrations", "")
				.replaceAll(/migration.(ts|sql)/g, "")
				.replaceAll("/", "");
			if (fs.readFileSync(params.path!).length === 0) {
				return {
					name: EMPTY_MIGRATION,
					up: async () => {
					},
				};
			}
			if (params.path?.endsWith(".sql")) {
				return {
					name,
					up: async () => runSql(params.path as string, prisma),
				};
			}
			const defaults = Umzug.defaultResolver(params);
			return {
				...defaults,
				name,
			};
		},
	},
	storage: {
		logMigration: async ({context: prisma, ...params}) => {
			if (params.name === EMPTY_MIGRATION) {
				return;
			}
			await ensureMigrationTable(prisma);
			const hash = sha256(fs.readFileSync(params.path!).toString());
			await prisma.$executeRaw`INSERT INTO _prisma_migrations VALUES (${v4()}, ${hash}, NOW(), ${params.name}, NULL, NULL, now(), 1)`;
		},
		unlogMigration: async params => {
		},
		executed: async ({context: prisma}) => {
			await ensureMigrationTable(prisma);
			return (await prisma.$queryRaw<{ migration_name: string }[]>`SELECT migration_name FROM _prisma_migrations ORDER BY migration_name ASC`).map(({migration_name}) => migration_name);
		},
	},
	context: prisma,
	logger: undefined,
});

export type IMigration = typeof umzug._types.migration;

umzug.up()
	.then(() => process.exit(0))
	.catch(e => {
		console.error(e);
		process.exit(1);
	});
