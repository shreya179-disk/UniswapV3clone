// scripts/deploy.js
const { ethers } = require("hardhat");

async function main() {
    // Addresses of the deployed contracts
    const nfpmAddress = ""; // Uniswap V3 NonfungiblePositionManager
    const daiAddress = ""; // DAI on sepolia
    const arbAddress = ""; // ARB on sepolia

    // Get the contract factory
    const LiquidityProvider = await ethers.getContractFactory("LiquidityProvider");

    // Deploy the contract
    const liquidityProvider = await LiquidityProvider.deploy(nfpmAddress, daiAddress, arbAddress);

    await liquidityProvider.deployed();

    console.log("LiquidityProvider deployed to:", liquidityProvider.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
      console.error(error);
      process.exit(1);
  });
