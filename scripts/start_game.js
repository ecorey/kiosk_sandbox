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
const PACKAGE_ID = "0x33bc9889f0b844a240b7c98e9d5571d6c154c74426da92e3dc9429d6c7a27450";
const itemType = `${PACKAGE_ID}::kiosk_practice::Prediction`;

// pub key for wallet-three used to publish the package
const devPubwallet = "0x07095af51002db0e9be284b8dab97263f77fec2a1be68cd42b7dd2358a6eccdd";
const tx_block = "";

// const for the move calls
const clock = "0x6";

//  created in init
const start_game_cap = "0xf144f5bee4a401efd5efbf6f16c9209362b9248b667979b678ad59117d2444b3";
const end_game_cap = "0xf347525fb401c8433cfab3771fffae980366c9ec4b8b493578c010e9921bf084";
const game_owner_cap = "0x965db27ef9ce407464b28009dc8bd5f438b38287a80d99ffbb0e0262be5813f9";
const transfer_policy_cap = "0x67d6d5ccb164201444030f26cf917d70848d7f4d896f70788acac4b390b2050b";
const publisher = "0x0b474c2637fb421b36fde2497307b402f071224d1ee9974f349d3b548e48fc21";
const upgrade_cap = "0x58ee86ee24b5be8e1a86a8bc18af4ef15f711a774e379edfd0e9f1e3143ef7d9";


// TIME STAMPS (election event on Nov. 5)
// get from get time event log
const predict_start_time = 1710618180870;
// November 3, 2024, at 12:00 AM (GMT)
const predict_end_time = 1730592000000;


// November 10, 2024 at 12:00 AM (GMT)
const report_start_time = 1731196800000;
// December 1, 2024 at 12:00 AM (GMT)
const report_end_time = 1733011200000;
 

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

        async function logCurrentTime() {
            await txb.moveCall({
                target: `${PACKAGE_ID}::kiosk_practice::get_time`,
                arguments: [txb.object(clock)],
            });
        
            
           
           
        }

        // return the current time in event log
        // 1710618180870
        // to add days to the timestamp so that is nov 10 2024 at 12:00 am: 1731196800000
        logCurrentTime();
        
        

        // CREATE PREDICT EPOCH AND REPORT EPOCH

        

  
        

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
