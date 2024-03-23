// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {MagicNum} from "../src/MagicNumber.sol";

/* 
Run time code - return 42
Creation code - return runtime code - 限制最大10个字节码
*/

/* 
[runtimecode -> return 42]
PUSH1 0x42
PUSH1 0
MSTORE
PUSH1 32
PUSH1 0
RETURN
=>
0x602A60005260206000F3 return 0x42

[creation_code -> runtimecode]
00000000000000000000000000000000000000000000602a60005260206000f3
22bytes + 10bytes

PUSH10  0x602A60005260206000F3
PUSH1   00
MSTORE
PUSH1 0x0A  // 10bytes
PUSH1 0x16  // pos -> 22 => 0x16
RETURN
=>
69602A60005260206000F3600052600A6016F3 return 0x602A60005260206000F3
*/

interface Solver {
    function whatIsTheMeaningOfLife() external view returns (uint256);
}

contract MagicNumberFactory {
    // Deploys a contract that always returns 42
    function deploy() external returns (address addr) {
        bytes memory bytecode = hex"69602a60005260206000f3600052600a6016f3";
        assembly {
            // create(msg.value, offset, size)
            // 引用类型跳过前面32bytes(0x20) 引用类型的数据类型前32字节存储此数据的length
            // bytecode长度19bytes(0x13)
            addr := create(0, add(bytecode, 0x20), 0x13)
        }
        require(addr != address(0));
    }
}

contract MagicNumberTest is Test {
    MagicNum public magicNum;
    MagicNumberFactory magicFactory;

    address alice = address(1);

    function setUp() public {
        magicFactory = new MagicNumberFactory();
    }

    function testAttack() public {
        address solver = magicFactory.deploy();
        Solver solvers = Solver(solver);
        uint256 magic = solvers.whatIsTheMeaningOfLife();

        assertEq(magic, 42);

        uint256 size;
        assembly {
            size := extcodesize(solvers)
        }
        assertLe(size, 10);
    }
}
