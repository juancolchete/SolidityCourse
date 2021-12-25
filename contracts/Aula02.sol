// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Aula02{
    uint public lastSum;
    mapping(address => uint256) public balances;
    //Função que altera o estado do contrato logo ao chamar gera uma transação
    //Para chamar use send()
    function sumTwo(uint256 firstNumber, uint256 secondNumber) public returns(uint256){
        lastSum = firstNumber + secondNumber;
        return lastSum;
    }
    //
    function sumTwoPure(uint256 firstNumber, uint256 secondNumber) public pure returns(uint256){
        return firstNumber + secondNumber;
    }
    function sumTwoView() public view returns(uint256){
        return lastSum + 1;
    }

    function addBalance(address payable holderAddress) public{
        return balances[holderAddress];
    }
}