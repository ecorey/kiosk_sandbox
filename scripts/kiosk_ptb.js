import { KioskClient, KioskTransaction, Network } from '@mysten/kiosk';
import { getFullnodeUrl, SuiClient } from '@mysten/sui.js/client';

// import { keypair } from '@mysten/sui.js/keypairs';

import { TransactionBlock } from '@mysten/sui.js/transactions';



const client = new SuiClient({ url: getFullnodeUrl('testnet')});



const kioskClient = new KioskClient({
    client, 
    network: Network.TESTNET,
});


const txb = new TransactionBlock();
const kioskTx = new KioskTransaction({ transactionBlock: txb, kioskClient});

kioskTx.create();





// place a prediction in the kiosk
// kioskTx.place({
//     itemType: '0x...::prediction::Prediction',
//     item: 'Prediction',
// });



// kioskTx.list({
//     itemType: '0x...::prediction::Prediction',
//     item: 'Prediction',
//     price: 1000000,
// });


// kioskTx.delist({
//     itemType: '0x...::prediction::Prediction',
//     item: 'Prediction',
// }).finalize();



// creates new kiosk and places the prediction
// kioskTx
//     .createPersonal(true) 
//     .place({
//         itemType: '0x...::prediction::Prediction',
//         item: 'Prediction',
//     })
//     .finalize(); 








// const publicKey = keypair.getPublicKey();
// const message = new TextEncoder().encode('hello world');





// const { signature } = await keypair.signPersonalMessage(message);
// const isValid = await publicKey.verifyPersonalMessage(message, signature);
// console.log(isValid);


// const address = '0x6060640454e670a0efb91c896a7ee4f3d5781c9b489f9962640873d1f2b8c961';

// const address_tp = '0x589f9d996ac0520f1dd026352c64eda595853b627258653e3e2c60a42b046810';

// const policies = await kioskClient.getOwnedTransferPolicies({address});

// console.log(policies);




kioskTx.shareAndTransferCap('0x6060640454e670a0efb91c896a7ee4f3d5781c9b489f9962640873d1f2b8c961');

kioskTx.finalize();

// const result = await client.signAndExecuteTransactionBlock({
// 	signer: keypair,
// 	transactionBlock: tx,
// 	options: {
// 		showEffects: true,
// 	},
// 	requestType: "WaitForLocalExecution"
// });

// console.log("result: ", JSON.stringify(result, null, 2))






