module kiosk_practice::kiosk_practice_two {


    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::object::{Self, UID, ID};
    use sui::transfer;
    use sui::transfer_policy::{Self as tp, TransferPolicy, TransferPolicyCap, TransferRequest, confirm_request, add_rule, new_request};
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



    


    // event emitted when a prediction is made
    // add ID to the event to connect to the prediction
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



    // registry for transfer policy
    struct Registry has key {
        id: UID, 
        tp: TransferPolicy<Prediction>,
    }
    

    // struct RoyaltyRuleConfig has store, drop {
    //     royalty_percentage: u64, 
    // }

    // struct FloorRuleConfig has store, drop {
    //     minimum_amount: u64, 
    // }



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


    // creates an transfer policy and publicly shares it
    // todo create rules for the transfer policy / add royalty rule and floor rule
    public fun create_transfer_policy( publisher: &Publisher, ctx: &mut TxContext) : (TransferPolicy<Prediction>, TransferPolicyCap<Prediction>) {

        let (transfer_policy, transfer_policy_cap) = tp::new<Prediction>(publisher, ctx);
       
        // let royalty_config = RoyaltyRuleConfig { royalty_percentage: 05 }; 
        // let floor_config = FloorRuleConfig { minimum_amount: 100 };


        // add_rule<RoyaltyRuleConfig>(royalty_config, &mut transfer_policy, &transfer_policy_cap, royalty_config);
        // add_rule<FloorRuleConfig>(floor_config, &mut transfer_policy, &transfer_policy_cap, floor_config);
        

        (transfer_policy, transfer_policy_cap)

    }




    // create a new game
    public fun new_game() {

    }



    // new instance
    fun new_instance() {

    }



    // creates a kiosk that holds the prediction
    public fun create_kiosk(ctx: &mut TxContext) : (Kiosk, KioskOwnerCap) {
        let (kiosk, kiosk_owner_cap) = kiosk::new(ctx);
        (kiosk, kiosk_owner_cap)
    }




    // mint a prediction and locks it in teh users kiosk and emits the event
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
        // need to adjust because cannot list / delist if teh prediction is locked needs to be placed
        kiosk::lock(kiosk, kiosk_owner_cap, _tp, prediction);
       

        
    }



    



    public fun burn_from_kiosk( kiosk: &mut Kiosk, kiosk_cap: &KioskOwnerCap, prediction_id: ID, registry: &mut Registry, ctx: &mut TxContext) {

        let purchase_cap = kiosk::list_with_purchase_cap<Prediction>( kiosk, kiosk_cap, prediction_id, 0, ctx); 
        let ( prediction, transfer_request)  = kiosk::purchase_with_cap<Prediction>(kiosk, purchase_cap, coin::zero<SUI>(ctx));
        confirm_request<Prediction>( &registry.tp, transfer_request  );

        let Prediction {id, prediction_id: _, prediction: _, timestamp: _} = prediction;
        object::delete(id);

    }




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



    // purchase the prediction from the kiosk
    public fun purchase_prediction<T: key + store>(
        kiosk: &mut Kiosk,
        prediction_id: ID,
        payment: Coin<SUI>
        
    ) : (Prediction, TransferRequest<Prediction>) {


        kiosk::purchase<Prediction>(kiosk, prediction_id, payment)

    }


    // clean up functions
    public fun return_policy(policy: TransferPolicy<Prediction>, cap: TransferPolicyCap<Prediction>, ctx: &mut TxContext) : Coin<SUI> {
        let profits = tp::destroy_and_withdraw(policy, cap, ctx);
        profits
        
    }


    


    //TESTS
    
    #[test]
    public fun test_init() {

        use sui::test_scenario;
        use sui::kiosk_test_utils::{Self as test, Asset};


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
            
                
            let (kiosk, kiosk_owner_cap) = test::get_kiosk(test_scenario::ctx(scenario_val));

            let publisher = test::get_publisher(test_scenario::ctx(scenario_val));

            // let ( transfer_policy, transfer_policy_cap) = create_transfer_policy(&publisher, test_scenario::ctx(scenario_val));
            
            


            // MAKE PREDICTION AND BURN PREDICTION
            // make_prediction(&mut kiosk, &kiosk_owner_cap, guess, &clock, &transfer_policy, test_scenario::ctx(scenario_val));
            // burn_from_kiosk( kiosk, kiosk_owner_cap, prediction_id, registry, test_scenario::ctx(scenario_val));




            // CLEANUP 

            // let balance = return_policy(transfer_policy, transfer_policy_cap, test_scenario::ctx(scenario_val));

            // let _amount_burned = coin::burn_for_testing(balance);
            
            test::return_publisher(publisher);

            test::return_kiosk(kiosk, kiosk_owner_cap, test_scenario::ctx(scenario_val));
           
            

            clock::destroy_for_testing(clock);
        };


        
       
        
        
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
















