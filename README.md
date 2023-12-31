# SUIChess ♟
*This smart contract is developed for Move on SUI Mini Hackaton in Dec 2023.*

**A demo smart contract for an online chess game. This has functions to add new player and update player level.**

### How To Run 🔑

Open the folder in Remix IDE. Connect with a wallet (Use SUI coin), compile and test the code. 🚀

### About

- This is my first time seeing Move and trying to implement functions. 
- For creating user cards, I used code from workshop and I tried to develop a level updating function.
- Due to errors, I was not able to properly test the code. I was able to compile without error. When I tried testing, I did not have any errors. There were only warnings, and they were not in my code but it seemed to be on root (?) folders.

### 🖥️ Technologies Used

- Remix IDE
- Move
- SUI
- WELLDONE Wallet
- TOML

### PlayerCard 📋

- **Properties**: name, image, rank, level
- **Level updates**: update_level function
  
### PlayerHub 📡
Keeps track of player cards.
- **Properties**: owner, count, cards
- **Adding cards**: Each player card is added to hub as default while creating card.

#### 💻 create_card 
This is the function to add a new player. Creates player card and updates player hub accordingly.
- **Arguments**: name(vector<u8>), img_url(vector<u8>), ranking(u8), level(u8), playerhub(PlayerHub), ctx(TxContext)
- This is an entry function, processing new data. Does not have a return value.

#### ✨ get_card_info 
This is the function to see info of a card. 
- **Arguments**: playerhub(PlayerHub), id(u64)
- Returns *name, owner, image url, ranking and level of given player id.*
  
#### 💾 update_level 
Updates level of a player.
- **Arguments**: playerhub(PlayerHub), new_level(u8), id(u64), ctx(TxContext)
- Changes existing level integer with new one.
- This is an entry function, processing new data. Does not have a return value.

