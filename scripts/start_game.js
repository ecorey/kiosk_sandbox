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
// SET: the consts
// GET: current time
// CREATE: predict epoch and report epoch with the correct times and use them to start the game
// GET: the game balance

// CLOSE: the game with the game id and a game result
// WITHDRAW: balance from the game
// DELETE: the game cap 


// CONSTS
const PACKAGE_ID = "";
const itemType = `${PACKAGE_ID}::kiosk_practice::Prediction`;

// pub key for wallet-three used to publish the package
const devPubwallet = "";
const tx_block = "";

// const for the move calls
const clock = "0x6";

//  created in init
const start_game_cap = "";
const end_game_cap = "";
const game_owner_cap = "";
const transfer_policy = "";
const transfer_policy_cap = "";
const publisher = "";
const upgrade_cap = "";


// TIME STAMPS (election event on Nov. 5)
// get from get time event log
const predict_start_time = 1710621232132;
// November 3, 2024, at 12:00 AM (GMT)
const predict_end_time = 1730592000000;


// November 10, 2024 at 12:00 AM (GMT)
const report_start_time = 1731196800000;
// December 1, 2024 at 12:00 AM (GMT)
const report_end_time = 1733011200000;
 

const game_price = 1000000;


const game_id ="";





// client
const client = new SuiClient({
    transport: new SuiHTTPTransport({
        url: getFullnodeUrl('testnet'),
        WebSocketConstructor: WebSocket
    }),
});


const ownerAddress = ''; 



// const coins = await client.getCoins({ owner: ownerAddress });
// console.log(`Coins owned by ${ownerAddress}:`, JSON.stringify(coins, null, 2));



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

        await logCurrentTime();
        
        





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
        
        // txb.moveCall({
        //     target: `${PACKAGE_ID}::kiosk_practice::start_game`,
        //     arguments: [ txb.object(start_game_cap), txb.pure.u64(game_price), txb.object(predict_epoch), txb.object(report_epoch), txb.object(clock)],
        // });





        // GET THE GAME BALANCE

        // async function logGameBalance() {
            
        //     const game_balance = await txb.moveCall({
        //         target: `${PACKAGE_ID}::kiosk_practice::get_game_balance`,
        //         arguments: [ txb.object(game_id) ],
        //     });

        //     const bal = game_balance[1];
        //     const a = bal.index;

        //     console.log(`Game balance: ${a}`);
           
        // }

        // await logGameBalance();
        
        




        // ADD A BALANCE TO THE GAME

        // const amount_to_add = 2000000;

        // txb.moveCall({
        //     target: `${PACKAGE_ID}::kiosk_practice::add_game_balance`,
        //     arguments: [ txb.object(game_id), txb.pure.u64(amount_to_add) ],
        // });





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
        


        // // log the transaction result
        console.log(`Transaction result: ${JSON.stringify(txid, null, 2)}`);
        console.log(`success: https://suiexplorer.com/txblock/${txid.digest}?network=testnet`);



        console.log(`END OF SCRIPT`);

    } catch (e) {
        console.error(`error: ${e}`);
    }
})();




