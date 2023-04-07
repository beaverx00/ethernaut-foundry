// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {ElevatorFactory} from "src/levels/ElevatorFactory.sol";
import {ElevatorAttack} from "src/attacks/ElevatorAttack.sol";

contract ElevatorTest is Test {
    ElevatorFactory public level;
    address public target;
    address public player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new ElevatorFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance(player);
    }

    function test_Elevator() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.startPrank(player);

        ElevatorAttack elevatorAttack = new ElevatorAttack(target);
        elevatorAttack.pwn();

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(target), player);
        assertEq(success, true);
    }
}
