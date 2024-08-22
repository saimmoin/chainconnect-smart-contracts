/** @format */

require("@nomiclabs/hardhat-waffle");
require("@nomicfoundation/hardhat-verify");

module.exports = {
  solidity: { version: "0.8.26", settings: { optimizer: { enabled: true, runs: 200 } } },
  defaultNetwork: "hardhat",

  networks: {
    aurora: {
      url: "https://testnet.aurora.dev",
      accounts: ["YOUR PRIVATE KEY !"],
    },
  },
  etherscan: {
    apiKey: {
      auroraTestnet: "MD23ZTR2YBBUSYABQK1ZJK4ZBPSQ86B3V2",
    },
  },
};
