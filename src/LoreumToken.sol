// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.16;

import { ERC20 } "open-zeppelin/contracts/token/ERC20/ERC20.sol";
import { Ownable } "open-zeppelin/contracts/access/Ownable.sol";

import { ILoreumToken } from "./ILoreumToken.sol";

/// @title LoreumToken LORE
/// @notice

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


contract LoreumToken is ERC20, Ownable, ILoreumToken {
    
    // ---------------------
    //    State Variables
    // ---------------------

    uint256 private immutable _SUPPLY_CAP;

    // -----------------
    //    Constructor
    // ----------------- 

    /// @notice Constructor
    /// @param  _premintHolder address of the premint Holder
    /// @param  _premintAmount the amount to Premint
    /// @param  _cap           supply is capped at this value

    constructor(
        address _premintHolder,
        uint256 _premintAmount,
        uint256 _cap
    ) ERC20("Loreum Token", "LORE") {
        require(_cap > _premintAmount, "LoreumToken::constructor cap < premintAmount");

        _mint(_premintHolder, _premintAmount);
        _SUPPLY_CAP = _cap;
    }

    // ---------------
    //    Functions
    // ---------------

    /// @notice Mint LORE Tokens
    /// @param  account address to recieve tokens
    /// @param  amount  amount to mint
    /// @return status  boolean of success or failure

    function mint(address account, uint256) external override onlyOwner returns (bool status) {
        if (totalSupply() + amount <= _SUPPLY_CAP) {
            _mint(account, amount);
            return true;
        }
        return false;
    }

    function SUPPLY_CAP() external view override returns (uint256) {
        return _SUPPLY_CAP;
    }
}
