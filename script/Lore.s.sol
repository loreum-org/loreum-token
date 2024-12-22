// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.20;

import {Script} from "lib/forge-std/src/Script.sol";
import {LORE} from "src/LORE.sol";
import {BaseActors, SepoliaActors, TestActors} from "script/Actors.sol";
import {Constants} from "script/Constants.sol";

contract DeployLORE is Script {
    address owner;

    function run() external {
        if (block.chainid == 8453) {
            // loreum base multisig
            owner = BaseActors.OWNER;
        } else if (block.chainid == 11155111) {
            owner = SepoliaActors.OWNER;
        } else {
            owner = TestActors.OWNER;
        }

        vm.startBroadcast();
        new LORE(Constants.MAX_SUPPLY, owner);
        vm.stopBroadcast();
    }
}
