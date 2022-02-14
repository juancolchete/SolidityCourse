//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Palindromo{
    
    function verificaPalindromo(uint256 palindromo) public pure returns(bool){
        uint rev = 0;
        uint palindromoAux = palindromo;
        while(palindromoAux > 0){
            rev = rev * 10 + palindromoAux % 10;
            palindromoAux =  palindromoAux/10;
        }

        if (rev == palindromo ) {
            return true;
        }else{
            return false;
        }
    }
}