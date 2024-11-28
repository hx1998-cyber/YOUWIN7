// 部署脚本，用于将合约部署到区块链
const hre = require("hardhat");

async function main() {
  // 部署合约
  const BettingGame = await hre.ethers.getContractFactory("BettingGame");
  const bettingGame = await BettingGame.deploy("国库地址");
  await bettingGame.deployed();

  console.log("BettingGame deployed to:", bettingGame.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
