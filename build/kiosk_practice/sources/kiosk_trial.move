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


    // errors
    const ENotOneTimeWitness: u64 = 0;
    const ETypeNotFromModule: u64 = 1;





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

    

    public fun start_game<OTW: drop, T: store>(otw: OTW, ctx: &mut TxContext ) {
        assert!(sui::types::is_one_time_witness(&otw), ENotOneTimeWitness);    
        
        let publisher = package::claim(otw, ctx);

        assert!(package::from_module<T>(&publisher), ETypeNotFromModule);
        transfer::transfer(PredictionTicket<T> {
            id: object::new(ctx),
            publisher,
        }, tx_context::sender(ctx));
    

    }


    // use the Prediction ticket to start a new game instance and recieve the prediction cap
    public fun create_game<T: store>(
        registry: &Registry,
        ticket: PredictionTicket<T>, 
        ctx: &mut TxContext,
    ) : PredictionCap<T> {
        let PredictionTicket { id, publisher } = ticket; 
        object::delete(id);
        
        let display = display::new<Prediction<T>>(&registry.publisher, ctx);
        let ( policy, policy_cap ) = policy::new<Prediction<T>>( &registry.publisher, ctx);

        transfer::public_share_object(policy);

        PredictionCap<T> {
            id: object::new(ctx),
            display: borrow::new(display, ctx),
            publisher: borrow::new(publisher, ctx),
            policy_cap: borrow::new(policy_cap, ctx),
            minted: 0,
        }

    }


    // MAKE PREDICTION
    public fun make_prediction<T: store> (

        cap: &mut PredictionCap<T>,
        image_url: String,
        name: Option<String>,
        demo: Option<String>,
        repub: Option<String>,
        meta: Option<T>,
        ctx: &mut TxContext,

    ) : Prediction<T> {

        cap.minted = cap.minted + 1;

        Prediction {
            id: object::new(ctx),
            image_url,
            demo,
            repub,
            meta,
        }

    }



    // BORROW METHODS






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