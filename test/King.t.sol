// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {KingFactory} from "src/levels/KingFactory.sol";
import {KingAttack} from "src/attacks/KingAttack.sol";

contract KingTest is Test {
    KingFactory level;
    address target;
    address player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new KingFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance{value: 0.001 ether}(player);
    }

    function test_King() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.deal(player, 1 ether);
        vm.startPrank(player);

        // Deploy contract not having receive/fallback function
        KingAttack kingAttack = new KingAttack(target);
        kingAttack.pwn{value: 0.1 ether}();

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(target), player);
        assertEq(success, true);
    }
}
