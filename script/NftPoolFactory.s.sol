// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {PoolFactory} from "../src/NftPoolFactory.sol";

contract DeployNftPoolFactory is Script {
    PoolFactory public fractionFactory;
    uint256 private constant Fee = 0.15 ether;

    function run() external returns (PoolFactory) {
        vm.startBroadcast();
        fractionFactory = new PoolFactory(Fee);
        vm.stopBroadcast();
        return fractionFactory;
    }
}
