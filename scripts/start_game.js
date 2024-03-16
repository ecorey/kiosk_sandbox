// imports
import { getFullnodeUrl, SuiClient, SuiHTTPTransport  } from "@mysten/sui.js/client";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { TransactionBlock } from "@mysten/sui.js/transactions";
import walletDev from './wallet-two.json' assert { type: 'json' };

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


// consts
const PACKAGE_ID = "";
const itemType = '::kiosk_practice::Prediction';




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
            target: '${PACKAGE_ID}::kiosk_practice::get_time',
            arguments: [ ],
        });


        console.log(`Current Time: ${current_time}`);

        




        // CREATE PREDICT EPOCH AND REPORT EPOCH

        const predict_start_time = 22;
        const predict_end_time = 555;

        const report_start_time = 555;
        const report_end_time = 777;
        

        const predict_epoch = txb.moveCall({
            target: '${PACKAGE_ID}::kiosk_practice::set_predict_epoch',
            arguments: [ txb.pure.u64(predict_start_time), txb.pure.u64(predict_end_time) ],
        });


        const report_epoch = txb.moveCall({
            target: '${PACKAGE_ID}::kiosk_practice::set_report_epoch',
            arguments: [ txb.pure.u64(report_start_time), txb.pure.u64(report_end_time) ],
        });





        // START THE GAME

        const start_game_cap = "";
        const end_game_cap = "";
        const game_price = 1000000;
        let clock = "0x6"

        
        const new_game = txb.moveCall({
            target: '${PACKAGE_ID}::kiosk_practice::start_game',
            arguments: [ txb.object(start_game_cap), txb.pure.u64(game_price), txb.object(predict_epoch), txb.object(report_epoch), txb.object(clock)],
        });





        // GET THE GAME BALANCE

        const game_balance = txb.moveCall({
                target: '${PACKAGE_ID}::kiosk_practice::get_game_balance',
                arguments: [ ],
            });


        console.log(`Game balance: ${game_balance}`)





        //WITHDRAW THE BALANCE FROM THE GAME

        const game_id ="";
        let game_owner_cap = "";
        let amount = 0;


        txb.moveCall({
            target: '${PACKAGE_ID}::kiosk_practice::withdraw_balance_from_game',
            arguments: [ txb.object(game_owner_cap), txb.object(game_id), txb.pure.u64(amount)],
        });

        


        // CLOSE THE GAME

        const game_result = 232;

        txb.moveCall({
            target: '${PACKAGE_ID}::kiosk_practice::close_game',
            arguments: [ txb.object(end_game_cap), txb.object(game_id), txb.pure.u64(game_result)],
        });





        // DELETE THE GAME OWNER CAP

        txb.moveCall({
            target: '${PACKAGE_ID}::kiosk_practice::delete_game_owner_cap',
            arguments: [ txb.object(end_game_cap)],
        });





        

        
    
        



      


















        
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
