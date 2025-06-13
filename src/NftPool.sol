// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Atom} from "./token/Atom.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract NftPool is Ownable, ReentrancyGuard {
    error NftPool__OnlyOwnerOfNftCanCreate();
    error NftPool__ZeroAmount();
    error NftPool__OnlyHolderCanSellAtom();
    error NftPool__WithdrawFailed();

    address public immutable i_nft;
    uint256 public immutable i_tokenId;
    uint256 public totalAtom;
    Atom public immutable i_atom;

    mapping(address holder => uint256 share) private atomHolder;
    mapping(address holder => bool) private isHolder;
    mapping(address user => uint256) private withdraws;

    event BoughtNftAtom(address buyer, uint256 nftId, address atom, uint256 amount);

    event SoldNftAtom(address seller, uint256 nftId, address atom, uint256 amount);

    constructor(address nft, uint256 tokenId, uint256 atomAmount, address caller) Ownable(msg.sender) {
        i_nft = nft;
        i_tokenId = tokenId;
        i_atom = new Atom(nft, tokenId, atomAmount, caller);
        totalAtom = i_atom.getTotalSupply();
    }

    // function buyAtom() external payable nonReentrant returns (uint256) {
    //     address caller = msg.sender;
    //     if (!isHolder[caller]) {
    //         isHolder[caller] = true;
    //     }
    //     uint256 amount = msg.value;
    //     if (amount == 0) {
    //         revert NftPool__ZeroAmount();
    //     }

    //     atomHolder[caller] = atomHolder[caller] + amount;
    //     totalAtom = totalAtom - amount;
    //     i_atom.transfer(caller, amount);

    //     emit BoughtNftAtom(caller, i_tokenId, address(i_atom), amount);

    //     return amount;
    // }

    // function sellAtom(uint256 amount) external nonReentrant returns (uint256) {
    //     address caller = msg.sender;
    //     if (!isHolder[caller]) {
    //         revert NftPool__OnlyHolderCanSellAtom();
    //     }
    //     if (amount > atomHolder[caller]) {
    //         amount = atomHolder[caller];
    //         delete atomHolder[caller];
    //         delete isHolder[caller];
    //         totalAtom = totalAtom + amount;
    //         i_atom.transferFrom(caller, address(this), amount);
    //         withdraws[caller] = withdraws[caller] + amount;
    //     } else {
    //         totalAtom = totalAtom + amount;
    //         atomHolder[caller] = atomHolder[caller] - amount;
    //         i_atom.transferFrom(caller, address(this), amount);
    //         withdraws[caller] = withdraws[caller] + amount;
    //     }
    //     emit SoldNftAtom(caller, i_tokenId, address(i_atom), amount);
    //     return amount;
    // }

    // function withdrawEth() external nonReentrant {
    //     address payable caller = payable(msg.sender);

    //     uint256 amountToWithdraw = withdraws[caller];

    //     if (amountToWithdraw == 0) {
    //         revert NftPool__ZeroAmount();
    //     }

    //     withdraws[caller] = 0;

    //     (bool success,) = caller.call{value: amountToWithdraw}("");
    //     if (success) {
    //         revert NftPool__WithdrawFailed();
    //     }
    // }

    // function getNft() external view returns (address) {
    //     return i_nft;
    // }

    // function getTokenId() external view returns (uint256) {
    //     return i_tokenId;
    // }

    // function getAtom() external view returns (address) {
    //     return address(i_atom);
    // }

    // function getTotalAtom() external view returns (uint256) {
    //     return totalAtom;
    // }
}
