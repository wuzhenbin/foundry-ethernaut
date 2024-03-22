// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";

contract ForceTest is Test {
    Vault public vault;

    address alice = address(1);

    function setUp() public {
        bytes32 psw = "hellokitty";
        vault = new Vault(psw);
    }

    function testAttack() public {
        bytes32 psw = vm.load(address(vault), bytes32(uint256(1)));
        vm.prank(alice);
        vault.unlock(psw);
        assertEq(vault.locked(), false);
    }
}
