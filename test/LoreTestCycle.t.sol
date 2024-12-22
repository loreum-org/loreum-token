// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {LORE} from "src/LORE.sol";
import {Test, console} from "lib/forge-std/src/Test.sol";
import {TestActors} from "script/Actors.sol";
import {Constants} from "script/Constants.sol";

contract LoreumLifecycleTest is Test {
    LORE lore;

    address alice = address(2);
    address bob = address(3);

    function setUp() public {
        lore = new LORE(Constants.MAX_SUPPLY, TestActors.OWNER);
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * This function tests the basic properties of the Loreum token contract, checking the name,
     * symbol, decimals, owner, total supply, and maximum supply.
     */
    function test_Basic() public view {
        assertEq(lore.name(), Constants.NAME);
        assertEq(lore.symbol(), Constants.SYMBOL);
        assertEq(lore.decimals(), 18);
        assertEq(lore.totalSupply(), Constants.MAX_SUPPLY);
        assertEq(lore.maxSupply(), Constants.MAX_SUPPLY);
    }

    /**
     * This function tests the total supply of the Loreum token contract. It checks that the total
     * supply equals the sum of all individual balances (this contract, Alice, and Bob) before and
     * after a token transfer.
     */
    function test_TotalSupplyEqualToAllBalance(uint256 amount) public {
        vm.assume(amount > 0);
        vm.assume(amount < Constants.MAX_SUPPLY);

        assertEq(lore.totalSupply(), lore.balanceOf(TestActors.OWNER));

        vm.startPrank(TestActors.OWNER);
        vm.expectEmit(true, true, false, true, address(lore));
        emit Transfer(TestActors.OWNER, alice, amount);
        bool success = lore.transfer(alice, amount);
        require(success, "transfer failed");
        vm.stopPrank();

        uint256 allBalance = lore.balanceOf(TestActors.OWNER) + lore.balanceOf(alice) + lore.balanceOf(bob);
        assertEq(lore.totalSupply(), allBalance);
    }

    /**
     * This function tests the successful transfer of tokens from the owner to Alice in the Loreum
     * token contract, checking that their balances update correctly.
     */
    function test_TokenTransferSuccess(uint256 amount) public {
        vm.assume(amount > 0);
        vm.assume(amount < Constants.MAX_SUPPLY);
        uint256 aliceOldBalance = lore.balanceOf(alice);

        vm.startPrank(TestActors.OWNER);
        vm.expectEmit(true, true, false, true, address(lore));
        emit Transfer(TestActors.OWNER, alice, amount);
        bool success = lore.transfer(alice, amount);
        require(success, "transfer failed");
        vm.stopPrank();

        assertEq(lore.balanceOf(TestActors.OWNER), Constants.MAX_SUPPLY - amount);
        assertEq(lore.balanceOf(alice), aliceOldBalance + amount);
    }

    /**
     * This function tests the failure case of token transfer in the Loreum token contract. It
     * checks that when a transfer amount exceeds the owner's balance, the transfer fails and
     * the balances remain unchanged.
     */
    function test_TokenTransferFail(uint256 amount) public {
        uint256 ownerOldBalance = Constants.MAX_SUPPLY;
        vm.assume(amount > ownerOldBalance);
        uint256 aliceOldBalance = lore.balanceOf(alice);

        vm.startPrank(TestActors.OWNER);
        vm.expectRevert();
        lore.transfer(alice, amount); // This should revert
        vm.stopPrank();

        uint256 ownerNewBalance = lore.balanceOf(TestActors.OWNER);
        uint256 aliceNewBalance = lore.balanceOf(alice);

        assertEq(ownerNewBalance, ownerOldBalance);
        assertEq(aliceNewBalance, aliceOldBalance);
    }

    /**
     * This function tests the 'transferFrom' method of the Loreum token contract. It checks that
     * Alice can successfully transfer tokens from the owner to Bob, given the owner's approval,
     * and that the balances update correctly.
     */
    function test_transferFrom(uint256 amount) public {
        vm.assume(amount > 0);
        vm.assume(amount < Constants.MAX_SUPPLY);

        uint256 ownerOldBalance = lore.balanceOf(TestActors.OWNER);
        uint256 aliceOldBalance = lore.balanceOf(alice);
        uint256 bobOldBalance = lore.balanceOf(bob);

        // Owner Aprrove alice to Spend some Amount of token on behalf of him
        vm.startPrank(TestActors.OWNER);
        lore.approve(alice, amount);
        vm.stopPrank();

        // Alice send some amount from owner to bob
        vm.startPrank(alice);
        bool success = lore.transferFrom(TestActors.OWNER, bob, amount);
        assertEq(lore.allowance(TestActors.OWNER, alice), 0);
        require(success, "Transfer Fail");
        vm.stopPrank();

        // Check if Bob receives the token and if the owner's token is deducted.
        assertEq(lore.balanceOf(TestActors.OWNER), ownerOldBalance - amount);
        assertEq(lore.balanceOf(alice), aliceOldBalance);
        assertEq(lore.balanceOf(bob), bobOldBalance + amount);
    }
}
