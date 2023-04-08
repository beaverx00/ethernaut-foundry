// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {ShopFactory} from "src/levels/ShopFactory.sol";
import {ShopAttack} from "src/attacks/ShopAttack.sol";

contract ShopTest is Test {
    ShopFactory public level;
    address public target;
    address public player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new ShopFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance(player);
    }

    function test_Shop() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.startPrank(player);

        ShopAttack shopAttack = new ShopAttack(target);
        shopAttack.pwn();

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(target), player);
        assertEq(success, true);
    }
}
