// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.18;

import { ERC20 } from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import { ERC20Permit } from "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol";
import { Ownable } from "openzeppelin-contracts/contracts/access/Ownable.sol";                                       

contract LoreumToken is ERC20, ERC20Permit, Ownable {
    
    // ---------------------
    //    State Variables
    // ---------------------

    uint256 public immutable maxSupply;



    // -----------------
    //    Constructor
    // ----------------- 

    /// @notice Constructor for LoreumToken.
    /// @param  premintReceiver The address that receives the pre-minted LORE tokens.
    /// @param  premintAmount The amount to pre-mint.
    /// @param  _maxSupply The maximum supply for LORE.
    constructor(
        address premintReceiver, 
        uint256 premintAmount, 
        uint256 _maxSupply
    ) Ownable(_msgSender()) ERC20("Loreum", "LORE") ERC20Permit("Loreum") {
        require(_maxSupply >= premintAmount, "LoreumToken::constructor() _maxSupply < premintAmount");
        _mint(premintReceiver, premintAmount);
        maxSupply = _maxSupply;
    }



    // ---------------
    //    Functions
    // ---------------

    /// @notice Burns LORE tokens.
    /// @param  amount Amount of LORE tokens to burn.
    function burn(uint256 amount) external virtual { _burn(_msgSender(), amount); }

    /// @notice Mint LORE to the provided account.
    /// @param  account The address that will receive LORE.
    /// @param  amount  The amount to mint.
    function mint(address account, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= maxSupply, "LoreumToken::mint() totalSupply() + amount > maxSupply");
        _mint(account, amount);
    }

}
