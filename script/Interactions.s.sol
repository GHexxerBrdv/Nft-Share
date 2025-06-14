// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script, console2} from "forge-std/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {PoolFactory} from "../src/NftPoolFactory.sol";
import {AtomNft} from "../src/token/AtomNft.sol";
import {NftPool} from "../src/NftPool.sol";

contract Interactions is Script {
    string public url = "okokokokok";
    uint256 public atoms = 1000e18;

    function run() external {
        address addressNft = DevOpsTools.get_most_recent_deployment("AtomNft", block.chainid);
        address getAddress = DevOpsTools.get_most_recent_deployment("PoolFactory", block.chainid);

        vm.startBroadcast();
        uint256 tokenId = AtomNft(addressNft).safeMint(url);
        address pool = PoolFactory(getAddress).createNftFraction(addressNft, tokenId, atoms);
        vm.stopBroadcast();
        console2.log("the address of created pool is: ", pool);
    }
}
