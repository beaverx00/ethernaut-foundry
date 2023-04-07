// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {GatekeeperOneFactory} from "src/levels/GatekeeperOneFactory.sol";
import {GatekeeperOneAttack} from "src/attacks/GatekeeperOneAttack.sol";

contract GatekeeperOneTest is Test {
    GatekeeperOneFactory public level;
    address public target;
    address public player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new GatekeeperOneFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance(player);
    }

    function test_GatekeeperOne() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.startPrank(player, player);

        GatekeeperOneAttack gatekeeperOneAttack = new GatekeeperOneAttack(
            target
        );
        gatekeeperOneAttack.pwn();

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(target), player);
        assertEq(success, true);
    }
}
