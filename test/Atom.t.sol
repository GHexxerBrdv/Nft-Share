// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Atom} from "../src/token/Atom.sol";
import {Test, console2} from "forge-std/Test.sol";

contract AtomTest is Test {
    Atom public atom;
    address public pool = makeAddr("pool");
    address public owner = makeAddr("owner");
    address nft = address(156);
    uint256 tokenId = 1;

    function setUp() public {
        vm.startPrank(owner);
        atom = new Atom(nft, tokenId, pool);
        vm.stopPrank();
    }

    function test_Setup() public view {
        console2.log(atom.getNft());
        console2.log(atom.getNftPool());
        console2.log(atom.getTokenId());
        console2.log(atom.getTotalSupply());
        console2.log(atom.balanceOf(owner));
    }

    function test_Transfer() public {
        address gaurang = makeAddr("Gaurang");
        vm.startPrank(owner);
        atom.transfer(gaurang, 15e18);
        vm.stopPrank();
        console2.log(atom.balanceOf(owner));
        console2.log(atom.balanceOf(gaurang));
    }

    function test_NonOwnerTransfer() public {
        address gaurang = makeAddr("Gaurang");
        vm.startPrank(gaurang);
        vm.expectRevert();
        atom.transfer(address(1), 15e18);
        vm.stopPrank();
    }

    function test_TransferFrom() public {
        address gaurang = makeAddr("Gaurang");
        vm.startPrank(owner);
        atom.transfer(gaurang, 15e18);
        console2.log(atom.balanceOf(gaurang));
        atom.transferFrom(gaurang, address(1), 10e18);
        vm.stopPrank();
        console2.log(atom.balanceOf(owner));
        console2.log(atom.balanceOf(gaurang));
        console2.log(atom.balanceOf(address(1)));
    }

    function test_NonOwnerTransferFrom() public {
        address gaurang = makeAddr("Gaurang");
        vm.startPrank(gaurang);
        vm.expectRevert();
        atom.transferFrom(gaurang, address(1), 15e18);
        vm.stopPrank();
    }
}
