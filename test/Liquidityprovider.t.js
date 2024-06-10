const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("LiquidityProvider", function () {
    let LiquidityProvider, liquidityProvider;
    let dai, arb;
    let owner, addr1;

    beforeEach(async function () {
        [owner, addr1] = await ethers.getSigners();

        const nfpmAddress = "0xC36442b4a4522E871399CD717aBDD847Ab11FE88"; // Uniswap V3 NonfungiblePositionManager
        const daiAddress = DAI_ADDRESS; 
        const arbAddress = ARB_ADDRESS; 

        LiquidityProvider = await ethers.getContractFactory("LiquidityProvider");
        liquidityProvider = await LiquidityProvider.deploy(nfpmAddress, daiAddress, arbAddress);

        await liquidityProvider.deployed();
    });

    it("Should mint new position and refund excess tokens", async function () {
        // Mint tokens for addr1
        const dai = await ethers.getContractAt("IERC20", "DAI_ADDRESS", addr1);
        const arb = await ethers.getContractAt("IERC20", "ARB_ADDRES", addr1);

        // Approve tokens for LiquidityProvider contract
        await dai.approve(liquidityProvider.address, ethers.utils.parseEther("1000"));
        await arb.approve(liquidityProvider.address, ethers.utils.parseEther("1000"));

        // Mint new position
        await liquidityProvider.connect(addr1).mintNewPosition(ethers.utils.parseEther("10"), ethers.utils.parseEther("10"));

        // Check balances
        const daiBalance = await dai.balanceOf(addr1.address);
        const arbBalance = await arb.balanceOf(addr1.address);

        console.log("DAI balance:", daiBalance.toString());
        console.log("ARB balance:", arbBalance.toString());

        expect(daiBalance).to.be.lte(ethers.utils.parseEther("990"));
        expect(arbBalance).to.be.lte(ethers.utils.parseEther("990"));
    });
});
