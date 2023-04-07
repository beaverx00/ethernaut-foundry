// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Ethernaut} from "src/Ethernaut.sol";
import {Statistics} from "src/metrics/Statistics.sol";
import {TelephoneFactory} from "src/levels/TelephoneFactory.sol";
import {TelephoneAttack} from "src/attacks/TelephoneAttack.sol";

contract TelephoneTest is Test {
    Ethernaut public ethernaut;
    TelephoneFactory public level;

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
        level = new TelephoneFactory();
        ethernaut.registerLevel(level);
    }

    function test_Telephone() public {
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
        TelephoneAttack telephoneAttack = new TelephoneAttack(target);
        telephoneAttack.pwn();

        // ----------------------------------
        // Validate
        // ----------------------------------
        ethernaut.submitLevelInstance(payable(address(target)));
        entries = vm.getRecordedLogs();
        assertEq(entries.length, 2);
    }
}
