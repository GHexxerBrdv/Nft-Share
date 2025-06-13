// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {AtomNft} from "../src/token/AtomNft.sol";
import {DeployAtomNft} from "../script/AtomNft.s.sol";

contract AtomNftTest is Test {
    AtomNft public atomNft;
    DeployAtomNft public deployer;

    function setUp() public {
        deployer = new DeployAtomNft();
        atomNft = deployer.run();
    }

    function test_nftDeployment() public view {
        console2.log("Address of deployed nft: ", address(atomNft));
        assertEq(atomNft.FEE(), 0.15 ether);
    }

    function test_mintNft() public {
        address user = makeAddr("user");
        vm.deal(user, 1 ether);

        vm.prank(user);
        uint256 tokenId = atomNft.safeMint{value: 0.15 ether}("url");

        assertEq(atomNft._nextTokenId(), 1);
        assertEq(atomNft.tokenURI(tokenId), "url");
        console2.log("the token id of the user", tokenId);
    }

    function test_sendLessFees() public {
        address user = makeAddr("user");
        vm.deal(user, 1 ether);

        vm.prank(user);
        vm.expectRevert();
        atomNft.safeMint{value: 0.1 ether}("url");
    }

    function test_OwnerBalance() public {
        address user = makeAddr("user");
        vm.deal(user, 1 ether);

        uint256 ownerBalanceBefore = atomNft.owner().balance;
        vm.prank(user);
        uint256 tokenId = atomNft.safeMint{value: 0.15 ether}("url");

        assertEq(atomNft._nextTokenId(), 1);
        assertEq(atomNft.tokenURI(tokenId), "url");
        console2.log("the token id of the user", tokenId);

        address owner = atomNft.owner();
        console2.log("balance of owner: ", owner.balance);
        assertEq(owner.balance, ownerBalanceBefore + 0.15 ether);
        console2.log("balance of user: ", user.balance);
    }
}
