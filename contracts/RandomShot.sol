//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract RandomShot{
    string [] array_participants;
    function random() private view returns(uint){
        return uint(keccak256(abi.encode(block.difficulty, block.timestamp, array_participants, block.number)));
    }
    
    function sortWinner() public view returns(string memory){
        uint win = random() % array_participants.length;
        return array_participants[win];
    }

    function addParticipants(string memory name) public {
        array_participants.push(name);
    }
}