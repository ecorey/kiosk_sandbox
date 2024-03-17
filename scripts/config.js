// ###################################
// ############CONFIG#################
// ###################################




// ORDER OF SCRIPTS AFTER PUBLISHING PACKAGE

// 1. node subscribe_events.js [FIX]


// 2. node current_time.js (use to set PREDICT_START_TIME in config.js)
// 3. node start_game.js (use to set GAME_ID in config.js)
// 4. node game_balance.js (check before adding to game balance)
// 5. node add_balance_to_game.js (set COIN_TO_ADD in config.js)
// 6. node game_balance.js (check after adding the game balance)


// 7. node withdraw_bal_from_game.js [FIX]
// 8. MAKE PREDICTIONS [TODO]
// - make prediction
// 9. KIOSK SCRIPTS [TODO]
// - get kiosk
// - place prediciton in kiosk
// - list prediciton in kiosk
// - purchase with another wallet
// - delist prediction from kiosk
// 10. WINNER SCRIPTS [TODO]
// - get winner


// 11. node close_game.js 
// 12. node delete_owner_cap.js 



// ###################################
// ############CONSTS#################
// ###################################

export const CLOCK = "0x6";


export const DEV_WALLET = "0x07095af51002db0e9be284b8dab97263f77fec2a1be68cd42b7dd2358a6eccdd";


// created in init
export const PACKAGE = "0xbb09ac4797ff8dd20210d016681896f3f472e99eb764edd151c64ca47f41c2d5";
export const itemType = `${PACKAGE}::kiosk_practice::Prediction`;
export const START_GAME_CAP = "0x641db2a8cbd3cd3dd8ab5b9cfc375054ccf8c39db222615881bbc2290260de18";
export const END_GAME_CAP = "0x607aaf624bc5394fb458da44748cd6fb003b84f95379f3475890a8b8d0acdf29";
export const GAME_OWNER_CAP = "0xa5bac3318d2234e87a7ae8ff069e9179f8d6c1459a54cd96d5467dcc33ab0172";
export const TRANSFER_POLICY  = "";
export const TRANSFER_POLICY_CAP = "";
export const PUBLISHER = "";
export const UPGRADE_CAP = "";


// START GAME SCRIPT
export const GAME_PRICE = "1000000";

// (election event on Nov. 5)
// get from get time event log
export const PREDICT_START_TIME = 1710649628204;

// November 3, 2024, at 12:00 AM (GMT)
export const PREDICT_END_TIME = 1730592000000;

// November 10, 2024 at 12:00 AM (GMT)
export const REPORT_START_TIME = 1731196800000;

// December 1, 2024 at 12:00 AM (GMT)
export const REPORT_END_TIME = 1733011200000;




//CLOSE GAME SCRIPT
// game id
export const GAME_ID = "0xcb60ff9d1e20bb364d1deca9184c53e728923aa12b6e4fb9e392f28431511cd3";




// ADD BALANCE TO GAME SCRIPT
export const COIN_TO_ADD = "0x7a3c612ffa71ae0d321b268613b6844e582603860f8bc102a88db4c9cbff8f13";





// GAME RESULT SCRIPT
export const GAME_RESULT = "223";








// WALLETS

export const devWalletPublicKeyRef = "0xb3d4cb714181fec39c22d820c963da9cfac970d3ab77c464b0dea06ce673c3e5";

export const walletOneRef = "0x6dc3f9438f890ff4031f6a2151b3ca02aebf9e1522f0014a956dd8ef067e3b01";

export const walletTwoRef = "0xe5f5e09892328ff278b473f485cbf85cef8a9958112023c84126aec3d32b8114";

export const walletThreeRef = "0x07095af51002db0e9be284b8dab97263f77fec2a1be68cd42b7dd2358a6eccdd";

export const walletFourRef = "0xf84965aee90c0e4d56a9658d78ecbc01e7908cab78cad6a62bcc558171cd2b34";

export const walletFiveRef = "0x95b2e05ab1b7f9f53f7085069dd5b7f9d7d1055e406605791d87b34253bca1cb";