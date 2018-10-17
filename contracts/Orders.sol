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
    uint updatedAt;
  }
  
  Order[] orders;
  mapping (uint => address) ordersToShop;
  mapping( address => uint[]) ordersOfShop;
  mapping ( address => uint[]) ordersOfCustomer;

  event NewOrder(
    uint productId, string name, uint quantity,
    uint price, string shippingAddress, uint shippingFee,
    uint orderStatus, uint shippingTime, uint createdAt,
    uint updatedAt
  );

  event UpdateOrder(uint _id, uint status);

  modifier orderExits(uint _id) {
    require(_id < orders.length, "Order does not exist.");
    _;
  }

  // Check if msg.sender have permission to get order info
  modifier canGetOrderInfo(uint _id) {
    require(checkOrderBeLongCustomer(_id) || checkOrderBeLongShop(_id), "Don't have permission to get this order.");
    _;
  }

  function createOrder(uint _productId, string _name, uint _quantity, uint _price, string _shipAddress, uint _shippingFee, address _shopAddress)
    public returns (uint) {
    uint id = orders.push(Order(_productId, _name, _quantity, _price, _shipAddress, _shippingFee, 0, 0, now, now)) - 1;
    ordersToShop[id] = _shopAddress;
    ordersOfShop[_shopAddress].push(id);
    ordersOfCustomer[msg.sender].push(id);
    // emit NewOrder(_productId, _name, _quantity, _price, _shipAddress, _shippingFee, 0, 0, now, now);
    return id;
    
  }

  function getOrderIdsByCustomer() external view returns (uint[]) {
    uint[] memory orderIds = ordersOfCustomer[msg.sender];
    return orderIds;
  }

  function getOrderIdsByShop() external view returns (uint[]) {
    uint[] memory orderIds = ordersOfShop[msg.sender];
    return orderIds;
  }

  function getOrderById(uint _id) external view 
  orderExits(_id)
  canGetOrderInfo(_id) 
  returns (uint, string, uint, uint, string, uint, uint, uint) 
  {
    Order memory order = orders[_id];
    return (
      order.productId, order.name,order.quantity,
      order.price, order.shippingAddress, order.shippingFee,
      order.shippingTime, order.createdAt
    );
  }

  function updateOrderStatus(uint _id, uint status) public {
    require(status <= 5, "Status is invalid.");
    if (status == 4) {
      require(checkOrderBeLongCustomer(_id), "Don't have permission to update this order.");
    } else {
      require(checkOrderBeLongShop(_id), "Don't have permission to update this order.");
    }
    orders[_id].orderStatus = status;
    // emit UpdateOrder(_id, status);
  }

  function checkOrderBeLongShop(uint _id) internal view returns (bool) {
    uint[] memory orderIdsOfshop = ordersOfShop[msg.sender];
    for(uint i = 0; i < orderIdsOfshop.length; i++) {
      if(orderIdsOfshop[i] == _id) {
        return true;
      }
    }
    return false;
  }

  function checkOrderBeLongCustomer(uint _id) internal view returns (bool) {
    uint[] memory orderIdsOfCustomer = ordersOfCustomer[msg.sender];
    for(uint i = 0; i < orderIdsOfCustomer.length; i++) {
      if(orderIdsOfCustomer[i] == _id) {
        return true;
      }
    }
    return false;
  }
}