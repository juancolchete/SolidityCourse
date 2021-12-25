// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract lottery{
    uint16 private _maxParticipantNumbers;
    uint16 private _participantsNumbers;
    uint16 private _ticketPrice;
    address payable[] _participants;
    address payable owner;

    modifier onlyOwner(){
        require(msg.sender == owner,"Access denied");
        _;
    }
    modifier notOwner(){
        require(msg.sender != owner,"Access denied");
        _;
    }

    function random() private view returns(uint){
        return uint(keccak256(abi.encode(block.difficulty, now, _participants, block.number)));
    }
    function getRandom() public view returns(uint){
        return (random()%(501-200))+200;
    }
}