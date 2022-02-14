const { expect } = require("chai");
const { ethers } = require("hardhat");
let sumNumbers 
describe("Sum numbers", () =>{
    
    it("Should deploy the contract", async ()=>{
        let SumNumbers = await ethers.getContractFactory("SumNumbers");
        sumNumbers = await SumNumbers.deploy();
    });
    it("Should print sum bettwen 10 and 20 using pure function", async ()=>{
        let printResponse = await sumNumbers.SumNumbersPure(10,20);
        expect(printResponse).to.be.equal("30");
    });
    it("Should print sum bettwen 10 and 90 using view function", async ()=>{
        let printResponse = await sumNumbers.SumNumbersView();
        expect(printResponse).to.be.equal("100");
    });
    it("Should print sum bettwen 10 and 20 using default function", async ()=>{
        let printResponse = await sumNumbers.SumNumbersNonPayable(10,20);
        let txn = await printResponse.wait();
        printResponse = txn.events[0].args.result.toString()
        expect(printResponse).to.be.equal("30");
    });
});