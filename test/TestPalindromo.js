const { expect } = require("chai");
const { ethers } = require("hardhat");

let palindromo

describe("Palindromo", () =>{
    
    it("Should deploy the contract", async ()=>{
        let Palindromo = await ethers.getContractFactory("Palindromo");
        palindromo = await Palindromo.deploy();
    });
    it("Should print 321123 is a palindrome", async ()=>{
        let printResponse = await palindromo.verificaPalindromo(321123);
        expect(printResponse).to.be.equal(true);
    });
    it("Should print 321 is not a palindrome", async ()=>{
        let printResponse = await palindromo.verificaPalindromo(321);
        expect(printResponse).to.be.equal(false);
    });
    
});