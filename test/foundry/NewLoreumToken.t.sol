// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.18;

import {LoreumToken} from "../../src/LoreumToken.sol";
import {Test, console} from "lib/forge-std/src/Test.sol";

contract LoreumTokenTest is Test {
    LoreumToken lore;
    address alice;
    address bob;

    function setUp() public {
        lore = new LoreumToken(address(this), 1000, 5000);
        alice = address(1);
        bob = address(2);
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /*
        This function tests the basic properties of the Loreum token contract, checking the name, 
        symbol, decimals, owner, total supply, and maximum supply.
    */
    function test_Basic() public {
        assertEq(lore.name(), "Loreum");
        assertEq(lore.symbol(), "LORE");
        assertEq(lore.decimals(), 18);
        assertEq(lore.owner(), address(this));
        assertEq(lore.totalSupply(), 1000);
        assertEq(lore.maxSupply(), 5000);
    }
    /*
        This function tests the minting process of the Loreum token contract. It checks successful 
        minting for the owner, failure of minting for non-owner addresses, and ensures the total 
        supply never exceeds the maximum supply.
    */
    function test_mint(uint256 amount) public {
        vm.assume(amount > 0);
        vm.assume(amount < (lore.maxSupply() - lore.totalSupply()));

        uint256 ownerOldBalance = lore.balanceOf(lore.owner());
        uint256 oldTotalSupply = lore.totalSupply();
        vm.startPrank(lore.owner());
        lore.mint(lore.owner(), amount);
        vm.stopPrank();
        assertEq(lore.balanceOf(lore.owner()), ownerOldBalance + amount);
        assertEq(lore.totalSupply(), oldTotalSupply + amount);

        uint256 F_ownerOldBalance = lore.balanceOf(alice);
        uint256 F_oldTotalSupply = lore.totalSupply();
        vm.startPrank(alice);
        vm.expectRevert();
        lore.mint(alice, 1000);
        vm.stopPrank();
        assertEq(lore.balanceOf(alice), F_ownerOldBalance);
        assertEq(lore.totalSupply(), F_oldTotalSupply);

        assertGe(lore.maxSupply(), lore.totalSupply());
    }
    /**
        This function tests the failure case of the minting process in the Loreum token contract. 
        It assumes an amount greater than the remaining supply, attempts to mint this amount, 
        and asserts that the owner's balance and total supply remain unchanged after the 
        failed minting attempt.
    */
    function testFail_Mint(uint256 amount) public {
        vm.assume(amount > 0);
        vm.assume(amount > (lore.maxSupply() - lore.totalSupply()));

        uint256 ownerOldBalance = lore.balanceOf(lore.owner());
        uint256 oldTotalSupply = lore.totalSupply();
        vm.startPrank(lore.owner());
        lore.mint(lore.owner(), amount);
        vm.stopPrank();
        assertEq(lore.balanceOf(lore.owner()), ownerOldBalance);
        assertEq(lore.totalSupply(), oldTotalSupply);
    }
    /*
        This function tests the burning process of the Loreum token contract. It checks that the 
        owner's balance and the total supply decrease correctly after tokens are burned.
    */
    function test_burn(uint256 amount) public {
        vm.assume(amount > 0);
        // Pass Test
        vm.assume(amount < lore.balanceOf(lore.owner()));
        uint256 ownerOldBalance = lore.balanceOf(lore.owner());
        uint256 oldTotalSupply = lore.totalSupply();
        vm.startPrank(lore.owner());
        lore.burn(amount);
        vm.stopPrank();
        assertEq(lore.balanceOf(lore.owner()), ownerOldBalance - amount);
        assertEq(lore.totalSupply(), oldTotalSupply - amount);
    }
    /*
        This function tests the token transfer and burning process of the Loreum token contract. 
        It checks that tokens can be transferred from the owner to another user (Alice), and that 
        Alice can successfully burn tokens, reducing her balance and the total supply.
    */
    function test_burn2(uint256 amount) public {
        vm.assume(amount > 0);
        vm.startPrank(lore.owner());
        vm.expectEmit(true, true, false, true, address(lore));
        emit Transfer(lore.owner(), alice, 900);
        bool success = lore.transfer(alice, 900);
        require(success, "Transfer Fail");
        vm.stopPrank();
        vm.assume(amount < lore.balanceOf(alice));
        // Pass Test
        uint256 aliceOldBalance = lore.balanceOf(alice);
        uint256 oldTotalSupply = lore.totalSupply();
        vm.startPrank(alice);
        lore.burn(amount);
        vm.stopPrank();
        assertEq(lore.balanceOf(alice), aliceOldBalance - amount);
        assertEq(lore.totalSupply(), oldTotalSupply - amount);

        assertGe(lore.maxSupply(), lore.totalSupply());
    }
    /*
        This function tests the total supply of the Loreum token contract. It checks that the total 
        supply equals the sum of all individual balances (this contract, Alice, and Bob) before and 
        after a token transfer.
    */
    function test_TotalsSupplyEqualToAllBalance(uint256 amount1) public {
        vm.assume(amount1 > 0);
        // Before Transfer
        vm.assume(amount1 < lore.balanceOf(lore.owner()));
        assertEq(lore.totalSupply(), lore.balanceOf(address(this)));
        vm.startPrank(lore.owner());
        vm.expectEmit(true, true, false, true, address(lore));
        emit Transfer(lore.owner(), alice, amount1);
        bool success = lore.transfer(alice, amount1);
        require(success, "transfer failed");
        vm.stopPrank();
        // After Transfer
        uint256 allBalance=lore.balanceOf(address(this))+lore.balanceOf(alice)+lore.balanceOf(bob);
        assertEq(lore.totalSupply(), allBalance);
        require(lore.totalSupply() == allBalance, "totalSupply != allBalance");

        assertGe(lore.maxSupply(), lore.totalSupply());
    }
    /*
        This function tests the successful transfer of tokens from the owner to Alice in the Loreum 
        token contract, checking that their balances update correctly.
    */
    function test_TokenTransferSuccess(uint256 amount) public {
        //uint256 amount = 500;
        vm.assume(amount > 0);
        uint256 ownerOldBalance = lore.balanceOf(lore.owner());
        vm.assume(amount < ownerOldBalance);
        uint256 aliceOldBalance = lore.balanceOf(alice);
        vm.startPrank(lore.owner());
        vm.expectEmit(true, true, false, true, address(lore));
        emit Transfer(lore.owner(), alice, amount);
        bool success = lore.transfer(alice, amount);
        vm.stopPrank();
        assertEq(lore.balanceOf(lore.owner()), ownerOldBalance - amount);
        assertEq(lore.balanceOf(alice), aliceOldBalance + amount);
        require(success, "transfer failed");

        assertGe(lore.maxSupply(), lore.totalSupply());
    }
    /*  
        This function tests the failure case of token transfer in the Loreum token contract. It 
        checks that when a transfer amount exceeds the owner's balance, the transfer fails and 
        the balances remain unchanged.
    */
    function test_FailTokenTransferSuccess(uint256 amount) public {
        //uint256 amount = 1001;
        uint256 ownerOldBalance = lore.balanceOf(lore.owner());
        vm.assume(amount > ownerOldBalance);
        uint256 aliceOldBalance = lore.balanceOf(alice);
        vm.startPrank(lore.owner());
        vm.expectRevert();
        bool success = lore.transfer(alice, amount);
        vm.stopPrank();
        uint256 ownerNewBalance = lore.balanceOf(lore.owner());
        uint256 aliceNewBalance = lore.balanceOf(alice);
        assertEq(ownerNewBalance, ownerOldBalance);
        assertEq(aliceNewBalance, aliceOldBalance);
        require(!success, "transfer success");

        assertGe(lore.maxSupply(), lore.totalSupply());
    }
    /*
        This function tests the 'transferFrom' method of the Loreum token contract. It checks that 
        Alice can successfully transfer tokens from the owner to Bob, given the owner's approval, 
        and that the balances update correctly.
    */
    function test_transferFrom(uint256 amount) public {
        vm.assume(amount > 0);
        vm.assume(amount < lore.balanceOf(lore.owner()));
        uint256 ownerOldBalance = lore.balanceOf(lore.owner());
        uint256 aliceOldBalance = lore.balanceOf(alice);
        uint256 bobOldBalance = lore.balanceOf(bob);
        vm.startPrank(lore.owner());
        vm.expectEmit(true, true, false, true, address(lore));
        emit Approval(lore.owner(), alice, amount);
        lore.approve(alice, amount);
        vm.stopPrank();
        vm.startPrank(alice);
        vm.expectEmit(true, true, false, true, address(lore));
        emit Transfer(lore.owner(), bob, amount);
        bool success = lore.transferFrom(lore.owner(), bob, amount);
        assertEq(lore.allowance(lore.owner(), alice), 0);
        require(success, "Transfer Fail");
        vm.stopPrank();
        assertEq(lore.balanceOf(lore.owner()), ownerOldBalance - amount);
        assertEq(lore.balanceOf(alice), aliceOldBalance);
        assertEq(lore.balanceOf(bob), bobOldBalance + amount);

        assertGe(lore.maxSupply(), lore.totalSupply());
    }
    /*
        This function tests the 'transferFrom' and 'increaseAllowance' methods of the Loreum token 
        contract. It checks that Alice can transfer tokens from the owner to Bob, given the owner's 
        approval, and that the owner can increase Alice's allowance. It verifies that all balances 
        and allowances update correctly.
    */
    function test_transferFromWithIncAllow(uint256 amount1) public {
        vm.assume(amount1 > 0);
        vm.assume(amount1 < lore.balanceOf(lore.owner()));
        uint256 ownerOldBalance = lore.balanceOf(lore.owner());
        uint256 aliceOldBalance = lore.balanceOf(alice);
        uint256 bobOldBalance = lore.balanceOf(bob);
        vm.startPrank(lore.owner());
        vm.expectEmit(true, true, false, true, address(lore));
        emit Approval(lore.owner(), alice, amount1);
        lore.approve(alice, amount1);
        vm.stopPrank();
        vm.startPrank(alice);
        vm.expectEmit(true, true, false, true, address(lore));
        emit Transfer(lore.owner(), bob, amount1);
        bool success = lore.transferFrom(lore.owner(), bob, amount1);
        assertEq(lore.allowance(lore.owner(), alice), 0);
        require(success, "Transfer Fail");
        vm.stopPrank();
        assertEq(lore.balanceOf(lore.owner()), ownerOldBalance - amount1);
        assertEq(lore.balanceOf(alice), aliceOldBalance);
        assertEq(lore.balanceOf(bob), bobOldBalance + amount1);

        vm.startPrank(lore.owner());
        lore.mint(lore.owner(), 1000);
        uint256 S_ownerOldBalance = lore.balanceOf(lore.owner());
        uint256 S_aliceOldBalance = lore.balanceOf(alice);
        uint256 S_bobOldBalance = lore.balanceOf(bob);
        bool increaseAllowanceSuccess = lore.increaseAllowance(alice, 1000);
        require(increaseAllowanceSuccess, "Increase Allowance Failed");
        vm.stopPrank();
        vm.startPrank(alice);
        vm.expectEmit(true, true, false, true, address(lore));
        emit Transfer(lore.owner(), bob, 1000);
        bool TF_success = lore.transferFrom(lore.owner(), bob, 1000);
        require(TF_success, "Transfer Fail");
        assertEq(lore.allowance(lore.owner(), alice), 0);
        vm.stopPrank();
        assertEq(lore.balanceOf(lore.owner()), S_ownerOldBalance - 1000);
        assertEq(lore.balanceOf(alice), S_aliceOldBalance);
        assertEq(lore.balanceOf(bob), S_bobOldBalance + 1000);
    }
}
