// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin-contracts/token/ERC20/ERC20.sol";
contract  ARB is ERC20 {
    constructor(uint256 initialSupply) ERC20("ARB token", "ARB") {
        _mint(msg.sender, initialSupply); //18 decimals
        
    }
}