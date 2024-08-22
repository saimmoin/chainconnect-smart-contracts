/** @format */

const hre = require("hardhat");

async function main() {
  const provider = ethers.provider;

  const [bob] = await ethers.getSigners();

  // Get bob wallet's ethers balance
  let bobBalance = await provider.getBalance(bob.address);
  console.log("Bob Balance: ", ethers.utils.formatEther(bobBalance));


  const ChainConnect = await hre.ethers.getContractFactory("ChainConnect", bob);
  const chainConnect = await ChainConnect.deploy("Chain Connect", "CC", bob.address, "0x8586f51864021FcDBaaBbcF0dA566F23c9B3c7A3");
  await chainConnect.deployed();
  console.log("Contract Deployed To: ", chainConnect.address);
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
