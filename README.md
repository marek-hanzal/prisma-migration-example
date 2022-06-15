# Prisma Migration Example
Example repository with combining native Prisma Migration and TS support with some other tools to make that work.

## The Toolbox
- Prisma - for the best thing it can do and for generating Prisma Migration (you can even apply them)
- Umzug - for running migrations; this should be main executor of migrations as it handles TypeScript support
- Others - things from `@leight-core` package can be omitted, I've keep here reference just because there are some helpers for executing SQL file
- Most important is `src/cli/migration.ts` which should be executed as a standalone script (do not run it through transpiler; it works even on Next.js)
- `npm run migration` - so look into `package.json` to see how a migration **must** be executed to work properly

## The Idea

This is quite raw barebone implementation of Prisma Migrations with TypeScript support for migration execution.

It uses Umzug as the migration executor, but Prisma Migrate for SQL migrations.

It should be compatible with current projects as it reads and writes to Prisma's migration table, so if by any time
Prisma implements TS execution support, it could work by default.

## The Limitations

Ok, some are there:
- the pain with creating migration folder - could be by hand or by doing "dummy" Prisma schema change, generate migration, revert Prisma schema change
- if there is TS migration (`migration.ts`), there must be an **empty** `migration.sql` file or Prisma will cry it's not there
- General workflow - do structure migration by SQLs, do _data/code_ migration by a new migration with TS and empty `migration.sql`

## The Epilog

So, this was created for my project:
https://github.com/marek-hanzal/puff-smith

There you can see the full working example of migration stuff on a real project; here is just some picks which should guide you with an idea.

If you find some way how to improve or make this basic repository as *real* working example, you're free to go.
