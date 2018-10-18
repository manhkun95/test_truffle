var Orders = artifacts.require("Orders");

contract('Orders', async (accounts) => {
  let install;
  beforeEach(async () => {
    install = await Orders.deployed();
  });
  it("Test case create order", async () => {
    const returnId = await install.createOrder.call(1, "Head Phone", 1, 1000, "C14 Bac Ha", 1, "0xc7b03736163079Db290bfE97038C1365FAF0Af88");
    const expected = 0;
    assert.equal(expected, returnId.toNumber(), "Order should be recoded");
  });
  it("Test case get order info", async () => {
    await install.createOrder(1, "Head Phone", 1, 1000, "C14 Bac Ha", 1, "0xc7b03736163079Db290bfE97038C1365FAF0Af88");
    const results = await install.getOrderById.call(0, { from: "0xc7b03736163079Db290bfE97038C1365FAF0Af88" });
    assert.equal(results[0].toNumber(), 1, "ProductId should be equal 1");
    assert.equal(results[1], "Head Phone", "Product name should be equal Head Phone");
    assert.equal(results[2].toNumber(), 1, "Quantity should be equal 1");
    assert.equal(results[3].toNumber(), 1000, "price should be equal 1000");
    assert.equal(results[4], "C14 Bac Ha", "ShipAddress should be equal C14 Bac Ha");
    assert.equal(results[5].toNumber(), 1, "Ship fee should be equal 1");
    assert.equal(results[6].toNumber(), 0, "Order status should be equal 0<Ordered>");
    assert.equal(results[7].toNumber(), 0, "Ship time should be equal 0");
  });

  it("Test case update order info", async () => {
    await install.createOrder(1, "Head Phone", 1, 1000, "C14 Bac Ha", 1, "0xc7b03736163079Db290bfE97038C1365FAF0Af88", { from: accounts[0] });
    const resultsBeforeChange = await install.getOrderById.call(0, { from: "0xc7b03736163079Db290bfE97038C1365FAF0Af88" });
    assert.equal(resultsBeforeChange[6].toNumber(), 0, "Order status should be equal 0<Ordered>");
    await install.updateOrderStatus(0, -1, { from: accounts[0] });
    const resultsAfterChange = await install.getOrderById.call(0, { from: "0xc7b03736163079Db290bfE97038C1365FAF0Af88" });
    assert.equal(resultsAfterChange[6].toNumber(), -1, "Order status should be equal 5<Order cancel>");
  });

})