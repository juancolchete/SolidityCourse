// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TheMemeNft is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    mapping(address=>mapping(uint256=>uint256)) public stake;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("The Meme Nft", "TMN") {}

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage)returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function startStake(uint256 idToken) public{
        require(!isStake(idToken,msg.sender),"Your NFT is already in stake, choose another NFT to stake");
        stake[msg.sender][idToken] = block.number;
    }

    function isStake(uint256 idToken, address end) public view returns(bool){
        if(stake[end][idToken] <= 0){
            return false;
        }
        else{
            return true;
        }
    }
}