module kiosk_practice::kiosk_practice_two {


    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::object::{Self, UID, ID};
    use sui::transfer;
    use sui::transfer_policy::{Self as tp, TransferPolicy, TransferPolicyCap, TransferRequest, confirm_request, new_request};
    use sui::tx_context::{TxContext, Self};
    use sui::package::{Self, Publisher};    
    use std::string::{String};
    use sui::display::{Self, Display};
    use std::option::{Self, Option};
    use sui::event;
    use sui::balance::{Self, Balance};
    use sui::sui::SUI;
    use sui::table::Table;
    use sui::coin::{Self, Coin};    
    use sui::clock::{Self, Clock};

    use kiosk_practice::royalty_policy;
    


    
    // errors
    const EOutsideWindow: u64 = 0;
    const EIncorrectPrediction: u64 = 1;

    


    // ##################################
    // ############GAME LOGIC############
    // ################################## 

    // struct to hold game times
    struct Epoch has key, store {
       id: UID,
       start_time: u64,
       end_time: u64,

    }



    // game owner cap that goes to sender of the init function
    struct GameOwnerCap has key {
        id: UID,
    }



    // game struct
    struct Game has key, store {
        id: UID,
        balance: Balance<SUI>,
        coin: String,
        price: u64, // price to make a prediction, mod the make prediction to have a cost
        prev_id: Option<ID>,    
        cur_id: ID,
        

    }



    // struct to hold a game instance
    struct GameInstance has key, store {
        id: UID,
        pot: Balance<SUI>, // holds the balance of the game instance, init to zero
        result: Option<u64>,  // will hold the result from the switchboard oracle, initialize to zero / add update function
        predict_epoch: Epoch, // start and end time for predictions
        report_epoch: Epoch, // start and end time for reporting the winner
        
    }



    // event emitted when a winner is reported  
    struct Winner has copy, drop {
        prediction: Option<u64>,
        made_by: address,
        time: u64,
    }



    // create a new game instance
    fun new_instance(predict_epoch: Epoch, report_epoch: Epoch, ctx: &mut TxContext) : GameInstance {
        GameInstance {
            id: object::new(ctx),
            pot: balance::zero<SUI>(),
            result: option::none(),
            predict_epoch,
            report_epoch,
        }
    }



    // create a new game
    fun new_game(instance: &GameInstance, coin: String, price: u64, ctx: &mut TxContext) : Game {
        Game {
            id: object::new(ctx),
            balance: balance::zero<SUI>(),
            coin,
            price,
            prev_id: option::none(),
            cur_id: object::id(instance),
        }

    }



    // startst the game and allows predictions to be made
    public fun start_game(_: &GameOwnerCap, coin: String, price: u64, predict_epoch: Epoch, report_epoch: Epoch, ctx: &mut TxContext)  {

        let instance = new_instance(predict_epoch, report_epoch, ctx);
        let game = new_game(&instance, coin, price, ctx);
        
        transfer::share_object(game);
        transfer::share_object(instance);


    }



    // close the game and allows the report winner function to be called
    public fun close_game() {

    }



    fun set_predict_epoch(start_time: u64, end_time: u64, ctx: &mut TxContext)  {
        
        let predict_epoch  = Epoch {
            id: object::new(ctx),
            start_time,
            end_time,
        };

        transfer::transfer(predict_epoch, tx_context::sender(ctx));

    }



    fun set_report_epoch(start_time: u64, end_time: u64, ctx: &mut TxContext) {
        
        let report_epoch  = Epoch {
            id: object::new(ctx),
            start_time,
            end_time,
        };

        transfer::transfer(report_epoch, tx_context::sender(ctx));

    }


    // claim the winner within timeframe by ref, add event to mark the winner
    public fun report_winner(prediction: &Prediction, game: &Game, game_instance: &GameInstance, clock: &Clock, ctx: &mut TxContext ) {
        assert!(clock::timestamp_ms(clock) > game_instance.predict_epoch.start_time, EOutsideWindow);
        assert!(clock::timestamp_ms(clock) < game_instance.predict_epoch.end_time, EOutsideWindow);

        assert!(clock::timestamp_ms(clock) > game_instance.report_epoch.start_time, EOutsideWindow);
        assert!(clock::timestamp_ms(clock) < game_instance.report_epoch.end_time, EOutsideWindow);

        assert!(prediction.prediction == game_instance.result, EIncorrectPrediction);


        if(prediction.prediction == game_instance.result) {
            event::emit(Winner {
                prediction: prediction.prediction,
                made_by: tx_context::sender(ctx),
                time: clock::timestamp_ms(clock),
            });
        }
    } 

    


