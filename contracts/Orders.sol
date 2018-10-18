pragma solidity ^0.4.23;

contract Orders {
  struct Order {
    uint productId;
    string name;
    uint quantity;
    uint price;
    string shippingAddress;
    uint shippingFee;
    int8 orderStatus;
    uint shippingTime;
    uint createdAt;
    uint updatedAt;
  }
  
  Order[] public orders;
  mapping (uint => address) ordersToShop;
  mapping( address => uint[]) ordersOfShop;
  mapping ( address => uint[]) ordersOfCustomer;

  event NewOrder(
    uint productId, string name, uint quantity,
    uint price, string shippingAddress, uint shippingFee,
    uint orderStatus, uint shippingTime, uint createdAt,
    uint updatedAt
  );

  event UpdateOrder(uint _id, int8 status);

  modifier orderExits(uint _id) {
    require(_id < orders.length, "Order does not exist.");
    _;
  }

  // Check if msg.sender have permission to get order info
  modifier canGetOrderInfo(uint _id) {
    require(orderBeLongCustomer(_id) || orderBeLongShop(_id), "Don't have permission to get this order.");
    _;
  }

  function createOrder(uint _productId, string _name, uint _quantity, uint _price, string _shipAddress, uint _shippingFee, address _shopAddress)
    public returns (uint) {
    uint id = orders.push(Order(_productId, _name, _quantity, _price, _shipAddress, _shippingFee, 0, 0, now, now)) - 1;
    ordersToShop[id] = _shopAddress;
    ordersOfShop[_shopAddress].push(id);
    ordersOfCustomer[msg.sender].push(id);
    emit NewOrder(_productId, _name, _quantity, _price, _shipAddress, _shippingFee, 0, 0, now, now);
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

  function getOrderLength() public view returns (uint) {
    return orders.length;
  }

  function getOrderById(uint _id) external view 
  orderExits(_id)
  canGetOrderInfo(_id) 
  returns (uint, string, uint, uint, string, uint, int8, uint, uint, uint) 
  {
    Order memory order = orders[_id];
    return (
      order.productId, order.name,order.quantity,
      order.price, order.shippingAddress, order.shippingFee,
      order.orderStatus, order.shippingTime, order.createdAt,
      order.updatedAt
    );
  }

  function updateOrderStatus(uint _id, int8 _status) public orderExits(_id) {
    require(_status <= 5, "Status is invalid.");
    if (_status == 4 || _status == -1) {
      require(orderBeLongCustomer(_id), "Don't have permission to update this order.");
    } else {
      require(orderBeLongShop(_id), "Don't have permission to update this order.");
    }
    orders[_id].orderStatus = _status;
    emit UpdateOrder(_id, _status);
  }

  //Check if shop is owner of this order
  function orderBeLongShop(uint _id) internal view returns (bool) {
    uint[] memory orderIdsOfshop = ordersOfShop[msg.sender];
    for(uint i = 0; i < orderIdsOfshop.length; i++) {
      if(orderIdsOfshop[i] == _id) {
        return true;
      }
    }
    return false;
  }

  //Check if sender is owner of this order
  function orderBeLongCustomer(uint _id) internal view returns (bool) {
    uint[] memory orderIdsOfCustomer = ordersOfCustomer[msg.sender];
    for(uint i = 0; i < orderIdsOfCustomer.length; i++) {
      if(orderIdsOfCustomer[i] == _id) {
        return true;
      }
    }
    return false;
  }
}