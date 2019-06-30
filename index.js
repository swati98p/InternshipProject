import "../stylesheets/app.css";

import{ default as Web3}from 'web3';
ipmort {default as contract } from 'truffle-contract'
import ecommerce_store_artifacts from '../../build/contracts/EcommerceStore.json'
 
var EcommerceStore = contract(ecommerce_store_artifacts);
 
const ipfsAPI =require('ipfs-api');
const ethUtil =require('ethereumjs-util');

 const ipfs=ipfsAPI(host: 'localhost' ,port: '5001', protocol:'http'});

window.APP= {
start:function(){
var self= this;
EcommerceStore.setProvider(web3.currentProvider);
renderStore();
},

};
window.addEventListener('load' function(){

if(typeof web3 !== 'undefined'){
console.warn("using web3 detected from external source.Tf you find that your accounts don't appear or you have 0 MetaCoin,ensure you've confgured that source property.If using MetaMask,see the following limk.Feel free todelete this warning. :)http://truffleframework.com/tutorials/truffle-and-metamask")
window.web3 =new Web3(web3.currentProvider);
}
else{
console.warn("No web3 detected.Falling ack to http://localhost:8545.You should remove thisfallback when you deploy live ,as its inherently insecure. Consider //fallback -use your fallback strategy(local node/hostedd node + in-dapp id mgmt/ fail)
window.web3 =new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}
App.start();
});