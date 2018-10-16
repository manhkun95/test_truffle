pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Orders.sol";

contract TestOrders {
  Orders orders = Orders(DeployedAddresses.Orders());
  function testUserCanCreateOrder() public {
    uint returnedId = orders.createOrder(1, "HeadPhone", 1, 1000, "C14 Bac Ha", 1, 0xc7b03736163079Db290bfE97038C1365FAF0Af88);
    uint expected = 1;

    Assert.equal(returnedId, expected, "Order should be recorded.");
  }

  function testUserGetListOrder() public {
    uint[] results = orders.ordersOfCustomer[msg.sender];
    uint expected = 1;

    Assert.equal(results[0], expected, "Order should be recorded.");
  }
}