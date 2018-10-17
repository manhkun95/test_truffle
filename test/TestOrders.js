var Orders = artifacts.require("Orders");
const truffleAssert = require('truffle-assertions');

contract('Orders', async (accounts) => {
  let install;
  beforeEach('Deploy contract', async () => {
    install = await Orders.deployed();
  })
  it("Create Order", async () => {

    const returnId = await install.createOrder.call(1, "HeadPhone", 1, 1000, "C14 Bac Ha", 1, 0xc7b03736163079Db290bfE97038C1365FAF0Af88);
    const expected = 0;
    truffleAssert.eventEmitted(returnId, 'NewOrder', (ev) => {
    });
    assert.equal(expected, returnId.toNumber(), "Order should be recoded");
  })

})