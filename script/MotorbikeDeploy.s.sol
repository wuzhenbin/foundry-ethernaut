// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {Script} from "forge-std/Script.sol";
import "forge-std/console.sol";

import {Motorbike, Engine, Destructive} from "../src/Motorbike.sol";

contract DeployMotorbike is Script {
    uint256 private1 = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 private2 = 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;

    function run() external {
        vm.startBroadcast(private1);

        Engine engine = new Engine();
        Destructive destructive = new Destructive();

        vm.stopBroadcast();

        vm.startBroadcast(private2);

        Motorbike motorbike = new Motorbike(address(engine));

        vm.stopBroadcast();

        console.log("engine:");
        console.logAddress(address(engine));

        console.log("motorbike:");
        console.logAddress(address(motorbike));

        console.log("destructive:");
        console.logAddress(address(destructive));
    }
}
