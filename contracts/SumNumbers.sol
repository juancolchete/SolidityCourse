// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract SumNumbers{
    uint256 num1 = 10;
    uint256 num2 = 90;   

    event SumNumbersDefault(uint256 n1, uint256 n2, uint256 result);

    function SumNumbersPure(uint256 num1, uint256 num2) public pure returns(uint256){
        return (num1 + num2);
    }
    
    function SumNumbersView() public view returns(uint256){
        return (num1 + num2);
    }

    function SumNumbersNonPayable(uint256 n1, uint256 n2) public returns(uint256){
        setNumbers(n1,n2);
        uint256 result = num1+num2;
        emit SumNumbersDefault(n1, n2,result);
    }

    function setNumbers(uint256 n1,uint256 n2) public{
        num1 = n1;
        num2 = n2;
    }
}