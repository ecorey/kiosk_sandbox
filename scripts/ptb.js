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


// txb.moveCall({
//     target: '0x0::predictrix::make_prediction',
//     arguments: [ ],
// });


console.log(
    `prediction made by ${ balance(acctBalance) }`
)