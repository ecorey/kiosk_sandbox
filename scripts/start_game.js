// imports
import { getFullnodeUrl, SuiClient, SuiHTTPTransport  } from "@mysten/sui.js/client";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { TransactionBlock } from "@mysten/sui.js/transactions";
import walletDev from './wallet-three.json' assert { type: 'json' };

import { WebSocket } from 'ws';



// generate a keypair
const privateKeyArray = walletDev.privateKey.split(',').map(num => parseInt(num, 10));
const privateKeyBytes = new Uint8Array(privateKeyArray);
const keypairdev = Ed25519Keypair.fromSecretKey(privateKeyBytes);


// PUBLISH MOVE CONTRACT THEN SET THE TARGET AND UPDATE MOVE CALLS TO USE THE NEW TARGET
// GET: current time
// CREATE: predict epoch and report epoch with the correct times
// GET: start game cap, predict epoch and report epoch ids and use them to start the game
// CLOSE: the game with the game id and a game result
// WITHDRAW: balance from the game
// DELETE: the game cap 


// CONSTS
const PACKAGE_ID = "0x94c8171fd7978a6ab311f8bd6f9269b5ea0d337c3ab5c38c3fca778e40d1e992";
const itemType = `${PACKAGE_ID}::kiosk_practice::Prediction`;

// pub key for wallet-three used to publish the package
const devPubwallet = "0x07095af51002db0e9be284b8dab97263f77fec2a1be68cd42b7dd2358a6eccdd";
const tx_block = "FnmPTA94PRDEaNbqMdZHVSQjcFatJiL2hg82EzLMbzev";

// const for the move calls
const clock = "0x6";

//  created in init
const start_game_cap = "0x3329d892922305b8c6d4665b6a85f70201097d6f7e199544d248e1f8d080a31a";
const end_game_cap = "0xf555c89e1df736f752a6cd72f85ac06b7c402ef73ba36c90e245eb0e87b74032";
const game_owner_cap = "0x3d76f965ac3e057a0ed18023482a146fc6d1c23143a767a956cb34bda4b81f43";
const transfer_policy_cap = "0xea7ed3d8275c99f3bc3f7c826850ed26a0be3ee1465def188cf93a9225429b58";
const publisher = "0x596d7621cb31c9c926ae8848981c5062624e96c05ccb7f2a1bf953371058405f";
const upgrade_cap = "0x5c1c1687f7a4a7a738b58e940eb3d6d760c148d720924b8b12d1b8ddbf4fc4aa";


const game_id ="";





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






        // GET THE CURRENT TIME

        const current_time = txb.moveCall({
            target: `${PACKAGE_ID}::kiosk_practice::get_time`,
            arguments: [ ],
        });


        console.log(`Current Time: ${current_time}`);

        




        // CREATE PREDICT EPOCH AND REPORT EPOCH

        // const predict_start_time = 22;
        // const predict_end_time = 555;

        // const report_start_time = 555;
        // const report_end_time = 777;
        

        // const predict_epoch = txb.moveCall({
        //     target: `${PACKAGE_ID}::kiosk_practice::set_predict_epoch`,
        //     arguments: [ txb.pure.u64(predict_start_time), txb.pure.u64(predict_end_time) ],
        // });


        // const report_epoch = txb.moveCall({
        //     target: `${PACKAGE_ID}::kiosk_practice::set_report_epoch`,
        //     arguments: [ txb.pure.u64(report_start_time), txb.pure.u64(report_end_time) ],
        // });





        // START THE GAME

        // const game_price = 1000000;
        
        // const new_game = txb.moveCall({
        //     target: `${PACKAGE_ID}::kiosk_practice::start_game`,
        //     arguments: [ txb.object(start_game_cap), txb.pure.u64(game_price), txb.object(predict_epoch), txb.object(report_epoch), txb.object(clock)],
        // });





        // GET THE GAME BALANCE

        // const game_balance = txb.moveCall({
        //         target: `${PACKAGE_ID}::kiosk_practice::get_game_balance`,
        //         arguments: [ ],
        //     });


        // console.log(`Game balance: ${game_balance}`)





        //WITHDRAW THE BALANCE FROM THE GAME

        // let amount = 0;

        // txb.moveCall({
        //     target: `${PACKAGE_ID}::kiosk_practice::withdraw_balance_from_game`,
        //     arguments: [ txb.object(game_owner_cap), txb.object(game_id), txb.pure.u64(amount)],
        // });

        


        // CLOSE THE GAME

        // const game_result = 232;

        // txb.moveCall({
        //     target: `${PACKAGE_ID}::kiosk_practice::close_game`,
        //     arguments: [ txb.object(end_game_cap), txb.object(game_id), txb.pure.u64(game_result)],
        // });





        // DELETE THE GAME OWNER CAP

        // txb.moveCall({
        //     target: `${PACKAGE_ID}::kiosk_practice::delete_game_owner_cap`,
        //     arguments: [ txb.object(end_game_cap)],
        // });





        

        
    
        



      


















        
        // finalize the transaction block
        let txid = await client.signAndExecuteTransactionBlock({
            signer: keypairdev,
            transactionBlock: txb,
        });
        


        // log the transaction result
        console.log(`Transaction result: ${JSON.stringify(txid, null, 2)}`);
        console.log(`success: https://suiexplorer.com/txblock/${txid.digest}?network=testnet`);



    } catch (e) {
        console.error(`error: ${e}`);
    }
})();
