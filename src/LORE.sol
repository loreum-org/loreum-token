// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract LORE is ERC20, ERC20Permit {
    /**
     *
     *     Token State Variables
     *
     */

    /**
     * @notice The maximum number of tokens that can ever be minted.
     * @dev This value is immutable.
     */
    uint256 public immutable maxSupply;

    /**
     *
     *     Constructor
     *
     */

    /**
     * @notice Constructor for the Loreum token.
     * @dev Mints an initial amount of tokens to the provided receiver's address.
     * Also sets the max supply of the token.
     * This contract inherits from the OpenZeppelin's ERC20, and ERC20Permit contracts.
     * @param _maxSupply The maximum supply that this token can ever reach.
     * @param _owner The initial owner of the Contract.
     */
    constructor(uint256 _maxSupply, address _owner) ERC20("Loreum", "LORE") ERC20Permit("Loreum") {
        _mint(_owner, _maxSupply);
        maxSupply = _maxSupply;
    }
}
