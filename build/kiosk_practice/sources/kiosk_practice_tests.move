#[test_only]
module kiosk_practice::kiosk_practice_tests {


    use sui::tx_context::{TxContext, Self};
    use sui::object::{Self, UID, ID};
    use sui::clock::{Self, Clock};
    use sui::coin::{Self, Coin, mint_for_testing, burn_for_testing};

    use sui::sui::SUI;
    use std::option;
    use sui::transfer;
    use sui::transfer_policy::{Self, TransferPolicy};
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap, PurchaseCap};
    
    use sui::test_scenario;
    use sui::test_utils::{create_one_time_witness, assert_eq};
    use sui::kiosk_test_utils::{Self as test};
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
    use kiosk_practice::kiosk_practice::claim_winner;








  
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
    public fun make_delete_prediction_tests() {



        let admin = @0x1;
        let user1 = @0x2;
       

        
        let scenario = init_test_helper();
        let scenario_val = &mut scenario;



        // TEST SENDER IS ADMIN AND HAS THE START GAME CAP 
        test_scenario::next_tx(scenario_val, admin);
        {
            
            let ctx = test_scenario::ctx(scenario_val);
            let sender_address = tx_context::sender(ctx);
            assert!(sender_address == admin, 0);

            let start_game_cap = test_scenario::take_from_sender<StartGameCap>(scenario_val);
            test_scenario::return_to_sender(scenario_val, start_game_cap);
            
        };




        // START GAME AND SET THE PREDICTION PRICE
        test_scenario::next_tx(scenario_val, admin);
        {

            


            let start_game_cap = test_scenario::take_from_sender<StartGameCap>(scenario_val);
            let clock = clock::create_for_testing(test_scenario::ctx(scenario_val)); 
            let price = 100;

            let predict_epoch = set_predict_epoch(222, 333, test_scenario::ctx(scenario_val));
            let report_epoch = set_report_epoch(333, 444, test_scenario::ctx(scenario_val));


            start_game(start_game_cap, price, predict_epoch, report_epoch, &clock, test_scenario::ctx(scenario_val));


            clock::destroy_for_testing(clock); 

            
        };



        // TAKE AND RETURN GAME OBJECT
        test_scenario::next_tx(scenario_val, admin);
        {
           
            let game = test_scenario::take_shared<Game>(scenario_val);

            test_scenario::return_shared(game);

        };



        // ADMIN MAKES PREDICTION
        test_scenario::next_tx(scenario_val, admin);
        {

            // setup
            let guess = 444;

            let payment = coin::mint_for_testing<SUI>(100, test_scenario::ctx(scenario_val));

            let game = test_scenario::take_shared<Game>(scenario_val);

            let clock = clock::create_for_testing(test_scenario::ctx(scenario_val));

            std::debug::print(&clock);

            let (kiosk, kiosk_owner_cap) = test::get_kiosk(test_scenario::ctx(scenario_val));

            
            

            // prediction 
            
            make_prediction(guess, payment, &mut game, &clock, test_scenario::ctx(scenario_val));



            // cleanup 


            test_scenario::return_shared(game);

            test::return_kiosk(kiosk, kiosk_owner_cap, test_scenario::ctx(scenario_val));
           
            clock::destroy_for_testing(clock);

        };


        

        // ADMIN DELETES PREDICTION
        test_scenario::next_tx(scenario_val, admin);
        {
             
            let predict = test_scenario::take_from_sender<Prediction>(scenario_val);

            delete_prediction(predict, test_scenario::ctx(scenario_val));


        };
        

        test_scenario::end(scenario);
        

    }




    // #[test]
    // public fun start_game_make_list_prediction_end_game_tests() {



    //     let admin = @0x1;
    //     let user1 = @0x2;
       

        
    //     let scenario = init_test_helper();
    //     let scenario_val = &mut scenario;



    //     // TEST SENDER IS ADMIN AND HAS THE START GAME CAP 
    //     test_scenario::next_tx(scenario_val, admin);
    //     {
            
    //         let ctx = test_scenario::ctx(scenario_val);
    //         let sender_address = tx_context::sender(ctx);
    //         assert!(sender_address == admin, 0);

    //         let start_game_cap = test_scenario::take_from_sender<StartGameCap>(scenario_val);
    //         test_scenario::return_to_sender(scenario_val, start_game_cap);
            
    //     };




    //     // START GAME
    //     test_scenario::next_tx(scenario_val, admin);
    //     {


    //         let start_game_cap = test_scenario::take_from_sender<StartGameCap>(scenario_val);
    //         let clock = clock::create_for_testing(test_scenario::ctx(scenario_val)); 
    //         let price = 100;

    //         let predict_epoch = set_predict_epoch(222, 333, test_scenario::ctx(scenario_val));
    //         let report_epoch = set_report_epoch(333, 444, test_scenario::ctx(scenario_val));



    //         start_game(start_game_cap, price, predict_epoch, report_epoch, &clock, test_scenario::ctx(scenario_val));


    //         clock::destroy_for_testing(clock); 

            
    //     };



    //     // CREATE KIOSK AND TRANSFER POLICY 
    //     test_scenario::next_tx(scenario_val, admin);
    //     {
           

    //         // Create a Kiosk share it public and transfer the cap to owner
    //         let (kiosk, cap) = kiosk::new(test_scenario::ctx(scenario_val));

    //         transfer::public_share_object(kiosk);
    //         transfer::public_transfer(cap, admin);



    //         // Create a transfer policy and transfer the cap to owner
    //         let (policy, policy_cap) = transfer_policy::new_for_testing<Prediction>(test_scenario::ctx(scenario_val));


    //         transfer::public_share_object(policy);
    //         transfer::public_transfer(policy_cap, admin);


            
    //     };



    //     // MAKE PREDICTION
    //     test_scenario::next_tx(scenario_val, admin);
    //     {
    //         // setup
    //         let guess = 444;

    //         let clock = clock::create_for_testing(test_scenario::ctx(scenario_val));
            
                        
            
    //         make_prediction(guess, &clock, test_scenario::ctx(scenario_val));


           
    //         clock::destroy_for_testing(clock);

    //     };


        

    //     // ADMIN GET THE KIOSK AND LIST PREDICTION
    //     test_scenario::next_tx(scenario_val, admin);
    //     {
            
            
    //         let admin_kiosk = test_scenario::take_shared<Kiosk>(scenario_val);
    //         let cap = test_scenario::take_from_sender<KioskOwnerCap>(scenario_val);
    //         let policy = test_scenario::take_shared<TransferPolicy<Prediction>>(scenario_val);

    //         let clock = clock::create_for_testing(test_scenario::ctx(scenario_val));
    //         let guess = 444;


           
    //         let predict = test_scenario::take_from_sender<Prediction>(scenario_val);

    //         let prediction_id = object::id(&predict);


    //         kiosk::place(&mut admin_kiosk, &cap, predict);
    //         assert_eq(kiosk::has_item(&admin_kiosk, prediction_id), true);


            
    //         kiosk::list<Prediction>(&mut admin_kiosk, &cap, prediction_id, 10);



    //         clock::destroy_for_testing(clock); 

    //         test_scenario::return_to_sender(scenario_val, cap);
    //         test_scenario::return_shared(admin_kiosk);
    //         test_scenario::return_shared(policy);



    //     };



    //     // ADMIN CLOSE GAME
    //     test_scenario::next_tx(scenario_val, admin);
    //     {

    //         let game = test_scenario::take_shared<Game>(scenario_val);

    //         let end_game_cap = test_scenario::take_from_sender<EndGameCap>(scenario_val);
           
    //         let game_closed = close_game(end_game_cap, &mut game, 444, test_scenario::ctx(scenario_val)); 

    //         assert!(game_closed == true, 0);

    //         test_scenario::return_shared(game);

    //     };





    //     test_scenario::end(scenario);   

    // }






    // #[test]
    // public fun purchase_prediction_from_kiosk_tests(){


    //     let admin = @0x1;
    //     let user1 = @0x2;
       

        
    //     let scenario = init_test_helper();
    //     let scenario_val = &mut scenario;




        
    //     // ADMIN AND USER CREATE KIOSKS AND TRANSFER POLICY AND AF+DMIN MAKES PREDICTION
    //     test_scenario::next_tx(scenario_val, admin);
    //     {

    //         // ADMIN

    //         // create admin kiosk and transfer policy
    //         let (admin_kiosk_two, admin_cap_two) = kiosk::new(test_scenario::ctx(scenario_val));
    //         transfer::public_share_object(admin_kiosk_two);
    //         transfer::public_transfer(admin_cap_two, admin);

    //         let admin_cap_two = test_scenario::take_from_sender<KioskOwnerCap>(scenario_val); 
    //         test_scenario::return_to_sender(scenario_val, admin_cap_two);


    //         let admin_policy_two = test_scenario::take_shared<TransferPolicy<Prediction>>(scenario_val);
    //         test_scenario::return_shared(admin_policy_two);
            


    //         // admin makes a prediction
    //         let clock = clock::create_for_testing(test_scenario::ctx(scenario_val));
    //         let guess = 444;

    //         make_prediction(guess, &clock, test_scenario::ctx(scenario_val));



    //         // USER1  
    //         // Create a Kiosk share it public and transfer the cap to owner
    //         let (user_kiosk_two, user_cap_two) = kiosk::new(test_scenario::ctx(scenario_val));
    //         transfer::public_share_object(user_kiosk_two);
    //         transfer::public_transfer(user_cap_two, user1);

    //         let user_cap_two = test_scenario::take_from_sender<KioskOwnerCap>(scenario_val); 
    //         test_scenario::return_to_sender(scenario_val, user_cap_two);
            


    //         clock::destroy_for_testing(clock); 
            


    //     };


        
    //      // ADMIN LISTS PREDICTION IN KIOSK AND USER PURCHASES PREDICTION
    //     test_scenario::next_tx(scenario_val, admin);
    //     {

    //         let admin_kiosk = test_scenario::take_shared<Kiosk>(scenario_val);
    //         let admin_cap = test_scenario::take_from_sender<KioskOwnerCap>(scenario_val);
    //         let policy = test_scenario::take_shared<TransferPolicy<Prediction>>(scenario_val);


    //         let predict = test_scenario::take_from_sender<Prediction>(scenario_val);
            

    //         let prediction_id = object::id(&predict);


    //         kiosk::place(&mut admin_kiosk, &admin_cap, predict);
    //         assert_eq(kiosk::has_item(&admin_kiosk, prediction_id), true);



    //         kiosk::list<Prediction>(&mut admin_kiosk, &admin_cap, prediction_id, 10);
            

    //         let user_kiosk = test_scenario::take_shared<Kiosk>(scenario_val);
    //         let user_cap = test_scenario::take_from_sender<KioskOwnerCap>(scenario_val);

    //         let coin = coin::mint_for_testing<SUI>(10, test_scenario::ctx(scenario_val));

    //         let (purchased_prediction, request) = kiosk::purchase<Prediction>(&mut admin_kiosk, prediction_id, coin);

    //         let purchased_prediction_id = object::id<Prediction>(&purchased_prediction);

    //         kiosk::place(&mut user_kiosk, &user_cap, purchased_prediction);
    //         assert_eq(kiosk::has_item(&user_kiosk, purchased_prediction_id), true);


    //         kiosk::list<Prediction>(&mut user_kiosk, &user_cap, purchased_prediction_id, 100);
           


    //         transfer_policy::confirm_request(&policy, request);


            
    //         test_scenario::return_to_sender(scenario_val, admin_cap);
    //         test_scenario::return_shared(admin_kiosk);
    //         test_scenario::return_shared(policy);

    //         test_scenario::return_to_sender(scenario_val, user_cap);
    //         test_scenario::return_shared(user_kiosk);



    //     };




    //     test_scenario::end(scenario);  



    // }







    // #[test]
    // public fun claim_winner_tests(){


    //     let admin = @0x1;
    //     let user1 = @0x2;
       

        
    //     let scenario = init_test_helper();
    //     let scenario_val = &mut scenario;




    //     // START GAME
    //     test_scenario::next_tx(scenario_val, admin);
    //     {
    //         let start_game_cap = test_scenario::take_from_sender<StartGameCap>(scenario_val);
    //         let clock = clock::create_for_testing(test_scenario::ctx(scenario_val)); 
    //         let price = 100;

    //         let predict_epoch = set_predict_epoch(0, 5, test_scenario::ctx(scenario_val));
    //         let report_epoch = set_report_epoch(0, 444, test_scenario::ctx(scenario_val));



    //         start_game(start_game_cap, price, predict_epoch, report_epoch, &clock, test_scenario::ctx(scenario_val));


    //         clock::destroy_for_testing(clock); 

    //     };




    //     // CREATE KIOSKS AND MAKE A PREDICTION
    //     test_scenario::next_tx(scenario_val, admin);
    //     {
    //        // ADMIN

    //         // create admin kiosk and transfer policy
    //         let (admin_kiosk_two, admin_cap_two) = kiosk::new(test_scenario::ctx(scenario_val));
    //         transfer::public_share_object(admin_kiosk_two);
    //         transfer::public_transfer(admin_cap_two, admin);

    //         let admin_cap_two = test_scenario::take_from_sender<KioskOwnerCap>(scenario_val); 
    //         test_scenario::return_to_sender(scenario_val, admin_cap_two);


    //         let admin_policy_two = test_scenario::take_shared<TransferPolicy<Prediction>>(scenario_val);
    //         test_scenario::return_shared(admin_policy_two);
            


    //         // admin makes a prediction
    //         let clock = clock::create_for_testing(test_scenario::ctx(scenario_val));
    //         let guess = 444;


    //         make_prediction(guess, &clock, test_scenario::ctx(scenario_val));



    //         // USER1  
    //         // Create a Kiosk share it public and transfer the cap to owner
    //         let (user_kiosk_two, user_cap_two) = kiosk::new(test_scenario::ctx(scenario_val));
    //         transfer::public_share_object(user_kiosk_two);
    //         transfer::public_transfer(user_cap_two, user1);

    //         let user_cap_two = test_scenario::take_from_sender<KioskOwnerCap>(scenario_val); 
    //         test_scenario::return_to_sender(scenario_val, user_cap_two);
            


    //         clock::destroy_for_testing(clock); 
            

    //     };




    //     // CLOSE GAME
    //     test_scenario::next_tx(scenario_val, admin);
    //     {
           
        
        
    //         let game = test_scenario::take_shared<Game>(scenario_val);

    //         let end_game_cap = test_scenario::take_from_sender<EndGameCap>(scenario_val);
           
    //         let game_closed = close_game(end_game_cap, &mut game, 444, test_scenario::ctx(scenario_val)); 

    //         assert!(game_closed == true, 0);

    //         test_scenario::return_shared(game);

    //     };




    //     // CLAIM WINNER
    //     test_scenario::next_tx(scenario_val, admin);
    //     {
    //         let prediction = test_scenario::take_from_sender<Prediction>(scenario_val);
    //         let game_instance = test_scenario::take_shared<Game>(scenario_val);
    //         let clock = clock::create_for_testing(test_scenario::ctx(scenario_val));
           

    //         claim_winner(prediction, &mut game_instance, &clock, test_scenario::ctx(scenario_val));
            

    //         clock::destroy_for_testing(clock);
    //         test_scenario::return_shared(game_instance);



    //     };




    //     test_scenario::end(scenario);  



        
    // }

        

    

}



