// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract AtomNft is ERC721, ERC721URIStorage, ReentrancyGuard, Ownable {
    error AtomNft__SendFee();
    error AtomNft__FailedRefund();
    error AtomNft__FailedTransaction();

    uint256 public _nextTokenId;
    uint256 public constant FEE = 0.15 ether;

    constructor() ERC721("AtomNft", "HAN") Ownable(msg.sender) {
        _nextTokenId = 0;
    }

    function safeMint(string memory uri) external payable nonReentrant returns (uint256) {
        address caller = msg.sender;
        if (msg.value < FEE) {
            revert AtomNft__SendFee();
        }

        (bool ok,) = payable(owner()).call{value: FEE}("");
        if (!ok) {
            revert AtomNft__FailedTransaction();
        }
        uint256 tokenId = _nextTokenId++;
        _safeMint(caller, tokenId);
        _setTokenURI(tokenId, uri);

        uint256 refund = msg.value - FEE;
        (ok,) = payable(caller).call{value: refund}("");
        if (!ok) {
            revert AtomNft__FailedRefund();
        }

        return tokenId;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
