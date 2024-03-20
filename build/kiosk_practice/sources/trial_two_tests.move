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


    use kiosk_practice::kiosk_practice::GameOwnerCap;
    use kiosk_practice::kiosk_practice::init_for_testing;
    use kiosk_practice::kiosk_practice::make_prediction;
    use kiosk_practice::kiosk_practice::delete_prediction;
    use kiosk_practice::kiosk_practice::KIOSK_PRACTICE;
    use kiosk_practice::kiosk_practice::Prediction;



  
    

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



        // test the sender has the game owner cap 
        test_scenario::next_tx(scenario_val, admin);
        {
            
            let ctx = test_scenario::ctx(scenario_val);
            let sender_address = tx_context::sender(ctx);
            assert!(sender_address == admin, 0);

            let game_owner_cap = test_scenario::take_from_sender<GameOwnerCap>(scenario_val);
            test_scenario::return_to_sender(scenario_val, game_owner_cap);
            
        };




        // make a prediction
        test_scenario::next_tx(scenario_val, admin);
        {

            // setup
            let guess = 444;

            let clock = clock::create_for_testing(test_scenario::ctx(scenario_val));

            let coin = coin::mint_for_testing<SUI>(100, test_scenario::ctx(scenario_val));
            
            let (kiosk, kiosk_owner_cap) = test::get_kiosk(test_scenario::ctx(scenario_val));

            let publisher = test::get_publisher(test_scenario::ctx(scenario_val));

            


            std::debug::print(&clock);
            
            

            // MAKE PREDICTION 
            
            make_prediction(guess, &clock, test_scenario::ctx(scenario_val));


            // CLEANUP 

            transfer::public_transfer(coin, admin);

            test::return_publisher(publisher);

            test::return_kiosk(kiosk, kiosk_owner_cap, test_scenario::ctx(scenario_val));
           
            

            clock::destroy_for_testing(clock);
        };


        


        test_scenario::next_tx(scenario_val, admin);
        {
             

            let predict = test_scenario::take_from_sender<Prediction>(scenario_val);

            // test_scenario::return_to_sender(scenario_val, predict);  


            delete_prediction(predict, test_scenario::ctx(scenario_val));

 
        };














       
        
        
        test_scenario::end(scenario);   

    }

    


    }

