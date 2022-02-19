//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Wait30 {
    uint256 public deployTime;
    
    constructor (){
        deployTime = block.timestamp;
    }
    
    function warmingUp() public view returns(string memory){
       require((block.timestamp - deployTime) > 30,"This contract is warming up, wait 30 seconds");
       return "Surprise NGQ2ZjY0NjE2Njc1NjM2YjY1NzI=";
    }
}