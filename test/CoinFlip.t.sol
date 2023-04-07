// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Ethernaut} from "src/Ethernaut.sol";
import {Statistics} from "src/metrics/Statistics.sol";
import {CoinFlipFactory} from "src/levels/CoinFlipFactory.sol";
import {CoinFlipper} from "src/attacks/CoinFlipper.sol";

contract CoinFlipTest is Test {
    Ethernaut public ethernaut;
    CoinFlipFactory public level;

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
        level = new CoinFlipFactory();
        ethernaut.registerLevel(level);
    }

    function test_CoinFlip() public {
        address PLAYER = makeAddr("PLAYER");
        address target;

        vm.startPrank(PLAYER);
        vm.recordLogs();

        // ----------------------------------
        // Create level instance
        // ----------------------------------
        ethernaut.createLevelInstance(level);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        target = payable(address(uint160(uint256(entries[0].topics[2]))));

        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.roll(1_000_000);
        CoinFlipper coinFlipper = new CoinFlipper(target);

        for (uint256 i; i < 10; ++i) {
            vm.roll(block.number + 42);
            coinFlipper.catchFlip();
        }

        // ----------------------------------
        // Validate
        // ----------------------------------
        ethernaut.submitLevelInstance(payable(address(target)));
        entries = vm.getRecordedLogs();
        assertEq(entries.length, 2);
    }
}
