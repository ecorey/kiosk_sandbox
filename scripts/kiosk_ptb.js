import { KioskClient, Network } from '@mysten/kiosk';
import { getFullnodeUrl, SuiClient } from '@mysten/sui.js/client';




const client = new SuiClient({ url: getFullnodeUrl('testnet')});



const kioskClient = new KioskClient({
    client, 
    network: Network.TESTNET,
});













