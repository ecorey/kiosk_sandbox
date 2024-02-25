module kiosk_practice::kiosk_practice_two {


    use sui::kiosk;
    use sui::object::{Self, UID, ID};
    use sui::transfer;
    use sui::transfer_policy::{Self as tp, TransferPolicy};
    use sui::tx_context::{TxContext, Self};
    use sui::package::{Self, Publisher};    
    use std::string::{String};
    use sui::display::{Self, Display};
    use std::option::{Self, Option};
    use sui::event;
    use sui::balance::{Self, Balance};
    use sui::sui::SUI;
    use sui::table::Table;






    // errors
    const ENotOneTimeWitness: u64 = 0;
    const ETypeNotFromModule: u64 = 1;


    // OTW for the kiosk init function
    struct KIOSK_PRACTICE_TWO has drop {}
    



    // game owner cap
    struct GameOwnerCap has key {
        id: UID,
    }


    // game
    struct Game has key, store {
        id: UID,
        coin: String,
        balance: Balance<SUI>,
        price: u64,
        prev_id: Option<ID>,    
        cur_id: ID,

    }


    struct GameInstance has key, store {
        id: UID,
        balance: Balance<SUI>,
        pick1: Table<u64, address >,
        pick2: Table<u64, address >,
        
        
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
        demo: Option<String>,
        repub: Option<String>,
        
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




    // create a new game and instance
    // #[allow(lint(share_owned))]
    // public fun new(_: &GameOwnerCap, coin: String, price: u64, ctx: &mut TxContext)  {
    //    let instance = new_instance(ctx);
    //    let game = new_game(&instance, coin, price, ctx);


    //    transfer::share_object(game);
    //    transfer::share_object(instance);
    // }



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




