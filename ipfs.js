//using the infura.io node, otherwise ipfs requires you to run a daemon on your own computer/server. See IPFS.io docs
const IPFS = require('ipfs-api')

const ipfs = new IPFS({ host: 'ipfs.infura.io', port: 5001, protocol: 'https' })
obj = {
    name: "teste"
}
var buf = Buffer.from(JSON.stringify(obj))
ipfs.add(buf, (err, ipfsHash) => {
  console.log(ipfsHash, "https://cloudflare-ipfs.com/ipfs/" + ipfsHash[0].hash)
})
