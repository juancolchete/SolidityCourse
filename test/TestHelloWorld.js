const { expect } = require("chai");

describe("HelloWorld", accounts => {
  it("should print hello world", async () =>{
    let HelloWorld = await ethers.getContractFactory("HelloWorld");
    let helloWorld = await HelloWorld.deploy();
    let helloWorldText = await helloWorld.Hello();
    expect(helloWorldText).to.equal("Hello World!");
  })
});