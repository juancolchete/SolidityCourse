// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TheMemeNft is ERC721, ERC721URIStorage, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    mapping(address=>mapping(uint256=>uint256)) public stake;
    string[] private rarities;
    // Rarity => Reward
    mapping(uint16 => uint256) private _rewardRarity;
    // TokenId => Rarity
    mapping(uint256 => uint16) private _tokenRarity;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("The Meme Nft", "TMN") {
        _rewardRarity[0] = 3472222222222;
        _rewardRarity[1] = 34722222222222;
        _rewardRarity[2] = 347222222222222;
        _rewardRarity[3] = 3472222222222222;
        rarities = ["garbage","simple", "rare","legend"];
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _tokenRarity[tokenId] = 3;
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
        require(ERC721.ownerOf(idToken) == msg.sender,"You are not the NFT owner !.");
        require(!isStake(idToken,msg.sender),"Your NFT is already in stake, choose another NFT to stake");
        stake[msg.sender][idToken] = block.number;
    }
    
    function stopStake(uint256 idToken) public{
        require(ERC721.ownerOf(idToken) == msg.sender,"You are not the NFT owner !.");
        require(isStake(idToken,msg.sender),"Your NFT is not in stake, choose another NFT to remove from stake");
        stake[msg.sender][idToken] = 0;
    }

    function _beforeTokenTransfer(address from,address to,uint256 idToken) internal view override{
        require(!isStake(idToken,msg.sender),"Your NFT is in stake, choose another NFT to stake");
    }

    function isStake(uint256 idToken, address end) public view returns(bool){
        if(stake[end][idToken] <= 0){
            return false;
        }
        else{
            return true;
        }
    }

    function calcRewards(uint256 idToken, address owner) public view returns(uint256){
        require(_exists(idToken),"Token that you have mention does not exist.");
        require(isStake(idToken,owner),"Your NFT is not stake, choose another NFT to calculate");
        uint256 calc = block.number.sub(stake[msg.sender][idToken]);
        calc = calc.mul(_rewardRarity[_tokenRarity[idToken]]);
        return calc;
    }
}