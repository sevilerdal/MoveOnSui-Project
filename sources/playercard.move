module chess::playercard {
    
    use std::string::{Self, String};
    use std::option::{Self, Option};
    use sui::transfer;
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::url::{Self, Url};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::object_table::{Self, ObjectTable};
    use sui::event;

    const NOT_THE_OWNER: u64 = 0;


    // Necessary information for a player to have in their card
    struct PlayerCard has key, store {
        id: UID,
        name: String,
        owner: address,
        img_url: Url,
        ranking: u8, // Global ranking of player
        level: u8,
    }

    struct PlayerHub has key, store {
        id: UID,
        owner: address,
        counter: u64,
        cards: ObjectTable<u64, PlayerCard>,
    }

    struct CardCreated has copy, drop {
        id: ID,
        name: String,
        owner: address,
        level: u8,
    }

    struct LevelUpdated has copy, drop {
        name: String,
        owner: address,
        new_level: u8,
    }

    fun init(ctx: &mut TxContext) {
        transfer::share_object(
            PlayerHub{
                id: object::new(ctx),
                owner: tx_context::sender(ctx),
                counter: 0,
                cards: object_table::new(ctx),
            }
        );

    }
    
    public entry fun create_card(
        name: vector<u8>,
        img_url: vector<u8>,
        ranking: u8,
        level: u8,
        playerhub: &mut PlayerHub,
        ctx: &mut TxContext,
    ) {
        playerhub.counter = playerhub.counter + 1;

        let id = object::new(ctx);

        event::emit(
            CardCreated{
                id: object::uid_to_inner(&id),
                name: string::utf8(name),
                owner: tx_context::sender(ctx),
                level,
            }
        );

        let playerCard = PlayerCard {
            id: id,
            name: string::utf8(name),
            owner: tx_context::sender(ctx),
            img_url: url::new_unsafe_from_bytes(img_url),
            ranking,
            level,
        };

        object_table::add(&mut playerhub.cards, playerhub.counter, playerCard);
    }

    public fun get_card_info(playerhub: &PlayerHub, id: u64): (
        String,
        address,
        Url,
        u8,
        u8,
    ) {
        let card = object_table::borrow(&playerhub.cards, id);
        (
            card.name,
            card.owner,
            card.img_url,
            card.ranking,
            card.level,
        )
    }

    public entry fun update_level(hub: &mut PlayerHub, new_level: u8, id: u64, ctx: &mut TxContext) {
        let user = object_table::borrow_mut(&mut hub.cards, id);
        assert!(tx_context::sender(ctx) == user.owner, NOT_THE_OWNER);
        user.level = new_level;

        event::emit(LevelUpdated {
            name: user.name,
            owner: user.owner,
            new_level: new_level,
        });

    }
    
    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext){
        init(ctx);
        
    }
    
    public fun create_for_testing(ctx: &mut TxContext, hub: &mut PlayerHub)
    {
        create_card(b"Test", b"https://picsum.photos/200", 5, 2, hub, ctx);
    }

    public fun test_update_level(ctx: &mut TxContext, hub: &mut PlayerHub, id: u64)
    {
        update_level(hub, 3, id, ctx);
    }
    
}