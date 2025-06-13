// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {Atom} from "../src/token/Atom.sol";

contract DeployAtom is Script {
    function run() external returns (Atom atom) {
        vm.startBroadcast();
        atom = new Atom(address(255), 0, 1000e18, address(this));
        vm.stopBroadcast();
    }
}
