//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./DSNft.sol";

contract DSNftFactory  {
    DSNft public nftClones;
    
    constructor(DSNft _nftContract) {
        nftClones = _nftContract;
    }
    
    function createNFT(address to, uint256 tokenId) public  {
        nftClones.safeMint(to, tokenId);
    }
}