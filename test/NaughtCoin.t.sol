// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {NaughtCoinFactory} from "src/levels/NaughtCoinFactory.sol";
import {NaughtCoinAttack} from "src/attacks/NaughtCoinAttack.sol";

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

contract NaughtCoinTest is Test {
    NaughtCoinFactory public level;
    IERC20 public target;
    address public player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new NaughtCoinFactory();
        player = makeAddr("PLAYER");
        target = IERC20(level.createInstance(player));
    }

    function test_NaughtCoin() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.startPrank(player);

        NaughtCoinAttack naughtCoinAttack = new NaughtCoinAttack(
            address(target)
        );
        target.approve(address(naughtCoinAttack), target.balanceOf(player));
        naughtCoinAttack.pwn();

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(address(target)), player);
        assertEq(success, true);
    }
}
