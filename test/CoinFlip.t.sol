// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {CoinFlipFactory} from "src/levels/CoinFlipFactory.sol";
import {CoinFlipAttack} from "src/attacks/CoinFlipAttack.sol";

contract CoinFlipTest is Test {
    CoinFlipFactory public level;
    address public target;
    address public player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new CoinFlipFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance(player);
    }

    function test_CoinFlip() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.startPrank(player);
        vm.roll(1_000_000);
        CoinFlipAttack coinFlipAttack = new CoinFlipAttack(target);

        for (uint256 i; i < 10; ++i) {
            vm.roll(block.number + 42);
            coinFlipAttack.pwn();
        }
        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(address(target)), player);
        assertEq(success, true);
    }
}
