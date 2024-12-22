// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {LoreumToken} from "contracts/LoreumToken.sol";
import {Test, console} from "modules/forge-std/src/Test.sol";

contract LoreumTokenTest is Test {
    LoreumToken lore;
    address PremintReceiver = address(this);
    uint256 PremintAmount = 1000;
    uint256 MaxSupply = 5000;
    address alice;
    uint256 alicePriKey;
    address bob;
    uint256 bobPriKey;
    address jb;
    uint256 jbPriKey;

    function setUp() public {
        lore = new LoreumToken(PremintReceiver, PremintAmount, MaxSupply);
        (alice, alicePriKey) = makeAddrAndKey("Alice");
        (bob, bobPriKey) = makeAddrAndKey("Bob");
        (jb, jbPriKey) = makeAddrAndKey("JB");
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function invariant() public {
        assertGe(lore.maxSupply(), lore.totalSupply());
        uint256 allBalance =
            lore.balanceOf(address(this)) + lore.balanceOf(alice) + lore.balanceOf(bob) + lore.balanceOf(jb);
        assertEq(lore.totalSupply(), allBalance);
        assertEq(lore.maxSupply(), 5000);
    }

    /**
     * This function tests the basic properties of the Loreum token contract, checking the name,
     * symbol, decimals, owner, total supply, and maximum supply.
     */
    function test_Basic() public {
        assertEq(lore.name(), "Loreum");
        assertEq(lore.symbol(), "LORE");
        assertEq(lore.decimals(), 18);
        assertEq(lore.owner(), address(this));
        assertEq(lore.totalSupply(), 1000);
        assertEq(lore.maxSupply(), 5000);

        invariant();
    }
    /**
     * This function is to simulate and validate the ownership transfer of 'lore' contract to 'alice'
     * and affirm the contract's post-transfer valid state.
     */

    function test_TransferOwnership() public {
        assertEq(lore.owner(), address(this));

        // Transfer the contract ownership to Alice
        vm.startPrank(lore.owner());
        lore.transferOwnership(alice);
        vm.stopPrank();

        assertEq(lore.owner(), alice);

        invariant();
    }
    /**
     * This function is to simulates a failed scenario of transferring 'lore' contract's
     * ownership from a non-owner 'alice' to 'bob' and validates the contract's state
     * after this unsuccessful attempt.
     */

    function test_TransferOwnershipFail() public {
        assertEq(lore.owner(), address(this));

        // Transfer the contract ownership to Alice
        vm.startPrank(alice);
        vm.expectRevert("Ownable: caller is not the owner");
        lore.transferOwnership(bob);
        vm.stopPrank();

        assertEq(lore.owner(), address(this));

        invariant();
    }
    /**
     * This function is to simulates the scenario of renouncing ownership of 'lore' contract and
     * validates that the contract's ownership is indeed null following this operation.
     */

    function test_TransferOwnershipToNULL() public {
        assertEq(lore.owner(), address(this));

        // Transfer the contract ownership to NULL or remove ownership
        vm.startPrank(lore.owner());
        lore.renounceOwnership();
        vm.stopPrank();

        assertEq(lore.owner(), address(0));

        invariant();
    }
    /**
     * This function tests the minting process of the Loreum token contract. It checks successful
     * minting for the owner, failure of minting for non-owner addresses, and ensures the total
     * supply never exceeds the maximum supply.
     */

    function test_MintPass(uint256 amount) public {
        vm.assume(amount > 0);
        vm.assume(amount < (lore.maxSupply() - lore.totalSupply()));

        // Owner can call the mint function
        uint256 ownerOldBalance = lore.balanceOf(lore.owner());
        uint256 oldTotalSupply = lore.totalSupply();

        vm.startPrank(lore.owner());
        lore.mint(lore.owner(), amount);
        vm.stopPrank();

        assertEq(lore.balanceOf(lore.owner()), ownerOldBalance + amount);
        assertEq(lore.totalSupply(), oldTotalSupply + amount);

        // alice can not call the mint function because she is not the owner
        uint256 F_ownerOldBalance = lore.balanceOf(alice);
        uint256 F_oldTotalSupply = lore.totalSupply();

        vm.startPrank(alice);
        vm.expectRevert("Ownable: caller is not the owner"); // mint function will revert
        lore.mint(alice, 1000);
        vm.stopPrank();

        assertEq(lore.balanceOf(alice), F_ownerOldBalance);
        assertEq(lore.totalSupply(), F_oldTotalSupply);

        invariant();
    }
    /**
     * This function tests the failure case of the minting process in the Loreum token contract.
     * It assumes an amount greater than the remaining supply, attempts to mint this amount,
     * and asserts that the owner's balance and total supply remain unchanged after the
     * failed minting attempt.
     */

    function testFail_MintFail(uint256 amount) public {
        // amount should be ( 4000 < amount < 0 )
        vm.assume(amount > 0);
        vm.assume(amount > (lore.maxSupply() - lore.totalSupply()));

        uint256 ownerOldBalance = lore.balanceOf(lore.owner());
        uint256 oldTotalSupply = lore.totalSupply();

        vm.startPrank(lore.owner());
        lore.mint(lore.owner(), amount);
        vm.stopPrank();

        assertEq(lore.balanceOf(lore.owner()), ownerOldBalance);
        assertEq(lore.totalSupply(), oldTotalSupply);

        invariant();
    }
    /**
     * This function tests the burning process of the Loreum token contract. It checks that the
     * owner's balance and the total supply decrease correctly after tokens are burned.
     */

    function test_OwnerBurnToken(uint256 amount) public {
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

        invariant();
    }
    /**
     * This function tests the token transfer and burning process of the Loreum token contract.
     * It checks that tokens can be transferred from the owner to another user (Alice), and that
     * Alice can successfully burn tokens, reducing her balance and the total supply.
     */

    function test_AliceBurnToken(uint256 amount) public {
        vm.assume(amount > 0);

        // send some token from owner to alice for burn
        vm.startPrank(lore.owner());
        vm.expectEmit(true, true, false, true, address(lore));
        emit Transfer(lore.owner(), alice, 900);
        bool success = lore.transfer(alice, 900);
        require(success, "Transfer Fail!");
        vm.stopPrank();

        vm.assume(amount < lore.balanceOf(alice));

        // alice burn her token
        uint256 aliceOldBalance = lore.balanceOf(alice);
        uint256 oldTotalSupply = lore.totalSupply();

        vm.startPrank(alice);
        lore.burn(amount);
        vm.stopPrank();

        assertEq(lore.balanceOf(alice), aliceOldBalance - amount);
        assertEq(lore.totalSupply(), oldTotalSupply - amount);

        invariant();
    }
    /**
     * This function tests that the burn function reverts when Alice tries to burn more tokens than
     * her balance. It impersonates Alice, expects the burn function to revert, and checks that
     * Alice's balance and the total supply remain unchanged.
     */

    function test_AliceBurnTokenFail(uint256 amount) public {
        vm.assume(amount > 0);

        uint256 aliceOldBalance = lore.balanceOf(alice);
        uint256 oldTotalSupply = lore.totalSupply();

        vm.startPrank(alice);
        vm.expectRevert("ERC20: burn amount exceeds balance");
        lore.burn(amount);
        vm.stopPrank();

        assertEq(lore.balanceOf(alice), aliceOldBalance);
        assertEq(lore.totalSupply(), oldTotalSupply);

        invariant();
    }
    /**
     * This function tests the total supply of the Loreum token contract. It checks that the total
     * supply equals the sum of all individual balances (this contract, Alice, and Bob) before and
     * after a token transfer.
     */

    function test_TotalSupplyEqualToAllBalance(uint256 amount) public {
        vm.assume(amount > 0);
        vm.assume(amount < lore.balanceOf(lore.owner()));

        assertEq(lore.totalSupply(), lore.balanceOf(address(this)));

        vm.startPrank(lore.owner());
        vm.expectEmit(true, true, false, true, address(lore));
        emit Transfer(lore.owner(), alice, amount);
        bool success = lore.transfer(alice, amount);
        require(success, "transfer failed");
        vm.stopPrank();

        uint256 allBalance = lore.balanceOf(lore.owner()) + lore.balanceOf(alice) + lore.balanceOf(bob);
        assertEq(lore.totalSupply(), allBalance);

        invariant();
    }
    /**
     * This function tests the successful transfer of tokens from the owner to Alice in the Loreum
     * token contract, checking that their balances update correctly.
     */

    function test_TokenTransferSuccess(uint256 amount) public {
        vm.assume(amount > 0);
        uint256 ownerOldBalance = lore.balanceOf(lore.owner());
        vm.assume(amount < ownerOldBalance);
        uint256 aliceOldBalance = lore.balanceOf(alice);

        vm.startPrank(lore.owner());
        vm.expectEmit(true, true, false, true, address(lore));
        emit Transfer(lore.owner(), alice, amount);
        bool success = lore.transfer(alice, amount);
        require(success, "transfer failed");
        vm.stopPrank();

        assertEq(lore.balanceOf(lore.owner()), ownerOldBalance - amount);
        assertEq(lore.balanceOf(alice), aliceOldBalance + amount);

        invariant();
    }
    /**
     * This function tests the failure case of token transfer in the Loreum token contract. It
     * checks that when a transfer amount exceeds the owner's balance, the transfer fails and
     * the balances remain unchanged.
     */

    function test_TokenTransferFail(uint256 amount) public {
        uint256 ownerOldBalance = lore.balanceOf(lore.owner());
        vm.assume(amount > ownerOldBalance);
        uint256 aliceOldBalance = lore.balanceOf(alice);

        vm.startPrank(lore.owner());
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        bool success = lore.transfer(alice, amount);
        vm.stopPrank();

        uint256 ownerNewBalance = lore.balanceOf(lore.owner());
        uint256 aliceNewBalance = lore.balanceOf(alice);

        assertEq(ownerNewBalance, ownerOldBalance);
        assertEq(aliceNewBalance, aliceOldBalance);
        require(!success, "transfer success");

        invariant();
    }
    /**
     * This function tests the 'transferFrom' method of the Loreum token contract. It checks that
     * Alice can successfully transfer tokens from the owner to Bob, given the owner's approval,
     * and that the balances update correctly.
     */

    function test_transferFrom(uint256 amount) public {
        vm.assume(amount > 0);
        vm.assume(amount < lore.balanceOf(lore.owner()));

        uint256 ownerOldBalance = lore.balanceOf(lore.owner());
        uint256 aliceOldBalance = lore.balanceOf(alice);
        uint256 bobOldBalance = lore.balanceOf(bob);

        // Owner Aprrove alice to Spend some Amount of token on behalf of him
        vm.startPrank(lore.owner());
        vm.expectEmit(true, true, false, true, address(lore));
        emit Approval(lore.owner(), alice, amount);
        lore.approve(alice, amount);
        vm.stopPrank();

        // Alice send some amount from owner to bob
        vm.startPrank(alice);
        vm.expectEmit(true, true, false, true, address(lore));
        emit Transfer(lore.owner(), bob, amount);
        bool success = lore.transferFrom(lore.owner(), bob, amount);
        assertEq(lore.allowance(lore.owner(), alice), 0);
        require(success, "Transfer Fail");
        vm.stopPrank();

        // Check if Bob receives the token and if the owner's token is deducted.
        assertEq(lore.balanceOf(lore.owner()), ownerOldBalance - amount);
        assertEq(lore.balanceOf(alice), aliceOldBalance);
        assertEq(lore.balanceOf(bob), bobOldBalance + amount);

        invariant();
    }
    /**
     * This function tests the 'transferFrom' and 'increaseAllowance' methods of the Loreum token
     * contract. It checks that Alice can transfer tokens from the owner to Bob, given the owner's
     * approval, and that the owner can increase Alice's allowance. It verifies that all balances
     * and allowances update correctly.
     */

    function test_transferFromWithIncAllow(uint256 amount1) public {
        vm.assume(amount1 > 0);
        vm.assume(amount1 < lore.balanceOf(lore.owner()));

        uint256 ownerOldBalance = lore.balanceOf(lore.owner());
        uint256 aliceOldBalance = lore.balanceOf(alice);
        uint256 bobOldBalance = lore.balanceOf(bob);

        // Owner Aprrove alice to Spend some Amount of token on behalf of him
        vm.startPrank(lore.owner());
        vm.expectEmit(true, true, false, true, address(lore));
        emit Approval(lore.owner(), alice, amount1);
        lore.approve(alice, amount1);
        vm.stopPrank();

        // Alice send some amount from owner to bob
        vm.startPrank(alice);
        vm.expectEmit(true, true, false, true, address(lore));
        emit Transfer(lore.owner(), bob, amount1);
        bool success = lore.transferFrom(lore.owner(), bob, amount1);
        assertEq(lore.allowance(lore.owner(), alice), 0);
        require(success, "Transfer Fail");
        vm.stopPrank();

        // Check if Bob receives the token and if the owner's token is deducted.
        assertEq(lore.balanceOf(lore.owner()), ownerOldBalance - amount1);
        assertEq(lore.balanceOf(alice), aliceOldBalance);
        assertEq(lore.balanceOf(bob), bobOldBalance + amount1);

        // Owner mint extra 1000 token and increase the allowance to 1000
        vm.startPrank(lore.owner());
        lore.mint(lore.owner(), 1000);
        uint256 S_ownerOldBalance = lore.balanceOf(lore.owner());
        uint256 S_aliceOldBalance = lore.balanceOf(alice);
        uint256 S_bobOldBalance = lore.balanceOf(bob);
        bool increaseAllowanceSuccess = lore.increaseAllowance(alice, 1000);
        require(increaseAllowanceSuccess, "Increase Allowance Failed");
        vm.stopPrank();

        // Alice send extra 1000 from owner to bob
        vm.startPrank(alice);
        vm.expectEmit(true, true, false, true, address(lore));
        emit Transfer(lore.owner(), bob, 1000);
        bool TF_success = lore.transferFrom(lore.owner(), bob, 1000);
        require(TF_success, "Transfer Fail");
        assertEq(lore.allowance(lore.owner(), alice), 0);
        vm.stopPrank();

        // Check if Bob receives the token and if the owner's token is deducted.
        assertEq(lore.balanceOf(lore.owner()), S_ownerOldBalance - 1000);
        assertEq(lore.balanceOf(alice), S_aliceOldBalance);
        assertEq(lore.balanceOf(bob), S_bobOldBalance + 1000);

        invariant();
    }

    /**
     * This function is a test case for an ERC20 token with permit feature. It checks initial
     * balances, performs token transfers, tests the permit function which implements a delegated
     * transfer, and verifies the balances and allowances after each operation. It finally invokes
     * the `invariant()` function to check certain invariant conditions.
     */
    function test_ERC20Permit() public {
        assertEq(lore.balanceOf(address(this)), 1000);
        assertEq(lore.balanceOf(alice), 0);
        assertEq(lore.balanceOf(bob), 0);
        assertEq(lore.balanceOf(jb), 0);

        // Owner transfer 1000 token to alice
        vm.startPrank(address(this));
        vm.expectEmit(true, true, false, true, address(lore));
        emit Transfer(lore.owner(), alice, 1000);
        bool success = lore.transfer(alice, 1000);
        require(success, "Transfer Failed!");
        vm.stopPrank();

        assertEq(lore.balanceOf(address(this)), 0);
        assertEq(lore.balanceOf(alice), 1000);
        assertEq(lore.balanceOf(bob), 0);
        assertEq(lore.balanceOf(jb), 0);

        assertEq(lore.allowance(alice, bob), 0);

        // Encodes the permit data to EIP712 specifications, signs it and calls the permit function
        bytes32 domainHash = keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256(bytes(lore.name())),
                keccak256(bytes("1")),
                block.chainid,
                lore
            )
        );
        bytes32 hashStruct = keccak256(
            abi.encode(
                keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
                alice,
                bob,
                500,
                lore.nonces(alice),
                (block.timestamp + 60)
            )
        );
        bytes32 hash = keccak256(abi.encodePacked(uint16(0x1901), domainHash, hashStruct));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(alicePriKey, hash);
        lore.permit(alice, bob, 500, (block.timestamp + 60), v, r, s);

        assertEq(lore.allowance(alice, bob), 500);

        // Starts another token transfer prank, but this time, it's bob transferring from alice to jb
        vm.startPrank(bob);
        vm.expectEmit(true, true, false, true, address(lore));
        emit Transfer(alice, jb, 500);
        bool success1 = lore.transferFrom(alice, jb, 500);
        require(success1, "Transfer Fail");
        vm.stopPrank();

        assertEq(lore.balanceOf(address(this)), 0);
        assertEq(lore.balanceOf(alice), 500);
        assertEq(lore.balanceOf(bob), 0);
        assertEq(lore.balanceOf(jb), 500);

        assertEq(lore.allowance(alice, bob), 0);

        invariant();
    }
}
