// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin8/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin8/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin8/contracts/access/Ownable.sol";

/* 
此题目的目标是让您破解下面的基本合约并通过价格操纵窃取资金。

一开始您可以得到10个token1和token2。合约以每个代币100个开始。

如果您设法从合约中取出两个代币中的至少一个，并让合约得到一个的“坏”的token价格，您将在此级别上取得成功。

注意： 通常，当您使用ERC20代币进行交换时，您必须approve合约才能为您使用代币。
为了与题目的语法保持一致，我们刚刚向合约本身添加了approve方法。
因此，请随意使用 contract.approve(contract.address, <uint amount>) 而不是直接调用代币，
它会自动批准将两个代币花费所需的金额。 请忽略SwappableToken合约。

可能有帮助的注意点：

代币的价格是如何计算的？
approve方法如何工作？
您如何批准ERC20 的交易？
*/

contract Dex is Ownable {
    address public token1;
    address public token2;

    constructor() {}

    function setTokens(address _token1, address _token2) public onlyOwner {
        token1 = _token1;
        token2 = _token2;
    }

    function addLiquidity(address token_address, uint256 amount) public onlyOwner {
        IERC20(token_address).transferFrom(msg.sender, address(this), amount);
    }

    function swap(address from, address to, uint256 amount) public {
        require((from == token1 && to == token2) || (from == token2 && to == token1), "Invalid tokens");
        require(IERC20(from).balanceOf(msg.sender) >= amount, "Not enough to swap");
        uint256 swapAmount = getSwapPrice(from, to, amount);
        IERC20(from).transferFrom(msg.sender, address(this), amount);
        IERC20(to).approve(address(this), swapAmount);
        IERC20(to).transferFrom(address(this), msg.sender, swapAmount);
    }

    function getSwapPrice(address from, address to, uint256 amount) public view returns (uint256) {
        return ((amount * IERC20(to).balanceOf(address(this))) / IERC20(from).balanceOf(address(this)));
    }

    function approve(address spender, uint256 amount) public {
        SwappableToken(token1).approve(msg.sender, spender, amount);
        SwappableToken(token2).approve(msg.sender, spender, amount);
    }

    function balanceOf(address token, address account) public view returns (uint256) {
        return IERC20(token).balanceOf(account);
    }
}

contract SwappableToken is ERC20 {
    address private _dex;

    constructor(address dexInstance, string memory name, string memory symbol, uint256 initialSupply)
        ERC20(name, symbol)
    {
        _mint(msg.sender, initialSupply);
        _dex = dexInstance;
    }

    function approve(address owner, address spender, uint256 amount) public {
        require(owner != _dex, "InvalidApprover");
        super._approve(owner, spender, amount);
    }
}
