// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract modifierSample{

    address payable owner;

    constructor() public{
        owner = msg.sender;
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner,"Access denied");
        _;
    }

    function getAnswer() public onlyOwner view returns(uint8) {
        return 42;
    } 
}