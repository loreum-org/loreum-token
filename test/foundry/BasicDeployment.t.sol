// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// Test (foundry-rs) imports.
import "forge-std/Test.sol";

import "../../src/LORE.sol";

import { AddressRegistry } from "./AddressRegistry.sol";
import { TestUtilities } from "./TestUtilities.sol";

contract BasicDeployment is Test, AddressRegistry, TestUtilities {


    LORE lore;

    address payable[] internal users;
    address internal Bones;

    function setUp() public {

        lore = new LORE("Loreum Token", "LORE", address(this));
    }

    function test_Loreum_init() public {

        assertEq(lore.balanceOf(address(this)), 100_000_000 * WAD);
    }

    function test_TODO() public {


        // NOTE Create some tests

    } 
}
