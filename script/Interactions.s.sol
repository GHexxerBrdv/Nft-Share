// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script, console2} from "forge-std/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {PoolFactory} from "../src/NftPoolFactory.sol";
import {AtomNft} from "../src/token/AtomNft.sol";
import {NftPool} from "../src/NftPool.sol";
import {Atom} from "../src/token/Atom.sol";

contract Interactions is Script {
    string public url = "okokokokok";
    uint256 public atoms = 1000e18;
    uint256 public amount = 100e18;
    address public to = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function run() external {
        address addressNft = DevOpsTools.get_most_recent_deployment("AtomNft", block.chainid);
        address getAddress = DevOpsTools.get_most_recent_deployment("PoolFactory", block.chainid);

        vm.startBroadcast();
        uint256 tokenId = AtomNft(addressNft).safeMint{value: 0.15 ether}(url);
        AtomNft(addressNft).approve(getAddress, tokenId);
        address pool = PoolFactory(getAddress).createNftFraction{value: 0.15 ether}(addressNft, tokenId, atoms);

        console2.log("the address of created pool is: ", pool);
        console2.log("amount in pool is:", NftPool(pool).getTotalAtom());

        address atom = NftPool(pool).getAtom();
        Atom token = Atom(atom);
        token.transfer(to, amount);

        console2.log("the amount of atom to address holds :", token.balanceOf(to));
        
        vm.stopBroadcast();

    }
}
