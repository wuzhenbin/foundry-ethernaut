// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {Script} from "forge-std/Script.sol";
import "forge-std/console.sol";

import {Motorbike, Engine, Destructive, Address} from "../src/Motorbike.sol";
// import {DevOpsTools} from "foundry-devops/DevOpsTools.sol";

contract MotorbikeInteract is Script {
    uint256 private1 = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    Motorbike motorbike = Motorbike(0x8464135c8F25Da09e49BC8782676a84730C318bC);
    Engine engine = Engine(0x5FbDB2315678afecb367f032d93F642f64180aa3);
    Destructive destructive = Destructive(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512);

    function getSize(address c) public view returns (uint32) {
        uint32 size;
        assembly {
            size := extcodesize(c)
        }
        return size;
    }

    function run() external {
        // vm.startBroadcast(private1);

        // engine.initialize();
        // engine.upgradeToAndCall(address(destructive), abi.encodeWithSignature("killed()"));

        // vm.stopBroadcast();

        // console.log(Address.isContract(address(engine)));
        console.log(getSize(address(engine)));
    }
}
