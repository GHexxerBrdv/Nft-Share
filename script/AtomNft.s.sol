// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {AtomNft} from "../src/token/AtomNft.sol";

contract DeployAtomNft is Script {
    AtomNft public atomNft;

    function run() external returns (AtomNft) {
        vm.startBroadcast();
        atomNft = new AtomNft();
        vm.stopBroadcast();
        return atomNft;
    }
}
