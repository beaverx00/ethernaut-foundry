// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {ForceFactory} from "src/levels/ForceFactory.sol";
import {ForceAttack} from "src/attacks/ForceAttack.sol";

contract ForceTest is Test {
    ForceFactory public level;
    address public target;
    address public player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new ForceFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance(player);
    }

    function test_Force() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.deal(player, 1 ether);
        vm.startPrank(player);

        ForceAttack forceAttack = new ForceAttack{value: 42}(target);

        // selfdestruct transfers all balances to designated address
        // Not revert regardless of whether that address has receive/payable function
        forceAttack.pwn();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(target), player);
        assertEq(success, true);
    }
}
