const HelloWorld = artifacts.require("HelloWorld");

contract("HelloWorld", accounts => {
  it("should print hello world", () =>
    HelloWorld.deployed()
      .then(instance => instance.Hello())
      .then(message => {
        assert.equal(
          message.valueOf(),
          "Hello World!",
          "The hello world message was wrong"
        );
      }));
});