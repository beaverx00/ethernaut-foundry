// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {GoodSamaritanFactory} from "src/levels/GoodSamaritanFactory.sol";
import {GoodSamaritanAttack} from "src/attacks/GoodSamaritanAttack.sol";

interface IGoodSamaritan {
    function requestDonation() external returns (bool);
}

contract GoodSamaritanTest is Test {
    GoodSamaritanFactory public level;
    address public target;
    address public player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new GoodSamaritanFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance(player);
    }

    function test_GoodSamaritan() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.startPrank(player);

        GoodSamaritanAttack goodSamaritanAttack = new GoodSamaritanAttack(
            target
        );
        goodSamaritanAttack.pwn();
        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(target), player);
        assertEq(success, true);
    }
}
