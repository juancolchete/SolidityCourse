// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./@openzeppelin/contracts/access/Ownable.sol";

contract VotationSistem is Ownable{
    TokenInterface trustToken;
    TokenInterface untrustToken;
    using SafeMath for uint256;
    address [] proposalAddresses;
    address [] votesAddress;
    event votationWinner(address winnerAddress,string  proposal, uint votes);

    struct proposal{
        string description;
        uint256 votes;
    }
    struct votationInfo{
        bool hasVoted;
        bool hasProposal;
    }
    mapping(address => proposal) proposals;
    mapping(address => votationInfo) addressVotation;


    constructor(address trustContract, address untrustContract){
        trustToken = TokenInterface(trustContract);
        untrustToken = TokenInterface(untrustContract);
    }

    function isEligible(address account) public view returns(bool){
        return checkTrustBalance(account) > 0;
    }

    modifier onlyEligible{
        require(isEligible(msg.sender),"You can't vote, try be a good citizen and come back later !");
        _;
    }

    function checkTrustBalance(address defendant) public view returns(uint256){
        (bool canSub, uint256 balance)   = trustToken.balanceOf(defendant).trySub(untrustToken.balanceOf(defendant));
        canSub;
        return balance;
    }
    
    function addProposal(string memory proposal_description) public onlyEligible{
        require(addressVotation[msg.sender].hasProposal == false, "Your proposal was already computed!");
        proposals[msg.sender].description = proposal_description;
        proposalAddresses.push(msg.sender);
        addressVotation[msg.sender].hasProposal  = true;
    }


    function checkProposal(address proposal_owner) public view returns(string memory){
        return proposals[proposal_owner].description;
    }
    
    function removeProposal(address proposal_owner) public {
        proposals[proposal_owner].description = "";
        addressVotation[msg.sender].hasProposal  = false;
    }

    function addVote(address proposal_voted) public onlyEligible{
        require(addressVotation[msg.sender].hasVoted == false, "Your vote was already computed!");
        proposals[proposal_voted].votes += (1  * checkTrustBalance(msg.sender));
        addressVotation[msg.sender].hasVoted  = true;
        votesAddress.push(msg.sender);
    }

    function checkVotes(address proposal_choosed) public view returns(uint256){
        return proposals[proposal_choosed].votes;
    }

    function pickWinner() public onlyOwner{
        uint maxVotes =0;
        address winner;
        for(uint vote = 0; vote < votesAddress.length;vote++){
            addressVotation[votesAddress[vote]].hasVoted = false;
        }
        for(uint p = 0; p < proposalAddresses.length;p++){
            if(checkVotes(proposalAddresses[p]) > maxVotes){
                maxVotes = proposals[proposalAddresses[p]].votes;
                winner = proposalAddresses[p];
            }
            addressVotation[proposalAddresses[p]].hasProposal = false;
            delete proposals[proposalAddresses[p]];
        }
        delete proposalAddresses;
        delete votesAddress;
        emit votationWinner(winner,proposals[winner].description,checkVotes(winner));
    }
}
interface TokenInterface{
    function balanceOf(address account) external view returns (uint256);
}