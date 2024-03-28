// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DoubleEntryPoint, LegacyToken, CryptoVault, Forta, DelegateERC20, IDetectionBot} from "../src/DoubleEntryPoint.sol";

/*  
LegacyToken
- delegate 即是 DoubleEntryPoint 合约， 
- delegateToNewContract 函数由 owner 设置

DoubleEntryPoint
- 本身代币 -DET 构造函数定义所有地址 为CryptoVault铸造100 个DET
- 修饰符 onlyDelegateFrom 只能由 legacyToken 合约执行
- 修饰符 fortaNotify 执行完 delegateTransfer 函数以后如果机器人如果检测到新错误产生 交易回滚
此时机器人并没有做任何事 需要后续添加
- delegateTransfer 

CryptoVault
- sweepToken的功能是将合约内的token都转到 sweptTokensRecipient 
但是要排除底层代币 
- 底层代币 underlying(DoubleEntryPoint) 只能设置一次
*/

/*  
在DetectionBot中发出警报的条件 - 判断origSender是否为cryptoVault合约

handleTransaction(address,bytes) 
0x220ab6aa          4bytes
address             32bytes
Offset of msgData   32bytes
Length of msgData   32bytes

delegateTransfer(address,uint256,address)
0x9cd1a121          4bytes 
address             32bytes  
uint256             32bytes    
address             32bytes

origSender的位置为168(a8)
*/

contract MyDetectionBot is IDetectionBot {
    address public cryptoVaultAddress;

    constructor(address _cryptoVaultAddress) {
        cryptoVaultAddress = _cryptoVaultAddress;
    }

    // we can comment out the variable name to silence "unused parameter" error
    function handleTransaction(
        address user,
        bytes calldata /* msgData */
    ) external override {
        // extract sender from calldata
        address origSender;
        assembly {
            origSender := calldataload(0xa8)
        }
        // raise alert only if the msg.sender is CryptoVault contract
        if (origSender == cryptoVaultAddress) {
            Forta(msg.sender).raiseAlert(user);
        }
    }
}

contract DoubleEntryPointTest is Test {
    DoubleEntryPoint public doubleEntryPoint;
    LegacyToken legacyToken;
    CryptoVault cryptoVault;
    Forta forta;

    address alice = makeAddr("alice");

    function setUp() public {
        vm.startPrank(alice);

        legacyToken = new LegacyToken();
        cryptoVault = new CryptoVault(alice);
        forta = new Forta();
        doubleEntryPoint = new DoubleEntryPoint(
            address(legacyToken),
            address(cryptoVault),
            address(forta),
            alice
        );

        legacyToken.delegateToNewContract(DelegateERC20(doubleEntryPoint));
        legacyToken.mint(address(cryptoVault), 100 ether);
        cryptoVault.setUnderlying(address(doubleEntryPoint));

        vm.stopPrank();
    }

    function testAttack() public {
        // 初始状态 CryptoVault 拥有 100个底层代币 还有 100 个 LGT
        assertEq(doubleEntryPoint.balanceOf(address(cryptoVault)), 100 ether);
        assertEq(legacyToken.balanceOf(address(cryptoVault)), 100 ether);

        cryptoVault.sweepToken(legacyToken);

        /* 执行流程
        legacyToken.transfer(
            sweptTokensRecipient, 
            legacyToken.balanceOf(cryptoVault)
        );

        doubleEntryPoint.delegateTransfer(
            sweptTokensRecipient, 
            legacyToken.balanceOf(cryptoVault), 
            address(cryptoVault)
        );

        doubleEntryPoint._transfer(
            address(cryptoVault), 
            sweptTokensRecipient, 
            legacyToken.balanceOf(cryptoVault)
        );
        */

        assertEq(doubleEntryPoint.balanceOf(address(cryptoVault)), 0 ether);
    }

    function testAttackFailWithBot() public {
        vm.startPrank(alice);

        MyDetectionBot bot = new MyDetectionBot(address(cryptoVault));
        forta.setDetectionBot(address(bot));

        vm.stopPrank();

        vm.expectRevert(bytes("Alert has been triggered, reverting"));
        cryptoVault.sweepToken(legacyToken);
    }
}
