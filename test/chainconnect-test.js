/** @format */

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Chain Connect Token", function () {
  it("Deploying Chain Connect Token", async function () {
    const ChainConnectToken = await ethers.getContractFactory("ChainConnectToken");
    const chainConnectToken = await ChainConnectToken.deploy();
      await chainConnectToken.deployed();
      console.log("Chain Connect Token Address: ", chainConnectToken.getAddress())
  });
});


// describe("Chain Connect Plateform", function () {
//   it("Deploying Chain Connect Plateform", async function () {
//     const ChainConnect = await ethers.getContractFactory("ChainConnect");
//     const chainConnect = await ChainConnect.deploy();
//     await chainConnect.deployed();
//     console.log("Chain Connect Address: ", chainConnect.getAddress());
//   });
// });