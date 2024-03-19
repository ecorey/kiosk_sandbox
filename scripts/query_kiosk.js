import { getFullnodeUrl, SuiClient, SuiHTTPTransport } from "@mysten/sui.js/client";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { TransactionBlock } from "@mysten/sui.js/transactions";
import { WebSocket } from 'ws';
import wallet from './dev-wallet.json' assert { type: 'json' };
import { KioskClient, Network, KioskTransaction } from '@mysten/kiosk';
import {  walletThreeRef } from './config.js';

// generate a keypair
const privateKeyArray = wallet.privateKey.split(',').map(num => parseInt(num, 10));
const privateKeyBytes = new Uint8Array(privateKeyArray);
const keypair = Ed25519Keypair.fromSecretKey(privateKeyBytes);





// client
const client = new SuiClient({
    transport: new SuiHTTPTransport({
        url: getFullnodeUrl('testnet'),
        WebSocketConstructor: WebSocket
    }),
});



// kiosk client
const kioskClient = new KioskClient({
    client, 
    network: Network.TESTNET,
});







(async () => {
    try {
     
        
        // create Transaction Block
        const txb = new TransactionBlock();



        
        const address = `${walletThreeRef}`;



        const { kioskOwnerCaps, kioskIds } = await kioskClient.getOwnedKiosks({ address });

        console.log(`kiosk owner cap: ${kioskOwnerCaps}, and kioskIds: ${kioskIds}`);
         
    


        
        // finalize the transaction block
        let txid = await client.signAndExecuteTransactionBlock({
            signer: keypair,
            transactionBlock: txb,
        });
        


        // log the transaction result
        console.log(`Transaction result: ${JSON.stringify(txid, null, 2)}`);
        console.log(`success: https://suiexplorer.com/txblock/${txid.digest}?network=testnet`);



    } catch (e) {
        console.error(`error: ${e}`);
    }
})();
