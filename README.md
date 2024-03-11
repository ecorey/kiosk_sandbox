ORDER TO TEST VIA CLI:

publish
create_kiosk
set_predict_epoch
set_report_epoch
start_game
make_prediction
list_prediction
delist_prediction
burn_from_kiosk


// create another account and switch to it 
purchase_prediction


withdraw_balance_from_kiosk
withdraw_balance_from_tranfer_policy
withdraw_balance_from_game


// cant test keep as prototype
close_game
claim_winner



---


clock ref:
--args '0x6'


---


packageid: 0xaafa4058de49a7fb79d450c61e33ee03033c7c21634b24b73e0bf2a021798725
clock: '0x6'
price: 10000000
epochpredict: 0xcc4cd3023aafa04185103534a81b4ac46e6d6b3a41720c050b47a0c8a45ed786
epochreport: 0x66aa55d09148d2c96383ce4620f1c2d324647acea1b0585c284c320ebe9622de
transferpolicy: 0x589f9d996ac0520f1dd026352c64eda595853b627258653e3e2c60a42b046810
transferpolicycap: 0xe15e80481e88cc2115bc1adb518058d64a116e0fcf1f0ea8987ab79cb80487fc
startgamecap: 0x0605a687cd7bdd375a3681b9c3ab3120acb1c4661274ed6c1b693a0239b1e019
endgamecap: 0x556995d5735fce6f605f33b4ee28cfc974b4860435812f3ea5432b2e5cfccdc5
gameownercap: 0x4611ae089016c0696946b948433fbe9387d798e55b5febd7ab97a0917a1373c8
kiosk: 0xce0d2b765d3c11fe64d8452400f3d16eb0843bcaa9a39abd3d25c001099f31aa
kioskownercap: 0x860279b546e2b3d91a89c36fcfbb9b80f17c00a90ce06ea9ea5f89c9c438f52e
Game: 0xb19fb542d7d0216ea4f459d6717f6ff2a91fe484395c35cf6c686ab9c1ff624f


---

flow to test via cli:
publish:

    sui client publish --gas-budget 100000000 --skip-dependency-verification


create_kiosk:

    sui client call --function create_kiosk --module kiosk_practice --package 0xaafa4058de49a7fb79d450c61e33ee03033c7c21634b24b73e0bf2a021798725  --gas-budget 10000000


set_predict_epoch:

    sui client call --function set_predict_epoch --module kiosk_practice --package 0xaafa4058de49a7fb79d450c61e33ee03033c7c21634b24b73e0bf2a021798725  --args 22 555 --gas-budget 10000000


set_report_epoch:

    sui client call --function set_report_epoch --module kiosk_practice --package 0xaafa4058de49a7fb79d450c61e33ee03033c7c21634b24b73e0bf2a021798725  --args 555 777 --gas-budget 10000000



start_game:

    sui client call --function start_game --module kiosk_practice --package 0xaafa4058de49a7fb79d450c61e33ee03033c7c21634b24b73e0bf2a021798725  --args 0x0605a687cd7bdd375a3681b9c3ab3120acb1c4661274ed6c1b693a0239b1e019 10000000 0xcc4cd3023aafa04185103534a81b4ac46e6d6b3a41720c050b47a0c8a45ed786 0x66aa55d09148d2c96383ce4620f1c2d324647acea1b0585c284c320ebe9622de '0x6' --gas-budget 10000000






make_prediction:



list_prediction:



delist_prediction: 



burn_from_kiosk:


// create another account and switch to it 
purchase_prediction:






withdraw_balance_from_kiosk
withdraw_balance_from_tranfer_policy
withdraw_balance_from_game







// cant test keep as prototype
close_game
claim_winner










--- 


TEST VIA CLI PTB
