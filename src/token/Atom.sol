// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {NftPool} from "../NftPool.sol";

contract Atom is ERC20, Ownable {
    address private immutable i_nft;
    uint256 private immutable i_tokenId;
    NftPool private immutable i_pool;
    uint256 private constant TOTAL_SUPPLY = 10 * 1e6 * 1e18;

    constructor(address _nft, uint256 tokenId, address _nftPool) ERC20("HexxaAtom", "HA") Ownable(msg.sender) {
        i_nft = _nft;
        i_tokenId = tokenId;
        i_pool = NftPool(_nftPool);
        _mint(msg.sender, TOTAL_SUPPLY);
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

    function getTotalSupply() external pure returns (uint256) {
        return TOTAL_SUPPLY;
    }

    function transfer(address to, uint256 value) public override onlyOwner returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public override onlyOwner returns (bool) {
        uint256 currentAllowance = allowance(from, owner());
        require(currentAllowance >= value, "ERC20: transfer amount exceeds allowance");
        _approve(from, _msgSender(), currentAllowance - value);
        _transfer(from, to, value);
        return true;
    }
}
