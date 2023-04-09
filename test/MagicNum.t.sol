// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {MagicNumFactory} from "src/levels/MagicNumFactory.sol";
import {MagicNumAttack} from "src/attacks/MagicNumAttack.sol";

contract MagicNumTest is Test {
    MagicNumFactory level;
    address target;
    address player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new MagicNumFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance(player);
    }

    function test_MagicNum() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.startPrank(player);

        MagicNumAttack magicNumAttack = new MagicNumAttack(target);
        magicNumAttack.pwn();

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(target), player);
        assertEq(success, true);
    }
}
