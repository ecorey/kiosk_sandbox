module kiosk_practice::kiosk_practice_two {




    use sui::kiosk;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::transfer_policy::{Self as tp, TransferPolicy};
    use sui::tx_context::{TxContext, Self};
    use sui::package::{Self, Publisher};    
    use std::string::{String};


    struct KIOSK_PRACTICE_TWO has drop {}


    struct NFT has key, store {
        id: UID,
        age: u64,
        name: String,
    }



    fun init(otw: KIOSK_PRACTICE_TWO, ctx: &mut TxContext) {
        let publisher = package::claim(otw, ctx);


        let ( transfer_policy, tp_cap ) = tp::new<NFT>(&publisher, ctx);

        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(tp_cap, tx_context::sender(ctx));

        transfer::public_share_object(transfer_policy);
    }


    public fun min() {

    }














}