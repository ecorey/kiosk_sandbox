import { getFullnodeUrl, SuiClient, SuiHTTPTransport  } from "@mysten/sui.js/client";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { TransactionBlock } from "@mysten/sui.js/transactions";
import walletDev from './dev-wallet.json' assert { type: 'json' };

import { WebSocket } from 'ws';

import {  PACKAGE, CLOCK, GUESS, GAME_ID  } from './config.js';


// ###################################
// ############MAKE PREDICTION########
// ###################################




// generate a keypair
const privateKeyArray = walletDev.privateKey.split(',').map(num => parseInt(num, 10));
const privateKeyBytes = new Uint8Array(privateKeyArray);
const keypairdev = Ed25519Keypair.fromSecretKey(privateKeyBytes);




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


        // get user balance
        const balance = await client.getBalance({ address: keypairdev.getPublicKey().toSuiAddress()} );

        console.log(`Balance: ${JSON.stringify(balance, null, 2)}`);

        const coin = await client.getCoins({ address: keypairdev.getPublicKey().toSuiAddress()} );

        let paymentCoin = txb.splitCoins(coin, 100);

        
        


        // make_prediction( predict: u64, payment: Coin<SUI>, game: &mut Game, clock: &Clock, ctx: &mut TxContext)
        txb.moveCall({
            target: `${PACKAGE}::kiosk_practice::make_prediction`,
            arguments: [  txb.pure.u64(GUESS), txb.object(paymentCoin), txb.object(GAME_ID), txb.object(CLOCK) ],
        });

        


        
        // finalize the transaction block
        let txid = await client.signAndExecuteTransactionBlock({
            signer: keypairdev,
            transactionBlock: txb,
        });
        


        // // log the transaction result
        console.log(`Transaction result: ${JSON.stringify(txid, null, 2)}`);
        console.log(`success: https://suiexplorer.com/txblock/${txid.digest}?network=testnet`);



        console.log(`END OF SCRIPT`);

    } catch (e) {
        console.error(`error: ${e}`);
    }
})();




