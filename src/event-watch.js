var Main = require ('../build/contracts/Main.json');
var Web3 = require('web3');
var contractAddress = '0xb9F6646f0873C85726aC24050e5372dA9654e1f5';

const web3 = new Web3("ws://localhost:9545");
const main = new web3.eth.Contract(Main.abi, contractAddress);
main.events.notifyChecker({ filter: { adr: '0x0F25a8182aED9AA848FF1C66760618821EC83c43' }})
.on("data", function (event) {
    let data = event.returnValues;
    console.log('Get event 1');
    console.log(data);
})
.on("error", console.error);

main.events.checkDone({ filter: { userName: 1 }})
.on("data", function (event) {
    let data = event.returnValues;
    console.log('checkDone');
    console.log(data);
})
.on("error", console.error);