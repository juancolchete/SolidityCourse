const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Hello World", () =>{
  it("Should print hello world", async ()=>{
    let HelloWorld = await ethers.getContractFactory("HelloWorld");
    let helloWorld = await HelloWorld.deploy();
    let printResponse = await helloWorld.PrintHelloWorld();
    expect(printResponse).to.be.equal("Hello World");
  });
});