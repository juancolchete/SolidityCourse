// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";

contract TheMemeNft is ERC721, ERC721URIStorage, Ownable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    IERC20 private _token;
    address payable rewardWallet;
    mapping(address=>mapping(uint256=>uint256)) public stake;
    string[] private rarities;
    // Rarity => Reward
    mapping(uint16 => uint256) private _rewardRarity;
    // TokenId => Rarity
    mapping(uint256 => uint16) private _tokenRarity;
    Counters.Counter private _tokenIdCounter;
    uint256 private stakeperiod;

    constructor(address payable token) ERC721("The Meme Nft", "TMN") {
        _rewardRarity[0] = 1000000000000;
        _rewardRarity[1] = 10000000000000;
        _rewardRarity[2] = 100000000000000;
        _rewardRarity[3] = 1000000000000000000;
        stakeperiod = 604800;
        rarities = ["garbage","simple", "rare","legend"];
        _token = token;
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
        stake[msg.sender][idToken] = block.timestamp;
    }
    
    function stopStake(uint256 idToken) public{
        require(ERC721.ownerOf(idToken) == msg.sender,"You are not the NFT owner !.");
        require(isStake(idToken,msg.sender),"Your NFT is not in stake, choose another NFT to remove from stake");
        require(block.timestamp.sub(stake[msg.sender][idToken]) >= stakeperiod,"You do not complete a week");
        calcRewards(idToken,msg.sender);
        sendRewards(calcRewards(idToken,msg.sender));
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
        uint256 semana = block.timestamp.sub(stake[owner][idToken]).div(stakeperiod);
        return _rewardRarity[_tokenRarity[idToken]].mul(semana);
    }
    
    function setPeriod(uint256 period) public onlyOwner{
        stakeperiod = period;
    }

    function sendRewards(uint256 quant) private{
        _token.SafeTransferFrom(rewardWallet,msg.sender,quant);
    }
}