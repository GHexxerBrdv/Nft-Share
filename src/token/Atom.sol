// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {NftPool} from "../NftPool.sol";

contract Atom is ERC20 {
    address private immutable i_nft;
    uint256 private immutable i_tokenId;
    NftPool private immutable i_pool;
    uint256 private immutable i_totalAtom;

    constructor(address _nft, uint256 tokenId, uint256 totalAtom, address caller) ERC20("HexxaAtom", "HA") {
        i_nft = _nft;
        i_tokenId = tokenId;
        i_totalAtom = totalAtom;
        _mint(caller, totalAtom);
    }

    function getNft() external view returns (address) {
        return i_nft;
    }

    function getTokenId() external view returns (uint256) {
        return i_tokenId;
    }

    function getNftPool() external view returns (address) {
        return address(i_pool);
    }

    function getTotalSupply() external view returns (uint256) {
        return i_totalAtom;
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        _transfer(from, to, value);
        return true;
    }
}
