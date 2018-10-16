pragma solidity ^0.4.23;

contract Orders {
  struct Order {
    uint productId;
    string name;
    uint quantity;
    uint price;
    string shippingAddress;
    uint shippingFee;
    uint orderStatus;
    uint shippingTime;
    uint createdAt;
  }
  
  Order[] public orders;
  mapping (uint => address) ordersToShop;
  mapping( address => uint[]) ordersOfShop;
  mapping ( address => uint[]) ordersOfCustomer;

  function createOrder(uint _productId, string _name, uint _quantity, uint _price, string _shipAddress, uint _shippingFee, address _shopAddress)
    public returns (uint) {
    uint id = orders.push(Order(_productId, _name, _quantity, _price, _shipAddress, _shippingFee, 0, 0, 0)) - 1;
    ordersToShop[id] = _shopAddress;
    ordersOfShop[_shopAddress].push(id);
    ordersOfCustomer[msg.sender].push(id);
    return id;
  }

  function getOrderByCustomer() external view returns (uint[]) {
    uint[] memory results = ordersOfCustomer[msg.sender];
    return results;
  }
}