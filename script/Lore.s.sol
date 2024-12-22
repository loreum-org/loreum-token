// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.20;

import {Script} from "lib/forge-std/src/Script.sol";
import {LoreumToken} from "src/LoreumToken.sol";

contract DeployLoreumToken is Script {

    address premintReceiver;

    function run() external {
        if (block.chainid == 8453) {
            
            // loreum base multisig
            premintReceiver = 0x61ED082106cF5DF1b05Eb0D67216B3F73CbA2DB4;
        }

        if (block.chainid == 11155111) {

            premintReceiver = 0x345F273fAE2CeC49e944BFBEf4899fA1625803C5;
        }

        uint256 premintAmount = 3_000_000 * 10 ** 18;
        uint256 maxSupply = 100_000_000 * 10 ** 18;

        vm.startBroadcast();
        new LoreumToken(premintReceiver, premintAmount, maxSupply);
        vm.stopBroadcast();
        


    }
}
