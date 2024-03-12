import { SuiClient, getFullnodeUrl } from '@mysten/sui.js/client';
import { TransactionBlock } from '@mysten/sui.js/transactions';
import { MIST_PER_SUI } from '@mysten/sui.js/utils';



const suiClient = new SuiClient({ url: getFullnodeUrl('testnet')});


const txb = new TransactionBlock();


const ADDRESS_User = '0x6060640454e670a0efb91c896a7ee4f3d5781c9b489f9962640873d1f2b8c961';





const balance = (balance) => {
	return Number.parseInt(balance.totalBalance) / Number(MIST_PER_SUI);
};

const acctBalance = await suiClient.getBalance({
	owner: ADDRESS_User,
});



// create coin object that is equalt to the cost of a prediction
const [coin] = txb.splitCoins(txb.gas, [10000000]);



// // call the set_predict_epoch function in the kiosk_practice contract
// const [kiosk, kiosk_owner_cap] = txb.moveCall({
//     target: '0xaafa4058de49a7fb79d450c61e33ee03033c7c21634b24b73e0bf2a021798725::kiosk_practice::create_kiosk',
//     arguments: [],
// });



// call the set_predict_epoch function in the kiosk_practice contract
const predict_epoch = txb.moveCall({
    target: '0xaafa4058de49a7fb79d450c61e33ee03033c7c21634b24b73e0bf2a021798725::kiosk_practice::set_predict_epoch',
    arguments: [ 2, 555 ],
});



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



console.log(
    `prediction made by ${ balance(acctBalance) }`
)