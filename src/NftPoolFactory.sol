// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC721} from "@openzeppelin/contracts/interfaces/IERC721.sol";
import {NftPool} from "./NftPool.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract PoolFactory is Ownable, ReentrancyGuard {
    error PoolFactory__NotAnOwnerOfNft();
    error PoolFactory__ZeroAmount();
    error PoolFactory__SendProperFee();
    error PoolFactory__TransactionFailed();

    uint256 public fee;

    mapping(address user => address[] pool) public userToPool;
    address[] public pools;

    event CreatedNftPool(address caller, address nft, uint256 toneId, uint256 atomAmount);
    event FeeChanged(uint256 oldFee, uint256 newFee);

    constructor(uint256 _protocolFee) Ownable(msg.sender) {
        fee = _protocolFee;
    }

    function createNftFraction(address nft, uint256 tokenId, uint256 atomAmount)
        external
        payable
        nonReentrant
        returns (address)
    {
        address caller = msg.sender;

        if (msg.value < fee) {
            revert PoolFactory__SendProperFee();
        }
        uint256 refund = msg.value - fee;
        (bool ok,) = payable(caller).call{value: refund}("");
        if (!ok) {
            revert PoolFactory__TransactionFailed();
        }
        if (IERC721(nft).ownerOf(tokenId) != caller) {
            revert PoolFactory__NotAnOwnerOfNft();
        }
        if (atomAmount == 0) {
            revert PoolFactory__ZeroAmount();
        }

        NftPool pool = new NftPool(nft, tokenId, atomAmount, caller);
        IERC721(nft).transferFrom(caller, address(pool), tokenId);
        userToPool[caller].push(address(pool));
        pools.push(address(pool));

        emit CreatedNftPool(caller, nft, tokenId, atomAmount);
        return address(pool);
    }

    function changeFee(uint256 _newFee) external onlyOwner {
        if (_newFee == 0) {
            revert PoolFactory__ZeroAmount();
        }
        uint256 oldFee = fee;
        fee = _newFee;
        emit FeeChanged(oldFee, _newFee);
    }

    function withdrawFees() external onlyOwner nonReentrant {
        uint256 balance = address(this).balance;
        (bool ok,) = payable(owner()).call{value: balance}("");

        if (!ok) {
            revert PoolFactory__TransactionFailed();
        }
    }
}
