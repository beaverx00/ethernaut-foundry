// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import {ReentranceFactory} from "src/levels/ReentranceFactory.sol";
import {ReentranceAttack} from "src/attacks/ReentranceAttack.sol";

contract ReentranceTest is Test {
    ReentranceFactory level;
    address target;
    address player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new ReentranceFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance{value: 0.001 ether}(player);
    }

    function test_Reentrance() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.deal(player, 1 ether);
        vm.startPrank(player);

        ReentranceAttack reentranceAttack = new ReentranceAttack(target);
        reentranceAttack.pwn{value: 0.0003 ether}();

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(target), player);
        assertEq(success, true);
    }
}
