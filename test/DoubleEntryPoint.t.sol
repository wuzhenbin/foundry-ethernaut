// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DoubleEntryPoint, LegacyToken, CryptoVault, Forta} from "../src/DoubleEntryPoint.sol";

contract DoubleEntryPointTest is Test {
    DoubleEntryPoint public doubleEntryPoint;
    LegacyToken legacyToken;
    CryptoVault cryptoVault;
    Forta forta;

    address alice = makeAddr("alice");

    function setUp() public {
        vm.startPrank(alice);

        legacyToken = new LegacyToken();
        cryptoVault = new CryptoVault(alice);
        forta = new Forta();
        doubleEntryPoint = new DoubleEntryPoint(address(legacyToken), address(cryptoVault), address(forta), alice);

        vm.stopPrank();
    }

    function testAttack() public {}
}
