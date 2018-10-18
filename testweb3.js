// var Web3 = require('web3');
// var fs = require('fs');

// var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
// var jsonFile = "./build/contracts/Orders.json";
// var parsed = JSON.parse(fs.readFileSync(jsonFile));
// var abi = parsed.abi;

// var orderInstall = new web3.eth.Contract(abi, "0x8dccacbf073ab7d1b0485e8cbcfdbbbbf54e7565");
// web3.eth.defaultAccount = web3.eth.accounts[0];
// orderInstall.methods.createOrder(1, "HeadPhone", 1, 1000, "C14 Bac Ha", 1, "0xc7b03736163079Db290bfE97038C1365FAF0Af88")
//   .call()
//   .then(result => {
//     console.log(result)
//     console.log(orderInstall.methods.getOrderByCustomer().call().then(res => console.log(res.length)))
//   });

const Web3 = require('web3');
var fs = require('fs');
const { CryptoUtils, Client, LocalAddress, LoomProvider } = require('loom-js')
const privateKey = CryptoUtils.generatePrivateKey()
const publicKey = CryptoUtils.publicKeyFromPrivateKey(privateKey)

// Create the client
const client = new Client(
  'default',
  'ws://127.0.0.1:46658/websocket',
  'ws://127.0.0.1:46658/queryws',
)

// The address for the caller of the function
const from = LocalAddress.fromPublicKey(publicKey).toString()

// Instantiate web3 client using LoomProvider
const web3 = new Web3(new LoomProvider(client, privateKey))

var jsonFile = "./build/contracts/Orders.json";
var parsed = JSON.parse(fs.readFileSync(jsonFile));
const ABI = parsed.abi;

const contractAddress = '0x216de686ccf8d28588a04b641a30be817beb6b92'

// Instantiate the contract and let it ready to be used
const orderInstall = new web3.eth.Contract(ABI, contractAddress, { from });
// web3.eth.defaultAccount = web3.eth.accounts[0];
orderInstall.methods.createOrder(1, "HeadPhone", 1, 1000, "C14 Bac Ha", 1, "0xc7b03736163079Db290bfE97038C1365FAF0Af88").send({ from: undefined })
  .then(function (result, err) {
    if (err) {
      console.log("MERR:", err);
    } else {
      console.log("RESULT:", result);
    }
  })

setTimeout(function () {
  web3.eth.getAccounts((error, accounts) => console.log(accounts[0]))
  orderInstall.methods.getOrderIdsByCustomer().call().then(console.log);
}, 2000);
// console.log(privateKey, from);
// orderInstall.methods.getOrderIdsByCustomer().call({ from }).then(console.log);
// // orderInstall.methods.getOrderById(1).call({ from: "0xc7b03736163079Db290bfE97038C1365FAF0Af88" }).then(result => console.log(result[1]));