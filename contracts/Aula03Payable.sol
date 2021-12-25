// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract payableTest{
    address teste;
    address testePayable;

    function testAddress(address testP) public returns(address)
    {
        return testP;
    }

    function testAddressPayable(address payable testP) public returns(address payable)
    {
        return testP;
    }
}
