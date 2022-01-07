// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Lottery8 {
    
    uint private maxParticipantNumbers;
    uint public participantNumbers;
    uint private ticketPrice;
    address private owner;
    address payable[] participants;
    
    constructor(uint256 maxParticipants, uint256 ticketValue){  
        owner =  msg.sender;
        maxParticipantNumbers = maxParticipants;
        ticketPrice = ticketValue;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Access denied!");
        _;
    }
    
    modifier notOwner(){
        require(msg.sender != owner, "Access denied");
        _;
    }
    
    function setTicketPrice(uint _valueInEther) public onlyOwner{
        ticketPrice = _valueInEther;
    }
    
    function setMaximmNumbers(uint _maxNumbers) public onlyOwner{
        participantNumbers = _maxNumbers;
    }
    function viewTicketPrice() external view returns(uint){
        return ticketPrice;
    }
    
    function joinLottery() payable public notOwner(){
        require(msg.value == ticketPrice);
        if (participantNumbers < maxParticipantNumbers){
            participants.push(payable(msg.sender));
            participantNumbers++;
        }
        else if (participantNumbers == maxParticipantNumbers){
            payable(msg.sender).transfer(msg.value);
            pickwinner();
        }
    }
    
    function random() private view returns(uint){
        return uint(keccak256(abi.encode(block.difficulty, block.timestamp, participants, block.number)));
    }
    
    function pickwinner() internal{
        uint win = random() % participants.length;
        
        participants[win].transfer(address(this).balance);
        
        delete participants;
        participantNumbers = 0;
    }
    
    function endGame() external onlyOwner{
        uint win = random() % participants.length;
        
        participants[win].transfer(address(this).balance);
        
        delete participants;
        participantNumbers = 0;
    }
}