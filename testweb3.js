var Web3 = require('web3');
var fs = require('fs');

var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
var jsonFile = "./build/contracts/Orders.json";
var parsed = JSON.parse(fs.readFileSync(jsonFile));
var abi = parsed.abi;

var orderInstall = new web3.eth.Contract(abi, "0x8dccacbf073ab7d1b0485e8cbcfdbbbbf54e7565");
web3.eth.defaultAccount = web3.eth.accounts[0];
orderInstall.methods.createOrder(1, "HeadPhone", 1, 1000, "C14 Bac Ha", 1, "0xc7b03736163079Db290bfE97038C1365FAF0Af88")
  .call()
  .then(result => {
    console.log(result)
    console.log(orderInstall.methods.getOrderByCustomer().call().then(res => console.log(res.length)))
  });