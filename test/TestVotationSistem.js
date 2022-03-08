const { expect } = require("chai");
const { ethers } = require("hardhat");
let signers;
let trustToken;
let untrustToken;
let testVotationSistem;
let company = 1;
async function addBallance(balanceData){
    for(let i = 0; i< balanceData.length; i++){
        await untrustToken.connect(signers[company]).transfer(balanceData[i].account,balanceData[i].untrustToken);
        await trustToken.connect(signers[company]).transfer(balanceData[i].account,balanceData[i].trustToken);
    }
}
describe("TestVotationSistem", () =>{
    it("Should deploy the contract", async ()=>{
        signers = await ethers.getSigners();
        let TrustToken = await ethers.getContractFactory("TrustToken");
        let UntrustToken = await ethers.getContractFactory("UntrustToken");
        let TestVotationSistem = await ethers.getContractFactory("VotationSistem");
        trustToken = await TrustToken.deploy();
        untrustToken = await UntrustToken.deploy();
        let trustTokenContract = trustToken.deployTransaction.creates;
        let untrustTokenContract = untrustToken.deployTransaction.creates;
        testVotationSistem = await TestVotationSistem.deploy(trustTokenContract,untrustTokenContract);
        let minterRole = await trustToken.MINTER_ROLE();
        await untrustToken.grantRole(minterRole,signers[company].address);
        await trustToken.grantRole(minterRole,signers[company].address);
        await untrustToken.transfer(signers[company].address,'40000000000000000000');
        await trustToken.transfer(signers[company].address,'40000000000000000000');
    });
    it("Should add 3 eligible accounts",async ()=>{
        let balanceData = [
            {account: signers[2].address,trustToken: 1000, untrustToken: 900},
            {account: signers[3].address,trustToken: 500, untrustToken: 0},
            {account: signers[4].address,trustToken: 100, untrustToken: 90},
        ]
        await addBallance(balanceData);
    })      
    it("Should insert proposal on the sistem ", async ()=>{
        await testVotationSistem.connect(signers[3]).addProposal("Change all school drinking fountain for coke");
        let printResponse = await testVotationSistem.checkProposal(signers[3].address);
        expect(printResponse).to.be.equal("Change all school drinking fountain for coke");
    });
    it("Should remove proposal on the sistem ", async ()=>{
        await testVotationSistem.connect(signers[3]).removeProposal(signers[3].address);
        let printResponse = await testVotationSistem.checkProposal(signers[3].address);
        expect(printResponse).to.be.equal("");
    });
    it("Should insert two proposal on the sistem ", async ()=>{
        await testVotationSistem.connect(signers[3]).addProposal("Change all school drinking fountain for coke");
        await testVotationSistem.connect(signers[4]).addProposal("Change school uniforms to normal clothes");
        let printResponse = await testVotationSistem.checkProposal(signers[3].address);
        expect(printResponse).to.be.equal("Change all school drinking fountain for coke");
        printResponse = await testVotationSistem.checkProposal(signers[4].address);
        expect(printResponse).to.be.equal("Change school uniforms to normal clothes");
    });
    it("Should register a vote ", async ()=>{
        await testVotationSistem.connect(signers[4]).addVote(signers[3].address)
        let voterBefore = await testVotationSistem.checkVotes(signers[3].address);
        let checkTrustBalance = await testVotationSistem.checkTrustBalance(signers[4].address);
        expect(voterBefore).to.be.equal(checkTrustBalance);
    });
    it("Should pick the winner, that is the 3 signer proposal", async () =>{
        let printResponse = await testVotationSistem.pickWinner();
        printResponse = await printResponse.wait()
        console.log(printResponse)
        expect(printResponse[0]).to.be.equal(signers[3].address);
    })
});

