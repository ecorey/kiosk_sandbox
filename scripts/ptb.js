import { SuiClient, getFullnodeUrl } from '@mysten/sui.js/client';
import { TransactionBlock } from '@mysten/sui.js/transactions';
import { MIST_PER_SUI } from '@mysten/sui.js/utils';
// import { JsonRpcProvider, testnetConnection } from '@mysten/sui.js';

import { Ed25519Keypair } from '@mysten/sui.js/keypairs/ed25519';




const suiClient = new SuiClient({ url: getFullnodeUrl('testnet')});


const txb = new TransactionBlock();


const ADDRESS_User = '0x6060640454e670a0efb91c896a7ee4f3d5781c9b489f9962640873d1f2b8c961';
const PACKAGE_ID = '0xaafa4058de49a7fb79d450c61e33ee03033c7c21634b24b73e0bf2a021798725'


// path to an event that is emitted in the init function of the kiosk_practice contract
const MoveEventType = '{PACKAGE_ID}::kiosk_practice::InitEvent';


// RPC for testnet
// const provider = new JsonRpcProvider(testnetConnection);


const balance = (balance) => {
	return Number.parseInt(balance.totalBalance) / Number(MIST_PER_SUI);
};



const acctBalance = await suiClient.getBalance({
	owner: ADDRESS_User,
});



// create coin object that is equalt to the cost of a prediction
const [coin] = txb.splitCoins(txb.gas, [10000000]);




// console.log(
//     await provider.getObject({
//         id: Package,
//         options: { showPreviousTransaction: true },
//     }),
// );




// // subscribe to events for the package
// let unsubscribe = await provider.subscribeEvent({
//     filter: { PACKAGE_ID },
//     onMessage: (event) => {
//         console.log("subscribeEvent", JSON.stringify(event, null, 2))
//     }
// });




// // call the set_predict_epoch function in the kiosk_practice contract
// const [kiosk, kiosk_owner_cap] = txb.moveCall({
//     target: '0xaafa4058de49a7fb79d450c61e33ee03033c7c21634b24b73e0bf2a021798725::kiosk_practice::create_kiosk',
//     arguments: [],
// });




// call the set_predict_epoch function in the kiosk_practice contract
// const predict_epoch = txb.moveCall({
//     target: '0xaafa4058de49a7fb79d450c61e33ee03033c7c21634b24b73e0bf2a021798725::kiosk_practice::set_predict_epoch',
//     arguments: [ 2, 555 ],
// });



// // call the set_report_epoch function in the kiosk_practice contract
// const report_epoch = txb.moveCall({
//     target: '0xaafa4058de49a7fb79d450c61e33ee03033c7c21634b24b73e0bf2a021798725::kiosk_practice::set_report_epoch',
//     arguments: [ 555, 777 ],
// });



// // call the set_report_epoch function in the kiosk_practice contract
// const game = txb.moveCall({
//     target: '0xaafa4058de49a7fb79d450c61e33ee03033c7c21634b24b73e0bf2a021798725::kiosk_practice::start_game',
//     arguments: [ 555, 777 ],
// });


const keypair = new Ed25519Keypair();
const pubKey = keypair.getPublicKey().toSuiAddress();
const pubKeyBytes = keypair.getPublicKey().toRawBytes();

const privkey = keypair.getSecretKey().toString();


console.log(
	`public key: ${ pubKey }`
);



console.log(
	`public key: ${ privkey }`
);



console.log(
    `acct balance: ${ balance(acctBalance) }`
)