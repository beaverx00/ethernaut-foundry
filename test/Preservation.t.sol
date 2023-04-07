// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {PreservationFactory} from "src/levels/PreservationFactory.sol";
import {PreservationAttack} from "src/attacks/PreservationAttack.sol";

contract PreservationTest is Test {
    PreservationFactory public level;
    address public target;
    address public player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new PreservationFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance(player);
    }

    function test_Preservation() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.startPrank(player);

        PreservationAttack preservationAttack = new PreservationAttack(
            address(target)
        );
        preservationAttack.pwn();

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(target), player);
        assertEq(success, true);
    }
}
