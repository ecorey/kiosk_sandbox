module kiosk_practice::kiosk_trial {

    use sui::kiosk;
    use sui::sui::SUI;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::table::{Self, Table};
    use sui::object::{Self, UID};
    use std::vector as vec;
    use std::string::String;
    use std::option::{Self, Option};
    use sui::package::{Self, Publisher};
    use sui::display::{Self, Display};
    use sui::borrow::{Self, Referent, Borrow};
    use sui::transfer_policy::{
        Self as policy,
        TransferPolicyCap
    };


    // centralized location to give access to the collectibles
    struct Registry has key {
        id: UID,
        publisher: Publisher,
    }




    // prediction cap for display, policycap, and publisher
    struct PredictionCap<T: store> has key, store {
        id: UID,
        publisher: Referent<Publisher>,
        display: Referent<Display<Prediction<T>>>,
        policy_cap: Referent<TransferPolicyCap<Prediction<T>>>,
        minted: u32,
        
    }


    // object connects init and the collection
    struct PredictionTicket<phantom T: store> has key, store {
        id: UID,
        publisher: Publisher,
    }


    // prediction struct
    struct Prediction<T: store> has key, store {
        id: UID,
        image_url: String,
        demo: Option<String>,
        repub: Option<String>,
        meta: Option<T>, 
    }

    // otw
    struct KIOSK_TRIAL has drop {}


    // init to create the registry and provide access to publisher
    fun init(otw: KIOSK_TRIAL, ctx: &mut TxContext) {
        transfer::share_object( Registry {
            id: object::new(ctx),
            publisher: package::claim(otw, ctx),
        })
    }

    
    public fun mint_object_to_kiosk(ctx: &mut TxContext) {
        
       

    }





    #[test_only]

    use sui::kiosk_test_utils::{Self, Asset};
   
    
    

    
    #[test]
    // test a new kiosk
    fun new_kiosk() {

        let ctx = &mut kiosk_test_utils::ctx();

        // create a new kiosk and owner_cap
        let ( kiosk, owner_cap) = kiosk_test_utils::get_kiosk(ctx);


        // returns kiosk and owner_cap
        kiosk_test_utils::return_kiosk(kiosk, owner_cap, ctx);
    }   

    






}