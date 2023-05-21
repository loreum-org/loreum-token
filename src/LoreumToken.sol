// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.18;

import { ERC20 } from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import { Ownable } from "openzeppelin-contracts/contracts/access/Ownable.sol";


//   ▄           ▄▄▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄ ▄         ▄ ▄▄       ▄▄ 
//  ▐░▌         ▐░░░░░░░░░░░▐░░░░░░░░░░░▐░░░░░░░░░░░▐░▌       ▐░▐░░▌     ▐░░▌
//  ▐░▌         ▐░█▀▀▀▀▀▀▀█░▐░█▀▀▀▀▀▀▀█░▐░█▀▀▀▀▀▀▀▀▀▐░▌       ▐░▐░▌░▌   ▐░▐░▌
//  ▐░▌         ▐░▌       ▐░▐░▌       ▐░▐░▌         ▐░▌       ▐░▐░▌▐░▌ ▐░▌▐░▌
//  ▐░▌         ▐░▌       ▐░▐░█▄▄▄▄▄▄▄█░▐░█▄▄▄▄▄▄▄▄▄▐░▌       ▐░▐░▌ ▐░▐░▌ ▐░▌
//  ▐░▌         ▐░▌       ▐░▐░░░░░░░░░░░▐░░░░░░░░░░░▐░▌       ▐░▐░▌  ▐░▌  ▐░▌
//  ▐░▌         ▐░▌       ▐░▐░█▀▀▀▀█░█▀▀▐░█▀▀▀▀▀▀▀▀▀▐░▌       ▐░▐░▌   ▀   ▐░▌
//  ▐░▌         ▐░▌       ▐░▐░▌     ▐░▌ ▐░▌         ▐░▌       ▐░▐░▌       ▐░▌
//  ▐░█▄▄▄▄▄▄▄▄▄▐░█▄▄▄▄▄▄▄█░▐░▌      ▐░▌▐░█▄▄▄▄▄▄▄▄▄▐░█▄▄▄▄▄▄▄█░▐░▌       ▐░▌
//  ▐░░░░░░░░░░░▐░░░░░░░░░░░▐░▌       ▐░▐░░░░░░░░░░░▐░░░░░░░░░░░▐░▌       ▐░▌
//   ▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀ ▀         ▀ ▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀ ▀         ▀ 
//                                                                           

contract LoreumToken is ERC20, Ownable {
    
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
    ) ERC20("Loreum", "LORE") {
        require(_maxSupply >= premintAmount, "LoreumToken::constructor() _maxSupply < premintAmount");
        _mint(premintReceiver, premintAmount);
        maxSupply = _maxSupply;
    }



    // ---------------
    //    Functions
    // ---------------

    /// @notice Mint LORE to the provided account.
    /// @param  account address to recieve tokens
    /// @param  amount  amount to mint
    function mint(address account, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= maxSupply, "LoreumToken::mint() totalSupply() + amount > maxSupply");
        _mint(account, amount);
    }

}
