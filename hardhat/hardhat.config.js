require("@nomiclabs/hardhat-waffle");
require('@openzeppelin/hardhat-upgrades');
require("@nomiclabs/hardhat-etherscan");
require("hardhat-deploy");
require("solidity-coverage");
require("hardhat-gas-reporter");
require("hardhat-contract-sizer");
require("@appliedblockchain/chainlink-plugins-fund-link");
require("dotenv").config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks:{
    rinkeby:{
      url: "https://rinkeby.infura.io/v3/4f3e89c81dfc4f3792d16b407960c483",
      accounts: ["0x7af7b855c20b58e85249792c1df4ba7c66f9cb9e0e1fb148d6948cdf69136fc7"],
      // accounts: {
      //   mnemonic: "finish replace truth lady analyst welcome youth exist skirt this burger ball",
      // },
      saveDeployments: true,
      chainId: 4,
    },
  },
  etherscan:{
    // npx hardhat verify --network rinkeby 0x49062073eeab600d9E0cdEF2e6B1D2415E51Fcb6 "0x7af7b855c20b58e85249792c1df4ba7c66f9cb9e0e1fb148d6948cdf69136fc7"
    apiKey:{
      rinkeby: "K5ESJSV1X64S8VXMA6SIFF1GKGGYN4BGSH",
    },
  },
};
