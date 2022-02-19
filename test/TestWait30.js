const { expect } = require("chai");
const { ethers } = require("hardhat");



describe("Wait30", () =>{
    
    it("Should deploy the contract", async ()=>{
        let Wait30 = await ethers.getContractFactory("Wait30");
        wait30 = await Wait30.deploy();
    });  
    it("Should decline,and say that the contracts is warming up", async ()=>{
        await expect(wait30.warmingUp()).to.be.revertedWith("This contract is warming up, wait 30 seconds");
    });
    it("Should show Surprise", async ()=>{
        setTimeout(async ()=>{
            let printResponse = await wait30.warmingUp();
            expect(printResponse).to.be.equal("Surprise NGQ2ZjY0NjE2Njc1NjM2YjY1NzI=");
        },30000);
    });
});