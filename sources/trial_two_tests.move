#[test_only]
module kiosk_practice::trial_two_tests {


    use sui::tx_context::{TxContext, Self};
    use sui::clock::{Self, Clock};
    use sui::coin::{Self, Coin, mint_for_testing, burn_for_testing};

    use sui::sui::SUI;
    use std::option;
    use sui::transfer;
    use sui::transfer_policy::{Self, TransferPolicy};
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap, PurchaseCap};
    
    use sui::test_scenario;
    use sui::test_utils::create_one_time_witness;
    use sui::kiosk_test_utils::{Self as test, Asset};
    use std::debug;

    use kiosk_practice::kiosk_practice::init_for_testing;
    use kiosk_practice::kiosk_practice::make_prediction;
    use kiosk_practice::kiosk_practice::delete_prediction;
    use kiosk_practice::kiosk_practice::KIOSK_PRACTICE;
    use kiosk_practice::kiosk_practice::Prediction;
    
    use kiosk_practice::kiosk_practice::set_predict_epoch;
    use kiosk_practice::kiosk_practice::set_report_epoch;
    use kiosk_practice::kiosk_practice::Game;
    use kiosk_practice::kiosk_practice::GameOwnerCap;
    use kiosk_practice::kiosk_practice::StartGameCap;
    use kiosk_practice::kiosk_practice::EndGameCap;
    use kiosk_practice::kiosk_practice::start_game;
    use kiosk_practice::kiosk_practice::close_game;
    use kiosk_practice::kiosk_practice::PredictEpoch;
    use kiosk_practice::kiosk_practice::delete_predict_epoch;
    use kiosk_practice::kiosk_practice::delete_report_epoch;








  
    // ###################################
    // ############TESTS##################
    // ###################################


    fun init_test_helper() : test_scenario::Scenario {

            let admin = @0x1;
            let user1 = @0x2;


            let scenario = test_scenario::begin(admin);
            let scenario_val = &mut scenario;


            let otw = create_one_time_witness<KIOSK_PRACTICE>();


            {
                init_for_testing(otw, test_scenario::ctx(scenario_val));
            };

            scenario

        }



    #[test]
    public fun predictix_tests() {



        let admin = @0x1;
        let user1 = @0x2;
       

        
        let scenario = init_test_helper();
        let scenario_val = &mut scenario;



        // TEST SENDER HAS START GAME CAP AND INIT WAS SUCCESSFUL
        test_scenario::next_tx(scenario_val, admin);
        {
            
            let ctx = test_scenario::ctx(scenario_val);
            let sender_address = tx_context::sender(ctx);
            assert!(sender_address == admin, 0);

            let start_game_cap = test_scenario::take_from_sender<StartGameCap>(scenario_val);
            test_scenario::return_to_sender(scenario_val, start_game_cap);
            
        };




        // START GAME
        test_scenario::next_tx(scenario_val, admin);
        {


            let start_game_cap = test_scenario::take_from_sender<StartGameCap>(scenario_val);
            let clock = clock::create_for_testing(test_scenario::ctx(scenario_val)); 
            let price = 100;

            let predict_epoch = set_predict_epoch(222, 333, test_scenario::ctx(scenario_val));
            let report_epoch = set_report_epoch(333, 444, test_scenario::ctx(scenario_val));



            start_game(start_game_cap, price, predict_epoch, report_epoch, &clock, test_scenario::ctx(scenario_val));



            clock::destroy_for_testing(clock); 

            





            // let end_game_cap = test_scenario::take_from_sender<EndGameCap>(scenario_val);
            // let game = test_scenario::take_from_sender<Game>(scenario_val);

            // let game_closed = close_game(end_game_cap, &mut game, 444, test_scenario::ctx(scenario_val)); 


            // test_scenario::return_to_sender(scenario_val, game);


            

        };






        // ADMIN MAKES PREDICTION
        test_scenario::next_tx(scenario_val, admin);
        {

            // setup
            let guess = 444;

            let clock = clock::create_for_testing(test_scenario::ctx(scenario_val));

            let coin = coin::mint_for_testing<SUI>(100, test_scenario::ctx(scenario_val));
            
            let (kiosk, kiosk_owner_cap) = test::get_kiosk(test_scenario::ctx(scenario_val));

            let publisher = test::get_publisher(test_scenario::ctx(scenario_val));

            
            std::debug::print(&clock);
            
            

            // prediction 
            
            make_prediction(guess, &clock, test_scenario::ctx(scenario_val));



            // cleanup 

            transfer::public_transfer(coin, admin);

            test::return_publisher(publisher);

            test::return_kiosk(kiosk, kiosk_owner_cap, test_scenario::ctx(scenario_val));
           
            clock::destroy_for_testing(clock);

        };


        

        // ADMIN DELETES PREDICTION
        test_scenario::next_tx(scenario_val, admin);
        {
             
            let predict = test_scenario::take_from_sender<Prediction>(scenario_val);

            delete_prediction(predict, test_scenario::ctx(scenario_val));


        };





        // ADMIN CREATE KIOSK AND LIST PREDICTION
        test_scenario::next_tx(scenario_val, admin);
        {
           

        };





        // USER CREATES A KIOSK AND PURCHASES PREDICTION FROM ADMIN
        test_scenario::next_tx(scenario_val, admin);
        {
           

        };





        // USER LISTS AND DELISTS PREDICTION
        test_scenario::next_tx(scenario_val, admin);
        {
           

        };


      


        // ADMIN CLOSES GAME
        test_scenario::next_tx(scenario_val, admin);
        {
           

        };




        // USER CLAIMS WINNER
        test_scenario::next_tx(scenario_val, admin);
        {
           

        };






        
        
        test_scenario::end(scenario);   

    }

    


    }

