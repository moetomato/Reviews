var Main = require ('../build/contracts/Main.json');
var Web3 = require('web3');

const web3 = new Web3("ws://localhost:9545");
const as = new web3.eth.Contract(Main.abi, '0x0ad12162Db261783a3e0DE118C00314843fE7132');
as.events.test()
.on("data", function (event) {
    let data = event.returnValues;
    console.log('Get event');
    console.log(data);
})
.on("error", console.error);