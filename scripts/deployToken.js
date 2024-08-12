/** @format */

const { ethers } = require("hardhat");

async function main() {
  const provider = ethers.provider;

  const [owner] = await ethers.getSigners();

  // Get owner wallet's ethers balance
  let ownerBalance = await provider.getBalance(owner.address);
  console.log("Owner Balance: ", ethers.utils.formatEther(ownerBalance));


//   const ChainConnectToken = await ethers.getContractFactory("ChainConnectToken");
//   const chainConnectToken = await ChainConnectToken.deploy();
//   await chainConnectToken.deployed();
//   console.log("Contract Deployed To: ", chainConnectToken.address);
}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
