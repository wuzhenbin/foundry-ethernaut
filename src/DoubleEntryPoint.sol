// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin8/contracts/access/Ownable.sol";
import "@openzeppelin8/contracts/token/ERC20/ERC20.sol";

/*  
本关特色是名为 CryptoVault 的特殊功能， 即 sweepToken 函数。 
这是用于检索卡在合约中的代币的常用函数。 
CryptoVault 使用无法清除的底层代币(underlying)运行，
因为它是 CryptoVault 的重要核心逻辑组件， 可以清除任何其他令牌。

底层代币是在 DoubleEntryPoint 合约定义中实现的 DET 代币实例，
CryptoVault 拥有 100 units 此外，CryptoVault 还持有 100 个 LegacyToken LGT。

在本关中，您应该找出 CryptoVault 中的错误位置，并保护它不被耗尽代币。

该合约继承有一个 Forta 合约，任何用户都可以在其中注册自己的检测机器人(detection bot)合约。 
Forta 是一个去中心化的、基于社区的监控网络，
用于尽快检测 DeFi、NFT、治理代币、区块链桥以及其他 Web3 系统上的威胁和异常。 
您的工作是设计一个检测机器人(detection bot)并将其注册到 Forta 合约中。 
机器人的需要发出正确的警报(alerts)，以防止潜在的攻击或漏洞利用。

可能有帮助的事情：
代币合约的双入口是如何运行的？
*/

interface DelegateERC20 {
    function delegateTransfer(address to, uint256 value, address origSender) external returns (bool);
}

interface IDetectionBot {
    function handleTransaction(address user, bytes calldata msgData) external;
}

interface IForta {
    function setDetectionBot(address detectionBotAddress) external;
    function notify(address user, bytes calldata msgData) external;
    function raiseAlert(address user) external;
}

contract Forta is IForta {
    // somebody -> bot
    mapping(address => IDetectionBot) public usersDetectionBots;
    // bot alert times
    mapping(address => uint256) public botRaisedAlerts;
    // set somebody's bot

    function setDetectionBot(address detectionBotAddress) external override {
        usersDetectionBots[msg.sender] = IDetectionBot(detectionBotAddress);
    }

    function notify(address user, bytes calldata msgData) external override {
        // the bot no exist
        if (address(usersDetectionBots[user]) == address(0)) return;
        //
        try usersDetectionBots[user].handleTransaction(user, msgData) {
            return;
        } catch {}
    }

    function raiseAlert(address user) external override {
        // bot add errors
        if (address(usersDetectionBots[user]) != msg.sender) return;
        botRaisedAlerts[msg.sender] += 1;
    }
}

contract CryptoVault {
    address public sweptTokensRecipient;
    IERC20 public underlying;

    constructor(address recipient) {
        sweptTokensRecipient = recipient;
    }

    function setUnderlying(address latestToken) public {
        require(address(underlying) == address(0), "Already set");
        underlying = IERC20(latestToken);
    }

    /*
    ...
    */

    function sweepToken(IERC20 token) public {
        require(token != underlying, "Can't transfer underlying token");
        token.transfer(sweptTokensRecipient, token.balanceOf(address(this)));
    }
}

contract LegacyToken is ERC20("LegacyToken", "LGT"), Ownable {
    DelegateERC20 public delegate;

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function delegateToNewContract(DelegateERC20 newContract) public onlyOwner {
        delegate = newContract;
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        if (address(delegate) == address(0)) {
            return super.transfer(to, value);
        } else {
            return delegate.delegateTransfer(to, value, msg.sender);
        }
    }
}

contract DoubleEntryPoint is ERC20("DoubleEntryPointToken", "DET"), DelegateERC20, Ownable {
    address public cryptoVault;
    address public player;
    address public delegatedFrom;
    Forta public forta;

    constructor(address legacyToken, address vaultAddress, address fortaAddress, address playerAddress) {
        delegatedFrom = legacyToken;
        forta = Forta(fortaAddress);
        player = playerAddress;
        cryptoVault = vaultAddress;
        _mint(cryptoVault, 100 ether);
    }

    modifier onlyDelegateFrom() {
        require(msg.sender == delegatedFrom, "Not legacy contract");
        _;
    }

    modifier fortaNotify() {
        address detectionBot = address(forta.usersDetectionBots(player));

        // Cache old number of bot alerts
        uint256 previousValue = forta.botRaisedAlerts(detectionBot);

        // Notify Forta
        forta.notify(player, msg.data);

        // Continue execution
        _;

        // Check if alarms have been raised
        if (forta.botRaisedAlerts(detectionBot) > previousValue) revert("Alert has been triggered, reverting");
    }

    // sweptTokensRecipient, CryptoVault's Total Balance, CryptoVault's Address
    function delegateTransfer(address to, uint256 value, address origSender)
        public
        override
        onlyDelegateFrom
        fortaNotify
        returns (bool)
    {
        _transfer(origSender, to, value);
        return true;
    }
}
