// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {TelephoneFactory} from "src/levels/TelephoneFactory.sol";
import {TelephoneAttack} from "src/attacks/TelephoneAttack.sol";

contract TelephoneTest is Test {
    TelephoneFactory public level;
    address public target;
    address public player;

    function setUp() public {
        // ----------------------------------
        // Register level
        // ----------------------------------
        level = new TelephoneFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance(player);
    }

    function test_Telephone() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.startPrank(player);

        TelephoneAttack telephoneAttack = new TelephoneAttack(target);
        telephoneAttack.pwn();

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(target), player);
        assertEq(success, true);
    }
}
