// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMagicNum {
    function setSolver(address _solver) external;
}

contract MagicNumAttack {
    IMagicNum target;

    constructor(address _target) {
        target = IMagicNum(_target);
    }

    function pwn() external {
        /*
           Runtime code: 0x602a60005260206000F3
           -
           PUSH1 42
           PUSH1 0
           MSTORE
           PUSH1 32
           PUSH1 0
           RETURN
        */
        /*
           Creation code: 0x69602a60005260206000F3600052600a6016F3
           -
           PUSH10 <Runtime Code> 
           PUSH1 0
           MSTORE
           PUSH1 10 
           PUSH1 22 
           RETURN
        */
        address solver;
        bytes memory bytecode = hex"69602a60005260206000F3600052600a6016F3";
        assembly {
            solver := create(0, add(bytecode, 0x20), mload(bytecode))
        }
        target.setSolver(solver);
    }
}