    // ########################################
    // ############PREDICTION LOGIC############
    // ########################################

    // event emitted when a prediction is made
    // user only needs to predict the repub and dem can be caluculated from the total count
    struct PredictionMade has copy, drop {
        prediction: Option<u64>,
        made_by: address,
    }



    // the prediction struct
    struct Prediction has key, store {
        id: UID,
        prediction_id: ID,
        prediction: Option<u64>,
        timestamp: u64,
        
    }



    // makes a prediction and locks it in the users kiosk and emits an event for the prediction
    public fun make_prediction(kiosk: &mut Kiosk, kiosk_owner_cap: &KioskOwnerCap, predict: u64, clock: &Clock, _tp: &TransferPolicy<Prediction>, ctx: &mut TxContext)  {
        
        
        event::emit(PredictionMade {
            prediction: option::some(predict),
            made_by: tx_context::sender(ctx),
        });

        let id = object::new(ctx);
        let prediction_id = object::uid_to_inner(&id);

        let prediction = Prediction {
            id, 
            prediction_id,
            prediction: option::some(predict),
            timestamp: clock::timestamp_ms(clock),
        };


        // place and lock item into the kiosk
        kiosk::lock(kiosk, kiosk_owner_cap, _tp, prediction);
       

        
    }





    // #####################################################
    // ############INIT  / TRANSFER POLICY LOGIC############
    // #####################################################

    // OTW for the init function
    struct KIOSK_PRACTICE_TWO has drop {}
    


    // registry that will hold the transfer policy
    struct Registry has key, store {
        id: UID, 
        tp: TransferPolicy<Prediction>,
    }
    


    // init creates the transfer policy and stores it in the regisry which is a shared object 
    // and transfers the transfer policy cap and game owner cap to the sender
    fun init(otw: KIOSK_PRACTICE_TWO, ctx: &mut TxContext) {

        

        let publisher = package::claim(otw, ctx);


        let ( transfer_policy, tp_cap ) = tp::new<Prediction>(&publisher, ctx);


        // add royality rule to the transfer policy with a 5% royality fee
        add_royalty_to_policy(&mut transfer_policy, &tp_cap, 005_00);

        // adds tranfer policy to the registry
        let registry = Registry {
            id: object::new(ctx),
            tp: transfer_policy,
        };

        // transfer the publisher, transfer policy cap and game owner cap to the sender and share the registry
        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(tp_cap, tx_context::sender(ctx));
        transfer::public_share_object(registry);
        

        transfer::transfer(GameOwnerCap {
            id: object::new(ctx),
        }, tx_context::sender(ctx));

    }

    

    // adds the royalty rule to the transfer policy
   public fun add_royalty_to_policy(
        policy: &mut TransferPolicy<Prediction>,
        cap: &TransferPolicyCap<Prediction>,
        amount_bp: u16, 
    ) {
        
        royalty_policy::set<Prediction>(policy, cap, amount_bp);
    }



    


    // ###################################
    // ############KIOSK LOGIC############
    // ###################################

    // creates a new kiosk for a user that can hold the predictions 
    // and returns the kiosk and the kiosk owner cap
    public fun create_kiosk(ctx: &mut TxContext) : (Kiosk, KioskOwnerCap) {
        let (kiosk, kiosk_owner_cap) = kiosk::new(ctx);
        (kiosk, kiosk_owner_cap)
    }



    // burns the prediction from the kiosk and deletes the prediction
    public fun burn_from_kiosk( kiosk: &mut Kiosk, kiosk_cap: &KioskOwnerCap, prediction_id: ID, registry: &mut Registry, ctx: &mut TxContext) {

        let purchase_cap = kiosk::list_with_purchase_cap<Prediction>( kiosk, kiosk_cap, prediction_id, 0, ctx); 
        let ( prediction, transfer_request)  = kiosk::purchase_with_cap<Prediction>(kiosk, purchase_cap, coin::zero<SUI>(ctx));
        tp::confirm_request<Prediction>( &registry.tp, transfer_request  );

        let Prediction {id, prediction_id: _, prediction: _, timestamp: _} = prediction;
        object::delete(id);

    }



