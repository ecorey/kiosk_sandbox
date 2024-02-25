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


}