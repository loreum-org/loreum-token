// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.16;

import "open-zeppelin/contracts/token/ERC20/ERC20.sol";

contract LORE is ERC20 {
    constructor(
        string memory name_,
        string memory symbol_,
        address holder
    ) ERC20(name_, symbol_) {
        _mint(holder, 100_000_000 ether);
    }
}
