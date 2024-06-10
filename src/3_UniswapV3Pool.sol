// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "lib/v3-core/contracts/interfaces/IUniswapV3Factory.sol";


contract UniswapV3PoolCreator {
    address public factory;
    
    // Event to log the address of the created pool
    event PoolCreated(address indexed tokenARB, address indexed tokenDAI, uint24 fee, address pool);

    constructor(address _factory) {
        factory = _factory;
    }

    function createUniswapV3Pool(address tokenARB, address tokenDAI, uint24 fee) external  returns (address pool) {{
    // Ensure token addresses are different
    require(tokenARB != tokenDAI, "UniswapV3PoolCreator: IDENTICAL_ADDRESSES");
    
    // Ensure token addresses are not zero addresses
    require(tokenARB != address(0) && tokenDAI != address(0), "UniswapV3PoolCreator: ZERO_ADDRESS");

    // Create the pool
     pool = IUniswapV3Factory(factory).createPool(tokenARB, tokenDAI, fee);
    
    // Emit the event
    emit PoolCreated(tokenARB, tokenDAI, fee, pool);
}

}
}

