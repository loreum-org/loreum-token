// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.18;

import "./Utility.sol";

import { LoreumToken } from "../../src/LoreumToken.sol";

contract Deployment is Utility {

    LoreumToken LORE;

    address premintReceiver = BONES;
    uint256 premintAmount   = 1_000_000 ether;
    uint256 maxSupply       = 10_000_000 ether;

    string constant NAME = "Loreum";
    string constant SYMBOL = "LORE";

    function setUp() public {

        LORE = new LoreumToken(premintReceiver, premintAmount, maxSupply);

    }

    // Events.

    event Transfer(address indexed from, address indexed to, uint256 value);


    // ----------------
    //    Unit Tests
    // ----------------

    function test_LoreumToken_init() public {

        assertEq(LORE.maxSupply(), maxSupply);
        assertEq(LORE.totalSupply(), premintAmount);
        assertEq(LORE.balanceOf(premintReceiver), premintAmount);

        assertEq(LORE.symbol(), SYMBOL);
        assertEq(LORE.name(), NAME);
    }


    // Validate mint() restrictions.
    // Validate mint() state changes.

    function test_LoreumToken_mint_restriction(uint256 mintAmount) public {

        hevm.assume(mintAmount < 100_000_000 ether);

        if (mintAmount > LORE.maxSupply() - LORE.totalSupply()) {
            hevm.expectRevert("LoreumToken::mint() totalSupply() + amount > maxSupply");
        }

        LORE.mint(BONES, mintAmount);
        
    }

    function test_LoreumToken_mint_state(uint256 mintAmount) public {

        hevm.assume(mintAmount <= LORE.maxSupply() - LORE.totalSupply());

        // Pre-state.
        assertEq(LORE.balanceOf(BONES), premintAmount);

        // mint().
        LORE.mint(BONES, mintAmount);

        // Post-state.
        assertEq(LORE.balanceOf(BONES), premintAmount + mintAmount);
    }

    // Validate burn() restrictions.
    // Validate burn() state changes.

    function test_LoreumToken_burn_restriction_account() public {
        
        hevm.startPrank(address(0));
        hevm.expectRevert("ERC20: burn from the zero address");
        LORE.burn(100 ether);
        hevm.stopPrank();

    }

    function test_LoreumToken_burn_restriction_amount(uint256 burnAmount) public {

        hevm.startPrank(premintReceiver);

        if (burnAmount > premintAmount) {
            hevm.expectRevert("ERC20: burn amount exceeds balance");
            LORE.burn(burnAmount);
        }
        else {
            LORE.burn(burnAmount);
        }

        hevm.stopPrank();

    }

    function test_LoreumToken_burn_state(uint256 burnAmount) public {
        
        hevm.assume(burnAmount <= premintAmount);

        // Pre-state.
        assertEq(LORE.totalSupply(), premintAmount);
        assertEq(LORE.balanceOf(premintReceiver), premintAmount);

        // burn().
        hevm.startPrank(premintReceiver);
        hevm.expectEmit(true, true, false, true, address(LORE));
        emit Transfer(premintReceiver, address(0), burnAmount);
        LORE.burn(burnAmount);
        hevm.stopPrank();

        // Post-state.
        assertEq(LORE.totalSupply(), premintAmount - burnAmount);
        assertEq(LORE.balanceOf(premintReceiver), premintAmount) - burnAmount;

    }

}
