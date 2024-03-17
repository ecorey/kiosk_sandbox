// Imports
import { getFullnodeUrl, SuiClient, SuiHTTPTransport } from "@mysten/sui.js/client";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { WebSocket } from 'ws';
import walletDev from './wallet-four.json' assert { type: 'json' };



// Initialize keypair
const privateKeyArray = walletDev.privateKey.split(',').map(num => parseInt(num, 10));
const privateKeyBytes = new Uint8Array(privateKeyArray);
const keypairdev = Ed25519Keypair.fromSecretKey(privateKeyBytes);



// Constants
const Package = "0xf5733f359175cb8f6b08fdc927a7dab4680d2255788a83f9afbe748d08602b99";




// Client connection to Sui testnet
const client = new SuiClient({
    transport: new SuiHTTPTransport({
        url: getFullnodeUrl('testnet'),
        WebSocketConstructor: WebSocket
    }),
});




(async () => {
    try {


        console.log(
            await client.getObject({
                id: Package,
                options: { showPreviousTransaction: true },
            }),
        );




        // let unsubscribe = await client.subscribeEvent({
        //     filter: { Package },
        //     onMessage: (event) => {
        //         console.log('subscribeEvent', JSON.stringify(event, null, 2));
        //     },
        // });
         
       

        // await unsubscribe();





        


        console.log(`END OF SCRIPT`);

        
    } catch (e) {
        console.error(`error: ${e}`);
    }

})();



