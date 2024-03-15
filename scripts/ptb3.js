// imports
import { getFullnodeUrl, SuiClient, SuiHTTPTransport  } from "@mysten/sui.js/client";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { TransactionBlock } from "@mysten/sui.js/transactions";
import walletDev from './wallet-two.json' assert { type: 'json' };
import walletOne from './wallet-one.json' assert { type: 'json' };

import { KioskClient, Network, KioskTransaction } from '@mysten/kiosk';
import { WebSocket } from 'ws';



// generate a keypair
const privateKeyArray = walletDev.privateKey.split(',').map(num => parseInt(num, 10));
const privateKeyBytes = new Uint8Array(privateKeyArray);
const keypairdev = Ed25519Keypair.fromSecretKey(privateKeyBytes);


console.log(`Public Key dev to raw bytes: ${keypairdev.getPublicKey().toRawBytes()}`);

console.log(`Public Key dev: ${keypairdev.getPublicKey().toSuiAddress()}`);



// generate a keypair for another user 
const privateKeyArrayWalletOne = walletOne.privateKey.split(',').map(num => parseInt(num, 10));
const privateKeyBytesWalletOne = new Uint8Array(privateKeyArrayWalletOne);
const keypairWalletOne = Ed25519Keypair.fromSecretKey(privateKeyBytesWalletOne);


console.log(`Public Key wallet one to raw bytes: ${keypairWalletOne.getPublicKey().toRawBytes()}`);

console.log(`Public Key wallet one: ${keypairWalletOne.getPublicKey().toSuiAddress()}`);




// consts
const PACKAGE_ID = "0xa5e20fbc457babd65e5d1927d7d20451a6681e3ae0751703dfea0da129f5e33e";
const itemType = '0xa5e20fbc457babd65e5d1927d7d20451a6681e3ae0751703dfea0da129f5e33e::kiosk_practice::Prediction';




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


// function to get the kiosk owner cap
const getCap = async () => {
    let { kioskOwnerCaps } = await kioskClient.getOwnedKiosks(keypairdev.getPublicKey().toRawBytes());
    // Assume that the user has only 1 kiosk.
    // Here, you need to do some more checks in a realistic scenario.
    // And possibly give the user in our dApp a kiosk selector to choose which one they want to interact with (if they own more than one).
    return kioskOwnerCaps[0];
}




(async () => {
    try {
     
        
        // create Transaction Block
        const txb = new TransactionBlock();
        

       

       

    

        // create Kiosk TxBlock
        const kioskTx = new KioskTransaction({ kioskClient, transactionBlock: txb, cap: await getCap() });



        // create a new kiosk
        kioskTx.create();







        // const predict_start_time = 22;
        // const predict_end_time = 555;

        
        // // make a epoch (works)
        // const predict_epoch = txb.moveCall({
        //     target: '0xa5e20fbc457babd65e5d1927d7d20451a6681e3ae0751703dfea0da129f5e33e::kiosk_practice::set_predict_epoch',
        //     arguments: [ txb.pure.u64(predict_start_time), txb.pure.u64(predict_end_time) ],
        // });


        

        // // delete the epoch (works)
        // txb.moveCall({
        //     target: '0xa5e20fbc457babd65e5d1927d7d20451a6681e3ae0751703dfea0da129f5e33e::kiosk_practice::delete_epoch',
        //     arguments: [ txb.object(predict_epoch)],
        // });





        // const guess = 232;
        // let clock = "0x6"

        // // make a prediction (works)
        // const prediction = txb.moveCall({
        //     target: '0xa5e20fbc457babd65e5d1927d7d20451a6681e3ae0751703dfea0da129f5e33e::kiosk_practice::make_prediction',
        //     arguments: [ txb.pure.u64(guess), txb.object(clock)],
        // });


        
    
        // // place a prediction in the kiosk (works)
        // const prediction_id = kioskTx.place({
        //     item: txb.object(prediction),
        //     itemType: itemType,
        // });




        // list the prediction in the kiosk
        // kioskTx.list({
        //     itemType: prediction,
        //     itemId: prediction_id,
        //     price: 1000000,
        // });




        // delist the prediction in the kiosk
        // kioskTx.delist({
        //     itemType: prediction,
        //     itemId: prediction_id,
        // });




        // // take the prediction from the kiosk
        // kioskTx.take({
        //     itemType: prediction,
        //     itemId: prediction_id,
        // });




        // delete the prediction (works)
        // txb.moveCall({
        //     target: '0xa5e20fbc457babd65e5d1927d7d20451a6681e3ae0751703dfea0da129f5e33e::kiosk_practice::delete_prediction',
        //     arguments: [ txb.object(prediction)],
        // });




        kioskTx.shareAndTransferCap(keypairdev.getPublicKey().toRawBytes());

        // finalize the kiosk transaction
        kioskTx.finalize();
        
        





        // subscribe to events for the package
        // let unsubscribe = await client.subscribeEvent({
        //     filter: { All },
        //     onMessage: (event) => {
        //         console.log("subscribeEvent", JSON.stringify(event, null, 2))
        //     }
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
