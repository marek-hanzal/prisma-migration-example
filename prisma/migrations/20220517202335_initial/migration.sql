-- CreateEnum
CREATE TYPE "JobStatus" AS ENUM ('NEW', 'RUNNING', 'SUCCESS', 'FAILURE', 'REVIEW', 'DONE');

-- CreateEnum
CREATE TYPE "MixtureError" AS ENUM ('LESS', 'MORE', 'FULL');

-- CreateTable
CREATE TABLE "Account" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    "refresh_token" TEXT,
    "access_token" TEXT,
    "expires_at" INTEGER,
    "token_type" TEXT,
    "scope" TEXT,
    "id_token" TEXT,
    "session_state" TEXT,
    "oauth_token_secret" TEXT,
    "oauth_token" TEXT,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "name" TEXT,
    "email" TEXT,
    "emailVerified" TIMESTAMP(3),
    "image" TEXT,
    "tariffId" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VerificationToken" (
    "identifier" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL
);

-- CreateTable
CREATE TABLE "Token" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "until" TIMESTAMP(3),

    CONSTRAINT "Token_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserToken" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "tokenId" TEXT NOT NULL,

    CONSTRAINT "UserToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Translation" (
    "id" TEXT NOT NULL,
    "language" VARCHAR(32) NOT NULL,
    "label" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "hash" VARCHAR(128) NOT NULL,

    CONSTRAINT "Translation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "File" (
    "id" TEXT NOT NULL,
    "path" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "mime" TEXT NOT NULL,
    "size" INTEGER NOT NULL,
    "location" TEXT NOT NULL,
    "ttl" INTEGER,
    "created" TIMESTAMP(3) NOT NULL,
    "updated" TIMESTAMP(3),
    "userId" TEXT NOT NULL,

    CONSTRAINT "File_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Job" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "status" "JobStatus" NOT NULL DEFAULT E'NEW',
    "total" INTEGER NOT NULL DEFAULT 0,
    "progress" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "success" INTEGER,
    "successRatio" DOUBLE PRECISION,
    "failure" INTEGER,
    "failureRatio" DOUBLE PRECISION,
    "skip" INTEGER,
    "skipRatio" DOUBLE PRECISION,
    "created" TIMESTAMP(3) NOT NULL,
    "started" TIMESTAMP(3),
    "finished" TIMESTAMP(3),
    "userId" TEXT,
    "params" TEXT,

    CONSTRAINT "Job_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "JobLog" (
    "id" TEXT NOT NULL,
    "jobId" TEXT NOT NULL,
    "message" TEXT NOT NULL,

    CONSTRAINT "JobLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Metric" (
    "id" TEXT NOT NULL,
    "reference" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "start" DOUBLE PRECISION,
    "value" DOUBLE PRECISION NOT NULL,
    "label" TEXT,
    "userId" TEXT,

    CONSTRAINT "Metric_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Comment" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "comment" TEXT NOT NULL,
    "created" TIMESTAMP(3) NOT NULL,
    "public" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Comment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tag" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "label" TEXT,
    "group" TEXT NOT NULL,
    "sort" INTEGER,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Vendor" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Vendor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tariff" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "description" TEXT,
    "from" TIMESTAMP(3),
    "to" TIMESTAMP(3),
    "created" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Tariff_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Price" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "price" DECIMAL(10,2) NOT NULL,
    "tariffId" TEXT NOT NULL,
    "from" TIMESTAMP(3),
    "to" TIMESTAMP(3),
    "created" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Price_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Transaction" (
    "id" TEXT NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "created" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "priceId" TEXT,
    "note" TEXT,

    CONSTRAINT "Transaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Atomizer" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "vendorId" TEXT NOT NULL,
    "typeId" TEXT NOT NULL,
    "coilMin" DOUBLE PRECISION,
    "coilMax" DOUBLE PRECISION,
    "dualCoil" BOOLEAN NOT NULL DEFAULT false,
    "squonk" BOOLEAN NOT NULL DEFAULT false,
    "cost" DOUBLE PRECISION,

    CONSTRAINT "Atomizer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AtomizerDraw" (
    "id" TEXT NOT NULL,
    "atomizerId" TEXT NOT NULL,
    "drawId" TEXT NOT NULL,

    CONSTRAINT "AtomizerDraw_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AtomizerComment" (
    "id" TEXT NOT NULL,
    "atomizerId" TEXT NOT NULL,
    "commentId" TEXT NOT NULL,

    CONSTRAINT "AtomizerComment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AtomizerInventory" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "atomizerId" TEXT NOT NULL,
    "transactionId" TEXT NOT NULL,

    CONSTRAINT "AtomizerInventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Cell" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "voltage" DOUBLE PRECISION NOT NULL,
    "drain" DOUBLE PRECISION,
    "ohm" DOUBLE PRECISION,
    "cost" DOUBLE PRECISION NOT NULL,
    "typeId" TEXT NOT NULL,
    "vendorId" TEXT NOT NULL,

    CONSTRAINT "Cell_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CellInventory" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "cellId" TEXT NOT NULL,
    "transactionId" TEXT NOT NULL,

    CONSTRAINT "CellInventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CellComment" (
    "id" TEXT NOT NULL,
    "cellId" TEXT NOT NULL,
    "commentId" TEXT NOT NULL,

    CONSTRAINT "CellComment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Mod" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "vendorId" TEXT NOT NULL,
    "cost" DOUBLE PRECISION NOT NULL,
    "voltage" DOUBLE PRECISION NOT NULL,
    "power" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "Mod_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ModCell" (
    "id" TEXT NOT NULL,
    "modId" TEXT NOT NULL,
    "cellId" TEXT NOT NULL,

    CONSTRAINT "ModCell_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ModInventory" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "modId" TEXT NOT NULL,
    "transactionId" TEXT NOT NULL,

    CONSTRAINT "ModInventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ModComment" (
    "id" TEXT NOT NULL,
    "modId" TEXT NOT NULL,
    "commentId" TEXT NOT NULL,

    CONSTRAINT "ModComment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Cotton" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "vendorId" TEXT NOT NULL,
    "cost" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "Cotton_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CottonDraw" (
    "id" TEXT NOT NULL,
    "cottonId" TEXT NOT NULL,
    "drawId" TEXT NOT NULL,

    CONSTRAINT "CottonDraw_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CottonInventory" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "cottonId" TEXT NOT NULL,
    "transactionId" TEXT NOT NULL,

    CONSTRAINT "CottonInventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CottonComment" (
    "id" TEXT NOT NULL,
    "cottonId" TEXT NOT NULL,
    "commentId" TEXT NOT NULL,

    CONSTRAINT "CottonComment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Voucher" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "cost" DOUBLE PRECISION NOT NULL,
    "maxFortune" DOUBLE PRECISION,

    CONSTRAINT "Voucher_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VoucherInventory" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "voucherId" TEXT NOT NULL,
    "transactionId" TEXT NOT NULL,

    CONSTRAINT "VoucherInventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Aroma" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "cost" DOUBLE PRECISION NOT NULL,
    "content" DOUBLE PRECISION NOT NULL,
    "volume" DOUBLE PRECISION,
    "pg" DOUBLE PRECISION NOT NULL,
    "vg" DOUBLE PRECISION NOT NULL,
    "vendorId" TEXT NOT NULL,
    "steep" INTEGER NOT NULL DEFAULT 14,

    CONSTRAINT "Aroma_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AromaTaste" (
    "id" TEXT NOT NULL,
    "aromaId" TEXT NOT NULL,
    "tasteId" TEXT NOT NULL,

    CONSTRAINT "AromaTaste_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AromaComment" (
    "id" TEXT NOT NULL,
    "aromaId" TEXT NOT NULL,
    "commentId" TEXT NOT NULL,

    CONSTRAINT "AromaComment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AromaInventory" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "aromaId" TEXT NOT NULL,
    "transactionId" TEXT NOT NULL,

    CONSTRAINT "AromaInventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Booster" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "cost" DOUBLE PRECISION NOT NULL,
    "volume" DOUBLE PRECISION NOT NULL,
    "nicotine" INTEGER NOT NULL,
    "pg" INTEGER NOT NULL,
    "vg" INTEGER NOT NULL,
    "vendorId" TEXT NOT NULL,

    CONSTRAINT "Booster_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BoosterInventory" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "boosterId" TEXT NOT NULL,
    "transactionId" TEXT NOT NULL,

    CONSTRAINT "BoosterInventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Base" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "cost" DOUBLE PRECISION NOT NULL,
    "pg" INTEGER NOT NULL,
    "vg" INTEGER NOT NULL,
    "vendorId" TEXT NOT NULL,

    CONSTRAINT "Base_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BaseInventory" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "baseId" TEXT NOT NULL,
    "transactionId" TEXT NOT NULL,

    CONSTRAINT "BaseInventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Liquid" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "mixtureId" TEXT NOT NULL,
    "aromaId" TEXT NOT NULL,
    "vendorId" TEXT NOT NULL,
    "boosterId" TEXT,
    "baseId" TEXT,
    "transactionId" TEXT NOT NULL,
    "created" TIMESTAMP(3) NOT NULL,
    "mixed" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Liquid_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Mixture" (
    "id" TEXT NOT NULL,
    "hash" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "volume" DOUBLE PRECISION NOT NULL,
    "content" DOUBLE PRECISION NOT NULL,
    "available" DOUBLE PRECISION NOT NULL,
    "diff" DOUBLE PRECISION NOT NULL,
    "nicotine" DOUBLE PRECISION NOT NULL,
    "nicotineToRound" INTEGER NOT NULL,
    "vg" DOUBLE PRECISION NOT NULL,
    "pg" DOUBLE PRECISION NOT NULL,
    "vgToMl" DOUBLE PRECISION NOT NULL,
    "vgToRound" INTEGER NOT NULL,
    "pgToMl" DOUBLE PRECISION NOT NULL,
    "pgToRound" INTEGER NOT NULL,
    "aromaId" TEXT NOT NULL,
    "vendorId" TEXT NOT NULL,
    "boosterId" TEXT,
    "boosterCount" INTEGER NOT NULL,
    "baseId" TEXT,
    "baseMl" DOUBLE PRECISION NOT NULL,
    "error" "MixtureError",

    CONSTRAINT "Mixture_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MixtureDraw" (
    "id" TEXT NOT NULL,
    "mixtureId" TEXT NOT NULL,
    "drawId" TEXT NOT NULL,

    CONSTRAINT "MixtureDraw_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MixtureInventory" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "mixtureId" TEXT NOT NULL,
    "aromaId" TEXT NOT NULL,
    "vendorId" TEXT NOT NULL,
    "boosterId" TEXT,
    "baseId" TEXT,

    CONSTRAINT "MixtureInventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Build" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "created" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "Build_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Coil" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "size" DOUBLE PRECISION NOT NULL,
    "wraps" INTEGER NOT NULL,
    "wireId" TEXT NOT NULL,

    CONSTRAINT "Coil_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CoilDraw" (
    "id" TEXT NOT NULL,
    "coilId" TEXT NOT NULL,
    "drawId" TEXT NOT NULL,

    CONSTRAINT "CoilDraw_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Wire" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "cost" DOUBLE PRECISION NOT NULL,
    "isTCR" BOOLEAN NOT NULL,
    "mm" DOUBLE PRECISION NOT NULL,
    "mmToRound" DOUBLE PRECISION NOT NULL,
    "vendorId" TEXT NOT NULL,

    CONSTRAINT "Wire_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WireInventory" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "wireId" TEXT NOT NULL,
    "transactionId" TEXT NOT NULL,

    CONSTRAINT "WireInventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WireDraw" (
    "id" TEXT NOT NULL,
    "wireId" TEXT NOT NULL,
    "drawId" TEXT NOT NULL,

    CONSTRAINT "WireDraw_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WireFiber" (
    "id" TEXT NOT NULL,
    "count" INTEGER NOT NULL,
    "wireId" TEXT NOT NULL,
    "fiberId" TEXT NOT NULL,

    CONSTRAINT "WireFiber_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Fiber" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "mm" DOUBLE PRECISION NOT NULL,
    "ga" INTEGER NOT NULL,
    "materialId" TEXT NOT NULL,

    CONSTRAINT "Fiber_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Account_provider_providerAccountId_key" ON "Account"("provider", "providerAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_token_key" ON "VerificationToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_identifier_token_key" ON "VerificationToken"("identifier", "token");

-- CreateIndex
CREATE UNIQUE INDEX "Token_name_key" ON "Token"("name");

-- CreateIndex
CREATE UNIQUE INDEX "UserToken_userId_tokenId_key" ON "UserToken"("userId", "tokenId");

-- CreateIndex
CREATE UNIQUE INDEX "Translation_language_hash_key" ON "Translation"("language", "hash");

-- CreateIndex
CREATE UNIQUE INDEX "Tag_code_group_key" ON "Tag"("code", "group");

-- CreateIndex
CREATE UNIQUE INDEX "Vendor_name_key" ON "Vendor"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Tariff_code_key" ON "Tariff"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Atomizer_code_key" ON "Atomizer"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Atomizer_name_vendorId_key" ON "Atomizer"("name", "vendorId");

-- CreateIndex
CREATE UNIQUE INDEX "AtomizerInventory_code_key" ON "AtomizerInventory"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Cell_code_key" ON "Cell"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Cell_name_vendorId_key" ON "Cell"("name", "vendorId");

-- CreateIndex
CREATE UNIQUE INDEX "CellInventory_code_key" ON "CellInventory"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Mod_code_key" ON "Mod"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Mod_name_vendorId_key" ON "Mod"("name", "vendorId");

-- CreateIndex
CREATE UNIQUE INDEX "ModInventory_code_key" ON "ModInventory"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Cotton_code_key" ON "Cotton"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Cotton_name_vendorId_key" ON "Cotton"("name", "vendorId");

-- CreateIndex
CREATE UNIQUE INDEX "CottonInventory_code_key" ON "CottonInventory"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Voucher_name_key" ON "Voucher"("name");

-- CreateIndex
CREATE UNIQUE INDEX "VoucherInventory_code_key" ON "VoucherInventory"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Aroma_code_key" ON "Aroma"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Aroma_name_vendorId_key" ON "Aroma"("name", "vendorId");

-- CreateIndex
CREATE UNIQUE INDEX "AromaInventory_code_key" ON "AromaInventory"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Booster_code_key" ON "Booster"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Booster_name_vendorId_key" ON "Booster"("name", "vendorId");

-- CreateIndex
CREATE UNIQUE INDEX "BoosterInventory_code_key" ON "BoosterInventory"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Base_code_key" ON "Base"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Base_name_vendorId_key" ON "Base"("name", "vendorId");

-- CreateIndex
CREATE UNIQUE INDEX "BaseInventory_code_key" ON "BaseInventory"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Liquid_code_key" ON "Liquid"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Mixture_hash_key" ON "Mixture"("hash");

-- CreateIndex
CREATE UNIQUE INDEX "Mixture_code_key" ON "Mixture"("code");

-- CreateIndex
CREATE INDEX "Mixture_nicotineToRound_vgToRound_pgToRound_aromaId_vendorI_idx" ON "Mixture" USING BRIN ("nicotineToRound", "vgToRound", "pgToRound", "aromaId", "vendorId", "boosterId", "baseId");

-- CreateIndex
CREATE INDEX "MixtureInventory_userId_mixtureId_aromaId_vendorId_boosterI_idx" ON "MixtureInventory" USING BRIN ("userId", "mixtureId", "aromaId", "vendorId", "boosterId", "baseId");

-- CreateIndex
CREATE UNIQUE INDEX "MixtureInventory_userId_mixtureId_key" ON "MixtureInventory"("userId", "mixtureId");

-- CreateIndex
CREATE UNIQUE INDEX "Build_code_key" ON "Build"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Coil_code_key" ON "Coil"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Coil_name_wireId_key" ON "Coil"("name", "wireId");

-- CreateIndex
CREATE UNIQUE INDEX "Wire_code_key" ON "Wire"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Wire_name_vendorId_key" ON "Wire"("name", "vendorId");

-- CreateIndex
CREATE UNIQUE INDEX "WireInventory_code_key" ON "WireInventory"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Fiber_code_key" ON "Fiber"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Fiber_ga_materialId_key" ON "Fiber"("ga", "materialId");

-- AddForeignKey
ALTER TABLE "Account" ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_tariffId_fkey" FOREIGN KEY ("tariffId") REFERENCES "Tariff"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserToken" ADD CONSTRAINT "UserToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserToken" ADD CONSTRAINT "UserToken_tokenId_fkey" FOREIGN KEY ("tokenId") REFERENCES "Token"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "File" ADD CONSTRAINT "File_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Job" ADD CONSTRAINT "Job_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JobLog" ADD CONSTRAINT "JobLog_jobId_fkey" FOREIGN KEY ("jobId") REFERENCES "Job"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Metric" ADD CONSTRAINT "Metric_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Price" ADD CONSTRAINT "Price_tariffId_fkey" FOREIGN KEY ("tariffId") REFERENCES "Tariff"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_priceId_fkey" FOREIGN KEY ("priceId") REFERENCES "Price"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Atomizer" ADD CONSTRAINT "Atomizer_typeId_fkey" FOREIGN KEY ("typeId") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Atomizer" ADD CONSTRAINT "Atomizer_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "Vendor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AtomizerDraw" ADD CONSTRAINT "AtomizerDraw_drawId_fkey" FOREIGN KEY ("drawId") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AtomizerDraw" ADD CONSTRAINT "AtomizerDraw_atomizerId_fkey" FOREIGN KEY ("atomizerId") REFERENCES "Atomizer"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AtomizerComment" ADD CONSTRAINT "AtomizerComment_commentId_fkey" FOREIGN KEY ("commentId") REFERENCES "Comment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AtomizerComment" ADD CONSTRAINT "AtomizerComment_atomizerId_fkey" FOREIGN KEY ("atomizerId") REFERENCES "Atomizer"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AtomizerInventory" ADD CONSTRAINT "AtomizerInventory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AtomizerInventory" ADD CONSTRAINT "AtomizerInventory_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "Transaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AtomizerInventory" ADD CONSTRAINT "AtomizerInventory_atomizerId_fkey" FOREIGN KEY ("atomizerId") REFERENCES "Atomizer"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Cell" ADD CONSTRAINT "Cell_typeId_fkey" FOREIGN KEY ("typeId") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Cell" ADD CONSTRAINT "Cell_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "Vendor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CellInventory" ADD CONSTRAINT "CellInventory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CellInventory" ADD CONSTRAINT "CellInventory_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "Transaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CellInventory" ADD CONSTRAINT "CellInventory_cellId_fkey" FOREIGN KEY ("cellId") REFERENCES "Cell"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CellComment" ADD CONSTRAINT "CellComment_commentId_fkey" FOREIGN KEY ("commentId") REFERENCES "Comment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CellComment" ADD CONSTRAINT "CellComment_cellId_fkey" FOREIGN KEY ("cellId") REFERENCES "Cell"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Mod" ADD CONSTRAINT "Mod_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "Vendor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ModCell" ADD CONSTRAINT "ModCell_cellId_fkey" FOREIGN KEY ("cellId") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ModCell" ADD CONSTRAINT "ModCell_modId_fkey" FOREIGN KEY ("modId") REFERENCES "Mod"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ModInventory" ADD CONSTRAINT "ModInventory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ModInventory" ADD CONSTRAINT "ModInventory_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "Transaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ModInventory" ADD CONSTRAINT "ModInventory_modId_fkey" FOREIGN KEY ("modId") REFERENCES "Mod"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ModComment" ADD CONSTRAINT "ModComment_commentId_fkey" FOREIGN KEY ("commentId") REFERENCES "Comment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ModComment" ADD CONSTRAINT "ModComment_modId_fkey" FOREIGN KEY ("modId") REFERENCES "Mod"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Cotton" ADD CONSTRAINT "Cotton_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "Vendor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CottonDraw" ADD CONSTRAINT "CottonDraw_drawId_fkey" FOREIGN KEY ("drawId") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CottonDraw" ADD CONSTRAINT "CottonDraw_cottonId_fkey" FOREIGN KEY ("cottonId") REFERENCES "Cotton"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CottonInventory" ADD CONSTRAINT "CottonInventory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CottonInventory" ADD CONSTRAINT "CottonInventory_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "Transaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CottonInventory" ADD CONSTRAINT "CottonInventory_cottonId_fkey" FOREIGN KEY ("cottonId") REFERENCES "Cotton"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CottonComment" ADD CONSTRAINT "CottonComment_commentId_fkey" FOREIGN KEY ("commentId") REFERENCES "Comment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CottonComment" ADD CONSTRAINT "CottonComment_cottonId_fkey" FOREIGN KEY ("cottonId") REFERENCES "Cotton"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoucherInventory" ADD CONSTRAINT "VoucherInventory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoucherInventory" ADD CONSTRAINT "VoucherInventory_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "Transaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoucherInventory" ADD CONSTRAINT "VoucherInventory_voucherId_fkey" FOREIGN KEY ("voucherId") REFERENCES "Voucher"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Aroma" ADD CONSTRAINT "Aroma_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "Vendor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AromaTaste" ADD CONSTRAINT "AromaTaste_tasteId_fkey" FOREIGN KEY ("tasteId") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AromaTaste" ADD CONSTRAINT "AromaTaste_aromaId_fkey" FOREIGN KEY ("aromaId") REFERENCES "Aroma"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AromaComment" ADD CONSTRAINT "AromaComment_commentId_fkey" FOREIGN KEY ("commentId") REFERENCES "Comment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AromaComment" ADD CONSTRAINT "AromaComment_aromaId_fkey" FOREIGN KEY ("aromaId") REFERENCES "Aroma"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AromaInventory" ADD CONSTRAINT "AromaInventory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AromaInventory" ADD CONSTRAINT "AromaInventory_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "Transaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AromaInventory" ADD CONSTRAINT "AromaInventory_aromaId_fkey" FOREIGN KEY ("aromaId") REFERENCES "Aroma"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Booster" ADD CONSTRAINT "Booster_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "Vendor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BoosterInventory" ADD CONSTRAINT "BoosterInventory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BoosterInventory" ADD CONSTRAINT "BoosterInventory_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "Transaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BoosterInventory" ADD CONSTRAINT "BoosterInventory_boosterId_fkey" FOREIGN KEY ("boosterId") REFERENCES "Booster"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Base" ADD CONSTRAINT "Base_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "Vendor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BaseInventory" ADD CONSTRAINT "BaseInventory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BaseInventory" ADD CONSTRAINT "BaseInventory_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "Transaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BaseInventory" ADD CONSTRAINT "BaseInventory_baseId_fkey" FOREIGN KEY ("baseId") REFERENCES "Base"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Liquid" ADD CONSTRAINT "Liquid_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Liquid" ADD CONSTRAINT "Liquid_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "Vendor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Liquid" ADD CONSTRAINT "Liquid_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "Transaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Liquid" ADD CONSTRAINT "Liquid_aromaId_fkey" FOREIGN KEY ("aromaId") REFERENCES "Aroma"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Liquid" ADD CONSTRAINT "Liquid_boosterId_fkey" FOREIGN KEY ("boosterId") REFERENCES "Booster"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Liquid" ADD CONSTRAINT "Liquid_baseId_fkey" FOREIGN KEY ("baseId") REFERENCES "Base"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Liquid" ADD CONSTRAINT "Liquid_mixtureId_fkey" FOREIGN KEY ("mixtureId") REFERENCES "Mixture"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Mixture" ADD CONSTRAINT "Mixture_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "Vendor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Mixture" ADD CONSTRAINT "Mixture_aromaId_fkey" FOREIGN KEY ("aromaId") REFERENCES "Aroma"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Mixture" ADD CONSTRAINT "Mixture_boosterId_fkey" FOREIGN KEY ("boosterId") REFERENCES "Booster"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Mixture" ADD CONSTRAINT "Mixture_baseId_fkey" FOREIGN KEY ("baseId") REFERENCES "Base"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MixtureDraw" ADD CONSTRAINT "MixtureDraw_drawId_fkey" FOREIGN KEY ("drawId") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MixtureDraw" ADD CONSTRAINT "MixtureDraw_mixtureId_fkey" FOREIGN KEY ("mixtureId") REFERENCES "Mixture"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MixtureInventory" ADD CONSTRAINT "MixtureInventory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MixtureInventory" ADD CONSTRAINT "MixtureInventory_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "Vendor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MixtureInventory" ADD CONSTRAINT "MixtureInventory_aromaId_fkey" FOREIGN KEY ("aromaId") REFERENCES "Aroma"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MixtureInventory" ADD CONSTRAINT "MixtureInventory_boosterId_fkey" FOREIGN KEY ("boosterId") REFERENCES "Booster"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MixtureInventory" ADD CONSTRAINT "MixtureInventory_baseId_fkey" FOREIGN KEY ("baseId") REFERENCES "Base"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MixtureInventory" ADD CONSTRAINT "MixtureInventory_mixtureId_fkey" FOREIGN KEY ("mixtureId") REFERENCES "Mixture"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Build" ADD CONSTRAINT "Build_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Coil" ADD CONSTRAINT "Coil_wireId_fkey" FOREIGN KEY ("wireId") REFERENCES "Wire"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CoilDraw" ADD CONSTRAINT "CoilDraw_drawId_fkey" FOREIGN KEY ("drawId") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CoilDraw" ADD CONSTRAINT "CoilDraw_coilId_fkey" FOREIGN KEY ("coilId") REFERENCES "Coil"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Wire" ADD CONSTRAINT "Wire_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "Vendor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WireInventory" ADD CONSTRAINT "WireInventory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WireInventory" ADD CONSTRAINT "WireInventory_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "Transaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WireInventory" ADD CONSTRAINT "WireInventory_wireId_fkey" FOREIGN KEY ("wireId") REFERENCES "Wire"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WireDraw" ADD CONSTRAINT "WireDraw_drawId_fkey" FOREIGN KEY ("drawId") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WireDraw" ADD CONSTRAINT "WireDraw_wireId_fkey" FOREIGN KEY ("wireId") REFERENCES "Wire"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WireFiber" ADD CONSTRAINT "WireFiber_wireId_fkey" FOREIGN KEY ("wireId") REFERENCES "Wire"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WireFiber" ADD CONSTRAINT "WireFiber_fiberId_fkey" FOREIGN KEY ("fiberId") REFERENCES "Fiber"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Fiber" ADD CONSTRAINT "Fiber_materialId_fkey" FOREIGN KEY ("materialId") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;
