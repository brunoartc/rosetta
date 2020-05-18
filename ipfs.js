//using the infura.io node, otherwise ipfs requires you to run a daemon on your own computer/server. See IPFS.io docs
const IPFS = require('ipfs-api');
var fs = require("fs");


const ipfs = new IPFS({ host: 'ipfs.infura.io', port: 5001, protocol: 'https' });
// Asynchronous read
fs.readFile('index.html', function (err, data) {
    if (err) {
       return console.error(err);
    }
    ipfs.add(data , (err, ipfsHash) => {
        console.log(ipfsHash);
        
        }); //storehash 
 });

