// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// Test (foundry-rs) imports.
import "forge-std/Test.sol";

import { LoreumToken } from "../../src/LoreumToken.sol";

import { AddressRegistry } from "../../lib/contract-utils/src/AddressRegistry.sol";
import { TestUtilities } from "../../lib/contract-utils/src/TestUtilities.sol";


contract Deployment is Test, AddressRegistry, TestUtilities {

    LoreumToken LORE;

    uint256 SUPPLY_CAP = 100_000_000 * WAD;
    uint256 PRE_MINT   = 10_000_000 * WAD;

    string NAME = "Loreum Token";
    string SYMBOL = "LORE";

    function setUp() public {

        /// @dev Create the Loreum Token Contract
        LORE = new LoreumToken(address(this), 10_000_000 * WAD, SUPPLY_CAP);
    }

    function test_LoreumToken_init() public {

        assertEq(LORE.cap(), SUPPLY_CAP);
        assertEq(LORE.totalSupply(), PRE_MINT);
        assertEq(LORE.balanceOf(address(this)), PRE_MINT);

        assertEq(LORE.symbol(), SYMBOL);
        assertEq(LORE.name(), NAME);
    }

    function test_LoreumToken_mint() public {

        /// @dev Test the mint function
        // Mint some tokens to Bones
        assertEq(LORE.mint(BONES, 10_000 * WAD), true);
        assertEq(LORE.balanceOf(BONES), 10_000 * WAD);

        /// NOTE Test should fail if minting more than SUPPLY_CAP
        assertEq(LORE.mint(BONES, SUPPLY_CAP + 1), false);
    } 
}
