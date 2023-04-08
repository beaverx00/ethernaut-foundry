// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {GatekeeperThreeFactory} from "src/levels/GatekeeperThreeFactory.sol";
import {GatekeeperThreeAttack} from "src/attacks/GatekeeperThreeAttack.sol";

contract GatekeeperThreeTest is Test {
    GatekeeperThreeFactory public level;
    address public target;
    address public player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new GatekeeperThreeFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance(player);
        vm.warp(1_234_567);
    }

    function test_GatekeeperThree() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.deal(player, 1 ether);
        vm.startPrank(player, player);

        GatekeeperThreeAttack gatekeeperThreeAttack = new GatekeeperThreeAttack(
            target
        );
        gatekeeperThreeAttack.pwn{value: 0.1 ether}();

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(target), player);
        assertEq(success, true);
    }
}
