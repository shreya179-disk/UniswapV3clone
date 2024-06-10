const { ethers } = require("ethers");
const fs = require("fs");

async function deploy() {
  // Load compiled contract ABI and bytecode
  const contractABI = JSON.parse(fs.readFileSync("./UniswapV3PoolCreator.json")).abi;
  const contractBytecode = JSON.parse(fs.readFileSync("./UniswapV3PoolCreator.json")).bytecode;

  // Connect to the Ethereum network using Infura
  const provider = new ethers.providers.InfuraProvider("mainnet", "YOUR_INFURA_PROJECT_ID");

  // Define the wallet private key and address
  const privateKey = "YOUR_PRIVATE_KEY";  
  const wallet = new ethers.Wallet(privateKey, provider);

  // Create a ContractFactory to deploy the contract
  const ContractFactory = new ethers.ContractFactory(contractABI, contractBytecode, wallet);

  // Deploy the contract with the Uniswap V3 Factory address
  const factoryAddress = "0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24"; // Uniswap V3 Factory address(Base Sepolia Address)
  const contract = await ContractFactory.deploy(factoryAddress);

  console.log("Contract deployed to address:", contract.address);
}

deploy().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
