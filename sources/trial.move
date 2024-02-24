module kiosk_practice::kiosk_trial {

    use sui::kiosk;
    use sui::sui::SUI;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::table::{Self, Table};
    use sui::object::{Self, UID, ID};
    use std::vector as vec;
    use std::string::String;
    use std::option::{Self, Option};
    use sui::package::{Self, Publisher};
    use sui::display::{Self, Display};
    use sui::borrow::{Self, Referent, Borrow};
    use sui::event;
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


    // event emitted when a prediction is made
    // add ID to the event to connect to the prediction
    struct PredictionMade has copy, drop {
        demo_event: Option<String>,
        repub_event: Option<String>,
        made_by: address,
    }


    // init to create the registry and provide access to publisher
    fun init(otw: KIOSK_TRIAL, ctx: &mut TxContext) {
        transfer::share_object( Registry {
            id: object::new(ctx),
            publisher: package::claim(otw, ctx),
        })
    }

    
    // start the game with the one time witness and store the prediction ticket
    public fun start_game<OTW: drop, T: store>(otw: OTW, ctx: &mut TxContext ) {
        assert!(sui::types::is_one_time_witness(&otw), ENotOneTimeWitness);    
        
        let publisher = package::claim(otw, ctx);

        assert!(package::from_module<T>(&publisher), ETypeNotFromModule);
        transfer::transfer(PredictionTicket<T> {
            id: object::new(ctx),
            publisher,
        }, tx_context::sender(ctx));
    
    }


    // use the prediction ticket to start a new game instance and recieve the prediction cap
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
    // event emites the demo, repub, and address of the sender making the prediction
    public fun make_prediction<T: store> (

        cap: &mut PredictionCap<T>,
        image_url: String,
        name: Option<String>,
        demo: Option<String>,
        repub: Option<String>,
        meta: Option<T>,
        ctx: &mut TxContext,

    ) : Prediction<T> {

        event::emit(PredictionMade {
            demo_event: demo,
            repub_event: repub,
            made_by: tx_context::sender(ctx),
        });

        // increment the minted count by one each prediction made
        cap.minted = cap.minted + 1;

        // returns the prediction object
        Prediction {
            id: object::new(ctx),
            image_url,
            demo,
            repub,
            meta,
        }

    }



    // BORROW METHODS

    // take the transfer policy cap from the prediction cap
    public fun borrow_policy_cap<T: store>(
        self: &mut PredictionCap<T>,
    ) : ( TransferPolicyCap<Prediction<T>>, Borrow) {
        borrow::borrow(&mut self.policy_cap)
    }


    // return transfer policy cap to the prediction cap
    public fun return_policy_cap<T: store>(
        self: &mut PredictionCap<T>,
        cap: TransferPolicyCap<Prediction<T>>,
        borrow: Borrow,
    ) {
        borrow::put_back(&mut self.policy_cap, cap, borrow)
    }


    // take the display from the prediction cap
    public fun borrow_display<T: store>(
        self: &mut PredictionCap<T>
    ) : ( Display<Prediction<T>>, Borrow) {
        borrow::borrow(&mut self.display)
    }


    // return the display to the prediction cap
    public fun return_display<T: store>(
        self: &mut PredictionCap<T>,
        display: Display<Prediction<T>>,
        borrow: Borrow,
    ) {
        borrow::put_back(&mut self.display, display, borrow)
    }


    // take the publisher from the prediction cap
    public fun borrow_publisher<T: store> (
        self: &mut PredictionCap<T>
    ) : ( Publisher, Borrow) {
        borrow::borrow(&mut self.publisher)
    }


    // return the publisher to the prediction cap
    public fun return_publisher<T: store> (
        self: &mut PredictionCap<T>,
        publisher: Publisher,
        borrow: Borrow
    ) {
        borrow::put_back(&mut self.publisher, publisher, borrow)
    }




    // internal methods

   
    




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