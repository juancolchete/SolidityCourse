const { expect } = require("chai");
const { ethers } = require("hardhat");
let list02;

describe("list02", accounts =>{
    it("Initialize test", async()=>{
        let List02 = await ethers.getContractFactory("list02");
        list02 = await List02.deploy();
        await list02.deployed();
    })
    it("Should return 30 in view sum strategy",async ()=>{
        let sum = await list02.sumView();
        expect(sum).to.equal(30)
    });
    it("Should return 100 in pure sum strategy", async ()=>{
        let sum = await list02.sumPure(25,75);
        expect(sum).to.equal(100);
    });
    it("Should return 260 in non-payable sum strategy", async ()=>{
        let sum = await list02.sumNonPayable(100,160);
        let txnData = await sum.wait()
        let sumResult = parseInt(txnData.events[0].args.sum.toString());
        expect(sumResult).to.equal(260);
    })
})