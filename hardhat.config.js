require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  let count = 0
  for (const account of accounts) {
    console.log(account.address);
    count ++
  }
  console.log(count)
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  networks: {
    localhost: {
      url: "http://127.0.0.1:7545"
    },
    bscTestnet:{
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      accounts: [process.env.WALLET_PRIVATEKEY]
    }
  },
  solidity: "0.8.9",
};
