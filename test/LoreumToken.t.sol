// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.18;

import {LORE} from "src/LORE.sol";
import {Test} from "lib/forge-std/src/Test.sol";
import {TestActors} from "script/Actors.sol";
import {Constants} from "script/Constants.sol";

contract LoreumTokenTests is Test {
    LORE lore;
    address constant BONES = address(1);

    function setUp() public {
        lore = new LORE(Constants.MAX_SUPPLY, TestActors.OWNER);
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    function test_LoreumToken_init() public view {
        assertEq(lore.maxSupply(), Constants.MAX_SUPPLY);
        assertEq(lore.totalSupply(), Constants.MAX_SUPPLY);
        assertEq(lore.balanceOf(TestActors.OWNER), Constants.MAX_SUPPLY);

        assertEq(lore.symbol(), Constants.SYMBOL);
        assertEq(lore.name(), Constants.NAME);
    }
}
