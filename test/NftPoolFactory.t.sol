// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {PoolFactory} from "../src/NftPoolFactory.sol";
import {DeployNftPoolFactory} from "../script/NftPoolFactory.s.sol";
import {DeployAtomNft} from "../script/AtomNft.s.sol";
import {AtomNft} from "../src/token/AtomNft.sol";
import {NftPool} from "../src/NftPool.sol";
import {Atom} from "../src/token/Atom.sol";

contract NftPoolFactory is Test {
    PoolFactory factory;
    DeployNftPoolFactory deployer;
    DeployAtomNft nftDeployer;
    AtomNft nft;
    Atom atom;

    address owner;
    uint256 fee;

    function setUp() public {
        nftDeployer = new DeployAtomNft();
        nft = nftDeployer.run();

        deployer = new DeployNftPoolFactory();
        factory = deployer.run();

        owner = factory.owner();
        fee = factory.getFee();
    }

    function test_deployment() public view {
        console2.log("Address of deployed factory: ", address(factory));
        console2.log(owner);
        console2.log(fee);
        console2.log("Address of deployed nft: ", address(nft));
        assertEq(nft.FEE(), 0.15 ether);
    }

    function test_createPool() public {
        address user = makeAddr("user");
        vm.deal(user, 2 ether);

        vm.startPrank(user);
        uint256 tokenId = nft.safeMint{value: 0.15 ether}("image url");
        assertEq(nft._nextTokenId(), 1);
        assertEq(nft.tokenURI(tokenId), "image url");
        nft.approve(address(factory), tokenId);
        address pool = factory.createNftFraction{value: 0.16 ether}(address(nft), tokenId, 1000e18);
        vm.stopPrank();

        assertEq(factory.userToPool(user, 0), pool);
        assertEq(factory.pools(0), pool);
        assertEq(nft.ownerOf(tokenId), pool);
        console2.log("the balance of factory: ", address(factory).balance);

        atom = Atom(NftPool(pool).getAtom());
        AtomNft createdNft = AtomNft(NftPool(pool).getNft());
        uint256 createdTokenId = uint256(NftPool(pool).getTokenId());
        assertEq(address(createdNft), address(nft));
        assertEq(createdTokenId, tokenId);
        assertEq(NftPool(pool).getTotalAtom(), 1000e18);
        assertEq(atom.balanceOf(user), 1000e18);

        vm.prank(user);
        vm.expectRevert();
        factory.changeFee(0.1 ether);

        vm.prank(user);
        vm.expectRevert();
        factory.withdrawFees();

        vm.prank(owner);
        factory.changeFee(1 ether);
        vm.prank(owner);
        factory.withdrawFees();

        assertEq(fee, 1 ether);
        assertEq(address(factory).balance, 0);
        console2.log(owner.balance);

        vm.prank(owner);
        vm.expectRevert();
        factory.changeFee(0 ether);
    }

    function test_wrongOwnerOfNft() public {
        address user = makeAddr("user");
        vm.deal(user, 2 ether);

        vm.startPrank(user);
        uint256 tokenId = nft.safeMint{value: 0.15 ether}("image url");
        assertEq(nft._nextTokenId(), 1);
        assertEq(nft.tokenURI(tokenId), "image url");
        nft.approve(address(factory), tokenId);
        vm.expectRevert();
        factory.createNftFraction{value: 0.16 ether}(address(nft), tokenId, 0);
        vm.stopPrank();
        vm.expectRevert();
        factory.createNftFraction{value: 0.16 ether}(address(nft), tokenId, 1000e18);
    }
}
