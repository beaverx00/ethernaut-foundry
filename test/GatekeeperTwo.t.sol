// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {GatekeeperTwoFactory} from "src/levels/GatekeeperTwoFactory.sol";
import {GatekeeperTwoAttack} from "src/attacks/GatekeeperTwoAttack.sol";

contract GatekeeperTwoTest is Test {
    GatekeeperTwoFactory public level;
    address public target;
    address public player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new GatekeeperTwoFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance(player);
    }

    function test_GatekeeperTwo() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.prank(player, player);
        new GatekeeperTwoAttack(target);

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(target), player);
        assertEq(success, true);
    }
}
