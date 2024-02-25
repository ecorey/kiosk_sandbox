module kiosk_practice::kiosk_practice_two {


    use sui::kiosk;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::transfer_policy::{Self as tp, TransferPolicy};
    use sui::tx_context::{TxContext, Self};
    use sui::package::{Self, Publisher};    
    use std::string::{String};
    use sui::display::{Self, Display};
    use std::option::{Self, Option};
    use sui::event;





    // errors
    const ENotOneTimeWitness: u64 = 0;
    const ETypeNotFromModule: u64 = 1;



    struct KIOSK_PRACTICE_TWO has drop {}


    // event emitted when a prediction is made
    // add ID to the event to connect to the prediction
    struct PredictionMade has copy, drop {
        demo_event: Option<String>,
        repub_event: Option<String>,
        made_by: address,
    }


    struct PredictionWrapper has key {
        id: UID, 
        prediction: Prediction,
    }


   struct Prediction has key, store {
        id: UID,
        image_url: String,
        demo: Option<String>,
        repub: Option<String>,
        
    }



    fun init(otw: KIOSK_PRACTICE_TWO, ctx: &mut TxContext) {
        let publisher = package::claim(otw, ctx);


        let ( transfer_policy, tp_cap ) = tp::new<Prediction>(&publisher, ctx);

        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(tp_cap, tx_context::sender(ctx));

        transfer::public_share_object(transfer_policy);
    }


    public fun mint(demo: String, repub: String, image_url: String, ctx: &mut TxContext) : PredictionWrapper{
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




