// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract LuckyDraw {
    using SafeMath for uint256;
    uint private maxParticipantNumbers;
    uint public participantNumbers;
    uint private ticketPrice;
    address public owner;
    address payable [] public participants;
    address payable [] public winners;

    
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

    function listParticipants() public view returns(address payable [] memory){
        return participants;
    }

    function listWinners() public view returns(address payable [] memory){
        return winners;
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

            if (participantNumbers == maxParticipantNumbers){
                pickwinner();
            }
        }
    }
    
    function random() private view returns(uint){
        return uint(keccak256(abi.encode(block.difficulty, block.timestamp, participants, block.number)));
    }

    function setWinner() private {
        uint256 total = participantNumbers * ticketPrice;
        uint win = random() % participants.length;
        
        participants[win].transfer(total.div(10) * 9);

        winners.push(participants[win]);

        delete participants;
        participantNumbers = 0;
        
    }
    
    function pickwinner() internal{
        setWinner();
    }
    
    function endGame() external onlyOwner{
        setWinner();
    }
    function listMaxParticipants() public view returns(uint256){
        return maxParticipantNumbers;
    }
}