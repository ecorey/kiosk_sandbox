// imports
import { getFullnodeUrl, SuiClient } from "@mysten/sui.js/client";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { TransactionBlock } from "@mysten/sui.js/transactions";
import wallet from './dev-wallet.json' assert { type: 'json' };
import { KioskClient, Network, KioskTransaction } from '@mysten/kiosk';



// generate a keypair
const privateKeyArray = wallet.privateKey.split(',').map(num => parseInt(num, 10));
const privateKeyBytes = new Uint8Array(privateKeyArray);
const keypair = Ed25519Keypair.fromSecretKey(privateKeyBytes);


console.log(`Public Key raw bytes: ${keypair.getPublicKey().toRawBytes()}`);

console.log(`Public Key: ${keypair.getPublicKey().toSuiAddress()}`);


const PACKAGE_ID = "0xaafa4058de49a7fb79d450c61e33ee03033c7c21634b24b73e0bf2a021798725";


// client
const client = new SuiClient({
    url: getFullnodeUrl('testnet'),
});


// kiosk client
const kioskClient = new KioskClient({
    client, 
    network: Network.TESTNET,
});



const getCap = async () => {
    let { kioskOwnerCaps } = await kioskClient.getOwnedKiosks(keypair.getPublicKey().toRawBytes());
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



        kioskTx.shareAndTransferCap(keypair.getPublicKey().toRawBytes());

        // finalize the kiosk transaction
        kioskTx.finalize();
        
        


        // subscribe to events for the package
        // let unsubscribe = await provider.subscribeEvent({
        //     filter: { PACKAGE_ID },
        //     onMessage: (event) => {
        //         console.log("subscribeEvent", JSON.stringify(event, null, 2))
        //     }
        // });


       










        
        // finalize the transaction block
        let txid = await client.signAndExecuteTransactionBlock({
            signer: keypair,
            transactionBlock: txb,
        });
        


        // log the transaction result
        console.log(`Transaction result: ${JSON.stringify(txid, null, 2)}`);
        console.log(`success: https://suiexplorer.com/txblock/${txid.digest}?network=testnet`);



    } catch (e) {
        console.error(`error: ${e}`);
    }
})();
