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
const Package_id = '0xf19b5c0a1fb5291fbd7bb9f1fcee14f5912f7a8c11adc77a4391b75c4f21e313';
// const eventsToSubscribe = [
//     `0xf19b5c0a1fb5291fbd7bb9f1fcee14f5912f7a8c11adc77a4391b75c4f21e313::kiosk_practice::TimeEvent`,
//     `0xf19b5c0a1fb5291fbd7bb9f1fcee14f5912f7a8c11adc77a4391b75c4f21e313::kiosk_practice::GameStarted`,
//     `0xf19b5c0a1fb5291fbd7bb9f1fcee14f5912f7a8c11adc77a4391b75c4f21e313::kiosk_practice::PredictionMade`,
// ];



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
                id: Package_id,
                options: { showPreviousTransaction: true },
            }),
        );



        const Package = "0xf19b5c0a1fb5291fbd7bb9f1fcee14f5912f7a8c11adc77a4391b75c4f21e313"
        let unsubscribe = await client.subscribeEvent({
            filter: { Package },
            onMessage: (event) => {
                console.log("subscribeEvent", JSON.stringify(event, null, 2))
            }
        });
         
        // later, to unsubscribe:
        await unsubscribe();





        


        console.log(`END OF SCRIPT`);

        
    } catch (e) {
        console.error(`error: ${e}`);
    }

})();



