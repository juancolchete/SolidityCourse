const { expect } = require("chai");
const { ethers } = require("hardhat");
let signerAddresses;
let firstAddress = "0x1D8989d956A015AE1333d9ee2a7a42b403426dFd";
let secondAddress = "0xBd3D3C0bCc3FBdDedd019277012ab2da6BB294F5";

describe("WhiteList", () =>{
    
    it("Should deploy the contract", async ()=>{
        let WhiteList = await ethers.getContractFactory("WhiteList");
        signerAddresses = await ethers.getSigners();
        whitelist = await WhiteList.deploy();
        whitelist.addToWhiteList(signerAddresses[0].address);
    });
    it("Should print that you are in the whitelist", async ()=>{
        await whitelist.addToWhiteList(firstAddress)
        let printResponse = await whitelist.isInList(firstAddress);
        expect(printResponse).to.be.equal(true);
    });
    it("Should print that you are not in the whitelist", async ()=>{
        let printResponse = await whitelist.isInList(secondAddress);
        expect(printResponse).to.be.equal(false);
    });
    it("Should remove the address from the whitelist and check if the address is really out", async ()=>{
        await whitelist.remove(firstAddress)
        let printResponse = await whitelist.isInList(firstAddress);
        expect(printResponse).to.be.equal(false);
    });
    it("Should only allow address from whitelist to execute", async ()=>{
        let printResponse = await whitelist.onlyWhiteListed();
        expect(printResponse).to.be.equal("Welcome back");
    });
    it("Should not allow to execute onlyWhiteListed function", async ()=>{
        await whitelist.remove(signerAddresses[0].address);
        expect(whitelist.onlyWhiteListed()).to.be.revertedWith("You are not in the whitelist !!");
    });
});