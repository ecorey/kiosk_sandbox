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
        balance: Balance<SUI>,
        pick1: Table<u64, address >,
        pick2: Table<u64, address >,
        
        
    }



    // registry for transfer policy
    struct Registry has key {
        id: UID, 
        tp: TransferPolicy<Prediction>,
    }
    
    


    // event emitted when a prediction is made
    // add ID to the event to connect to the prediction
    struct PredictionMade has copy, drop {
        demo_event: Option<String>,
        repub_event: Option<String>,
        made_by: address,
    }



    // wrapper for the prediction to keep it in the kiosk
    struct PredictionWrapper has key {
        id: UID, 
        prediction: Prediction,
    }



    // the prediction struct
    struct Prediction has key, store {
        id: UID,
        image_url: String,
        prediction: u64,
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
    public fun make_prediction(demo: String, repub: String, image_url: String, ctx: &mut TxContext) : PredictionWrapper{
        event::emit(PredictionMade {
            demo_event: option::some(demo),
            repub_event: option::some(repub),
            made_by: tx_context::sender(ctx),
        });

        let prediction = Prediction {
            id: object::new(ctx),
            image_url,
            demo: option::some(demo),
            repub: option::some(repub),
        };

        PredictionWrapper {
            id: object::new(ctx),
            prediction
        }
    }



    // unwraps prediction and locks the kiosk
    public fun unwrap(

        prediction_wrapper: PredictionWrapper, 
        kiosk: &mut Kiosk, 
        kiosk_cap: &KioskOwnerCap, 
        _tp: &TransferPolicy<Prediction>
        ) 
        {

        let PredictionWrapper { id, prediction } = prediction_wrapper;


        object::delete(id);
        kiosk::lock(kiosk, kiosk_cap, _tp, prediction);
    }



    // creates an empty transfer policy and publicly shares it
    // todo create rules for the transfer policy / add royalty rule and floor rule
    public fun create_empty_policy( publisher: &Publisher, ctx: &mut TxContext) {

       

    }





    public fun burn_from_kiosk( kiosk: &mut Kiosk, kiosk_cap: &KioskOwnerCap, prediction_id: ID, registry: &mut Registry, ctx: &mut TxContext) {

        let purchase_cap = kiosk::list_with_purchase_cap<Prediction>( kiosk, kiosk_cap, prediction_id, 0, ctx); 
        let ( prediction, transfer_request)  = kiosk::purchase_with_cap<Prediction>(kiosk, purchase_cap, coin::zero<SUI>(ctx));
        confirm_request<Prediction>( &registry.tp, transfer_request  );

        let Prediction {id, image_url: _, demo: _, repub: _} = prediction;
        object::delete(id);

    }









    //TESTS
    // test the prediction kiosk
    #[test_only]
    fun test_prediction_kiosk() {

        use sui::test_scenario;
        use sui::coin;


        

        let admin = @0xABC;
        let user = @0xDEF;


        let scenario_val = test_scenario::begin(admin);
        let scenario = &mut scenario_val;
        {
            
            
        };

       
        test_scenario::next_tx(scenario, admin );
        {

        };


        test_scenario::end(scenario_val);

    }


    // sample test using kiosk test utils
    #[test]
    fun test_kiok() {

         use sui::kiosk_test_utils::{Self, Asset};


        let ctx = &mut kiosk_test_utils::ctx();
        let ( kiosk, owner_cap) = kiosk_test_utils::get_kiosk(ctx);

        let old_owner = kiosk::owner(&kiosk);
        kiosk::set_owner(&mut kiosk, &owner_cap, ctx);
        assert!(kiosk::owner(&kiosk) == old_owner, 0);

        kiosk::set_owner_custom(&mut kiosk, &owner_cap, @0x0333);
        assert!(kiosk::owner(&kiosk) != old_owner, 0);
        assert!(kiosk::owner(&kiosk) == @0x0333, 0);

        kiosk_test_utils::return_kiosk(kiosk, owner_cap, ctx);
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
















