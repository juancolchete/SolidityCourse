//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract list02{
    uint32 private _firstValue = 20;
    uint32 private _secondValue = 10;
    event sumResult(uint32 fistValue, uint32 secondValue, uint64 sum);

    function sumView() public view returns(uint64){
        return _firstValue + _secondValue;
    }

    function sumPure(uint32 firstNum, uint32 secondNum) public pure returns(uint64){
        return firstNum + secondNum;
    }

    function sumNonPayable(uint32 firstValue, uint32 secondValue) public returns(uint64){
        _firstValue = firstValue;
        _secondValue = secondValue;
        uint64 sum = _firstValue + _secondValue;
        emit sumResult(_firstValue,_secondValue,sum);
    }
}