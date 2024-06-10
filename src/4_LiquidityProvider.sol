// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin-contracts/token/ERC20/IERC20.sol";


interface INonfungiblePositionManager {

    struct MintParams {
        address token0;
        address token1;
        uint24 fee;
        int24 tickLower;
        int24 tickUpper;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        address recipient;
        uint256 deadline;
    }
    struct CollectParams {
        uint256 tokenId;
        address recipient;
        uint128 amount0Max;
        uint128 amount1Max;
    }
    function mint(MintParams calldata params)
        external
        payable
        returns (
            uint256 tokenId,
            uint128 liquidity,
            uint256 amount0,
            uint256 amount1
        );


    
    function collect(CollectParams calldata params) external returns (uint256 amount0, uint256 amount1);
}


contract LiquidityProvider {

    INonfungiblePositionManager public immutable nfpm;
    IERC20 public immutable dai;
    IERC20 public immutable arb;

    uint24 public constant poolFee = 2000;
    address public  nfpmAddress;

    constructor(address _nfpm, address _dai, address _arb) {
        nfpm = INonfungiblePositionManager(_nfpm);
        nfpmAddress= _nfpm;
        dai = IERC20(_dai);
        arb = IERC20(_arb);
    }

    function mintNewPosition(uint256 amount0ToAdd, uint256 amount1ToAdd)
        external
        returns (
            uint256 tokenId,
            uint128 liquidity,
            uint256 amount0,
            uint256 amount1
        )
    {
        dai.transferFrom(msg.sender, address(this), amount0ToAdd);
        arb.transferFrom(msg.sender, address(this), amount1ToAdd);

        dai.approve(address(nfpm), amount0ToAdd);
        arb.approve(address(nfpm), amount1ToAdd);

        INonfungiblePositionManager.MintParams memory params =
        INonfungiblePositionManager.MintParams({
            token0: address(dai),
            token1: address(arb),
            fee: 3000,
            tickLower: -887272,
            tickUpper: 887272,
            amount0Desired: amount0ToAdd,
            amount1Desired: amount1ToAdd,
            amount0Min: 0,
            amount1Min: 0,
            recipient: address(this),
            deadline: block.timestamp
        });

        (tokenId, liquidity, amount0, amount1) =
            nfpm.mint(params);

        if (amount0 < amount0ToAdd) {
            dai.approve(address(nfpm), 0);
            uint256 refund0 = amount0ToAdd - amount0;
            dai.transfer(msg.sender, refund0);
        }
        if (amount1 < amount1ToAdd) {
            arb.approve(address(nfpm), 0);
            uint256 refund1 = amount1ToAdd - amount1;
            arb.transfer(msg.sender, refund1);
        }
    }
    function _sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, "Identical addresses");
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
    }

    function getSwapFees(uint256 tokenId) external view returns (uint256 amount0, uint256 amount1) {
        INonfungiblePositionManager.CollectParams memory params = INonfungiblePositionManager.CollectParams({
            tokenId: tokenId,
            recipient: address(this),
            amount0Max: type(uint128).max,
            amount1Max: type(uint128).max
        });

        (bool success, bytes memory data) = nfpmAddress.staticcall(
            abi.encodeWithSelector(
                INonfungiblePositionManager.collect.selector,
                params
            )
        );

        require(success, "Static call failed");

        // Decode the returned data
        (amount0, amount1) = abi.decode(data, (uint256, uint256));
    }

    
}