    // lists the prediction in the kiosk for sale
    public fun list_prediction<T: key + store>(
        kiosk: &mut Kiosk, 
        kiosk_cap: &KioskOwnerCap, 
        prediction_id: ID, 
        price: u64
    ) {
        kiosk::list<Prediction>(kiosk, kiosk_cap, prediction_id, price);
    }



    // delists the prediction from the kiosk
    public fun delist_prediction<T: key + store>(
        kiosk: &mut Kiosk,
        kiosk_cap: &KioskOwnerCap,
        prediction_id: ID,
    ) {
        kiosk::delist<Prediction>(kiosk, kiosk_cap, prediction_id);
    }



    // purchase a prediction from another user
    public fun purchase_prediction<T: key + store>(
        kiosk: &mut Kiosk,
        prediction_id: ID,
        payment: Coin<SUI>
        
    ) : (Prediction, TransferRequest<Prediction>) {

        kiosk::purchase<Prediction>(kiosk, prediction_id, payment)
    }



    


    // withdraw from a personal kiosk
    public fun withdraw_balance_from_kiosk(kiosk: &mut Kiosk, kiosk_owner_cap: &KioskOwnerCap, amount: Option<u64>, ctx: &mut TxContext) : Coin<SUI> {
        kiosk::withdraw(kiosk, kiosk_owner_cap, amount, ctx)
    }



    // withdraw from the transfer policy
    public fun withdraw_balance_from_tranfer_policy( transfer_policy: &mut TransferPolicy<Prediction>, transfer_policy_cap: &TransferPolicyCap<Prediction>, amount: Option<u64>, ctx: &mut TxContext ) : Coin<SUI> {
        tp::withdraw(transfer_policy, transfer_policy_cap, amount, ctx)
    }





    // ###################################
    // ############ORACLE LOGIC###########
    // ###################################

    // function to call switchboard oracle prototype to pull the final results










    // ###################################
    // ############TESTS##################
    // ###################################

    #[test]
    public fun test_init() {

        use sui::test_scenario;
        use sui::test_utils;
        use sui::kiosk_test_utils::{Self as test, Asset};
        use std::debug;

        let admin = @0x1;
        let user1 = @0x2;
        let scenario = test_scenario::begin(admin);
        let scenario_val = &mut scenario;

        let otw = KIOSK_PRACTICE_TWO {};

        // test the init function
        {
            
            init(otw, test_scenario::ctx(scenario_val));
            
            
        };

        // test the sender has the game owner cap 
        test_scenario::next_tx(scenario_val, admin);
        {
            
            let ctx = test_scenario::ctx(scenario_val);
            let sender_address = tx_context::sender(ctx);
            assert!(sender_address == admin, 0);

            let game_owner_cap = test_scenario::take_from_sender<GameOwnerCap>(scenario_val);
            test_scenario::return_to_sender(scenario_val, game_owner_cap);
            
        };


        // test making a prediction
        // TODO
        // fix the transfer policy in the test then test for the prediction
        test_scenario::next_tx(scenario_val, admin);
        {
            // setup
            let guess = 444;

            let clock = clock::create_for_testing(test_scenario::ctx(scenario_val));

            let coin = coin::mint_for_testing<SUI>(100, test_scenario::ctx(scenario_val));
            
            let (kiosk, kiosk_owner_cap) = test::get_kiosk(test_scenario::ctx(scenario_val));

            let publisher = test::get_publisher(test_scenario::ctx(scenario_val));

            


            std::debug::print(&clock);
            
            

            // MAKE PREDICTION AND BURN PREDICTION
            // make_prediction(&mut kiosk, &kiosk_owner_cap, guess, &clock, &transfer_policy, test_scenario::ctx(scenario_val));
            // burn_from_kiosk( kiosk, kiosk_owner_cap, prediction_id, registry, test_scenario::ctx(scenario_val));






            // CLEANUP 

            transfer::public_transfer(coin, admin);

            test::return_publisher(publisher);

            test::return_kiosk(kiosk, kiosk_owner_cap, test_scenario::ctx(scenario_val));
           
            

            clock::destroy_for_testing(clock);
        };


        
       
        
        
        test_scenario::end(scenario);   

    }

    




}



// ###################################
// ############TODO###################
// ###################################

// only need one value as a + b = 538
// add transfer policy rules and create the empty_policy function
// add consts, asserts, and tests
// add switchboard oracle prototype
// ptb for making predictions
// add display for teh prediction
















