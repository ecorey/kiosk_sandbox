// imports
import { getFullnodeUrl, SuiClient, SuiHTTPTransport  } from "@mysten/sui.js/client";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { TransactionBlock } from "@mysten/sui.js/transactions";
import wallet from './dev-wallet.json' assert { type: 'json' };
import { WebSocket } from 'ws';

import { decodeSuiPrivateKey } from '@mysten/sui.js/cryptography';



// generate keypair_one from a .json file with the raw bytes of the private key
const privateKeyArray = wallet.privateKey.split(',').map(num => parseInt(num, 10));
const privateKeyBytes = new Uint8Array(privateKeyArray);
const keypair_one = Ed25519Keypair.fromSecretKey(privateKeyBytes);


// pb / pk keypair_one
console.log(`Public Key: ${keypair_one.getPublicKey().toSuiAddress()}`);

console.log(`Public Key to raw bytes: ${keypair_one.getPublicKey().toRawBytes()}`);

console.log(`Secret Key to raw bytes: ${privateKeyBytes}`);









// pb / pk keypair_two

// generate a keypair from mnemonic
const exampleMnemonic = 'treat rain attract net shiver try disagree veteran minimum unfold borrow ice';
 
const keyPair_two = Ed25519Keypair.deriveKeypair(exampleMnemonic);

// logs the public key
console.log(`Public Key 2: ${keyPair_two.getPublicKey().toSuiAddress()}`);

console.log(`Public Key 2 to raw bytes: ${keyPair_two.getPublicKey().toRawBytes()}`);


// logs the private key
const pk_two = keyPair_two.getSecretKey();

console.log(`Private Key 2: ${pk_two}`);

// get pkey encoded from the secretKey function then decode it
const secKey_two = 'suiprivkey1qzj5dtex3nv4qz7mjerzrkv4yyhrm6uxmpt5hyfk9jft5qyqjcat2rfst8m';


const secKey  = decodeSuiPrivateKey(secKey_two);

console.log(`Private Key 2 to raw bytes: ${secKey.secretKey}`);









// client
const client = new SuiClient({
    transport: new SuiHTTPTransport({
        url: getFullnodeUrl('testnet'),
        WebSocketConstructor: WebSocket
    }),
});






(async () => {
    try {
     
        
        // create Transaction Block
        const txb = new TransactionBlock();
        

       

       

    


        







        
        // finalize the transaction block
        let txid = await client.signAndExecuteTransactionBlock({
            signer: keypair_one,
            transactionBlock: txb,
        });
        


        // log the transaction result
        console.log(`Transaction result: ${JSON.stringify(txid, null, 2)}`);
        console.log(`success: https://suiexplorer.com/txblock/${txid.digest}?network=testnet`);



    } catch (e) {
        console.error(`error: ${e}`);
    }
})();
