// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {DenialFactory} from "src/levels/DenialFactory.sol";
import {DenialAttack} from "src/attacks/DenialAttack.sol";

contract DenialTest is Test {
    DenialFactory level;
    address target;
    address player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new DenialFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance{value: 0.001 ether}(player);
    }

    function test_Denial() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.startPrank(player);

        DenialAttack denialAttack = new DenialAttack(target);
        denialAttack.pwn();

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(target), player);
        assertEq(success, true);
    }
}
