module kiosk_practice::kiosk_practice_two {


    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::object::{Self, UID, ID};
    use sui::transfer;
    use sui::transfer_policy::{Self as tp, TransferPolicy, confirm_request};
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






    // errors
    const EOutsideWindow: u64 = 0;


    // OTW for the kiosk init function
    struct KIOSK_PRACTICE_TWO has drop {}
    



    // game owner cap
    struct GameOwnerCap has key {
        id: UID,
    }


    struct Epoch has store {
       start_time: u64,
       end_time: u64,

    }


    // game
    struct Game has key, store {
        id: UID,
        coin: String,
        balance: Balance<SUI>,
        price: u64,
        prev_id: Option<ID>,    
        cur_id: ID,
        result: u64,
        predict_epoch: Epoch,
        report_epoch: Epoch,
        

    }

    // report winner within timeframe by ref , add event
    public fun report_winner(prediction: &Prediction, game: &mut Game, clock: &Clock ) {
        assert!(clock::timestamp_ms(clock) > game.predict_epoch.start_time, EOutsideWindow);
        assert!(clock::timestamp_ms(clock) < game.predict_epoch.end_time, EOutsideWindow);
    } 



    struct GameInstance has key, store {
        id: UID,
        game_id: ID,
        balance: Balance<SUI>,
        
    }



    // registry for transfer policy
    struct Registry has key {
        id: UID, 
        tp: TransferPolicy<Prediction>,
    }
    
    


    // event emitted when a prediction is made
    // add ID to the event to connect to the prediction
    // user only needs to predict the repub and dem can be caluculated from the total count
    struct PredictionMade has copy, drop {
        prediction: Option<u64>,
        made_by: address,
    }



    // wrapper for the prediction to keep it in the kiosk
    struct PredictionWrapper has key {
        id: UID, 
        kiosk: Kiosk,
        kiosk_owner_cap: KioskOwnerCap,
        // prediction: Prediction,
    }



    // the prediction struct
    struct Prediction has key, store {
        id: UID,
        prediction: Option<u64>,
        timestamp: u64,
        
    }






    // init to make the transfer policy a shared object 
    // and transfer the game owner cap to the sender
    fun init(otw: KIOSK_PRACTICE_TWO, ctx: &mut TxContext) {
        let publisher = package::claim(otw, ctx);


        let ( transfer_policy, tp_cap ) = tp::new<Prediction>(&publisher, ctx);

        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(tp_cap, tx_context::sender(ctx));

        transfer::public_share_object(transfer_policy);

        transfer::transfer(GameOwnerCap {
            id: object::new(ctx),
        }, tx_context::sender(ctx));

    }





    // create a new game
    public fun new_game() {

    }



    // new instance
    fun new_instance() {

    }







    // mint a prediction in a prediction wrapper and emit the event
    public fun make_prediction(predict: u64, clock: &Clock, _tp: &TransferPolicy<Prediction> , ctx: &mut TxContext) : PredictionWrapper{
        
        
        event::emit(PredictionMade {
            prediction: option::some(predict),
            made_by: tx_context::sender(ctx),
        });

        

        let prediction = Prediction {
            id: object::new(ctx),
            prediction: option::some(predict),
            timestamp: clock::timestamp_ms(clock),
        };



        let (kiosk, kiosk_owner_cap) = kiosk::new(ctx);


        // place and lock item into the kiosk
        kiosk::lock(&mut kiosk, &kiosk_owner_cap, _tp, prediction);
       

        // wrapper is retuned to the user with the item locked in the kiosk
        // the prediction is not included in the prediction wrapper becasue its locked in teh kiosk
        PredictionWrapper {
            id: object::new(ctx),
            kiosk: kiosk,
            kiosk_owner_cap: kiosk_owner_cap,
            
        }


    }



    // unwraps prediction and returns the kiosk and kiosk owner cap
    public fun unwrap(
        prediction_wrapper: PredictionWrapper, 
        ctx: &mut TxContext
    ) : (Kiosk, KioskOwnerCap) {
        let PredictionWrapper { id, kiosk, kiosk_owner_cap} = prediction_wrapper;
        
        object::delete(id); 

        (kiosk, kiosk_owner_cap)
    }



    // creates an empty transfer policy and publicly shares it
    // todo create rules for the transfer policy / add royalty rule and floor rule
    public fun create_empty_policy( publisher: &Publisher, ctx: &mut TxContext) {

       

    }





    // public fun burn_from_kiosk( kiosk: &mut Kiosk, kiosk_cap: &KioskOwnerCap, prediction_id: ID, registry: &mut Registry, ctx: &mut TxContext) {

        // let purchase_cap = kiosk::list_with_purchase_cap<Prediction>( kiosk, kiosk_cap, prediction_id, 0, ctx); 
        // let ( prediction, transfer_request)  = kiosk::purchase_with_cap<Prediction>(kiosk, purchase_cap, coin::zero<SUI>(ctx));
        // confirm_request<Prediction>( &registry.tp, transfer_request  );

        // let Prediction {id, prediction: _, timestamp: _} = prediction;
        // object::delete(id);

    // }




    public fun list_prediction<T: key + store>(
        kiosk: &mut Kiosk, 
        kiosk_cap: &KioskOwnerCap, 
        prediction_id: ID, 
        price: u64
    ) {
        kiosk::list<Prediction>(kiosk, kiosk_cap, prediction_id, price);
    }



    public fun delist_prediction<T: key + store>(
        kiosk: &mut Kiosk,
        kiosk_cap: &KioskOwnerCap,
        prediction_id: ID,
    ) {
        kiosk::delist<Prediction>(kiosk, kiosk_cap, prediction_id);
    }


    //TESTS
    
    #[test]
    public fun test_init() {

        use sui::test_scenario;


        let admin = @0x1;
        let user1 = @0x2;
        let scenario = test_scenario::begin(admin);
        let scenario_val = &mut scenario;

        let otw = KIOSK_PRACTICE_TWO {};


        {
            
            init(otw, test_scenario::ctx(scenario_val));
            
            
        };


         test_scenario::next_tx(scenario_val, admin);
        {
            
            let ctx = test_scenario::ctx(scenario_val);
            let sender_address = tx_context::sender(ctx);
            assert!(sender_address == admin, 0);

            let game_owner_cap = test_scenario::take_from_sender<GameOwnerCap>(scenario_val);
            test_scenario::return_to_sender(scenario_val, game_owner_cap);
            
        };



        // test_scenario::next_tx(scenario_val, user1);
        // {
            
            // let prediction = 444;
            // let clock = clock::create_for_testing(test_scenario::ctx(scenario_val));
            
        
            // let wrapper = make_prediction(prediction, &clock, test_scenario::ctx(scenario_val));
            
            // let kiosk: &mut Kiosk; 
            // let kiosk_cap: &KioskOwnerCap; 
            // let tp: &TransferPolicy<Prediction>; 

        
            // unwrap(wrapper, kiosk, kiosk_cap, tp);

            // clock::destroy_for_testing(clock);
        // };


        
       
        
        
        test_scenario::end(scenario);   

    }

   





}



// TODO


 
// user gets predictin with timeline and winenr claims within a timeperiod 

// dont use shared object let user claim

// time windows 


// vector to hold values
// only need one value as a + b = 538
// add timestamp to the prediction
// create game_data struct that is a shared object and holds vector of predictions
// add transfer policy rules and create the empty_policy function
// add consts, asserts, and tests
// add game elements (new, instance, finalize, ext.)
// add table to store the predictions with an address
// add switchboard oracle prototype
// ptb for making predictions
















