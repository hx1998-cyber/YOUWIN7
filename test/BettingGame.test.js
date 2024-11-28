// 测试文件，用于测试合约功能
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BettingGame", function () {
  it("Should deploy successfully", async function () {
    const BettingGame = await ethers.getContractFactory("BettingGame");
    const bettingGame = await BettingGame.deploy("测试国库地址");
    await bettingGame.deployed();
    expect(await bettingGame.treasuryAddress()).to.not.equal(0);
  });
});
