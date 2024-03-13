import { getFullnodeUrl, SuiClient }  from '@mysten/sui.js/client';
import { Ed25519Keypair } from '@mysten/sui.js/keypairs/ed25519';
import dotenv from 'dotenv';


export const keypair = Ed25519Keypair.fromSecretKey(Uint8Array.from(Buffer.from(process.env.KEY, "base64")).slice(1));
// const keypair = Ed25519Keypair.fromSecretKey(process.env.KEY);


export const client = new SuiClient({ url: getFullnodeUrl('testnet') });

export const PACKAGE = "0xaafa4058de49a7fb79d450c61e33ee03033c7c21634b24b73e0bf2a021798725";