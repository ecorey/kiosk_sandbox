// imports
import { getFullnodeUrl, SuiClient } from "@mysten/sui.js/client";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { TransactionBlock } from "@mysten/sui.js/transactions";
import wallet from './dev-wallet.json' assert { type: 'json' };


// generate a keypair
const privateKeyArray = wallet.privateKey.split(',').map(num => parseInt(num, 10));
const privateKeyBytes = new Uint8Array(privateKeyArray);
const keypair = Ed25519Keypair.fromSecretKey(privateKeyBytes);

// client
const client = new SuiClient({
    url: getFullnodeUrl('testnet'),
});


(async () => {
    try {
     
        
        // create Transaction Block
        const txb = new TransactionBlock();
        

        // const kp1 = keypair.getPublicKey().toSuiAddress();
       
        console.log(`Public Key: ${keypair.getPublicKey().toRawBytes()}`);

       

        // console.log(
        //     `kp1: ${ keypair(kp1) }`
        // )
       


    } catch (e) {
        console.error(`error: ${e}`);
    }
})();
