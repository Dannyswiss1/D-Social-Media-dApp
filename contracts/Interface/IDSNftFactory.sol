//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IDSNft {
    function createNFT(address to, uint256 tokenId) external;
}