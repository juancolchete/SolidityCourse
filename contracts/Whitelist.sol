pragma solidity ^0.8.9;

contract WhiteList{
    mapping(address => bool) private _whiteList;

    function addToWhiteList(address addr) public{
        _whiteList[addr] = true;
    }

    function isInList(address addr) public view returns(bool){
        return _whiteList[addr];
    }

    function remove(address addr) public{
        _whiteList[addr] = false;
    }

    function onlyWhiteListed() public view returns(string memory){
        require(_whiteList[msg.sender],"You are not in the whitelist !!");
        return "Welcome back";
    }
}