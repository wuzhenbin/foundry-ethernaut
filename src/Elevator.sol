// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* 
电梯不会让你达到大楼顶部, 对吧?
目标: top = true

这可能有帮助:
Sometimes solidity is not good at keeping promises.
This Elevator expects to be used from a Building.
*/

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}
