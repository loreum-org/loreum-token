// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import { IERC20 } from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

interface ILoreumToken is IERC20 {
    function SUPPLY_CAP() external view returns (uint256);

    function mint(address account, uint256 amount) external returns (bool);
}