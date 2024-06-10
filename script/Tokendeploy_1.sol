// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "src/1_ARB.sol";
import "src/2_DAI.sol";


contract Tokendeploy {
    event TokenDeployed(address tokenAddress, string tokenSymbol);

    function run() external {
        uint256 initialSupply = 1000000 * 10**18; // 2 million tokens with 18 decimals

        // Deploy DAI token
        DAI dai = new DAI(initialSupply);
        emit TokenDeployed(address(dai), "DAI");

        // Deploy ARB token
        ARB arb = new ARB(initialSupply);
        emit TokenDeployed(address(arb), "ARB");
    }
}
