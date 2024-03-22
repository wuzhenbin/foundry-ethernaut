// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*  
下面的合约表示了一个很简单的游戏: 任何一个发送了高于目前价格的人将成为新的国王. 
在这个情况下, 上一个国王将会获得新的出价, 这样可以赚得一些以太币. 看起来像是庞氏骗局.

这么有趣的游戏, 你的目标是攻破他.
当你提交实例给关卡时, 关卡会重新申明王位. 
你需要阻止他重获王位来通过这一关.
*/

contract King {
    address king;
    uint256 public prize;
    address public owner;

    constructor() payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address) {
        return king;
    }
}