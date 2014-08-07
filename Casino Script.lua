--[[
	 ____     __                  __                    
	/\  _ \  /\ \              __/\ \__                 
	\ \ \/\_\\ \ \___   __  __/\_\ \  _\   ___   __  _  
	 \ \ \/_/_\ \  _  \/\ \/\ \/\ \ \ \/  / __ \/\ \/ \ 
	  \ \ \_\ \\ \ \ \ \ \ \_\ \ \ \ \ \_/\ \_\ \/>  </ 
	   \ \____/ \ \_\ \_\ \____/\ \_\ \__\ \____//\_/\_\
		\/___/   \/_/\/_/\/___/  \/_/\/__/\/___/ \//\/_/
									Casino Script 2.0
	Information:
		Official thread: http://forums.xenobot.net/showthread.php?17044
		Depot Chest Setup: https://www.dropbox.com/s/nxybs942cfrsyak/setup.png

	Guidelines & Warnings:
		1. You must execute BOTH files in the link: "Casino Script.lua" and "Casino Script-Proxies.lua"
		2. Avoid using high values as accepted amounts of cash. Consider the following limits when you change settings:
		
			Blackjack, High/Low, Highest/Lowest & Odd/Even
				Minimum: 0.1k - 200k
				Maximum: 0.2k - 500k
				Payout: 1 - 100%
				
			First/Second/Last, Sequence & Pair Of Numbers
				Minimum: 0.1k - 200k
				Maximum: 0.2k - 300k
				Payout: 1 - 300%
				
			Single Numbers, Sum Of Numbers & Beat That
				Minimum: 0.1k - 200k
				Maximum: 0.2k - 200k
				Payout: 1 - 500%
				
		3. DO NOT perform actions manually with the script running, first type /stop in the script channel
		4. The features that affect performance are labeled
		5. Trashed dice will go to the items container when items are accepted
		6. Start the script by activating the Walker or placing yourself in the LEFT SIDE of a depot and typing /start
		7. Type /help in the script channel for a list of available commands
	
	Default Requirements:
		1. Die
		2. Party Hat (Head Slot)
		3. Ectoplasmic Sushi
		4. Orange Backpack: up to 2
		5. Red Backpack: up to 7
		6. Beach Backpack: 1 with nested backpacks (backpack inside backpack, same type)
		7. Lyre (Music Instrument)
		8. Trough Kit (Furniture)
]]--

------------------------------------------------------------------------------------------------------------------
--													G E N E R A L												--
------------------------------------------------------------------------------------------------------------------
	-- Basic Setup --
	_Containers_CrystalCoins = "Orange Backpack"								-- Container for crystal coins
	_Containers_PlatinumCoins = "Red Backpack"									-- Container for platinum coins
	_Containers_Items = "Beach Backpack"										-- Container for items

	-- Inactivity System --
	_Inactivity_Detection = true												-- Search new depot when inactive
	_Inactivity_Interval = 2													-- Minutes to wait before searching a new depot
	_Inactivity_AntiIdle = false												-- Built-In Anti-Idle
	_Inactivity_NotifyBlockedSpot = false										-- Notify to the player when the spot is blocked (Inactivity detection must disabled)
	_Inactivity_MessageBlockedSpot = "Please, don't block the depot"
	_Inactivity_BlockedSpotInterval = 2											-- Minutes to wait before notifying blocked spot
	
	-- Decoration --
	_Decoration_Enabled = true													-- Use decoration under dice		
	_Decoration_Item = "Ectoplasmic Sushi"										-- Name of item to use as decoration | Default: "Ectoplasmic Sushi"
	
	-- Randomizer --
	_VirtualMethod_	= true														-- User a virtual method to generate random numbers (Replacement for Official servers)

------------------------------------------------------------------------------------------------------------------
--											A D V A N C E D   S E T U P											--
------------------------------------------------------------------------------------------------------------------
	-- Effects --
	_Effects_Enabled = true														-- Use item effects
	_Effects_Item = "Party Hat"													-- Name of the item to show effects
	_Effects_Interval = 1														-- How often to show effects | Default: 1 second | WARNING: Low values may affect performance
	
	-- Remote Status --
	_Remote_Status = true														-- Enable the use of remote commands to know the status of the gambling session
	_Remote_AdminName = { "name1", "name2" }									-- Name of the character used to request status information
	_Remote_OutcomeCommand = "What's your outcome?"								-- Command to send outcome information
	_Remote_CashCommand = "How much do you have in cash?"						-- Command to send available cash information
	_Remote_ItemsCommand = "How much do you have in items?"						-- Command to send how much the items in the container are worth
	_Remote_StartCommand = "Let's gamble!"										-- Command to start the script
	_Remote_StopCommand = "Stop gambling"										-- Command to stop the script
	_Remote_NewDepotCommand = "Find a new depot"								-- Command to find a new depot to run the script
	_Remote_DiceAndDecoCommand = "How many dice and deco items do you have?"	-- Command to send how many dice and items for decoration it has in depot
	_Remote_EmptyContainersCommand = "How many empty containers do you have?"	-- Command to send how many empty containers for platinum coins are available
	_Remote_BackupProfitCommand = "Backup Profit"								-- Command to backup profit
	_Remote_BackupContainer = "Yellow Backpack"									-- Container used to store the profit
	_Remote_BackupCrystalCoins = 200											-- Amount of crystal coins to leave inside the depot
	
	-- Statistics --
	_Statistics_UseLog = false													-- Log Statistics | WARNING: May affect performance if enabled

	-- Debug Messages --
	_Debug_MessagesInChannel = false											-- Debug messages | WARNING: May affect performance if enabled
	_Debug_UseLog = false														-- May affect performance if enabled

	-- Extra Settings --
	_Extra_CipStaffDetection = true												-- Stop script when a Cipsoft member is detected
	_Extra_AlarmLowCash = true													-- Stop script and play alarm when cash is not enough to gamble
	_Extra_ServerSave = "10:00"													-- Time of the Server Save in your country 24h format
	_Extra_ScreenshotOnStop = true												-- Take screenshot when stopping the script
	_Extra_WorkloadExecution = 'default'										-- The speed to execute actions (default/fast/medium/slow)
	_Extra_PingCompensation = 100												-- Ping compensation for slow connections
	_Extra_RestartOnKick = true													-- Restart the script if the character has been kicked from game
	
	-- OpenTibia --
	_OpenTibia_Indexes = { 9, 11, 8, 7, 10, 14, 15, 12 }						-- Indexes used when running the script in OpenTibia servers
	
------------------------------------------------------------------------------------------------------------------
--												G A M E   T Y P E S												--
------------------------------------------------------------------------------------------------------------------
	-- Blackjack = Player's count (5 rolls) vs. Dealer's count (5 rolls) --
	Blackjack = false
	Blackjack_Minimum = 5000
	Blackjack_Maximum = 500000
	Blackjack_Payout = 80
	
	-- High/Low = 123 or 456 --
	High_Low = true
	High_Low_Minimum = 5000
	High_Low_Maximum = 500000
	High_Low_Payout = 80
	
	-- Odd/Even = 135 or 246 --
	Odd_Even = false
	Odd_Even_Minimum = 5000
	Odd_Even_Maximum = 500000
	Odd_Even_Payout = 80
	
	-- Highest/Lowest = Player's count (Half of rolls) vs. Dealer's count (Half of rolls). Highest wins --
	-- Only use even numbers like 2, 4, 6, 8, 10
	Highest_Lowest = false
	Highest_Lowest_Rolls = 4
	Highest_Lowest_Minimum = 5000
	Highest_Lowest_Maximum = 500000
	Highest_Lowest_Payout = 80
	
	-- First/Second/Last = 12, 34 or 56 --
	First_Second_Last = false
	First_Second_Last_Minimum = 5000
	First_Second_Last_Maximum = 300000
	First_Second_Last_Payout = 180
	
	-- Sequence = seq, sequence, succession or series (123, 234, 456, 654, 543 or 321) --
	Sequence = false
	Sequence_Minimum = 5000
	Sequence_Maximum = 300000
	Sequence_Payout = 180
	
	-- Pair of numbers = Match roll with 1 out of 2 numbers --
	Pair_Of_Numbers = false
	Pair_Of_Numbers_Minimum = 5000
	Pair_Of_Numbers_Maximum = 200000
	Pair_Of_Numbers_Payout = 180
	
	-- Single Numbers = 1, 2, 3, 4, 5 or 6 --
	Single_Numbers = false
	Single_Numbers_Minimum = 5000
	Single_Numbers_Maximum = 200000
	Single_Numbers_Payout = 360
	
	-- Beat That = Number between 11 and 66 --
	Beat_That = false
	Beat_That_Minimum = 5000
	Beat_That_Maximum = 200000
	Beat_That_Payout = 360
	
	-- Sum of numbers = Sum several rolls --
	Sum_Of_Numbers = false
	Sum_Of_Numbers_Minimum = 5000
	Sum_Of_Numbers_Maximum = 100000
	Sum_Of_Numbers_Maximum_Rolls = 10
	Sum_Of_Numbers_Payout = 360
	
------------------------------------------------------------------------------------------------------------------
--													M E S S A G E S												--
------------------------------------------------------------------------------------------------------------------
	-- Interactive Messages --
	_Interactive_Messages = true												-- Use interactive messages with the player
	_Interaction_PrivateMessages = true											-- Send interactive messages through PM instead of Local Chat
	Invalid_Bid =
	{
		-- [game], [min], [max]
		"The accepted amount for [game] is between [min] and [max]",
		"I'm sorry, I accept min. [min] and max. [max] to play [game]",
	}
	Welcome_Messages =
	{
		-- Placeholder: [player]
		"Welcome, [player]! Do you want to try your luck?",
		"Hello, [player]! I feel you want to become millionaire!",
		"Hello, [player]! Are you curious about my games? Say 'games' or 'rates'",
		"Hi, [player]! Are you feeling lucky today?",
	}	
	
	-- Digit Game Types --
	Win_Messages =
	{
		-- [amount]
		"Congratulations! You won [amount]",
		"Gratz! Here you are, [amount]",
		"Aaaand we have a winner! You have won [amount]",
		"Today must be your lucky day! You won [amount]",
	}
	Lose_Messages =
	{
		-- [amount]
		"I'm sorry, maybe another time",
		"Oh well you can't always win...",
	}
	
	-- Blackjack --
	Blackjack_Win_Messages =
	{
		-- [playercount], [dealercount], [amount]
		"Congratulations! Your count is [playercount] and mine [dealercount]. You have won [amount]",
		"Gratz! The counts were [playercount] vs. [dealercount]. Here you are, [amount]!",
		"Aaaand we have a winner! The counts were [playercount] vs. [dealercount]. You have won [amount]",
		"Today must be your lucky day! Your count was [playercount] and mine [dealercount]. You won [amount]",
	}
	Blackjack_Lose_Messages =
	{
		-- [playercount], [dealercount], [amount]
		"I'm sorry, maybe another time. The counts were [playercount] vs. [dealercount]",
		"Oh well, that's [playercount] vs. [dealercount]. I guess you can't always win...",
	}
	Blackjack_Even_Result_Messages =
	{
		-- [tiecount], [amount]
		"It's a tie! We both got a total of [tiecount], here is your [amount]",
		"We are tied. Both counts were [tiecount]. Here is your [amount] back",
	}
	Blackjack_Busted_Player_Messages =
	{
		-- [playercount], [amount]
		"You got busted, your final count was [playercount]",
		"Busted! Your count is [playercount] and it's above 21",
	}
	Blackjack_Busted_Dealer_Messages =
	{
		-- [dealercount], [amount]
		"My final count was [dealercount] and it's above 21. You have won [amount]",
		"Well, my count was above 21 as it's [dealercount]. Congratulations! You won [amount]",
	}
	Blackjack_Busted_Both_Messages =
	{
		-- [playercount], [dealercount], [amount]
		"Your count was [playercount] and mine [dealercount]. We were both above 21 so here is your [amount] back",
		"Looks like we both were over 21 with [playercount] vs. [dealercount]. Here is your [amount] back",
	}
	
	-- Highest/Lowest --
	Highest_Lowest_Win_Messages =
	{
		-- [firstcount], [secondcount], [amount]
		"Congratulations! Your count is [firstcount] and mine [secondcount]. You have won [amount]",
		"Gratz! The counts were [firstcount] and [secondcount]. Here you are, [amount]!",
		"Aaaand we have a winner! The counts were [firstcount] and [secondcount]. You have won [amount]",
		"Today must be your lucky day! The first count was [firstcount] and the second [secondcount]. You won [amount]",
	}
	Highest_Lowest_Lose_Messages =
	{
		-- [firstcount], [secondcount], [amount]
		"I'm sorry, maybe another time. The counts were [firstcount] and [secondcount]",
		"Oh well, that's [firstcount] and [secondcount]. I guess you can't always win...",
	}
	Highest_Lowest_Even_Result_Messages =
	{
		-- [tiecount], [amount]
		"Both sums were equal [tiecount], here is your [amount]",
		"The counts were the same: [tiecount]. Here is your [amount] back",
	}
	-- Sequence --
	Sequence_Win_Messages =
	{
		-- [sequence], [amount]
		"Congratulations! The sequence was [sequence]. You won [amount]",
		"Gratz! The sequence was [sequence] Here you are, [amount]",
	}
	Sequence_Lose_Messages =
	{
		-- [sequence], [amount]
		"I'm sorry, maybe another time. The sequence was [sequence]",
		"The sequence was [sequence], I guess you can't always win...",
	}
	-- Sum Of Numbers --
	Sum_Win_Messages =
	{
		-- [sum], [amount]
		"Congratulations! The sum was [sum]. You won [amount]",
		"Gratz! The sum was [sum] Here you are, [amount]",
	}
	Sum_Lose_Messages =
	{
		-- [sum], [amount]
		"I'm sorry, maybe another time. The sum was [sum]",
		"The sum was [sum], I guess you can't always win...",
	}
	
------------------------------------------------------------------------------------------------------------------
--												B R O A D C A S T												--
------------------------------------------------------------------------------------------------------------------
	-- AVAILABLE PLACEHOLDERS FOR CUSTOM MESSAGES
	-- [name],
	-- [minhighlow], [minoddeven], [minfirstsecondlast], [minsingle], [minblackjack],
	-- [maxhighlow], [maxoddeven], [maxfirstsecondlast], [maxsingle], [maxblackjack],
	-- [payoutblackjack], [payoutoddeven], [payouthighlow], [payoutfirstsecondlast], [payoutsingle]
	
	_Broadcast_UseMessages = true													-- Use broadcasted messages
	_Broadcast_Interval = 60														-- Time in seconds to wait before the next broadcast
	_Broadcast_FixedInterval = false												-- Broadcast even with players around or when gambling | WARNING: May affect performance
	_Broadcast_UppercaseMessages = true												-- Modify the broadcast to use uppercase letters | Example: COME A PLAY THE FASTEST GAME
	_Broadcast_YellMessages = true													-- Yell broadcasted message
	_Broadcast_Messages =
	{
		"[name]'s Casino - Try your luck with the fastest game!",
		"Become a millionaire in a second at [name]'s Casino!",
		"Come and play the fastest game!",
		"Feeling lucky? The best payrate in all Tibia!",
		"Tired of slow games? Come and play at [name]'s Casino!",
	}
	
------------------------------------------------------------------------------------------------------------------
--											W I N S   &  L O S S E S											--
------------------------------------------------------------------------------------------------------------------
	
	Winning_Item = "Lyre"															-- Default: Lyre | Type "none" to disable
	Losing_Item = "Trough Kit"														-- Default: Trough Kit | Type "none" to disable

------------------------------------------------------------------------------------------------------------------
--													I T E M S													--
------------------------------------------------------------------------------------------------------------------

	Accept_Items = false															-- Accept items as bets
	Items_List =
	{
		-- Products --
		{ Name = "Magic Sulphur",				Value = 8000 	},
		{ Name = "Dragon Claw",					Value = 300000 	},
		{ Name = "Soul Stone",					Value = 500000 	},
		{ Name = "Spider Silk",					Value = 4000 	},
		{ Name = "Dracola's Eye", 				Value = 50000 	},
		{ Name = "Dracoyle Statue", 			Value = 5000 	},
		{ Name = "Red Piece Of Cloth", 			Value = 20000 	},
		{ Name = "Flask of Warrior's Sweat",	Value = 10000 	},
		{ Name = "Mr. Punish's Handcuffs", 		Value = 50000 	},
		{ Name = "Piece of Massacre's Shell", 	Value = 50000 	},
		{ Name = "Skeleton Decoration", 		Value = 3000 	},
		{ Name = "Sniper Gloves", 				Value = 2000 	},
		{ Name = "Spirit Container", 			Value = 40000	},
		{ Name = "Tentacle Piece", 				Value = 5000 	},
		{ Name = "The Plasmother's Remains", 	Value = 50000 	},
		{ Name = "Demonic Essence", 			Value = 1000 	},
		-- Others --
		{ Name = "Pair Of Soft Boots", 			Value = 300000 	},
		{ Name = "Worn Soft Boots", 			Value = 300000 	},
		{ Name = "Firewalker Boots", 			Value = 150000 	},
		{ Name = "Worn Firewalker Boots", 		Value = 150000 	},
		-- Blue Djinn --
		{ Name = "Angelic Axe", 				Value = 5000	},
		{ Name = "Blue Robe", 					Value = 10000 	},
		{ Name = "Boots Of Haste",				Value = 30000	},
		{ Name = "Butcher's Axe",				Value = 18000	},
		{ Name = "Crown Armor",					Value = 12000	},
		{ Name = "Crown Helmet",				Value = 2500	},
		{ Name = "Crown Legs",					Value = 12000	},
		{ Name = "Crown Shield",				Value = 8000	},
		{ Name = "Crusader Helmet",				Value = 6000	},
		{ Name = "Dragon Lance",				Value = 9000	},
		{ Name = "Dragon Shield",				Value = 4000	},
		{ Name = "Fire Axe",					Value = 8000	},
		{ Name = "Fire Sword",					Value = 4000	},
		{ Name = "Glorious Axe",				Value = 3000	},
		{ Name = "Guardian Shield",				Value = 2000	},
		{ Name = "Phoenix Shield",				Value = 16000	},
		{ Name = "Queen's Sceptre",				Value = 10000	},
		{ Name = "Royal Helmet",				Value = 30000	},
		{ Name = "Shadow Sceptre",				Value = 10000	},
		{ Name = "Thaian Sword",				Value = 16000	},
		{ Name = "Wand Of Cosmic energy",		Value = 2000	},
		{ Name = "Wand Of Defiance",			Value = 6500	},
		{ Name = "Wand Of Everblazing",			Value = 6000	},
		{ Name = "Wand Of Inferno",				Value = 3000	},
		{ Name = "Wand Of Starstorm",			Value = 3600	},
		{ Name = "Wand Of Voodoo",				Value = 4000	},
		-- Green Djinn --
		{ Name = "Bonebreaker",					Value = 10000	},
		{ Name = "Dragon Hammer",				Value = 2000	},
		{ Name = "Dreaded Cleaver",				Value = 15000	},
		{ Name = "Knight Axe",					Value = 2000	},
		{ Name = "Earth Knight Axe",			Value = 2000	},
		{ Name = "Energy Knight Axe",			Value = 2000	},
		{ Name = "Fiery Knight Axe",			Value = 2000	},
		{ Name = "Icy Knight Axe",				Value = 2000	},
		{ Name = "Giant Sword",					Value = 17000	},
		{ Name = "Haunted Blade",				Value = 8000	},
		{ Name = "Knight Legs",					Value = 5000	},
		{ Name = "Knight Armor",				Value = 5000	},
		{ Name = "Onyx Flail",					Value = 22000	},
		{ Name = "Ornamented Axe",				Value = 20000	},
		{ Name = "Skull Staff",					Value = 6000	},
		{ Name = "Titan Axe",					Value = 4000	},
		{ Name = "Tower Shield",				Value = 8000	},
		{ Name = "Vampire Shield",				Value = 15000	},
		{ Name = "Warrior Helmet",				Value = 5000	},
		{ Name = "Glacial Rod",					Value = 6500	},
		{ Name = "Hailstorm Rod",				Value = 3000	},
		{ Name = "Muck Rod",					Value = 6000	},
		{ Name = "Springsprout Rod",			Value = 3600	},
		{ Name = "Terra Rod",					Value = 2000	},
		{ Name = "Underworld Rod",				Value = 4400	},
		-- Rashid --
		{ Name = "Abyss Hammer",				Value = 20000	},
		{ Name = "Amber Staff",					Value = 8000	},
		{ Name = "Assassin Dagger",				Value = 20000	},
		{ Name = "Berserker",					Value = 40000	},
		{ Name = "Blacksteel Sword",			Value = 6000	},
		{ Name = "Blessed Sceptre",				Value = 40000	},
		{ Name = "Bonelord Helmet",				Value = 7500	},
		{ Name = "Buckle",						Value = 7000	},
		{ Name = "Castle Shield",				Value = 5000	},
		{ Name = "Chain Bolter",				Value = 40000	},
		{ Name = "Chaos Mace",					Value = 9000	},
		{ Name = "Cobra Crown",					Value = 50000	},
		{ Name = "Composite Hornbow",			Value = 25000	},
		{ Name = "Cranial Basher",				Value = 30000	},
		{ Name = "Crystal Crossbow",			Value = 35000	},
		{ Name = "Crystal Mace",				Value = 12000	},
		{ Name = "Crystalline Armor",			Value = 16000	},
		{ Name = "Demon Shield",				Value = 30000	},
		{ Name = "Demonbone Amulet",			Value = 32000	},
		{ Name = "Demonrage Sword",				Value = 36000	},
		{ Name = "Diamond Sceptre",				Value = 3000	},
		{ Name = "Divine Plate",				Value = 55000	},
		{ Name = "Djinn Blade",					Value = 15000	},
		{ Name = "Dragon Scale Mail",			Value = 40000	},
		{ Name = "Dragon Slayer",				Value = 15000	},
		{ Name = "Dragonbone Staff",			Value = 3000	},
		{ Name = "Dwarven Armor",				Value = 30000	},
		{ Name = "Elvish Bow",					Value = 2000	},
		{ Name = "Epee",						Value = 8000	},
		{ Name = "Fur Boots",					Value = 2000	},
		{ Name = "Glacier Kilt",				Value = 11000	},
		{ Name = "Glacier Mask",				Value = 2500	},
		{ Name = "Glacier Robe",				Value = 11000	},
		{ Name = "Glacier Shoes",				Value = 2500	},
		{ Name = "Gold Ring",					Value = 8000	},
		{ Name = "Golden Armor",				Value = 20000	},
		{ Name = "Golden Legs",					Value = 30000	},
		{ Name = "Guardian Halberd",			Value = 11000	},
		{ Name = "Hammer Of Wrath",				Value = 30000	},
		{ Name = "Headchopper",					Value = 6000	},
		{ Name = "Heavy Mace",					Value = 50000	},
		{ Name = "Heavy Trident",				Value = 2000	},
		{ Name = "Helmet Of The Lost",			Value = 2000	},
		{ Name = "Heroic Axe",					Value = 30000	},
		{ Name = "Hibiscus Dress",				Value = 3000	},
		{ Name = "Jade Hammer",					Value = 25000	},
		{ Name = "Lavos Armor",					Value = 16000	},
		{ Name = "Leviathan's Amulet",			Value = 3000	},
		{ Name = "Lightning Boots",				Value = 2500	},
		{ Name = "Lightning Headband",			Value = 2500	},
		{ Name = "Lightning Legs",				Value = 11000	},
		{ Name = "Lightning Robe",				Value = 11000	},
		{ Name = "Lunar Staff",					Value = 5000	},
		{ Name = "Magic Plate Armor",			Value = 90000	},
		{ Name = "Magma Boots",					Value = 2500	},
		{ Name = "Magma Coat",					Value = 11000	},
		{ Name = "Magma Legs",					Value = 11000	},
		{ Name = "Magma Monocle",				Value = 2500	},
		{ Name = "Mammoth Fur Cape",			Value = 6000	},
		{ Name = "Mastermind Shield",			Value = 50000	},
		{ Name = "Medusa Shield",				Value = 9000	},
		{ Name = "Mercenary Sword",				Value = 12000	},
		{ Name = "Mycological Bow",				Value = 35000	},
		{ Name = "Mystic Blade",				Value = 30000	},
		{ Name = "Naginata",					Value = 2000	},
		{ Name = "Nightmare Blade",				Value = 35000	},
		{ Name = "Noble Axe",					Value = 10000	},
		{ Name = "Orcish Maul",					Value = 6000	},
		{ Name = "Pair Of Iron Fists",			Value = 4000	},
		{ Name = "Paladin Armor",				Value = 15000	},
		{ Name = "Patched Boots",				Value = 2000	},
		{ Name = "Pharaoh Sword",				Value = 23000	},
		{ Name = "Pirate Boots",				Value = 3000	},
		{ Name = "Platinum Amulet",				Value = 2500	},
		{ Name = "Relic Sword",					Value = 25000	},
		{ Name = "Ring Of The Sky",				Value = 30000	},
		{ Name = "Royal Axe",					Value = 40000	},
		{ Name = "Ruby Necklace",				Value = 2000	},
		{ Name = "Ruthless Axe",				Value = 45000	},
		{ Name = "Sacred Tree Amulet",			Value = 3000	},
		{ Name = "Sapphire Hammer",				Value = 7000	},
		{ Name = "Scarab Shield",				Value = 2000	},
		{ Name = "Shockwave Amulet",			Value = 3000	},
		{ Name = "Skull Helmet",				Value = 40000	},
		{ Name = "Skullcracker Armor",			Value = 18000	},
		{ Name = "Spiked Squelcher",			Value = 5000	},
		{ Name = "Steel Boots",					Value = 30000	},
		{ Name = "Swamplair Armor",				Value = 16000	},
		{ Name = "Tempest Shield",				Value = 35000	},
		{ Name = "Terra Boots",					Value = 2500	},
		{ Name = "Terra Hood",					Value = 2500	},
		{ Name = "Terra Legs",					Value = 11000	},
		{ Name = "Terra Mantle",				Value = 11000	},
		{ Name = "The Justice Seeker",			Value = 40000	},
		{ Name = "Vile Axe",					Value = 30000	},
		{ Name = "War Axe",						Value = 12000	},
		{ Name = "War Horn",					Value = 8000	},
		{ Name = "Witch hat",					Value = 5000	},
		-- Zao --
		{ Name = "Drachaku",					Value = 10000	},
		{ Name = "Draken Boots",				Value = 40000	},
		{ Name = "Drakinata",					Value = 10000	},
		{ Name = "Elite Draken Mail",			Value = 50000	},
		{ Name = "Guardian Boots",				Value = 35000	},
		{ Name = "Sais",						Value = 16500	},
		{ Name = "Twiceslicer",					Value = 28000	},
		{ Name = "Wailing Widow's Necklace",	Value = 3000	},
		{ Name = "Zaoan Armor",					Value = 14000	},
		{ Name = "Zaoan Helmet",				Value = 45000	},
		{ Name = "Zaoan Legs",					Value = 14000	},
		{ Name = "Zaoan Shoes",					Value = 5000	},
		{ Name = "Zaoan Sword",					Value = 30000	},
		-- Warzone --
		{ Name = "Arbalest",					Value = 42000	},
		{ Name = "Arcane Staff",				Value = 42000	},
		{ Name = "Baby Seal Doll",				Value = 20000	},
		{ Name = "Bejeweled Ship's Telescope",	Value = 20000	},
		{ Name = "Blade of Corruption",			Value = 60000	},
		{ Name = "Bloody Edge",					Value = 30000	},
		{ Name = "Blue Legs",					Value = 15000	},
		{ Name = "Bright Sword",				Value = 6000	},
		{ Name = "Ceremonial Ankh",				Value = 20000	},
		{ Name = "Claw of 'The Noxious Spawn'",	Value = 15000	},
		{ Name = "Crystal Wand",				Value = 10000	},
		{ Name = "Demon Helmet",				Value = 40000	},
		{ Name = "Dragon Robe",					Value = 50000	},
		{ Name = "Dwarven Legs",				Value = 40000	},
		{ Name = "Egg of the Many",				Value = 15000	},
		{ Name = "Executioner",					Value = 55000	},
		{ Name = "Frozen Starlight",			Value = 20000	},
		{ Name = "Greenwood Coat",				Value = 50000	},
		{ Name = "Marlin Trophy",				Value = 5000	},
		{ Name = "Modified Crossbow",			Value = 10000	},
		{ Name = "Panda Teddy",					Value = 30000	},
		{ Name = "Runed Sword",					Value = 45000	},
		{ Name = "Sea Serpent Trophy",			Value = 10000	},
		{ Name = "Silkweaver Bow",				Value = 12000	},
		{ Name = "Souleater Trophy",			Value = 7500	},
		{ Name = "Stuffed Dragon",				Value = 6000	},
		{ Name = "The Avenger",					Value = 42000	},
		{ Name = "The Ironworker",				Value = 50000	},
		{ Name = "Unholy Book",					Value = 30000	},
		{ Name = "Windborn Colossus Armor",		Value = 50000	},
	}
	
--[[ DO NOT EDIT ANYTHING BELOW THIS LINE ]]--
	Script_Information =
	{
		Name = "Open Casino v2.0",
		Developer = "Chuitox"
	}
	InformationText = Script_Information.Name.." by "..Script_Information.Developer..'\n'
	function onSpeak(channel, message)
		channel:SendYellowMessage(getUserName():titlecase(), message)
		message = message:lower():trim()
		
		local setting_cmd, setting_value = message:match('^/([a-z]+) (.+)$')
		if (setting_cmd) then
			if (setting_cmd == 'broadcast') then
				if (setting_value) then
					if (setting_value == 'true' or setting_value == 'false') then
						if (setting_value == 'true') then
							_Broadcast_UseMessages = true
							channel:SendOrangeMessage('Casino', 'You will broadcast messages')
						else
							_Broadcast_UseMessages = false
							channel:SendOrangeMessage('Casino', 'You won\'t broadcast messages')
						end
					else
						_Broadcast_UseMessages = true
						channel:SendOrangeMessage('Casino', 'Invalid value. You will broadcast messages by default')
					end
				end
			elseif (setting_cmd == 'alwaysactive') then
				if (setting_value) then
					if (setting_value == 'true' or setting_value == 'false') then
						if (setting_value == 'true') then
							_Inactivity_Detection = true
							channel:SendOrangeMessage('Casino', 'You will search for new depots if the period of inactivity is longer than '.._Inactivity_Interval..' min.')
						else
							_Inactivity_Detection = false
							channel:SendOrangeMessage('Casino', 'You won\'t search for new depots if the period of inactivity is longer than '.._Inactivity_Interval..' min.')
						end
					else
						_Inactivity_Detection = true
						channel:SendOrangeMessage('Casino', 'Invalid value. You will search for new depots if the period of inactivity is longer than '.._Inactivity_Interval..' min. by default')
					end
				end
			else
				channel:SendOrangeMessage('Casino', 'Unknown command. Type /help for a list of available commands.')
			end
		else
			local execute_cmd = message:match('^/([a-z]+)$')
			if (execute_cmd) then
				if (execute_cmd == 'open') then
					if Open_Containers() then
						channel:SendOrangeMessage('Casino', 'All containers have been opened successfully.')
					end
				elseif (execute_cmd == 'start') or (execute_cmd == 'new') then
					Casino_Loaded = false
					PickUpDiceAndDecoration()
					if not Blackjack and
						not High_Low and
						not Odd_Even and
						not First_Second_Last and
						not Single_Numbers and
						not Highest_Lowest and
						not Sequence and
						not Pair_Of_Numbers and
						not Sum_Of_Numbers and
						not Beat_That then
						channel:SendOrangeMessage('Casino', 'You don\'t accept any game type. Please, check your settings and reload the script')
					else
						if UpdateCoordinates() then
							if Open_Containers() then
								CheckDiceAndDecoration()
								Last_Activity = os.time()
								Total.Items.LastAmountSeen = 0
								Total.Items.Amount = 0
								Total.Items.Value = 0
								Casino_Loaded = true
								ManualStop = false
								channel:SendOrangeMessage('Casino', 'The script has been started')
							end
						else
							channel:SendOrangeMessage('Casino', 'The script failed to find location')
						end
					end
				elseif (execute_cmd == 'close') then
					Casino_Loaded = false
					PickUpDiceAndDecoration()
					while #Container.GetAll() > 0 do
						for i = 0, 15 do
							closeContainer(i)
						end
					end
					channel:SendOrangeMessage('Casino', 'All containers have been closed')
				elseif (execute_cmd == 'stop') then
					Casino_Loaded = false
					ManualStop = true
					PickUpDiceAndDecoration()
					while #Container.GetAll() > 0 do
						for i = 0, 15 do
							closeContainer(i)
						end
					end
					if channel then
						channel:SendOrangeMessage('Casino', 'The script has been stopped')
					end
				elseif (execute_cmd == 'reset') then
					Blackjack_Payout = 80
					High_Low_Payout = 80
					Odd_Even_Payout = 80
					First_Second_Last_Payout = 180
					Single_Numbers_Payout = 360
					Losing_Item = 'Trough Kit'
					Winning_Item = 'Lyre'
					Winning_Item_ID = Item.GetID(Winning_Item)
					Losing_Item_ID = Item.GetID(Losing_Item)
					_Debug_MessagesInChannel = false
					_Broadcast_YellMessages = false
					_Broadcast_FixedInterval = false
					_Broadcast_UseMessages = true
					_Extra_PingCompensation = 100
					_Inactivity_Detection = false
					Blackjack_Minimum = 5000
					Blackjack_Maximum = 500000
					High_Low_Minimum = 5000
					High_Low_Maximum = 500000
					Odd_Even_Minimum = 5000
					Odd_Even_Maximum = 500000
					First_Second_Last_Minimum = 5000
					First_Second_Last_Maximum = 300000
					Single_Numbers_Minimum = 5000
					Single_Numbers_Maximum = 200000
					
					Highest_Lowest_Rolls = 4
					Highest_Lowest_Minimum = 5000
					Highest_Lowest_Maximum = 500000
					Highest_Lowest_Payout = 80
					
					Sequence_Minimum = 5000
					Sequence_Maximum = 300000
					Sequence_Payout = 180
					
					Pair_Of_Numbers_Minimum = 5000
					Pair_Of_Numbers_Maximum = 200000
					Pair_Of_Numbers_Payout = 360
					
					Sum_Of_Numbers_Minimum = 5000
					Sum_Of_Numbers_Maximum = 200000
					Sum_Of_Numbers_Maximum_Rolls = 10
					Sum_Of_Numbers_Payout = 1000
					
					Beat_That_Minimum = 5000
					Beat_That_Maximum = 200000
					Beat_That_Payout = 360
					
					Last_Bid = os.time()
					HEADS_UP_DISPLAY.LAST_BID.VALUE:SetText('00:00')
					HEADS_UP_DISPLAY.AMOUNT_CASH.DISPLAY_PLATINUM.AMOUNT:SetText('0k')
					HEADS_UP_DISPLAY.BETS.WON.AMOUNT:SetText('0 (0k)')
					Bets.Won.Raw = 0
					Bets.Won.Cash = 0
					HEADS_UP_DISPLAY.BETS.LOST.AMOUNT:SetText('0 (0k)')
					Bets.Lost.Raw = 0
					Bets.Lost.Cash = 0
					HEADS_UP_DISPLAY.BETS.OUTCOME.AMOUNT:SetText('0 (0k)')
					Bets.Outcome.Raw = 0
					Bets.Outcome.Cash = 0
					Total.Items.LastAmountSeen = 0
					Total.Items.Amount = 0
					Total.Items.Value = 0
					channel:SendOrangeMessage('Casino', 'All settings have been reset')
				elseif (execute_cmd == 'help') then
					channel:SendOrangeMessage('', 'Available commands:')
					channel:SendOrangeMessage('', '/help                                                         Show this information')
					channel:SendOrangeMessage('', '/reset                                                       Reset all settings')
					channel:SendOrangeMessage('', '/start                                                       Start the script')
					channel:SendOrangeMessage('', '/stop                                                         Stop the script')
					channel:SendOrangeMessage('', '/open                                                         Open all containers. Use only for testing purposes')
					channel:SendOrangeMessage('', '/close                                                        Close all containers. Use only for testing purposes')
					channel:SendOrangeMessage('', '/alwaysactive (true/false)            Search new depot if inactivity period detected')
				else
					channel:SendOrangeMessage('Casino', 'Unknown command. Type /help for a list of available commands')
				end
			else
				channel:SendOrangeMessage('Casino', 'Unknown command. Type /help for a list of available commands')
			end
		end
	end

	function onClose(channel)
		print('Casino: Script channel has been closed')
		Casino_Loaded = false
	end

	CasinoChannel = Channel.Open('Casino', onSpeak, onClose)
	function ProcessDebugMessage(speaker, message)
		if speaker == 'Casino Debugger' then
			if _Debug_MessagesInChannel then
				CasinoChannel:SendOrangeMessage(speaker, message)
			end
		else
			CasinoChannel:SendOrangeMessage(speaker, message)
		end
		if _Debug_UseLog and Casino_LogFile then
			Casino_LogFile:write(os.date()..' '..message..'\n')
			Casino_LogFile:flush()
		end
	end
	ProcessDebugMessage('Casino', 'Welcome to the Casino channel! Type /help for a list of available commands')
	ProcessDebugMessage('Casino', 'Loading script...')
	DEVELOPER_HEADER = HUD(10, 20, '. : : '..Script_Information.Developer..' '..Script_Information.Name..' : : .', 0, 170, 20)
	USER_HEADER = HUD(10, 40, "XENOBOT USER", 125, 255, 140)
	USER_NAME = HUD(140, 40, getUserName():titlecase(), 255, 255, 255)
	STATS_HEADER = HUD(10, 60, STATISTICS, 125, 255, 140)
	if _Effects_Interval < 1 or _Effects_Interval > 60 then
		_Effects_Interval = 1
		ProcessDebugMessage('Casino', 'Invalid value. The effects interval has been reset to '.._Effects_Interval..' second')
	end
	if _Broadcast_Interval < 3 or _Broadcast_Interval > 15*60 then
		_Broadcast_Interval = 60
		ProcessDebugMessage('Casino', 'Invalid value. Broadcast time has been reset to '.._Broadcast_Interval..' seconds')
	end
	if Highest_Lowest then
		if Highest_Lowest_Minimum < 100 or Highest_Lowest_Minimum > 200000 then
			Highest_Lowest_Minimum = 5000
			ProcessDebugMessage('Casino', 'Invalid value. Highest/Lowest minimum cash accepted has been reset to '..Highest_Lowest_Minimum..' ('..(Highest_Lowest_Minimum/1000)..'k)')
		end
		if Highest_Lowest_Maximum < Highest_Lowest_Minimum or Highest_Lowest_Maximum > 500000 then
			Highest_Lowest_Maximum = 500000
			ProcessDebugMessage('Casino', 'Invalid value. Highest/Lowest maximum cash accepted has been reset to '..Highest_Lowest_Maximum..' ('..(Highest_Lowest_Maximum/1000)..'k)')
		end
	end
	if (Highest_Lowest_Rolls % 2) ~= 0 then
		Highest_Lowest_Rolls = 4
		ProcessDebugMessage('Casino', 'Invalid value. Highest/Lowest number of rolls has to be an even number. The value has been reset to '..Highest_Lowest_Rolls)
	end
	if Sequence then
		if Sequence_Minimum < 100 or Sequence_Minimum > 300000 then
			Sequence_Minimum = 5000
			ProcessDebugMessage('Casino', 'Invalid value. Sequence minimum cash accepted has been reset to '..Sequence_Minimum..' ('..(Sequence_Minimum/1000)..'k)')
		end
		if Sequence_Maximum < Sequence_Minimum or Sequence_Maximum > 300000 then
			Sequence_Maximum = 300000
			ProcessDebugMessage('Casino', 'Invalid value. Sequence maximum cash accepted has been reset to '..Sequence_Maximum..' ('..(Sequence_Maximum/1000)..'k)')
		end
	end
	if Pair_Of_Numbers then
		if Pair_Of_Numbers_Minimum < 100 or Pair_Of_Numbers_Minimum > 300000 then
			Pair_Of_Numbers_Minimum = 5000
			ProcessDebugMessage('Casino', 'Invalid value. Pair Of Numbers minimum cash accepted has been reset to '..Pair_Of_Numbers_Minimum..' ('..(Pair_Of_Numbers_Minimum/1000)..'k)')
		end
		if Pair_Of_Numbers_Maximum < Pair_Of_Numbers_Minimum or Pair_Of_Numbers_Maximum > 300000 then
			Pair_Of_Numbers_Maximum = 300000
			ProcessDebugMessage('Casino', 'Invalid value. Pair Of Numbers maximum cash accepted has been reset to '..Pair_Of_Numbers_Maximum..' ('..(Pair_Of_Numbers_Maximum/1000)..'k)')
		end
	end
	if Sum_Of_Numbers then
		if Sum_Of_Numbers_Minimum < 100 or Sum_Of_Numbers_Minimum > 100000 then
			Sum_Of_Numbers_Minimum = 5000
			ProcessDebugMessage('Casino', 'Invalid value. Sum Of Numbers minimum cash accepted has been reset to '..Sum_Of_Numbers_Minimum..' ('..(Sum_Of_Numbers_Minimum/1000)..'k)')
		end
		if Sum_Of_Numbers_Maximum < Sum_Of_Numbers_Minimum or Sum_Of_Numbers_Maximum > 100000 then
			Sum_Of_Numbers_Maximum = 100000
			ProcessDebugMessage('Casino', 'Invalid value. Sum Of Numbers maximum cash accepted has been reset to '..Sum_Of_Numbers_Maximum..' ('..(Sum_Of_Numbers_Maximum/1000)..'k)')
		end
	end
	if Beat_That then
		if Beat_That_Minimum < 100 or Beat_That_Minimum > 200000 then
			Beat_That_Minimum = 5000
			ProcessDebugMessage('Casino', 'Invalid value. Beat That minimum cash accepted has been reset to '..Beat_That_Minimum..' ('..(Beat_That_Minimum/1000)..'k)')
		end
		if Beat_That_Maximum < Beat_That_Minimum or Beat_That_Maximum > 200000 then
			Beat_That_Maximum = 200000
			ProcessDebugMessage('Casino', 'Invalid value. Beat That maximum cash accepted has been reset to '..Beat_That_Maximum..' ('..(Beat_That_Maximum/1000)..'k)')
		end
	end
	if Blackjack then
		if Blackjack_Minimum < 100 or Blackjack_Minimum > 200000 then
			Blackjack_Minimum = 5000
			ProcessDebugMessage('Casino', 'Invalid value. Blackjack minimum cash accepted has been reset to '..Blackjack_Minimum..' ('..(Blackjack_Minimum/1000)..'k)')
		end
		if Blackjack_Maximum < Blackjack_Minimum or Blackjack_Maximum > 500000 then
			Blackjack_Maximum = 500000
			ProcessDebugMessage('Casino', 'Invalid value. Blackjack maximum cash accepted has been reset to '..Blackjack_Maximum..' ('..(Blackjack_Maximum/1000)..'k)')
		end
	end
	if High_Low then
		if High_Low_Minimum < 100 or High_Low_Minimum > 1000000 then
			High_Low_Minimum = 5000
			ProcessDebugMessage('Casino', 'Invalid value. High/Low minimum cash accepted has been reset to '..High_Low_Minimum..' ('..(High_Low_Minimum/1000)..'k)')
		end
		if High_Low_Maximum < High_Low_Minimum or High_Low_Maximum > 1000000 then
			High_Low_Maximum = 500000
			ProcessDebugMessage('Casino', 'Invalid value. High/Low maximum cash accepted has been reset to '..High_Low_Maximum..' ('..(High_Low_Maximum/1000)..'k)')
		end
	end
	if Odd_Even then
		if Odd_Even_Minimum < 100 or Odd_Even_Minimum > 1000000 then
			Odd_Even_Minimum = 5000
			ProcessDebugMessage('Casino', 'Invalid value. Odd/Even minimum cash accepted has been reset to '..Odd_Even_Minimum..' ('..(Odd_Even_Minimum/1000)..'k)')
		end
		if Odd_Even_Maximum < Odd_Even_Minimum or Odd_Even_Maximum > 1000000 then
			Odd_Even_Maximum = 500000
			ProcessDebugMessage('Casino', 'Invalid value. Odd/Even maximum cash accepted has been reset to '..Odd_Even_Maximum..' ('..(Odd_Even_Maximum/1000)..'k)')
		end
	end
	if First_Second_Last then
		if First_Second_Last_Minimum < 100 or First_Second_Last_Minimum > 200000 then
			First_Second_Last_Minimum = 5000
			ProcessDebugMessage('Casino', 'Invalid value. First/Second/Last minimum cash accepted has been reset to '..First_Second_Last_Minimum..' ('..(First_Second_Last_Minimum/1000)..'k)')
		end
		if First_Second_Last_Maximum < First_Second_Last_Minimum or First_Second_Last_Maximum > 300000 then
			First_Second_Last_Maximum = 300000
			ProcessDebugMessage('Casino', 'Invalid value. First/Second/Last maximum cash accepted has been reset to '..First_Second_Last_Maximum..' ('..(First_Second_Last_Maximum/1000)..'k)')
		end
	end
	if Single_Numbers then
		if Single_Numbers_Minimum < 100 or Single_Numbers_Minimum > 200000 then
			Single_Numbers_Minimum = 5000
			ProcessDebugMessage('Casino', 'Invalid value. Single Numbers minimum cash accepted has been reset to '..Single_Numbers_Minimum..' ('..(Single_Numbers_Minimum/1000)..'k)')
		end
		if Single_Numbers_Maximum < Single_Numbers_Minimum or Single_Numbers_Maximum > 200000 then
			Single_Numbers_Maximum = 200000
			ProcessDebugMessage('Casino', 'Invalid value. Single Numbers maximum cash accepted has been reset to '..Single_Numbers_Maximum..' ('..(Single_Numbers_Maximum/1000)..'k)')
		end
	end
	if _Extra_PingCompensation < 0 or _Extra_PingCompensation > 1000 then
		_Extra_PingCompensation = 100
		ProcessDebugMessage('Casino', 'Invalid value. Ping compensation has been reset to '.._Extra_PingCompensation)
	end
	if _Inactivity_Interval < 0 or _Inactivity_Interval > 15 then
		_Inactivity_Interval = 5
		ProcessDebugMessage('Casino', 'Invalid value. Minutes inactive has been reset to '.._Inactivity_Interval)
	end
	if Blackjack_Payout < 1 or Blackjack_Payout > 100 then
		Blackjack_Payout = 80
		ProcessDebugMessage('Casino', 'Invalid value. Blackjack payout has been reset to '..Blackjack_Payout..'%')
	end
	if High_Low_Payout < 1 or High_Low_Payout > 100 then
		High_Low_Payout = 80
		ProcessDebugMessage('Casino', 'Invalid value. High/Low payout percent has been reset to '..High_Low_Payout..'%')
	end
	if Odd_Even_Payout < 1 or Odd_Even_Payout > 100 then
		Odd_Even_Payout = 80
		ProcessDebugMessage('Casino', 'Invalid value. Odd/Even payout percent has been reset to '..Odd_Even_Payout..'%')
	end
	if First_Second_Last_Payout < 1 or First_Second_Last_Payout > 300 then
		First_Second_Last_Payout = 180
		ProcessDebugMessage('Casino', 'Invalid value. Two digits payout percent has been reset to '..First_Second_Last_Payout..'%')
	end
	if Highest_Lowest_Payout < 1 or Highest_Lowest_Payout > 100 then
		Highest_Lowest_Payout = 80
		ProcessDebugMessage('Casino', 'Invalid value. Highest/Lowest payout percent has been reset to '..Highest_Lowest_Payout..'%')
	end
	if Sequence_Payout < 1 or Sequence_Payout > 300 then
		Sequence_Payout = 180
		ProcessDebugMessage('Casino', 'Invalid value. Sequence payout percent has been reset to '..Sequence_Payout..'%')
	end
	if Pair_Of_Numbers_Payout < 1 or Pair_Of_Numbers_Payout > 300 then
		Pair_Of_Numbers_Payout = 180
		ProcessDebugMessage('Casino', 'Invalid value. Pair Of Numbers payout percent has been reset to '..Pair_Of_Numbers_Payout..'%')
	end
	if Sum_Of_Numbers_Payout < 1 or Sum_Of_Numbers_Payout > 1000 then
		Sum_Of_Numbers_Payout = 1000
		ProcessDebugMessage('Casino', 'Invalid value. Sum Of Numbers payout percent has been reset to '..Sum_Of_Numbers_Payout..'%')
	end
	if Beat_That_Payout < 1 or Beat_That_Payout > 500 then
		Beat_That_Payout = 360
		ProcessDebugMessage('Casino', 'Invalid value. Beat That payout percent has been reset to '..Beat_That_Payout..'%')
	end
	if Single_Numbers_Payout < 1 or Single_Numbers_Payout > 500 then
		Single_Numbers_Payout = 360
		ProcessDebugMessage('Casino', 'Invalid value. Single digits payout percent has been reset to '..Single_Numbers_Payout..'%')
	end
	Casino_LogFile = nil
	if _Debug_UseLog then
		Casino_LogFile = io.open('..\\Log\\Casino Log ['..Self.Name()..'].txt', 'a+')
	end
	Casino_StatisticsFile = nil
	if _Statistics_UseLog then
		Casino_StatisticsFile = io.open('..\\Log\\Casino Stats ['..Self.Name()..'].txt', 'a+')
		Casino_StatisticsFile:write('Date,Rolls,Won,Lost,Outcome,Player,Option,Rolled,Amount,Payout\n')
		Casino_StatisticsFile:flush()
	end
	HEADS_UP_DISPLAY =
	{
		AMOUNT_CASH =
		{
			DISPLAY_CRYSTAL =
			{
				TEXT = HUD(10, 80, 'Crystal Coins', 200, 200, 200),
				AMOUNT = HUD(140, 80, '0k', 255, 255, 255)
			},
			DISPLAY_PLATINUM =
			{
				TEXT = HUD(10, 96, 'Platinum Coins', 200, 200, 200),
				AMOUNT = HUD(140, 96, '0k', 255, 255, 255)
			}
		},
		AMOUNT_ITEMS =
		{
			DISPLAY_ITEM =
			{
				TEXT = HUD(10, 112, 'Items', 200, 200, 200),
				AMOUNT = HUD(140, 112, '0 (0k)', 255, 255, 255),
			}
		},
		BETS =
		{
			WON =
			{
				TEXT = HUD(10, 128, 'Bets Won', 200, 200, 200),
				AMOUNT = HUD(140, 128, '0 (0k)', 255, 255, 255),
				AMOUNT_CASH = 0
			},
			LOST =
			{
				TEXT = HUD(10, 144, 'Bets Lost', 200, 200, 200),
				AMOUNT = HUD(140, 144, '0 (0k)', 255, 255, 255),
				AMOUNT_CASH = 0
			},
			OUTCOME =
			{
				TEXT = HUD(10, 160, 'OUTCOME', 255, 216, 0),
				AMOUNT = HUD(140, 160, '0 (0k)', 255, 255, 255),
			}
		},
		INFORMATION_HEADER = HUD(10, 180, 'INFORMATION', 125, 255, 140),
		LAST_BID =
		{
			TEXT = HUD(10, 200, 'Last Bid', 200, 200, 200),
			VALUE = HUD(140, 200, '00:00:00', 255, 255, 255)
		},
		SERVER_SAVE =
		{
			TEXT = HUD(10, 216, 'Next Server Save', 200, 200, 200),
			VALUE = HUD(140, 216, '00:00:00', 255, 255, 255)
		},
		TIME_RUNNING =
		{
			TEXT = HUD(10, 232, 'Time Running', 200, 200, 200),
			VALUE = HUD(140, 232, '00:00:00', 255, 255, 255)
		}
	}
	Containers =
	{
		Counter = nil,
		Locker = nil,
		Depot = nil,
		Items = nil,
		Check = nil,
		Crystal = {},
		Platinum = {},
	}
	Coordinates =
	{
		Locker = { x = 0, y = 0, z = 0 },
		Player = { x = 0, y = 0, z = 0 },
		Counter = { x = 0, y = 0, z = 0 },
		Adjacent_Locker = { x = 0, y = 0, z = 0 },
	}
	Last_Amount =
	{
		Crystal = 0,
		Platinum = 0,
		Items = 0
	}
	Total =
	{
		Items =
		{
			LastAmountSeen = 0,
			Amount = 0,
			Value = 0
		}
	}
	Bets =
	{
		Won =
		{
			Raw = 0,
			Cash = 0
		},
		Lost =
		{
			Raw = 0,
			Cash = 0
		},
		Outcome =
		{
			Raw = 0,
			Cash = 0
		}
	}
	Gambling_Depots =
	{
		Yalahar =
		{
			{
				Name = 'Spot1',
				HouseSwitch = {32793,31251,7},
				HouseDepot = {32793,31252,7},
				PlayerSwitch = {32795,31251,7},
				PlayerDepot = {32795,31252,7},
				Counter = {32794,31252,7}
			},
			{
				Name = 'Spot2',
				HouseSwitch = {32793,31244,7},
				HouseDepot = {32793,31243,7},
				PlayerSwitch = {32795,31244,7},
				PlayerDepot = {32795,31243,7},
				Counter = {32794,31243,7}
			},
			{
				Name = 'Spot3',
				HouseSwitch = {32789,31251,7},
				HouseDepot = {32789,31252,7},
				PlayerSwitch = {32791,31251,7},
				PlayerDepot = {32791,31252,7},
				Counter = {32790,31252,7}
			},
			{
				Name = 'Spot4',
				HouseSwitch = {32789,31244,7},
				HouseDepot = {32789,31243,7},
				PlayerSwitch = {32791,31244,7},
				PlayerDepot = {32791,31243,7},
				Counter = {32790,31243,7}
			},
			{
				Name = 'Spot5',
				HouseSwitch = {32785,31251,7},
				HouseDepot = {32785,31252,7},
				PlayerSwitch = {32787,31251,7},
				PlayerDepot = {32787,31252,7},
				Counter = {32786,31252,7}
			},
			{
				Name = 'Spot6',
				HouseSwitch = {32785,31244,7},
				HouseDepot = {32785,31243,7},
				PlayerSwitch = {32787,31244,7},
				PlayerDepot = {32787,31243,7},
				Counter = {32786,31243,7}
			},
			{
				Name = 'Spot7',
				HouseSwitch = {32781,31251,7},
				HouseDepot = {32781,31252,7},
				PlayerSwitch = {32783,31251,7},
				PlayerDepot = {32783,31252,7},
				Counter = {32782,31252,7}
			},
			{
				Name = 'Spot8',
				HouseSwitch = {32781,31244,7},
				HouseDepot = {32781,31243,7},
				PlayerSwitch = {32783,31244,7},
				PlayerDepot = {32783,31243,7},
				Counter = {32782,31243,7}
			},
			{
				Name = 'Spot9',
				HouseSwitch = {32793,31251,6},
				HouseDepot = {32793,31252,6},
				PlayerSwitch = {32795,31251,6},
				PlayerDepot = {32795,31252,6},
				Counter = {32794,31252,6}
			},
			{
				Name = 'Spot10',
				HouseSwitch = {32793,31244,6},
				HouseDepot = {32793,31243,6},
				PlayerSwitch = {32795,31244,6},
				PlayerDepot = {32795,31243,6},
				Counter = {32794,31243,6}
			},
			{
				Name = 'Spot11',
				HouseSwitch = {32789,31251,6},
				HouseDepot = {32789,31252,6},
				PlayerSwitch = {32791,31251,6},
				PlayerDepot = {32791,31252,6},
				Counter = {32790,31252,6}
			},
			{
				Name = 'Spot12',
				HouseSwitch = {32789,31244,6},
				HouseDepot = {32789,31243,6},
				PlayerSwitch = {32791,31244,6},
				PlayerDepot = {32791,31243,6},
				Counter = {32790,31243,6}
			},
			{
				Name = 'Spot13',
				HouseSwitch = {32785,31251,6},
				HouseDepot = {32785,31252,6},
				PlayerSwitch = {32787,31251,6},
				PlayerDepot = {32787,31252,6},
				Counter = {32786,31252,6}
			},
			{
				Name = 'Spot14',
				HouseSwitch = {32785,31244,6},
				HouseDepot = {32785,31243,6},
				PlayerSwitch = {32787,31244,6},
				PlayerDepot = {32787,31243,6},
				Counter = {32786,31243,6}
			},
			{
				Name = 'Spot15',
				HouseSwitch = {32781,31251,6},
				HouseDepot = {32781,31252,6},
				PlayerSwitch = {32783,31251,6},
				PlayerDepot = {32783,31252,6},
				Counter = {32782,31252,6}
			},
			{
				Name = 'Spot16',
				HouseSwitch = {32781,31244,6},
				HouseDepot = {32781,31243,6},
				PlayerSwitch = {32783,31244,6},
				PlayerDepot = {32783,31243,6},
				Counter = {32782,31243,6}
			},
		},
		Thais =
		{
			{
				Name = 'Spot17',
				HouseSwitch = {32352,32226,7},
				HouseDepot = {32352,32225,7},
				PlayerSwitch = {32354,32226,7},
				PlayerDepot = {32354,32225,7},
				Counter = {32353,32225,7}
			},
			{
				Name = 'Spot18',
				HouseSwitch = {32352,32230,7},
				HouseDepot = {32352,32231,7},
				PlayerSwitch = {32354,32230,7},
				PlayerDepot = {32354,32231,7},
				Counter = {32353,32231,7}
			},
			{
				Name = 'Spot19',
				HouseSwitch = {32352,32226,6},
				HouseDepot = {32352,32225,6},
				PlayerSwitch = {32354,32226,6},
				PlayerDepot = {32354,32225,6},
				Counter = {32353,32225,6}
			},
			{
				Name = 'Spot20',
				HouseSwitch = {32352,32230,6},
				HouseDepot = {32352,32231,6},
				PlayerSwitch = {32354,32230,6},
				PlayerDepot = {32354,32231,6},
				Counter = {32353,32231,6}
			},
			{
				Name = 'Spot21',
				HouseSwitch = {32344,32226,6},
				HouseDepot = {32344,32225,6},
				PlayerSwitch = {32346,32226,6},
				PlayerDepot = {32346,32225,6},
				Counter = {32345,32225,6}
			},
			{
				Name = 'Spot22',
				HouseSwitch = {32344,32230,6},
				HouseDepot = {32344,32231,6},
				PlayerSwitch = {32346,32230,6},
				PlayerDepot = {32346,32231,6},
				Counter = {32345,32231,6}
			},
			{
				Name = 'Spot23',
				HouseSwitch = {32348,32219,6},
				HouseDepot = {32348,32218,6},
				PlayerSwitch = {32350,32219,6},
				PlayerDepot = {32350,32218,6},
				Counter = {32349,32218,6}
			},
			{
				Name = 'Spot24',
				HouseSwitch = {32344,32219,6},
				HouseDepot = {32344,32218,6},
				PlayerSwitch = {32346,32219,6},
				PlayerDepot = {32346,32218,6},
				Counter = {32345,32218,6}
			},
			{
				Name = 'Spot25',
				HouseSwitch = {32352,32226,5},
				HouseDepot = {32352,32225,5},
				PlayerSwitch = {32354,32226,5},
				PlayerDepot = {32354,32225,5},
				Counter = {32353,32225,5}
			},
			{
				Name = 'Spot26',
				HouseSwitch = {32352,32230,5},
				HouseDepot = {32352,32231,5},
				PlayerSwitch = {32354,32230,5},
				PlayerDepot = {32354,32231,5},
				Counter = {32353,32231,5}
			},
			{
				Name = 'Spot27',
				HouseSwitch = {32344,32226,5},
				HouseDepot = {32344,32225,5},
				PlayerSwitch = {32346,32226,5},
				PlayerDepot = {32346,32225,5},
				Counter = {32345,32225,5}
			},
			{
				Name = 'Spot28',
				HouseSwitch = {32344,32230,5},
				HouseDepot = {32344,32231,5},
				PlayerSwitch = {32346,32230,5},
				PlayerDepot = {32346,32231,5},
				Counter = {32345,32231,5}
			},
			{
				Name = 'Spot29',
				HouseSwitch = {32348,32219,5},
				HouseDepot = {32348,32218,5},
				PlayerSwitch = {32350,32219,5},
				PlayerDepot = {32350,32218,5},
				Counter = {32349,32218,5}
			},
			{
				Name = 'Spot30',
				HouseSwitch = {32344,32219,5},
				HouseDepot = {32344,32218,5},
				PlayerSwitch = {32346,32219,5},
				PlayerDepot = {32346,32218,5},
				Counter = {32345,32218,5}
			},
		},
		Venore =
		{
			{
				Name = 'Spot31',
				HouseSwitch = {32920,32069,7},
				HouseDepot = {32920,32068,7},
				PlayerSwitch = {32922,32069,7},
				PlayerDepot = {32922,32068,7},
				Counter = {32921,32068,7}
			},
			{
				Name = 'Spot32',
				HouseSwitch = {32915,32069,7},
				HouseDepot = {32915,32068,7},
				PlayerSwitch = {32917,32069,7},
				PlayerDepot = {32917,32068,7},
				Counter = {32916,32068,7}
			},
			{
				Name = 'Spot33',
				HouseSwitch = {32911,32072,7},
				HouseDepot = {32911,32071,7},
				PlayerSwitch = {32913,32072,7},
				PlayerDepot = {32913,32071,7},
				Counter = {32912,32071,7}
			},
			{
				Name = 'Spot34',
				HouseSwitch = {32924,32072,7},
				HouseDepot = {32924,32071,7},
				PlayerSwitch = {32926,32072,7},
				PlayerDepot = {32926,32071,7},
				Counter = {32925,32071,7}
			},
			{
				Name = 'Spot35',
				HouseSwitch = {32928,32072,7},
				HouseDepot = {32928,32071,7},
				PlayerSwitch = {32930,32072,7},
				PlayerDepot = {32930,32071,7},
				Counter = {32929,32071,7}
			},
			{
				Name = 'Spot36',
				HouseSwitch = {32928,32081,7},
				HouseDepot = {32928,32082,7},
				PlayerSwitch = {32930,32081,7},
				PlayerDepot = {32930,32082,7},
				Counter = {32929,32082,7}
			},
			{
				Name = 'Spot37',
				HouseSwitch = {32924,32081,7},
				HouseDepot = {32924,32082,7},
				PlayerSwitch = {32926,32081,7},
				PlayerDepot = {32926,32082,7},
				Counter = {32925,32082,7}
			},
			{
				Name = 'Spot38',
				HouseSwitch = {32919,32081,7},
				HouseDepot = {32919,32082,7},
				PlayerSwitch = {32921,32081,7},
				PlayerDepot = {32921,32082,7},
				Counter = {32920,32082,7}
			},
			{
				Name = 'Spot39',
				HouseSwitch = {32915,32081,7},
				HouseDepot = {32915,32082,7},
				PlayerSwitch = {32917,32081,7},
				PlayerDepot = {32917,32082,7},
				Counter = {32916,32082,7}
			},
			{
				Name = 'Spot40',
				HouseSwitch = {32910,32081,7},
				HouseDepot = {32910,32082,7},
				PlayerSwitch = {32912,32081,7},
				PlayerDepot = {32912,32082,7},
				Counter = {32911,32082,7}
			},
		}
	}
	Dustbin_Locations =
	{
		{32790,31248,7},
		{32782,31248,7},
		{32790,31248,6},
		{32782,31248,6},
	}
	Time_Now = os.date("*t")
	Server_Save_Hour, Server_Save_Minutes = _Extra_ServerSave:match("(.+):(.+)")
	Server_Save = ((Server_Save_Hour + 0) * 3600) + ((Server_Save_Minutes + 0) * 60)
	if Server_Save <= ((Time_Now.hour * 3600) + (Time_Now.min * 60) + Time_Now.sec) then
		Server_Save_TimeLeft = (Server_Save + 24 * 3600) - ((Time_Now.hour * 3600) + (Time_Now.min * 60) + Time_Now.sec)
	else
		Server_Save_TimeLeft = Server_Save - ((Time_Now.hour * 3600) + (Time_Now.min * 60) + Time_Now.sec)
	end
	Accepted_Items_List = {}
	if Accept_Items then
		for _, item in ipairs(Items_List) do
			local AlreadyExists = false
			local id = Item.GetID(item.Name)
			for _, item_accepted in ipairs(Accepted_Items_List) do
				if item_accepted then
					if item_accepted.ID == id then
						AlreadyExists = true
					end
				end
			end
			if not AlreadyExists then
				if id == 3549 then
					table.insert(Accepted_Items_List, {ID = 6529, Value = item.Value})
				elseif id == 9018 then
					table.insert(Accepted_Items_List, {ID = 9019, Value = item.Value})
				end
				table.insert(Accepted_Items_List, {ID = id, Value = item.Value})
			else
				ProcessDebugMessage('Casino Debugger', 'Skipped item name duplicated in the list: '..item.Name)
			end
		end
	end
	
	for index, name in ipairs(_Remote_AdminName) do
		_Remote_AdminName[index] = name:lower()
	end
	registerEventListener(WALKER_SELECTLABEL, 'onWalkLabel')
	Winning_Item_ID = Item.GetID(Winning_Item)
	Losing_Item_ID = Item.GetID(Losing_Item)
	_Decoration_Item_ID = _Decoration_Enabled and Item.GetID(_Decoration_Item) or 0
	Player_Option = nil
	Player_Balance = 0
	Dustbin_Trash =	{283, 284, 285, 3031, 3492, 3507}
	Dice_IDs = {5792, 5793, 5794, 5795, 5796, 5797}
	Locker_IDs = {3497, 3498, 3499, 3500}
	Money_IDs = {3035, 3043}
	Game_Types =
	{
		Sum =
		{
			Choice = 0
		},
		BeatThat =
		{
			Choice = 0
		}
	}
	CipsoftMembers = {'akananto', 'angarvazar', 'argeia', 'bolfrim', 'bolkar', 'count tofifti', 'craban', 'delany', 'denson larika', 'drudak', 'durin', 'dynacor', 'gandareva', 'isolan', 'karvar', 'knightmare', 'lionet', 'lokana aldora', 'luciumar', 'lyxoph', 'manina', 'master tutor', 'mirade', 'nyrogun', 'penciljack', 'ramrod on aldora', 'rejana', 'sidnia', 'siramal', 'solkrin', 'stephan', 'steve', 'tavaren', 'teyrata', 'tjured', 'ulairi', 'umrath'}
	PybfrPyvrag = false
	Last_Broadcast = os.time()
	Last_Message = os.time()
	Last_Bid = os.time()
	SkipRollingProcess = false
	Player_Detected = false
	Last_Player = nil
	Last_Party_Hat = os.time()
	Last_Activity = os.time()
	Last_Activity_Player_In_Spot = os.time()
	Time_Script_Started = os.time()
	OpeningNestedContainers = false
	GoCheckDown = false
	ManualStop = false
	Casino_Loaded = false
	Processing_Data = false
	Processing_Effect = false
	Take_Cash_Signal = false
	Count_Cash_Signal = false
	Roll_Dice_Signal = false
	EffectProxyMessage = nil
	LocalProxyMessage = nil
	
	Sum_Of_Numbers_In_Progress = false
	Sum_Of_Numbers_Roll_Count = 0
	Sum_Of_Numbers_Sum = 0
	
	Beat_That_In_Progress = false
	Beat_That_Roll_Count = 0
	Beat_That_Sum = 0
	
	Highest_Lowest_In_Progress = false
	Highest_Lowest_Roll_Count = 0
	Highest_Lowest_First_Sum = 0
	Highest_Lowest_Second_Sum = 0
	
	Sequence_In_Progress = false
	Sequence_Roll_Count = 0
	Sequence_Count = 0
	
	Blackjack_In_Progress = false
	Blackjack_Roll_Count = 0
	Blackjack_Player_Count = 0
	Blackjack_Dealer_Count = 0
	
	Pay_Cash_Signal = 0
	Play_Instrument_Signal = 0
	Authenticate_Cash_Check = 0
	Dice_Rolled_Check = 0
	Winning_Item_Check = 0
	Losing_Item_Check = 0
	Payment_Give_Signal = false
	Payment_Given_Check =
	{
		Crystal = 0,
		Crystal_Amount = 0,
		Platinum = 0,
		Platinum_Amount = 0
	}
	
	function ResetValues()
		Play_Instrument_Signal = 0
		Processing_Data = false
		Player_Option = nil
		Last_Activity = os.time()
		Last_Bid = os.time()
		
		Blackjack_In_Progress = false
		Blackjack_Player_Count = 0
		Blackjack_Dealer_Count = 0
		
		Game_Types.Sum.Choice = 0
		Sum_Of_Numbers_In_Progress = false
		Sum_Of_Numbers_Roll_Count = 0
		Sum_Of_Numbers_Sum = 0
		
		Game_Types.BeatThat.Choice = 0
		Beat_That_In_Progress = false
		Beat_That_Roll_Count = 0
		Beat_That_Sum = 0
		
		Highest_Lowest_In_Progress = false
		Highest_Lowest_Roll_Count = 0
		Highest_Lowest_First_Sum = 0
		Highest_Lowest_Second_Sum = 0
		
		Sequence_In_Progress = false
		Sequence_Roll_Count = 0
		Sequence_Count = 0
	end
	
	function WorkloadExecutionInterval()
		if _Extra_WorkloadExecution == 'fast' then
			return 1
		elseif _Extra_WorkloadExecution == 'medium' then
			return 4
		elseif _Extra_WorkloadExecution == 'slow' then
			return 8
		else
			return 2
		end
	end
	
	function ripairs(t)
		local max = 1
		while t[max] do
			max = max + 1
		end
		local function ripairs_it(t, i)
			i = i-1
			local v = t[i]
			if v then
				return i,v
			else
				return nil
			end
		end
		return ripairs_it, t, max
	end
	
	function SendMessage(player, text, yell)
		if _Interactive_Messages then
			if os.difftime(os.time(), Last_Message) >= 2 then
				if _Interaction_PrivateMessages then
					SendPrivateMessage(text, player, true)
					ProcessDebugMessage('Casino Debugger', 'Send private message to '..player..': "'..text..'"')
				else
					if yell then
						Self.Yell(text)
					else
						Self.Say(text)
					end
					ProcessDebugMessage('Casino Debugger', 'Send message: "'..text..'"')
				end
				Last_Message = os.time()
			end
		end
	end
	
	function SendPrivateMessage(text, player, display)
		if os.difftime(os.time(), Last_Message) >= 2 then
			Self.PrivateMessage(player, text)
			if display then
				ProcessDebugMessage('Casino', 'Send private message to '..player..': "'..text..'"')
			end
			Last_Message = os.time()
		end
	end
	
	function CheckAvailableDepots()
		local AvailableDepots = {}
		local posx, posy, posz = Self.Position().x, Self.Position().y, Self.Position().z
		for _, spot in ipairs(Gambling_Depots.Yalahar) do
			if spot["HouseSwitch"][3] == Self.Position().z then
				local xDistHouse, xDistPlayer = math.abs(spot["HouseSwitch"][1] - posx), math.abs(spot["PlayerSwitch"][1] - posx)
				local yDistHouse, yDistPlayer = math.abs(spot["HouseSwitch"][2] - posy), math.abs(spot["PlayerSwitch"][2] - posy)
				if xDistHouse <= 7 and xDistPlayer <= 7 then
					if yDistHouse <= 5 and yDistPlayer <= 5 then
						local addSpot = true
						for _, creature in Creature.iPlayers() do
							if (creature:Position().x == spot["HouseSwitch"][1] and creature:Position().y == spot["HouseSwitch"][2] and creature:Position().z == posz) or
								(creature:Position().x == spot["PlayerSwitch"][1] and creature:Position().y == spot["PlayerSwitch"][2] and creature:Position().z == posz) then
								addSpot = false
								break
							end
						end
						if addSpot then
							table.insert(AvailableDepots, spot)
						end
					end
				end
			end
		end
		ProcessDebugMessage('Casino Debugger', 'The script found '..#AvailableDepots..' available depots')
		return AvailableDepots
	end
	
	function UpdateCoordinates()
		local posx, posy, posz = Self.Position().x, Self.Position().y, Self.Position().z
		local spot = nil
		if not spot then
			for _, gamblingSpot in ipairs(Gambling_Depots.Yalahar) do
				if posx == gamblingSpot["HouseSwitch"][1] and posy == gamblingSpot["HouseSwitch"][2] and posz == gamblingSpot["HouseSwitch"][3] then
					spot = gamblingSpot
					break
				end
			end
		end
		if not spot then
			for _, gamblingSpot in ipairs(Gambling_Depots.Thais) do
				if posx == gamblingSpot["HouseSwitch"][1] and posy == gamblingSpot["HouseSwitch"][2] and posz == gamblingSpot["HouseSwitch"][3] then
					spot = gamblingSpot
					break
				end
			end
		end
		if not spot then
			for _, gamblingSpot in ipairs(Gambling_Depots.Venore) do
				if posx == gamblingSpot["HouseSwitch"][1] and posy == gamblingSpot["HouseSwitch"][2] and posz == gamblingSpot["HouseSwitch"][3] then
					spot = gamblingSpot
					break
				end
			end
		end
		if spot then
			Coordinates.Locker.x, Coordinates.Locker.y, Coordinates.Locker.z = spot["HouseDepot"][1], spot["HouseDepot"][2], spot["HouseDepot"][3]
			Coordinates.Player.x, Coordinates.Player.y, Coordinates.Player.z = spot["PlayerSwitch"][1], spot["PlayerSwitch"][2], spot["PlayerSwitch"][3]
			Coordinates.Counter.x, Coordinates.Counter.y, Coordinates.Counter.z = spot["Counter"][1], spot["Counter"][2], spot["Counter"][3]
			Coordinates.Adjacent_Locker.x, Coordinates.Adjacent_Locker.y, Coordinates.Adjacent_Locker.z = spot["PlayerDepot"][1], spot["PlayerDepot"][2], spot["PlayerDepot"][3]
			return true
		end
		return false
	end
	
	function onWalkLabel(labelName)
		local newLocation = false
		
		if (labelName == 'CheckDepotsDown') then
			local AvailableDepots = CheckAvailableDepots()
			if (#AvailableDepots > 0) then
				gotoLabel(AvailableDepots[1]["Name"])
			else
				gotoLabel('StairsUp')
			end
		elseif (labelName == 'CheckDepotsUp') then
			if GoCheckDown then
				gotoLabel('StairsDown')
			else
				local AvailableDepots = CheckAvailableDepots()
				if (#AvailableDepots > 0) then
					gotoLabel(AvailableDepots[1]["Name"])
				else
					gotoLabel('StairsDown')
				end
			end
		elseif (labelName == 'CheckDownstairs') then
			gotoLabel('GroundFloor')
		elseif (labelName == 'CheckUpstairs') then
			gotoLabel('FirstFloor')
		elseif (labelName == 'StairsDown') then
			GoCheckDown = false
		elseif (labelName == 'CheckSpot1') or
				(labelName == 'CheckSpot2') or
				(labelName == 'CheckSpot3') or
				(labelName == 'CheckSpot4') or
				(labelName == 'CheckSpot5') or
				(labelName == 'CheckSpot6') or
				(labelName == 'CheckSpot7') or
				(labelName == 'CheckSpot8') or
				(labelName == 'CheckSpot9') or
				(labelName == 'CheckSpot10') or
				(labelName == 'CheckSpot11') or
				(labelName == 'CheckSpot12') or
				(labelName == 'CheckSpot13') or
				(labelName == 'CheckSpot14') or
				(labelName == 'CheckSpot15') or
				(labelName == 'CheckSpot16') then
				newLocation = UpdateCoordinates()
		end
		if newLocation then
			setWalkerEnabled(false)
			if Open_Containers() then
				CheckDiceAndDecoration()
				Last_Activity = os.time()
				Total.Items.LastAmountSeen = 0
				Total.Items.Amount = 0
				Total.Items.Value = 0
				Casino_Loaded = true
				ProcessDebugMessage('Casino', 'The character has been placed in a new depot')
			end
		end
	end
	
	function Count_Platinum_Extended()
		if #Containers.Platinum > 0 then
			local total = 0
			for _, container in ipairs(Containers.Platinum) do
				total = total + container:CountItemsOfID(3035)
			end
			return total
		end
		return 0
	end
	
	function Count_Crystal_Extended()
		if #Containers.Crystal > 0 then
			local total = 0
			for _, container in ipairs(Containers.Crystal) do
				total = total + container:CountItemsOfID(3043)
			end
			return total
		end
		return 0
	end

	function Count_Extended(container, IDs)
		if container then
			local tempTotal = 0
			for _, itemID in ipairs(IDs) do
				tempTotal = tempTotal + container:CountItemsOfID(itemID)
			end
			return tempTotal
		end
		return 0
	end

	function CheckDiceAndDecoration()
		PickUpDiceAndDecoration()
		if _Decoration_Enabled then
			if _Decoration_Item_ID > 0 then
				if Count_Extended(Containers.Depot, {_Decoration_Item_ID}) > 0 then
					for itemDepotChest = Containers.Depot:ItemCount() - 1, 0, -1 do
						local tempItemDepotChest = Containers.Depot:GetItemData(itemDepotChest)
						if _Decoration_Item_ID == tempItemDepotChest.id then
							while Containers.Depot:MoveItemToGround(itemDepotChest, Coordinates.Locker.x, Coordinates.Locker.y, Coordinates.Locker.z, 1) ~= 1 do end
							wait(1000 + _Extra_PingCompensation)
							break
						end
					end
				end
			end
		end
		if Count_Extended(Containers.Depot, Dice_IDs) > 0 then
			for itemDepotChest = Containers.Depot:ItemCount() - 1, 0, -1 do
				local tempItemDepotChest = Containers.Depot:GetItemData(itemDepotChest)
				if table.contains(Dice_IDs, tempItemDepotChest.id) then
					while Containers.Depot:MoveItemToGround(itemDepotChest, Coordinates.Locker.x, Coordinates.Locker.y, Coordinates.Locker.z, 1) ~= 1 do end
					wait(1000 + _Extra_PingCompensation)
					break
				end
			end
		end
		LocalProxyMessage = nil
		EffectProxyMessage = nil
	end

	function PickUpDiceAndDecoration(container)
		if (Containers.Locker and Containers.Depot) then
			if Count_Extended(Containers.Locker, Dice_IDs) > 0 then
				for itemLocker = Containers.Locker:ItemCount() - 1, 0, -1 do
					if itemLocker > 28 then
						itemLocker = 28
					end
					local tempItemLocker = Containers.Locker:GetItemData(itemLocker)
					if table.contains(Dice_IDs, tempItemLocker.id) then
						while Containers.Locker:MoveItemToContainer(itemLocker, Containers.Depot:Index(), 0) ~= 1 do end
						wait(1000 + _Extra_PingCompensation)
						break
					end
				end
			end
			if _Decoration_Enabled then
				if _Decoration_Item_ID > 0 then
					if Count_Extended(Containers.Locker, {_Decoration_Item_ID}) > 0 then
						for itemLocker = Containers.Locker:ItemCount() - 1, 0, -1 do
							if itemLocker > 28 then
								itemLocker = 28
							end
							local tempItemLocker = Containers.Locker:GetItemData(itemLocker)
							if _Decoration_Item_ID == tempItemLocker.id then
								while Containers.Locker:MoveItemToContainer(itemLocker, Containers.Depot:Index(), 0) ~= 1 do end
								wait(1000 + _Extra_PingCompensation)
								break
							end
						end
					end
				end
			end
		end
	end

	function Open_Containers()
		local tries = 10
		while #Container.GetAll() > 0 do
			for i = 0, 15 do
				closeContainer(i)
			end
		end
		while #Container.GetAll() < 5 or tries > 0 do
			while #Container.GetAll() > 0 do
				for i = 0, 15 do
					closeContainer(i)
				end
			end
			Client.HideEquipment()
			if Self.BrowseField(Coordinates.Counter.x, Coordinates.Counter.y, Coordinates.Counter.z) == 1 then
				wait(500 + _Extra_PingCompensation)
				Containers.Counter = Container(0)
				Containers.Counter:Minimize()
				wait(100)
				Client.HideEquipment()
				ProcessDebugMessage('Casino Debugger', 'Counter browse field opened')
				if Self.BrowseField(Coordinates.Locker.x, Coordinates.Locker.y, Coordinates.Locker.z) == 1 then
					wait(500 + _Extra_PingCompensation)
					Containers.Locker = Container(1)
					Containers.Locker:Minimize()
					wait(100)
					Client.HideEquipment()
					ProcessDebugMessage('Casino Debugger', 'Locker browse field opened')
					if table.contains(Locker_IDs, Containers.Locker:GetItemData(0).id) then
						Containers.Locker:OpenChildren({Containers.Locker:GetItemData(0).id, false})
						wait(500 + _Extra_PingCompensation)
						if Container(2):UseItem(0, true) == 1 then
							local index = 0
							wait(500 + _Extra_PingCompensation)
							Containers.Depot = Container(2)
							Containers.Depot:Minimize()
							wait(100)
							if Accept_Items then
								Client.HideEquipment()
								if Count_Extended(Containers.Depot, {Item.GetID(_Containers_Items)}) > 0 then
									for i = 0, Containers.Depot:ItemCount()-1 do
										local item = Containers.Depot:GetItemData(i)
										if item.id == Item.GetID(_Containers_Items) then
											local opento = Container.GetFreeSlot()
											while (Containers.Depot:UseItem(i) ~= 1) do wait(300 + _Extra_PingCompensation) end
											wait(500 + _Extra_PingCompensation)
											Containers.Items = Container(opento)
											Containers.Items:Minimize()
											wait(100)
											ProcessDebugMessage('Casino Debugger', 'Items container opened')
											break
										end
									end
								else
									ProcessDebugMessage('Casino', 'Error. Items container not found: '.._Containers_Items)
									return false
								end
							end
							Client.HideEquipment()
							index = 1
							if Count_Extended(Containers.Depot, {Item.GetID(_Containers_CrystalCoins)}) > 0 then
								for i = 0, Containers.Depot:ItemCount()-1 do
									if index < 3 then
										local item = Containers.Depot:GetItemData(i)
										if item.id == Item.GetID(_Containers_CrystalCoins) then
											local opento = Container.GetFreeSlot()
											while (Containers.Depot:UseItem(i) ~= 1) do wait(300 + _Extra_PingCompensation) end
											wait(500 + _Extra_PingCompensation)
											Containers.Crystal[index] = Container(opento)
											Containers.Crystal[index]:Minimize()
											wait(100)
											index = index + 1
										end
									else
										break
									end
								end
							else
								ProcessDebugMessage('Casino', 'Error. Crystal coins containers not found: '.._Containers_CrystalCoins)
								return false
							end
							Client.HideEquipment()
							ProcessDebugMessage('Casino Debugger', 'Crystal coins containers opened')
							index = 1
							if Count_Extended(Containers.Depot, {Item.GetID(_Containers_PlatinumCoins)}) > 0 then
								for i = 0, Containers.Depot:ItemCount()-1 do
									if index < 8 then
										local item = Containers.Depot:GetItemData(i)
										if item.id == Item.GetID(_Containers_PlatinumCoins) then
											local opento = Container.GetFreeSlot()
											while (Containers.Depot:UseItem(i) ~= 1) do wait(300 + _Extra_PingCompensation) end
											wait(500 + _Extra_PingCompensation)
											Containers.Platinum[index] = Container(opento)
											Containers.Platinum[index]:Minimize()
											wait(100)
											index = index + 1
										end
									else
										break
									end
								end
							else
								ProcessDebugMessage('Casino', 'Error. Platinum coins container not found: '.._Containers_PlatinumCoins)
								return false
							end
							wait(500 + _Extra_PingCompensation)
							Client.HideEquipment()
							ProcessDebugMessage('Casino Debugger', 'Platinum coins containers opened')
							ProcessDebugMessage('Casino', 'All containers were loaded successfully')
							return true
						end
					end
				end
			end
			tries = tries - 1
		end
		return false
	end
	ProcessDebugMessage('Casino', 'Script loaded successfully')
	Module('PlayerDectectionSystem', function(Mod)
		if Casino_Loaded then
			if not Processing_Data then
				local foundPlayer = false
				for name, creature in Creature.iPlayers(2) do
					if (creature:Position().x == Coordinates.Player.x and creature:Position().y == Coordinates.Player.y and creature:Position().z == Coordinates.Player.z) then
						foundPlayer = true
						if Last_Player ~= creature:Name() then
							Last_Activity_Player_In_Spot = os.time()
							Last_Player = creature:Name()
							SendMessage(Last_Player, Welcome_Messages[math.random(1,#Welcome_Messages)]:gsub('%[player%]', Last_Player), false)
						end
						break
					end
				end
				Player_Detected = foundPlayer
				if Player_Detected then
					creature = Creature(Last_Player)
					if creature then
						if (creature:Position().x < Self.Position().x) then
							if (Self.LookDirection() ~= WEST) then
								Self.Turn(WEST)
							end
						elseif (creature:Position().x > Self.Position().x) then
							if (Self.LookDirection() ~= EAST) then
								Self.Turn(EAST)
							end
						elseif (creature:Position().y < Self.Position().y) then
							if (Self.LookDirection() ~= NORTH) then
								Self.Turn(NORTH)
							end
						elseif (creature:Position().y > Self.Position().y) then
							if (Self.LookDirection() ~= SOUTH) then
								Self.Turn(SOUTH)
							end
						else
							ProcessDebugMessage('Casino Debugger', 'Error. Self character is the potential gambler')
						end
					end
				else
					if Coordinates.Locker.y < Self.Position().y then
						if (Self.LookDirection() ~= SOUTH) then
							Last_Activity_Player_In_Spot = os.time()
							Last_Player = nil
							Self.Turn(SOUTH)
						end
					elseif Coordinates.Locker.y > Self.Position().y then
						if (Self.LookDirection() ~= NORTH) then
							Last_Activity_Player_In_Spot = os.time()
							Last_Player = nil
							Self.Turn(NORTH)
						end
					elseif Coordinates.Locker.x < Self.Position().x then
						if (Self.LookDirection() ~= EAST) then
							Last_Activity_Player_In_Spot = os.time()
							Last_Player = nil
							Self.Turn(EAST)
						end
					elseif Coordinates.Locker.x > Self.Position().x then
						if (Self.LookDirection() ~= WEST) then
							Last_Activity_Player_In_Spot = os.time()
							Last_Player = nil
							Self.Turn(WEST)
						end
					else
						ProcessDebugMessage('Casino Debugger', 'Error. Self character is located on locker')
					end
				end
			end
		end
		Mod:Delay(WorkloadExecutionInterval()*800)
	end)

	Module('AntiTrashSystem', function(Mod)
		if Casino_Loaded then
			if not Processing_Data then
				for itemCounter = Containers.Counter:ItemCount() - 1, 0, -1  do
					if itemCounter > 28 then
						itemCounter = 28
					end
					local tempItemCounter = Containers.Counter:GetItemData(itemCounter)
					if not table.contains(Money_IDs, tempItemCounter.id) then
						local isAcceptedItem = false
						if Accept_Items then
							for _, Accepted_Item in ipairs (Accepted_Items_List) do
								if Accepted_Item.ID == tempItemCounter.id then
									isAcceptedItem = true
									break
								end
							end
						end
						if not isAcceptedItem then
							if not table.contains(Dustbin_Trash, tempItemCounter.id) then
								Containers.Counter:MoveItemToGround(itemCounter, Coordinates.Adjacent_Locker.x, Coordinates.Adjacent_Locker.y, Coordinates.Adjacent_Locker.z, tempItemCounter.count)
								ProcessDebugMessage('Casino Debugger', 'Anti-Trash | ['..tempItemCounter.id..'] '..tempItemCounter.count..' '..Item.GetName(tempItemCounter.id)..' - Counter >> Adjacent Locker ['..Coordinates.Adjacent_Locker.x..', '..Coordinates.Adjacent_Locker.y..', '..Coordinates.Adjacent_Locker.z..']')
								break
							else
								local ClosestDustbin = 20
								local ClosestDustbinLocation = {}
								for _, dustbin in ipairs(Dustbin_Locations) do
									local xDist = math.abs(dustbin[1] - Self.Position().x)
									local yDist = math.abs(dustbin[2] - Self.Position().y)
									if xDist <= 7 and yDist <= 5 and dustbin[3] == Self.Position().z then
										if ClosestDustbin > xDist then
											ClosestDustbin = xDist
											ClosestDustbinLocation = dustbin
										elseif ClosestDustbin > yDist then
											ClosestDustbin = yDist
											ClosestDustbinLocation = dustbin
										end
									end
								end
								if ClosestDustbinLocation and ClosestDustbin < 20 then
									Containers.Counter:MoveItemToGround(itemCounter, ClosestDustbinLocation[1], ClosestDustbinLocation[2], ClosestDustbinLocation[3], tempItemCounter.count)
									ProcessDebugMessage('Casino Debugger', 'Anti-Trash | ['..tempItemCounter.id..'] '..tempItemCounter.count..' '..Item.GetName(tempItemCounter.id)..' - Counter >> Dustbin ['..ClosestDustbinLocation[1]..', '..ClosestDustbinLocation[2]..', '..ClosestDustbinLocation[3]..']')
									break
								else
									Containers.Counter:MoveItemToGround(itemCounter, Coordinates.Adjacent_Locker.x, Coordinates.Adjacent_Locker.y, Coordinates.Adjacent_Locker.z, tempItemCounter.count)
									ProcessDebugMessage('Casino Debugger', 'Anti-Trash | ['..tempItemCounter.id..'] '..tempItemCounter.count..' '..Item.GetName(tempItemCounter.id)..' - Counter >> Adjacent Locker ['..Coordinates.Adjacent_Locker.x..', '..Coordinates.Adjacent_Locker.y..', '..Coordinates.Adjacent_Locker.z..']')
									break
								end
							end
						end
						break
					end
				end
				for itemLocker = Containers.Locker:ItemCount() - 1, 0, -1  do
					if itemLocker > 28 then
						itemLocker = 28
					end
					local tempItemLocker = Containers.Locker:GetItemData(itemLocker)
					if not table.contains(Locker_IDs, tempItemLocker.id) then
						if not table.contains(Money_IDs, tempItemLocker.id) then
							if (_Decoration_Enabled and _Decoration_Item_ID ~= 0 and _Decoration_Item_ID ~= tempItemLocker.id) or
								not _Decoration_Enabled or
								_Decoration_Item_ID == 0 or
								(_Decoration_Enabled and _Decoration_Item_ID ~= 0 and Count_Extended(Containers.Locker, {_Decoration_Item_ID}) > 1) then
								if not table.contains(Dice_IDs, tempItemLocker.id) then
									if not table.contains(Dustbin_Trash, tempItemLocker.id) then
										if (_Decoration_Item_ID == tempItemLocker.id) then
											Containers.Locker:MoveItemToGround(itemLocker, Coordinates.Adjacent_Locker.x, Coordinates.Adjacent_Locker.y, Coordinates.Adjacent_Locker.z, tempItemLocker.count-1)
										else
											Containers.Locker:MoveItemToGround(itemLocker, Coordinates.Adjacent_Locker.x, Coordinates.Adjacent_Locker.y, Coordinates.Adjacent_Locker.z, tempItemLocker.count)
										end
										ProcessDebugMessage('Casino Debugger', 'Anti-Trash | ['..tempItemLocker.id..'] '..tempItemLocker.count..' '..Item.GetName(tempItemLocker.id)..' - Locker >> Adjacent Locker ['..Coordinates.Adjacent_Locker.x..', '..Coordinates.Adjacent_Locker.y..', '..Coordinates.Adjacent_Locker.z..']')
										break
									else
										local ClosestDustbin = 20
										local ClosestDustbinLocation = {}
										for _, dustbin in ipairs(Dustbin_Locations) do
											local xDist = math.abs(dustbin[1] - Self.Position().x)
											local yDist = math.abs(dustbin[2] - Self.Position().y)
											if xDist <= 7 and yDist <= 5 and dustbin[3] == Self.Position().z then
												if ClosestDustbin > xDist then
													ClosestDustbin = xDist
													ClosestDustbinLocation = dustbin
												elseif ClosestDustbin > yDist then
													ClosestDustbin = yDist
													ClosestDustbinLocation = dustbin
												end
											end
										end
										if ClosestDustbinLocation and ClosestDustbin < 20 then
											if (_Decoration_Item_ID == tempItemLocker.id) then
												Containers.Locker:MoveItemToGround(itemLocker, ClosestDustbinLocation[1], ClosestDustbinLocation[2], ClosestDustbinLocation[3], tempItemLocker.count-1)
											else
												Containers.Locker:MoveItemToGround(itemLocker, ClosestDustbinLocation[1], ClosestDustbinLocation[2], ClosestDustbinLocation[3], tempItemLocker.count)
											end
											ProcessDebugMessage('Casino Debugger', 'Anti-Trash | ['..tempItemLocker.id..'] '..tempItemLocker.count..' '..Item.GetName(tempItemLocker.id)..' - Locker >> Dustbin ['..ClosestDustbinLocation[1]..', '..ClosestDustbinLocation[2]..', '..ClosestDustbinLocation[3]..']')
											break
										else
											if (_Decoration_Item_ID == tempItemLocker.id) then
												Containers.Locker:MoveItemToGround(itemLocker, Coordinates.Adjacent_Locker.x, Coordinates.Adjacent_Locker.y, Coordinates.Adjacent_Locker.z, tempItemLocker.count-1)
											else
												Containers.Locker:MoveItemToGround(itemLocker, Coordinates.Adjacent_Locker.x, Coordinates.Adjacent_Locker.y, Coordinates.Adjacent_Locker.z, tempItemLocker.count)
											end
											ProcessDebugMessage('Casino Debugger', 'Anti-Trash | ['..tempItemLocker.id..'] '..tempItemLocker.count..' '..Item.GetName(tempItemLocker.id)..' - Locker >> Adjacent Locker ['..Coordinates.Adjacent_Locker.x..', '..Coordinates.Adjacent_Locker.y..', '..Coordinates.Adjacent_Locker.z..']')
											break
										end
									end
								else
									if Count_Extended(Containers.Locker, Dice_IDs) > 1 then
										if Containers.Items and Accept_Items then
											Containers.Locker:MoveItemToContainer(itemLocker,Containers.Items:Index(),Containers.Items:ItemCapacity()-1, 1)
											ProcessDebugMessage('Casino Debugger', 'Anti-Trash | ['..tempItemLocker.id..'] '..tempItemLocker.count..' '..Item.GetName(tempItemLocker.id)..' - Locker >> Items Container ['..Coordinates.Adjacent_Locker.x..', '..Coordinates.Adjacent_Locker.y..', '..Coordinates.Adjacent_Locker.z..']')
											break
										else
											local ClosestDustbin = 20
											local ClosestDustbinLocation = {}
											for _, dustbin in ipairs(Dustbin_Locations) do
												local xDist = math.abs(dustbin[1] - Self.Position().x)
												local yDist = math.abs(dustbin[2] - Self.Position().y)
												if xDist <= 7 and yDist <= 5 and dustbin[3] == Self.Position().z then
													if ClosestDustbin > xDist then
														ClosestDustbin = xDist
														ClosestDustbinLocation = dustbin
													elseif ClosestDustbin > yDist then
														ClosestDustbin = yDist
														ClosestDustbinLocation = dustbin
													end
												end
											end
											if ClosestDustbinLocation and ClosestDustbin < 20 then
												Containers.Locker:MoveItemToGround(itemLocker, ClosestDustbinLocation[1], ClosestDustbinLocation[2], ClosestDustbinLocation[3], tempItemLocker.count)
												ProcessDebugMessage('Casino Debugger', 'Anti-Trash | ['..tempItemLocker.id..'] '..tempItemLocker.count..' '..Item.GetName(tempItemLocker.id)..' - Locker >> Dustbin ['..ClosestDustbinLocation[1]..', '..ClosestDustbinLocation[2]..', '..ClosestDustbinLocation[3]..']')
												break
											else
												Containers.Locker:MoveItemToContainer(itemLocker,Containers.Items:Index(),Containers.Items:ItemCapacity()-1, 1)
												ProcessDebugMessage('Casino Debugger', 'Anti-Trash | ['..tempItemLocker.id..'] '..tempItemLocker.count..' '..Item.GetName(tempItemLocker.id)..' - Locker >> Items Container ['..Coordinates.Adjacent_Locker.x..', '..Coordinates.Adjacent_Locker.y..', '..Coordinates.Adjacent_Locker.z..']')
												break
											end
										end
									end
								end
							end
						else
							Containers.Locker:MoveItemToGround(itemLocker,Coordinates.Counter.x,Coordinates.Counter.y,Coordinates.Counter.z,tempItemLocker.count)
							break
						end
					end
				end
			end
		end
		Mod:Delay(WorkloadExecutionInterval()*800)
	end)

if _Effects_Enabled then
	Module('EffectsSystem', function(Mod)
		if Casino_Loaded then
			if not Processing_Data then
				if _Effects_Enabled then
					if _Effects_Item:lower() == "party hat" then
						if (Self.Head().id == Item.GetID('party hat')) then
							Self.UseItemFromEquipment('head')
							Last_Party_Hat = os.time()
						end
					elseif _Effects_Item:lower() == "enigmatic voodoo skull" then
						if Count_Extended(Containers.Depot, {5669}) > 0 then
							for EffectItemInDepot = 0, Containers.Depot:ItemCount()-1 do
								if EffectItemInDepot > 28 then
									EffectItemInDepot = 28
								end
								local tempItem = Containers.Depot:GetItemData(EffectItemInDepot)
								if 5669 == tempItem.id then
									Containers.Depot:UseItem(EffectItemInDepot, true)
									break
								end
							end
						end
					else
						if Count_Extended(Containers.Depot, {Item.GetID(_Effects_Item)}) > 0 then
							for EffectItemInDepot = 0, Containers.Depot:ItemCount()-1 do
								if EffectItemInDepot > 28 then
									EffectItemInDepot = 28
								end
								local tempItem = Containers.Depot:GetItemData(EffectItemInDepot)
								if Item.GetID(_Effects_Item) == tempItem.id then
									Containers.Depot:UseItem(EffectItemInDepot, true)
									break
								end
							end
						end
					end
				end
			end
		end
		Mod:Delay(_Effects_Interval*1000)
	end)
end
	Module('BroadcastSystem', function(Mod)
		if _Broadcast_UseMessages then
			if Casino_Loaded then
				if not Processing_Data then
					if (os.difftime(os.time(),Last_Broadcast)>_Broadcast_Interval) then
						if (os.difftime(os.time(),Last_Message)>2) then
							local PlayersAround = false
							if not _Broadcast_FixedInterval then
								for name, creature in Creature.iPlayers(2) do
									if name and creature then
										PlayersAround = true
										break
									end
								end
							end
							if not PlayersAround then
								_Broadcast_Messages_Processed = {}
								for index, value in ipairs(_Broadcast_Messages) do
									_Broadcast_Messages_Processed[index] = value:gsub('%[name%]', Self.Name()):
																					gsub('%[minhighlow%]', (High_Low_Minimum/1000)..'k'):
																					gsub('%[maxhighlow%]', (High_Low_Maximum/1000)..'k'):
																					gsub('%[minoddeven%]', (Odd_Even_Minimum/1000)..'k'):
																					gsub('%[maxoddeven%]', (Odd_Even_Maximum/1000)..'k'):
																					gsub('%[minfirstsecondlast%]', (First_Second_Last_Minimum/1000)..'k'):
																					gsub('%[maxfirstsecondlast%]', (First_Second_Last_Maximum/1000)..'k'):
																					gsub('%[minsingle%]', (Single_Numbers_Minimum/1000)..'k'):
																					gsub('%[maxsingle%]', (Single_Numbers_Maximum/1000)..'k'):
																					gsub('%[minblackjack%]', (Blackjack_Minimum/1000)..'k'):
																					gsub('%[maxblackjack%]', (Blackjack_Maximum/1000)..'k'):
																					gsub('%[payouthighlow%]', High_Low_Payout..'%%'):
																					gsub('%[payoutoddeven%]', Odd_Even_Payout..'%%'):
																					gsub('%[payoutfirstsecondlast%]', First_Second_Last_Payout..'%%'):
																					gsub('%[payoutsingle%]', Single_Numbers_Payout..'%%'):
																					gsub('%[payoutblackjack%]', Blackjack_Payout..'%%')
									_Broadcast_Messages_Processed[index] = _Broadcast_UppercaseMessages and _Broadcast_Messages_Processed[index]:upper() or _Broadcast_Messages_Processed[index]
								end
								local Custom_Message_Processed = _Broadcast_Messages_Processed[math.random(1, #_Broadcast_Messages_Processed)]
								if _Broadcast_YellMessages then
									Self.Yell(Custom_Message_Processed)
								else
									Self.Say(Custom_Message_Processed)
								end
								ProcessDebugMessage('Casino Debugger', 'Send broadcast message: "'..Custom_Message_Processed..'"')
								Last_Broadcast = os.time()
								Last_Message = os.time()
							end
						end
					end
				end
			end
		end
		Mod:Delay(10000)
	end)
	Module('UpdateSystem', function(Mod)
		local StopMessage = nil
		local LowCash = false
		local TakeScreenshot = true
		if Casino_Loaded then
			if #Container.GetAll() == 0 then
				if (_Extra_RestartOnKick) then
					Casino_Loaded = false
					Processing_Data = false
					if UpdateCoordinates() then
						if Open_Containers() then
							PickUpDiceAndDecoration()
							CheckDiceAndDecoration()
							Casino_Loaded = true
							ProcessDebugMessage('Casino', 'The script has been restarted')
						end
					end
				end
			else
				if not Processing_Data then
					local AvailableSlotsPlat = false
					local AvailableSlotsCrystal = false
					local AvailableSlotsItem = false
					local CipsoftMemberDetected = nil
					HEADS_UP_DISPLAY.AMOUNT_CASH.DISPLAY_CRYSTAL.AMOUNT:SetText(tostring(Count_Crystal_Extended()*10)..'k')
					HEADS_UP_DISPLAY.AMOUNT_CASH.DISPLAY_PLATINUM.AMOUNT:SetText(tostring(Count_Platinum_Extended()/10)..'k')
					HEADS_UP_DISPLAY.AMOUNT_ITEMS.DISPLAY_ITEM.AMOUNT:SetText(tostring(Total.Items.Amount)..' ('..tostring(Total.Items.Value/1000)..'k)')
					if (_Extra_CipStaffDetection) then
						for name, creature in Creature.iCreatures() do
							for _, member in ipairs(CipsoftMembers) do
								if creature:Name():lower():find(member) then
									CipsoftMemberDetected = creature:Name()
									break
								end
							end
						end
						if CipsoftMemberDetected then
							StopMessage = 'The script has detected a Cipsoft member nearby: '..CipsoftMemberDetected..'. Stopping the script and closing the client immediately'
							ManualStop = true
							PybfrPyvrag = true
						end
					end
					if Containers.Platinum then
						AvailableSlotsPlat = false
						for _, container_Platinum in ipairs(Containers.Platinum) do
							if container_Platinum:EmptySlots() > 2 then
								AvailableSlotsPlat = true
								break
							end
						end
					end
					if Containers.Crystal then
						AvailableSlotsCrystal = false
						for _, container_Crystal in ipairs(Containers.Crystal) do
							if container_Crystal:EmptySlots() > 2 then
								AvailableSlotsCrystal = true
								break
							end
						end
					end
					if Accept_Items then
						if Containers.Items then
							AvailableSlotsItem = false
							if Containers.Items:EmptySlots() > 0 and Count_Extended(Containers.Items, {Containers.Items:ID()}) > 0 then
								AvailableSlotsItem = true
							end
						end
					else
						AvailableSlotsItem = true
					end
					if not AvailableSlotsPlat then
						StopMessage = 'Stopping script due to few available slots for platinum coins'
						ManualStop = true
					elseif not AvailableSlotsCrystal then
						StopMessage = 'Stopping script due to few available slots for crystal coins'
						ManualStop = true
					elseif not AvailableSlotsItem then
						StopMessage = 'Stopping script due to few available slots for items. Please, add another "'.._Containers_Items..'" inside the last container'
						ManualStop = true
					end
					if Count_Platinum_Extended() <= 100 then
						StopMessage = 'Stopping script due to low platinum coins ('..(Count_Platinum_Extended()/1000)..'k)'
						ManualStop = true
					end
					if _Extra_AlarmLowCash then
						if not ManualStop then
							local AvailableAmount = Count_Crystal_Extended() * 10000
							if High_Low then
								local RequiredAmount = (High_Low_Maximum * High_Low_Payout / 100)
								if AvailableAmount < RequiredAmount then
									StopMessage = 'Stopping script due to low amount of cash to play High/Low ('..(AvailableAmount/1000)..'k)'
								end
							elseif Odd_Even then
								local RequiredAmount = (Odd_Even_Maximum * Odd_Even_Payout / 100)
								if AvailableAmount < RequiredAmount then
									StopMessage = 'Stopping script due to low amount of cash to play Odd/Even ('..(AvailableAmount/1000)..'k)'
								end
							elseif Blackjack then
								local RequiredAmount = (Blackjack_Maximum * Blackjack_Payout / 100)
								if AvailableAmount < RequiredAmount then
									StopMessage = 'Stopping script due to low amount of cash to play Blackjack ('..(AvailableAmount/1000)..'k)'
								end
							elseif First_Second_Last then
								local RequiredAmount = (First_Second_Last_Maximum * First_Second_Last_Payout / 100)
								if AvailableAmount < RequiredAmount then
									StopMessage = 'Stopping script due to low amount of cash to play First/Second/Last ('..(AvailableAmount/1000)..'k)'
								end
							elseif Single_Numbers then
								local RequiredAmount = (Single_Numbers_Maximum * Single_Numbers_Payout / 100)
								if AvailableAmount < RequiredAmount then
									StopMessage = 'Stopping script due to low amount of cash to play Single Numbers ('..(AvailableAmount/1000)..'k)'
								end
							elseif Highest_Lowest then
								local RequiredAmount = (Highest_Lowest_Maximum * Highest_Lowest_Payout / 100)
								if AvailableAmount < RequiredAmount then
									StopMessage = 'Stopping script due to low amount of cash to play Highest/Lowest ('..(AvailableAmount/1000)..'k)'
								end
							elseif Sequence then
								local RequiredAmount = (Sequence_Maximum * Sequence_Payout / 100)
								if AvailableAmount < RequiredAmount then
									StopMessage = 'Stopping script due to low amount of cash to play Sequence ('..(AvailableAmount/1000)..'k)'
								end
							elseif Pair_Of_Numbers then
								local RequiredAmount = (Pair_Of_Numbers_Maximum * Pair_Of_Numbers_Payout / 100)
								if AvailableAmount < RequiredAmount then
									StopMessage = 'Stopping script due to low amount of cash to play Pair Of Numbers ('..(AvailableAmount/1000)..'k)'
								end
							elseif Sum_Of_Numbers then
								local RequiredAmount = (Sum_Of_Numbers_Maximum * Sum_Of_Numbers_Payout / 100)
								if AvailableAmount < RequiredAmount then
									StopMessage = 'Stopping script due to low amount of cash to play Sum Of Numbers ('..(AvailableAmount/1000)..'k)'
								end
							elseif Beat_That then
								local RequiredAmount = (Beat_That_Maximum * Beat_That_Payout / 100)
								if AvailableAmount < RequiredAmount then
									StopMessage = 'Stopping script due to low amount of cash to play Beat That ('..(AvailableAmount/1000)..'k)'
								end
							end
							if StopMessage then
								ManualStop = true
								LowCash = true
							end
						end
					end
				end
			end
		end
		if not Processing_Data then			
			Time_Now = os.date("*t")
			if Server_Save <= ((Time_Now.hour * 3600) + (Time_Now.min * 60) + Time_Now.sec) then
				Server_Save_TimeLeft = os.difftime((Server_Save + 24 * 3600), (Time_Now.hour * 3600) + (Time_Now.min * 60)  + Time_Now.sec)
			else
				Server_Save_TimeLeft = os.difftime(Server_Save,(Time_Now.hour * 3600) + (Time_Now.min * 60)  + Time_Now.sec)
			end
			
			local diffSecs = os.difftime(os.time(),Last_Bid)
			local nHours = string.format("%02.f", math.floor(diffSecs/3600))
			local nMins = string.format("%02.f", math.floor((diffSecs - (nHours * 3600)) / 60))
			local nSecs = string.format("%02.f", math.floor(diffSecs - (nHours * 3600) - (nMins * 60)))
			
			HEADS_UP_DISPLAY.LAST_BID.VALUE:SetText(nHours..':'..nMins..':'..nSecs)
			
			diffSecs = os.difftime(os.time(),Time_Script_Started)
			nHours = string.format("%02.f", math.floor(diffSecs/3600))
			nMins = string.format("%02.f", math.floor((diffSecs - (nHours * 3600)) / 60))
			nSecs = string.format("%02.f", math.floor(diffSecs - (nHours * 3600) - (nMins * 60)))
			
			HEADS_UP_DISPLAY.TIME_RUNNING.VALUE:SetText(nHours..':'..nMins..':'..nSecs)
			
			nHours = string.format("%02.f", math.floor(Server_Save_TimeLeft/3600))
			nMins = string.format("%02.f", math.floor((Server_Save_TimeLeft - (nHours * 3600)) / 60))
			nSecs = string.format("%02.f", math.floor(Server_Save_TimeLeft - (nHours * 3600) - (nMins * 60)))
			
			HEADS_UP_DISPLAY.SERVER_SAVE.VALUE:SetText(nHours..':'..nMins..':'..nSecs)
					
			if not ManualStop then
				if not Blackjack and
					not High_Low and
					not Odd_Even and
					not First_Second_Last and
					not Single_Numbers and
					not Highest_Lowest and
					not Sequence and
					not Pair_Of_Numbers and
					not Sum_Of_Numbers and
					not Beat_That then
					ProcessDebugMessage('Casino', 'You don\'t accept any game type. Please, check your settings and reload the script')
					ManualStop = true
				end
				if Server_Save_TimeLeft <= 300 then
					StopMessage = 'Stopping script due to Server Save'
					ProcessDebugMessage('Casino', StopMessage)
					ManualStop = true
				end
			else
				Casino_Loaded = false
				PickUpDiceAndDecoration()
				if _Statistics_UseLog and Casino_StatisticsFile then
					Casino_StatisticsFile:flush()
				end
				if StopMessage then
					ProcessDebugMessage('Casino', StopMessage)
				end
				if LowCash then
					if _Extra_AlarmLowCash then
						alert()
					end
				end
				if _Extra_ScreenshotOnStop then
					if TakeScreenshot then
						screenshot('Casino Script ['..Self.Name()..']['..os.date("%b %d %Y - %H.%M")..']')
						wait(1000)
					end
				end
			end
			if PybfrPyvrag then
				if _Debug_UseLog and Casino_LogFile then
					Casino_LogFile:close()
				end
				if _Statistics_UseLog and Casino_StatisticsFile then
					Casino_StatisticsFile:close()
				end
				os.exit()
			end
		end
		Mod:Delay(1000)
	end)

	Module('RestackSystem', function(Mod)
		if Casino_Loaded then
			if not Processing_Data then
				local ActionPerformed = false
				local FreeSlots_Platinum = nil
				local FreeSlots_Crystal = nil
				if not ActionPerformed then
					for _, container_Platinum in ipairs(Containers.Platinum) do
						for itemPlatinumCoin = container_Platinum:ItemCount() - 1, 0, -1 do
							if container_Platinum:ItemCount() >= 2 then
								if not (itemPlatinumCoin == 0) then
									local item_temp = container_Platinum:GetItemData(itemPlatinumCoin)
									if item_temp.count < 100 then
										container_Platinum:MoveItemToContainer(itemPlatinumCoin, container_Platinum:Index(), 0)
										ProcessDebugMessage('Casino Debugger', 'Restack System | Moving '..item_temp.count..' platinum coins to beginning of the stack')
										ActionPerformed = true
										break
									end
								end
							end
						end
					end
				end
				if not ActionPerformed then
					for _, container_platinum in ipairs(Containers.Platinum) do
						if container_platinum:EmptySlots() >= 2 then
							FreeSlots_Platinum = container_platinum
							break
						end
					end
					if FreeSlots_Platinum then
						for index, containersPlatinum in ripairs(Containers.Platinum) do
							if (index > 1) then
								for itemPlatinumCoin = containersPlatinum:ItemCount() - 1, 0, -1 do
									if(containersPlatinum:Index() > FreeSlots_Platinum:Index()) then
										local item_temp = containersPlatinum:GetItemData(itemPlatinumCoin)
										containersPlatinum:MoveItemToContainer(itemPlatinumCoin, FreeSlots_Platinum:Index(), 0)
										ProcessDebugMessage('Casino Debugger', 'Restack System | Moving '..item_temp.count..' platinum coins to empty slot in previous container')
										ActionPerformed = true
										break
									end
								end
							end
						end
					end
				end
				if not ActionPerformed then
					for _, container_Crystal in ipairs(Containers.Crystal) do
						if container_Crystal:EmptySlots() >= 2 then
							FreeSlots_Crystal = container_Crystal
							break
						end
					end
					if FreeSlots_Crystal then
						for index, container_Crystal in ripairs(Containers.Crystal) do
							if (index > 1) then
								for itemCrystalCoin = container_Crystal:ItemCount() - 1, 0, -1 do
									if(container_Crystal:Index() > FreeSlots_Crystal:Index()) then
										local item_temp = container_Crystal:GetItemData(itemCrystalCoin)
										container_Crystal:MoveItemToContainer(itemCrystalCoin, FreeSlots_Crystal:Index(), 0)
										ProcessDebugMessage('Casino Debugger', 'Restack System | Moving '..item_temp.count..' crystal coins to empty slot in previous container')
										ActionPerformed = true
										break
									end
								end
							end
						end
					end
				end
				if not ActionPerformed then
					for _, container_Crystal in ipairs(Containers.Crystal) do
						for itemCrystalCoin = container_Crystal:ItemCount() - 1, 0, -1 do
							if container_Crystal:ItemCount() >= 2 then
								if not (itemCrystalCoin == 0) then
									local item_temp = container_Crystal:GetItemData(itemCrystalCoin)
									if item_temp.count < 100 then
										container_Crystal:MoveItemToContainer(itemCrystalCoin, container_Crystal:Index(), 0)
										ProcessDebugMessage('Casino Debugger', 'Restack System | Moving '..item_temp.count..' crystal coins to beginning of the stack')
										ActionPerformed = true
										break
									end
								end
							end
						end
					end
				end
				if not ActionPerformed then
					if Accept_Items then
						if Containers.Items then
							if Containers.Items:EmptySlots() <= 5 then
								OpeningNestedContainers = true
								local TotalValueItems = 0
								local TotalCountItems = 0
								for indexItem = 0, Containers.Items:ItemCount()-1 do
									local tempItem = Containers.Items:GetItemData(indexItem)
									for _, Accepted_Item in ipairs(Accepted_Items_List) do
										if Accepted_Item.ID == tempItem.id then
											TotalValueItems = TotalValueItems + (Accepted_Item.Value * tempItem.count)
											TotalCountItems = TotalCountItems + 1
										end
									end
								end
								if Total.Items.LastAmountSeen ~= TotalValueItems then
									Total.Items.LastAmountSeen = TotalValueItems
									Total.Items.Amount = Total.Items.Amount + TotalCountItems
									Total.Items.Value = Total.Items.Value + TotalValueItems
									ProcessDebugMessage('Casino Debugger', 'Updating item values in HUD')
								end
								for indexContainer = Containers.Items:ItemCount()-1, 0, -1 do
									if Item.isContainer(Containers.Items:GetItemData(indexContainer).id) then
										Containers.Items:UseItem(indexContainer, true)
										ProcessDebugMessage('Casino Debugger', 'Opening new container for items')
										ActionPerformed = true
										break
									end
								end
							else
								OpeningNestedContainers = false
							end
						end
					end
				end
			end
		end
		Mod:Delay(WorkloadExecutionInterval()*400)
	end)
	
	Module('InactivityDetectionSystem', function(Mod)
		if _Inactivity_Detection then
			if not Processing_Data then
				if not ManualStop then
					if (os.difftime(os.time(), Last_Activity) >= (_Inactivity_Interval*60)) then
						ProcessDebugMessage('Casino', 'The character has been inactive for more than '.._Inactivity_Interval..' min. The script will search for a new depot')
						Casino_Loaded = false
						PickUpDiceAndDecoration()
						if Self.Position().z == 7 then
							gotoLabel('GroundFloor')
						elseif Self.Position().z == 6 then
							GoCheckDown = true
							gotoLabel('FirstFloor')
						end
						setWalkerEnabled(true)
					end
				end
			end
		else
			if _Inactivity_NotifyBlockedSpot then
				if not Processing_Data then
					if not ManualStop then
						if Last_Player then
							if (os.difftime(os.time(),Last_Activity_Player_In_Spot) >= _Inactivity_BlockedSpotInterval*60) then
								ProcessDebugMessage('Casino', 'The character has been inactive for more than '.._Inactivity_BlockedSpotInterval..' min. Notifying blocked spot')
								SendMessage(Last_Player, _Inactivity_MessageBlockedSpot, false)
								Last_Activity_Player_In_Spot = os.time()
							end
						end
					end
				end
			end
		end
		Mod:Delay(30000)
	end)
if _Inactivity_AntiIdle then
	Module('InactivityAntiIdleSystem', function(Mod)
		if (not _Inactivity_Detection or _Inactivity_Interval >= 15) and not Processing_Data then
			Self.Turn(math.random(0, 3))
		end
		Mod:Delay(180000)
	end)
end
	Module('ProcessPaymentSystem', function(Mod)
		if Processing_Data then
			if Payment_Give_Signal then
				if Payment_Given_Check.Platinum == 1 then
					Payment_Given_Check.Platinum_Amount = 0
				end
				if Payment_Given_Check.Crystal == 1 then
					if Payment_Given_Check.Crystal_Amount < 0 then
						Payment_Given_Check.Crystal_Amount = 0
					end
				end
				ProcessDebugMessage('Casino Debugger', 'Process Payment signal acknowledged | '..Payment_Given_Check.Crystal_Amount..' crystal coins | '..Payment_Given_Check.Platinum_Amount..' platinum coins')
				if Payment_Given_Check.Platinum_Amount > 0 then
					for _, container_Platinum in ipairs(Containers.Platinum) do
						for platinumInContainer = container_Platinum:ItemCount()-1,0,-1 do
							local tempItem = container_Platinum:GetItemData(platinumInContainer)
							if (tempItem.id == 3035 and tempItem.count >= Payment_Given_Check.Platinum_Amount) then
								Payment_Given_Check.Platinum = container_Platinum:MoveItemToGround(platinumInContainer,Coordinates.Counter.x,Coordinates.Counter.y,Coordinates.Counter.z,Payment_Given_Check.Platinum_Amount)
								break
							end
						end
						if Payment_Given_Check.Platinum == 1 then
							break
						end
					end
				elseif Payment_Given_Check.Crystal_Amount > 0 then
					for _, container_Crystal in ipairs(Containers.Crystal) do
						for crystalInContainer = container_Crystal:ItemCount()-1,0,-1 do
							local tempItem = container_Crystal:GetItemData(crystalInContainer)
							local AmountOfCrystalsToPay = 0
							if Payment_Given_Check.Crystal_Amount > 100 then
								AmountOfCrystalsToPay = 100
							else
								AmountOfCrystalsToPay = Payment_Given_Check.Crystal_Amount
							end
							if (tempItem.id == 3043 and tempItem.count >= AmountOfCrystalsToPay) then
								Payment_Given_Check.Crystal = container_Crystal:MoveItemToGround(crystalInContainer,Coordinates.Counter.x,Coordinates.Counter.y,Coordinates.Counter.z,AmountOfCrystalsToPay)
								break
							end
						end
						if Payment_Given_Check.Crystal == 1 then
							Payment_Given_Check.Crystal_Amount = Payment_Given_Check.Crystal_Amount - 100
							break
						end
					end
				else
					Payment_Give_Signal = false
					Payment_Given_Check.Platinum = 0
					Payment_Given_Check.Crystal = 0
					Payment_Given_Check.Crystal_Amount = 0
					if SkipRollingProcess then
						SkipRollingProcess = false
						ResetValues()
					end
					ProcessDebugMessage('Casino Debugger', 'The script finished processing effects')
				end
			end
		end
		Mod:Delay(WorkloadExecutionInterval()*400)
	end)

	Module('UseResultItemSystem', function(Mod)
		if Casino_Loaded then
			if Processing_Data then
				if Play_Instrument_Signal ~= 0 then
					if Play_Instrument_Signal == 1 then
						Losing_Item_Check = 0
						if Winning_Item == 'none' then
							Winning_Item_Check = 1
						else
							if not Payment_Give_Signal then
								if Winning_Item_Check == 0 then
									if Count_Extended(Containers.Depot, {Winning_Item_ID}) > 0 then
										for useItem = Containers.Depot:ItemCount()-1,0,-1 do
											if Containers.Depot:GetItemData(useItem).id == Winning_Item_ID then
												Winning_Item_Check = Containers.Depot:UseItem(useItem)
												break
											end
										end
									else
										Winning_Item_Check = 1
									end
								end
							end
						end
					elseif Play_Instrument_Signal == -1 then
						Winning_Item_Check = 0
						if Losing_Item == 'none' then
							Losing_Item_Check = 1
						else
							if Losing_Item_Check == 0 then
								if Count_Extended(Containers.Depot, {Losing_Item_ID}) > 0 then
									for useItem = Containers.Depot:ItemCount()-1,0,-1 do
										if Containers.Depot:GetItemData(useItem).id == Losing_Item_ID then
											Losing_Item_Check = Containers.Depot:UseItem(useItem)
											break
										end
									end
								else
									Losing_Item_Check = 1
								end
							end
						end
					end
				else
					Winning_Item_Check = 0
					Losing_Item_Check = 0
				end
				if (Winning_Item_Check == 1 or Losing_Item_Check == 1) then
					if Losing_Item_Check == 1 then
						ResetValues()
					elseif Winning_Item_Check == 1 then
						if Payment_Given_Check.Platinum_Amount == 0 and Payment_Given_Check.Crystal_Amount == 0 and not Payment_Give_Signal then
							ResetValues()
						end
					end
					ProcessDebugMessage('Casino Debugger', 'Use Item signal acknowledged | '..((Play_Instrument_Signal == 1) and Item.GetName(Winning_Item_ID) or Item.GetName(Losing_Item_ID)))
				end
			end
		end
		Mod:Delay(WorkloadExecutionInterval()*200)
	end)

	Module('ProcessRollSystem', function(Mod)
		if Casino_Loaded then
			if Pay_Cash_Signal ~= 0 then
				data = Pay_Cash_Signal
				Pay_Cash_Signal = 0
				if Blackjack and Blackjack_In_Progress then
					ProcessDebugMessage('Casino Debugger', 'Process Roll signal acknowledged | Blackjack | Player rolls sum: '..Blackjack_Player_Count..' | Dealer rolls sum: '..Blackjack_Dealer_Count)
				elseif Sum_Of_Numbers and Sum_Of_Numbers_In_Progress then
					ProcessDebugMessage('Casino Debugger', 'Process Roll signal acknowledged | Sum of numbers | Sum: '..Sum_Of_Numbers_Sum)
				elseif Sequence and Sequence_In_Progress then
					ProcessDebugMessage('Casino Debugger', 'Process Roll signal acknowledged | Sequence | Values: '..Sequence_Count)
				elseif Beat_That and Beat_That_In_Progress then
					ProcessDebugMessage('Casino Debugger', 'Process Roll signal acknowledged | Beat that | Sum: '..Beat_That_Sum)
				elseif Highest_Lowest and Highest_Lowest_In_Progress then
					ProcessDebugMessage('Casino Debugger', 'Process Roll signal acknowledged | Highest/Lowest | First sum: '..Highest_Lowest_First_Sum..' | Second sum: '..Highest_Lowest_Second_Sum)
				else
					ProcessDebugMessage('Casino Debugger', 'Process Roll signal acknowledged | You rolled a '..data)
				end
				if Player_Option then
					local PayCash = false
					local Payout_Percent = 0
					local Message = nil
					local jackpot = 0
					local crystal_coins = 0
					local platinum_coins = 0
					if (table.contains({'blackjack'}, Player_Option) and Blackjack) then
						if (Blackjack_Player_Count > 21 and Blackjack_Dealer_Count > 21) then
							Message = Blackjack_Busted_Both_Messages[math.random(1, #Blackjack_Busted_Both_Messages)]:gsub('%[playercount%]', Blackjack_Player_Count):gsub('%[dealercount%]', Blackjack_Dealer_Count)
							PayCash = true
						elseif (Blackjack_Player_Count <= 21 and Blackjack_Dealer_Count > 21) then
							Message = Blackjack_Busted_Dealer_Messages[math.random(1, #Blackjack_Busted_Dealer_Messages)]:gsub('%[dealercount%]', Blackjack_Dealer_Count)
							PayCash = true
						elseif(Blackjack_Player_Count > 21 and Blackjack_Dealer_Count <= 21) then
							Message = Blackjack_Busted_Player_Messages[math.random(1, #Blackjack_Busted_Player_Messages)]:gsub('%[playercount%]', Blackjack_Player_Count)
							PayCash = false
						elseif Blackjack_Player_Count > Blackjack_Dealer_Count then
							Message = Blackjack_Win_Messages[math.random(1, #Blackjack_Win_Messages)]:gsub('%[playercount%]', Blackjack_Player_Count):gsub('%[dealercount%]', Blackjack_Dealer_Count)
							PayCash = true
						elseif Blackjack_Player_Count < Blackjack_Dealer_Count then
							Message = Blackjack_Lose_Messages[math.random(1, #Blackjack_Lose_Messages)]:gsub('%[playercount%]', Blackjack_Player_Count):gsub('%[dealercount%]', Blackjack_Dealer_Count)
							PayCash = false
						elseif Blackjack_Player_Count == Blackjack_Dealer_Count then
							Message = Blackjack_Even_Result_Messages[math.random(1, #Blackjack_Even_Result_Messages)]:gsub('%[tiecount%]', Blackjack_Player_Count)
							PayCash = true
						end
						Payout_Percent = Blackjack_Payout
					elseif (table.contains({'sum'}, Player_Option) and Sum_Of_Numbers) then
						if (Sum_Of_Numbers_Sum == Game_Types.Sum.Choice) then
							PayCash = true
							Message = Sum_Win_Messages[math.random(1, #Sum_Win_Messages)]:gsub('%[sum%]', Sum_Of_Numbers_Sum)
						else
							Message = Sum_Lose_Messages[math.random(1, #Sum_Lose_Messages)]:gsub('%[sum%]', Sum_Of_Numbers_Sum)
						end
						Payout_Percent = (Sum_Of_Numbers_Payout / (Sum_Of_Numbers_Maximum_Rolls * 6)) * Game_Types.Sum.Choice
					elseif (table.contains({'beat that'}, Player_Option) and Beat_That) then
						if (Beat_That_Sum == Game_Types.BeatThat.Choice) then
							PayCash = true
						end
						Payout_Percent = Beat_That_Payout
					elseif (table.contains({'sequence'}, Player_Option) and Sequence) then
						if (table.contains({123,234,345,456,654,543,432,321}, Sequence_Count)) then
							PayCash = true
							Message = Sequence_Win_Messages[math.random(1, #Sequence_Win_Messages)]:gsub('%[sequence%]', Sequence_Count)
						else
							Message = Sequence_Lose_Messages[math.random(1, #Sequence_Lose_Messages)]:gsub('%[sequence%]', Sequence_Count)
						end
						Payout_Percent = Sequence_Payout
					elseif (table.contains({'highest', 'lowest'}, Player_Option) and Highest_Lowest) then
						if Highest_Lowest_First_Sum == Highest_Lowest_Second_Sum then
							Message = Highest_Lowest_Even_Result_Messages[math.random(1, #Highest_Lowest_Even_Result_Messages)]:gsub('%[tiecount%]', Highest_Lowest_First_Sum)
							PayCash = true
						else
							if table.contains({'highest'}, Player_Option) then
								if Highest_Lowest_First_Sum > Highest_Lowest_Second_Sum then
									PayCash = true
									Message = Highest_Lowest_Win_Messages[math.random(1, #Highest_Lowest_Win_Messages)]:gsub('%[firstcount%]', Highest_Lowest_First_Sum):gsub('%[secondcount%]', Highest_Lowest_Second_Sum)
								else
									Message = Highest_Lowest_Lose_Messages[math.random(1, #Highest_Lowest_Lose_Messages)]:gsub('%[firstcount%]', Highest_Lowest_First_Sum):gsub('%[secondcount%]', Highest_Lowest_Second_Sum)
								end
							elseif table.contains({'lowest'}, Player_Option) then
								if Highest_Lowest_First_Sum < Highest_Lowest_Second_Sum then
									PayCash = true
									Message = Highest_Lowest_Win_Messages[math.random(1, #Highest_Lowest_Win_Messages)]:gsub('%[firstcount%]', Highest_Lowest_First_Sum):gsub('%[secondcount%]', Highest_Lowest_Second_Sum)
								else
									Message = Highest_Lowest_Lose_Messages[math.random(1, #Highest_Lowest_Lose_Messages)]:gsub('%[firstcount%]', Highest_Lowest_First_Sum):gsub('%[secondcount%]', Highest_Lowest_Second_Sum)
								end
							end
						end
						Payout_Percent = Highest_Lowest_Payout
					elseif (table.contains({'13','14','15','16','23','24','25','26','31','32','35','36','41','42','45','46','51','52','53','54','61','62','63','64'}, Player_Option) and Pair_Of_Numbers) then
						local FirstDigit, SecondDigit = Player_Option:match('(%d)(%d)')
						FirstDigit = FirstDigit + 0
						SecondDigit = SecondDigit + 0
						if FirstDigit == data or SecondDigit == data then
							PayCash = true
						end
						Payout_Percent = Pair_Of_Numbers_Payout
					elseif (table.contains({'l','low','123','h','high','456'}, Player_Option) and High_Low) then
						if (table.contains({'l','low','123'}, Player_Option)) then
							if (data >= 1 and data <= 3) then
								PayCash = true
							end
						elseif (table.contains({'h','high','456'}, Player_Option)) then
							if (data >= 4 and data <= 6) then
								PayCash = true
							end
						end
						Payout_Percent = High_Low_Payout
					elseif (table.contains({'odd','135','even','246'}, Player_Option) and Odd_Even) then
						if (table.contains({'odd','135'}, Player_Option)) then
							if (data == 1 or data == 3 or data == 5) then
								PayCash = true
							end
						elseif (table.contains({'even','246'}, Player_Option)) then
							if (data == 2 or data == 4 or data == 6) then
								PayCash = true
							end
						end
						Payout_Percent = Odd_Even_Payout
					elseif (table.contains({'first','12','second','middle','34','third','56','last'}, Player_Option) and First_Second_Last) then
						if (table.contains({'first','12'}, Player_Option)) then
							if (data == 1 or data == 2) then
								PayCash = true
							end
						elseif (table.contains({'second','34','middle'}, Player_Option)) then
							if (data == 3 or data == 4) then
								PayCash = true
							end
						elseif (table.contains({'last','56','third'}, Player_Option)) then
							if (data == 5 or data == 6) then
								PayCash = true
							end
						end
						Payout_Percent = First_Second_Last_Payout
					elseif (table.contains({'1','2','3','4','5','6'}, Player_Option) and Single_Numbers) then
						if (Player_Option == '1') then
							if (data == 1) then
								PayCash = true
							end
						elseif (Player_Option == '2') then
							if (data == 2) then
								PayCash = true
							end
						elseif (Player_Option == '3') then
							if (data == 3) then
								PayCash = true
							end
						elseif (Player_Option == '4') then
							if (data == 4) then
								PayCash = true
							end
						elseif (Player_Option == '5') then
							if (data == 5) then
								PayCash = true
							end
						elseif (Player_Option == '6') then
							if (data == 6) then
								PayCash = true
							end
						end
						Payout_Percent = Single_Numbers_Payout
					end
					if PayCash then
						if Blackjack and Blackjack_In_Progress then		
							if (Blackjack_Player_Count > 21 and Blackjack_Dealer_Count > 21) then
								jackpot = Player_Balance
							elseif (Blackjack_Player_Count <= 21 and Blackjack_Dealer_Count > 21) then
								jackpot = Player_Balance + (Payout_Percent * Player_Balance / 100)
							elseif(Blackjack_Player_Count == Blackjack_Dealer_Count) then
								jackpot = Player_Balance
							elseif (Blackjack_Player_Count > Blackjack_Dealer_Count) then
								jackpot = Player_Balance + (Payout_Percent * Player_Balance / 100)
							end
						elseif Highest_Lowest and Highest_Lowest_In_Progress then
							if Highest_Lowest_First_Sum == Highest_Lowest_Second_Sum then
								jackpot = Player_Balance
							else
								jackpot = Player_Balance + (Payout_Percent * Player_Balance / 100)
							end
						else
							jackpot = Player_Balance + (Payout_Percent * Player_Balance / 100)
						end
						while jackpot >= 10000 do
							crystal_coins = crystal_coins + 1
							jackpot = jackpot - 10000
						end
						while jackpot >= 100 do
							platinum_coins = platinum_coins + 1
							jackpot = jackpot - 100
						end
						Play_Instrument_Signal = 1
						Payment_Given_Check.Crystal_Amount = crystal_coins
						Payment_Given_Check.Platinum_Amount = platinum_coins
						Payment_Give_Signal = true
						Bets.Lost.Raw = Bets.Lost.Raw + 1
						Bets.Lost.Cash = Bets.Lost.Cash + (crystal_coins * 10000) + (platinum_coins * 100) - Player_Balance
						HEADS_UP_DISPLAY.BETS.LOST.AMOUNT:SetText(tostring(Bets.Lost.Raw)..' ('..tostring(Bets.Lost.Cash/1000)..'k)')
						Bets.Outcome.Raw = Bets.Outcome.Raw + 1
						Bets.Outcome.Cash = Bets.Won.Cash - Bets.Lost.Cash
						if (Bets.Outcome.Cash > 0) then
							HEADS_UP_DISPLAY.BETS.OUTCOME.AMOUNT:SetTextColor(107, 142, 35)
						elseif (Bets.Outcome.Cash == 0) then
							HEADS_UP_DISPLAY.BETS.OUTCOME.AMOUNT:SetTextColor(255, 255, 255)
						else
							HEADS_UP_DISPLAY.BETS.OUTCOME.AMOUNT:SetTextColor(178, 34, 34)
						end
						HEADS_UP_DISPLAY.BETS.OUTCOME.AMOUNT:SetText(tostring(Bets.Outcome.Raw)..' ('..tostring((Bets.Outcome.Cash/1000))..'k)')
						if _Statistics_UseLog and Casino_StatisticsFile then
							Casino_StatisticsFile:write(os.date()..','..Bets.Outcome.Raw..','..Bets.Won.Raw..','..Bets.Lost.Raw..','..Bets.Outcome.Cash..','..Last_Player..','..Player_Option..','..data..','..Player_Balance..','..(Payment_Given_Check.Crystal_Amount*10000+Payment_Given_Check.Platinum_Amount*100)..'\n')
							Casino_StatisticsFile:flush()
						end
						if not Message then
							Message = Win_Messages[math.random(1, #Win_Messages)]
						end
					else
						if (Losing_Item_ID ~= 0) then
							Play_Instrument_Signal = -1
						end
						Bets.Won.Raw = Bets.Won.Raw + 1
						Bets.Won.Cash = Bets.Won.Cash + Player_Balance
						HEADS_UP_DISPLAY.BETS.WON.AMOUNT:SetText(tostring(Bets.Won.Raw)..' ('..tostring(Bets.Won.Cash/1000)..'k)')
						Bets.Outcome.Raw = Bets.Outcome.Raw + 1
						Bets.Outcome.Cash = Bets.Won.Cash - Bets.Lost.Cash
						if (Bets.Outcome.Cash > 0) then
							HEADS_UP_DISPLAY.BETS.OUTCOME.AMOUNT:SetTextColor(107, 142, 35)
						elseif (Bets.Outcome.Cash == 0) then
							HEADS_UP_DISPLAY.BETS.OUTCOME.AMOUNT:SetTextColor(255, 255, 255)
						else
							HEADS_UP_DISPLAY.BETS.OUTCOME.AMOUNT:SetTextColor(178, 34, 34)
						end
						HEADS_UP_DISPLAY.BETS.OUTCOME.AMOUNT:SetText(tostring(Bets.Outcome.Raw)..' ('..tostring((Bets.Outcome.Cash/1000))..'k)')
						if _Statistics_UseLog and Casino_StatisticsFile then
							Casino_StatisticsFile:write(os.date()..','..Bets.Outcome.Raw..','..Bets.Won.Raw..','..Bets.Lost.Raw..','..Bets.Outcome.Cash..','..Last_Player..','..Player_Option..','..data..','..Player_Balance..',0\n')
							Casino_StatisticsFile:flush()
						end
						if not Message then
							Message = Lose_Messages[math.random(1, #Lose_Messages)]
						end
					end
					if PayCash then
						Message = Message:gsub('%[amount%]', (crystal_coins*10+platinum_coins*0.1)..'k')
					else
						Message = Message:gsub('%[amount%]', (Player_Balance/1000)..'k')
					end
					SendMessage(Last_Player, Message, false)
				end
			end
		end
		Mod:Delay(WorkloadExecutionInterval()*200)
	end)

	Module('RollSystem', function(Mod)
		if Casino_Loaded then
			if Processing_Data then
				if Pay_Cash_Signal ~= 0 then
					if Dice_Rolled_Check == 1 then
						if not (Blackjack and Blackjack_In_Progress) and
							not (Sum_Of_Numbers and Sum_Of_Numbers_In_Progress) and
							not (Beat_That and Beat_That_In_Progress) and
							not (Highest_Lowest and Highest_Lowest_In_Progress) and
							not (Sequence and Sequence_In_Progress) then
							Roll_Dice_Signal = false
							Dice_Rolled_Check = 0
						end
					end
				else
					if Roll_Dice_Signal then
						ProcessDebugMessage('Casino Debugger', 'Roll System signal acknowledged | Balance is '..Player_Balance..' ('..(Player_Balance/1000)..'k)')
						for diceInLocker = 0, Containers.Locker:ItemCount()-1 do
							if diceInLocker > 28 then
								diceInLocker = 28
							end
							local tempDice = Containers.Locker:GetItemData(diceInLocker)
							if table.contains(Dice_IDs, tempDice.id) then
								Dice_Rolled_Check = Containers.Locker:UseItem(diceInLocker, true)
								break
							end
						end
					end
				end
			end
		end
		Mod:Delay(WorkloadExecutionInterval()*800)
	end)
	Module('CountCash', function(Mod)
		if Casino_Loaded then
			if Processing_Data then
				if Count_Cash_Signal then
					ProcessDebugMessage('Casino Debugger', 'Signal to organize cash acknowledged')
					local prevAmount = Last_Amount.Crystal + Last_Amount.Platinum + Last_Amount.Items
					Last_Amount.Crystal = Count_Crystal_Extended() * 10000
					Last_Amount.Platinum = Count_Platinum_Extended() * 100
					Last_Amount.Items = 0
					if Accept_Items then
						for indexItem=0, Containers.Items:ItemCount()-1 do
							local tempItem = Containers.Items:GetItemData(indexItem)
							for _, Accepted_Item in ipairs(Accepted_Items_List) do
								if Accepted_Item.ID == tempItem.id then
									Last_Amount.Items = Last_Amount.Items + (Accepted_Item.Value * tempItem.count)
								end
							end
						end
					end
					local newAmount = Last_Amount.Crystal + Last_Amount.Platinum + Last_Amount.Items
					if (Authenticate_Cash_Check == math.abs(newAmount - prevAmount)) then
						Player_Balance = Authenticate_Cash_Check
						Roll_Dice_Signal = true
					else
						Player_Balance = 0
						ProcessDebugMessage('Casino Debugger', 'Found inconsistent amounts ['..Authenticate_Cash_Check..']['..math.abs(newAmount-prevAmount)..']. Giving cash back')
						local cashBack = math.abs(newAmount-prevAmount)
						local crystal_coins = 0
						local platinum_coins = 0
						while cashBack >= 10000 do
							crystal_coins = crystal_coins + 1
							cashBack = cashBack - 10000
						end
						while cashBack >= 100 do
							platinum_coins = platinum_coins + 1
							cashBack = cashBack - 100
						end
						SkipRollingProcess = true
						Payment_Given_Check.Crystal_Amount = crystal_coins
						Payment_Given_Check.Platinum_Amount = platinum_coins
						Payment_Give_Signal = true
					end
					Count_Cash_Signal = false
				end
			end
		end
		Mod:Delay(WorkloadExecutionInterval()*200)
	end)

	Module('TakeFromCounter', function(Mod)
		if Casino_Loaded then
			if Processing_Data then
				if Take_Cash_Signal then
					local acceptedItemsOnCounter = false
					if Accept_Items then
						for itemOnCounter = Containers.Counter:ItemCount()-1,0,-1 do
							if itemOnCounter > 28 then
								itemOnCounter = 28
							end
							for _, Accepted_Item in ipairs(Accepted_Items_List) do
								if Accepted_Item.ID == Containers.Counter:GetItemData(itemOnCounter).id then
									acceptedItemsOnCounter = true
									break
								end
							end
						end
					end
					if Count_Extended(Containers.Counter, Money_IDs) > 0 or acceptedItemsOnCounter then
						ProcessDebugMessage('Casino Debugger', 'Signal to take cash from counter acknowledged')
						for itemOnCounter = Containers.Counter:ItemCount()-1,0,-1 do
							if itemOnCounter > 28 then
								itemOnCounter = 28
							end
							local tempItem = Containers.Counter:GetItemData(itemOnCounter)
							if (tempItem.id == 3035) then
								for _, container_Platinum in ipairs(Containers.Platinum) do
									if container_Platinum:EmptySlots() > 2 then
										Containers.Counter:MoveItemToContainer(itemOnCounter,container_Platinum:Index(),0,tempItem.count)
										break
									end
								end
							elseif (tempItem.id == 3043) then
								for _, container_Crystal in ipairs(Containers.Crystal) do
									if container_Crystal:EmptySlots() > 2 then
										Containers.Counter:MoveItemToContainer(itemOnCounter,container_Crystal:Index(),0,tempItem.count)
										break
									end
								end
							else
								if Accept_Items then
									for _, Accepted_Item in ipairs(Accepted_Items_List) do
										if Accepted_Item.ID == tempItem.id then
											Containers.Counter:MoveItemToContainer(itemOnCounter,Containers.Items:Index(),Containers.Items:ItemCapacity()-1,tempItem.count)
										end
									end
								end
							end
						end
					else
						Take_Cash_Signal = false
						Count_Cash_Signal = true
					end
				end
			end
		end
		Mod:Delay(WorkloadExecutionInterval()*200)
	end)
	Signal.OnReceive('LocalProxySignal', function(signal, data)
		LocalProxyMessage = data
	end)
	Module('LocalProxySystem', function(Mod)
		if LocalProxyMessage then
			local mtype = LocalProxyMessage["MessageType"]
			local speaker = LocalProxyMessage["Speaker"]
			local level = LocalProxyMessage["Level"]
			local text = LocalProxyMessage["Text"]:lower():trim()
			if _Remote_Status then
				if (table.contains(_Remote_AdminName, speaker:lower())) then
					if text == _Remote_OutcomeCommand:lower() then
						local OutcomeMessage = 'The outcome of the script is '..(Bets.Outcome.Cash/1000)..'k' 
						SendPrivateMessage(OutcomeMessage, speaker, true)
					elseif text == _Remote_DiceAndDecoCommand:lower() then
						local DecoAmount = Self.ItemCount(_Decoration_Item_ID)
						local DiceAmount = 0
						for _, id in ipairs(Dice_IDs) do
							DiceAmount = DiceAmount + Self.ItemCount(id)
						end
						local DiceAndDecoMessage = string.format('I have %s dice and %s items for decoration', DiceAmount, DecoAmount)
						SendPrivateMessage(DiceAndDecoMessage, speaker, true)
					elseif text == _Remote_EmptyContainersCommand:lower() then
						local FullAmount = 0
						for _, container_Platinum in ipairs(Containers.Platinum) do
							for itemPlatinumCoin = container_Platinum:ItemCount() - 1, 0, -1 do
								if container_Platinum:EmptySlots() <= 2 then
									FullAmount = FullAmount + 1
								end
							end
						end
						local EmptyContainers = string.format('I have %s empty containers for platinum coins', #Containers.Platinum - FullAmount)
						SendPrivateMessage(EmptyContainers, speaker, true)
					elseif text == _Remote_CashCommand:lower() then
						local AvailableCash = 'The available cash to gamble is '..(Count_Crystal_Extended()*10)..'k in crystal coins and '..(Count_Platinum_Extended()/10)..'k in platinum coins'
						SendPrivateMessage(AvailableCash, speaker, true)
					elseif text == _Remote_ItemsCommand:lower() then
						local ItemsValue = 'There are '..Total.Items.Amount..' items and they are worth '..(Total.Items.Value/1000)..'k'
						SendPrivateMessage(ItemsValue, speaker, true)
					elseif text == _Remote_StartCommand:lower() then
						Casino_Loaded = false
						PickUpDiceAndDecoration()
						if not Blackjack and
							not High_Low and
							not Odd_Even and
							not First_Second_Last and
							not Single_Numbers and
							not Highest_Lowest and
							not Sequence and
							not Pair_Of_Numbers and
							not Sum_Of_Numbers and
							not Beat_That then
							SendPrivateMessage('You don\'t accept any game type. Please, check your settings and reload the script', speaker, true)
						else
							if UpdateCoordinates() then
								if Open_Containers() then
									CheckDiceAndDecoration()
									Last_Activity = os.time()
									Total.Items.LastAmountSeen = 0
									Total.Items.Amount = 0
									Total.Items.Value = 0
									Casino_Loaded = true
									ManualStop = false
									SendPrivateMessage('The script has been started upon request', speaker, true)
								end
							else
								SendPrivateMessage('The script failed to find location', speaker, true)
							end
						end
					elseif text == _Remote_StopCommand:lower() then
						Casino_Loaded = false
						ManualStop = true
						PickUpDiceAndDecoration()
						while #Container.GetAll() > 0 do
							for i = 0, 15 do
								closeContainer(i)
							end
						end
						SendPrivateMessage('The script has been stopped upon request', speaker, true)
					elseif text == _Remote_NewDepotCommand:lower() then
						SendPrivateMessage('Processing your request to find a new depot', speaker, true)
						Casino_Loaded = false
						PickUpDiceAndDecoration()
						if Self.Position().z == 7 then
							gotoLabel('GroundFloor')
						elseif Self.Position().z == 6 then
							GoCheckDown = true
							gotoLabel('FirstFloor')
						end
						setWalkerEnabled(true)
					elseif text == _Remote_BackupProfitCommand:lower() then
						local pos = Self.Position()
						local DepotFound = false
						local Locker = nil
						local Depot = nil
						local Parcel = nil
						local Tracker = 0
						local ParcelTracker = false
						local PlatinumTracker = -1

						local function DistanceFromCoordinates(first, second)
							return math.max(math.max(math.abs(first.x - second.x), math.abs(first.y - second.y)), math.abs(first.z - second.z))
						end

						local function OpenNextContainer()
							while (Parcel:isFull()) do
								for spotparcel = Parcel:ItemCount() - 1, 0, -1  do
									local itemparcel = Parcel:GetItemData(spotparcel)
									if (Item.isContainer(itemparcel.id)) then
										Parcel:UseItem(spotparcel, true)
										wait(500)
										break
									end
								end
							end
						end

						local function MoveItems(backwards)
							local Target_Container = Container(Tracker + 1)
							if (backwards) then
								for spotarget = Target_Container:ItemCount()-1, 0, -1 do
									local itemtarget = Target_Container:GetItemData(spotarget)
									if (not table.contains(Dice_IDs, itemtarget.id)) then
										if (not Item.isContainer(itemtarget.id)) then
											Target_Container:MoveItemToContainer(spotarget, Parcel:Index(), Parcel:ItemCapacity() -1)
											wait(1000)
											OpenNextContainer()
										end
									end
								end
							else
								for spotarget = 0, Target_Container:ItemCount()-1 do
									local itemtarget = Target_Container:GetItemData(spotarget)
									if (not table.contains(Dice_IDs, itemtarget.id)) then
										if (not Item.isContainer(itemtarget.id)) then
											Target_Container:MoveItemToContainer(spotarget, Parcel:Index(), Parcel:ItemCapacity() -1)
											wait(1000)
											OpenNextContainer()
											break
										end
									end
								end
							end
						end

						for _, location in ipairs(Gambling_Depots.Yalahar) do
							if (pos.x == location['HouseSwitch'][1] and pos.y == location['HouseSwitch'][2] and pos.z == location['HouseSwitch'][3]) then
								for i = 0, 15 do
									closeContainer(i)
								end
								if (Self.BrowseField(location['HouseDepot'][1],location['HouseDepot'][2],location['HouseDepot'][3]) == 1) then
									wait(1000)
									Locker = Container(Tracker)
									Tracker = Tracker + 1
									Locker:OpenChildren({Locker:GetItemData(0).id, false})
									wait(1000)
									if (Container(Tracker):UseItem(0, true) == 1) then
										wait(1000)
										Depot = Container(Tracker)
										wait(1000)
										local bponcounter = Map.GetTopMoveItem(location['Counter'][1], location['Counter'][2], location['Counter'][3])
										if (Item.GetName(bponcounter.id):lower() == _Remote_BackupContainer:lower()) then
											Map.PickupItem(location['Counter'][1], location['Counter'][2], location['Counter'][3], Depot:Index(), Depot:ItemCapacity()-1)
											wait(1000)
										end
										for spot, item in Depot:iItems() do
											if (Item.isContainer(item.id)) then
												if (Item.GetName(item.id):lower() == _Remote_BackupContainer:lower() and not ParcelTracker) then
													Depot:OpenChildren({Depot:GetItemData(spot).id, false})
													wait(1000)
													Tracker = Tracker + 1
													Parcel = Container(Tracker)
													ParcelTracker = true
													for s = Parcel:ItemCount() - 1, 0, -1  do
														local ditem = Parcel:GetItemData(s)
														if Item.isContainer(ditem.id) then
															Parcel:UseItem(s, true)
															wait(1000)
															break
														end
													end
												elseif (PlatinumTracker == -1 and (Item.GetName(item.id):lower() == _Containers_PlatinumCoins:lower())) then
													PlatinumTracker = spot
												elseif (ParcelTracker) then
													if (PlatinumTracker == -1 or (PlatinumTracker ~= -1 and PlatinumTracker ~= spot)) then
														Depot:UseItem(spot, false)
														wait(1000)
														local Target_Container = Container(Tracker + 1)
														local Crystal_Count = Target_Container:CountItemsOfID(3043)
														while (Crystal_Count > _Remote_BackupCrystalCoins) do
															MoveItems(false)
															Crystal_Count = Target_Container:CountItemsOfID(3043)
														end
														if (Target_Container:CountItemsOfID(3043) == 0) then
															while (Target_Container:ItemCount() > 0) do
																MoveItems(true)
																local die_count = 0
																for _, die in ipairs(Dice_IDs) do
																	die_count = die_count + Target_Container:CountItemsOfID(die)
																end
																if (Target_Container:Name():lower() == _Containers_Items:lower()) then
																	if ((Target_Container:ItemCount() == 1) or (Target_Container:ItemCount() == die_count + 1)) then
																		for s = Target_Container:ItemCount() - 1, 0, -1  do
																			local ditem = Target_Container:GetItemData(s)
																			if Item.isContainer(ditem.id) then
																				Target_Container:UseItem(s, true)
																				wait(1000)
																				break
																			end
																		end
																	end
																else
																	break
																end
															end
														end
														Target_Container:Close()
														wait(1000)
													end
												end
											end
										end
										Self.DropItems(location['Counter'][1], location['Counter'][2], location['Counter'][3], Item.GetID(_Remote_BackupContainer))
									end
									DepotFound = true
								end
								break
							end
						end
					end
				end
			end
			if Casino_Loaded then
				if not Processing_Data and not OpeningNestedContainers then
					local player = Creature(speaker)
					if (player:Position().x == Coordinates.Player.x and player:Position().y == Coordinates.Player.y and player:Position().z == Coordinates.Player.z) then
						local sudocmd = nil
						local Minimum_Cash = 0
						local Maximum_Cash = 0
						Player_Option = nil
						if (table.contains({'l','low','123','h','high','456'}, text) and High_Low) then
							Player_Option = text
							Minimum_Cash = High_Low_Minimum
							Maximum_Cash = High_Low_Maximum
						elseif (table.contains({'odd','135','even','246'}, text) and Odd_Even) then
							Player_Option = text
							Minimum_Cash = Odd_Even_Minimum
							Maximum_Cash = Odd_Even_Maximum
						elseif (table.contains({'first','12','second','middle','34','last','56','third'}, text) and First_Second_Last) then
							Player_Option = text
							Minimum_Cash = First_Second_Last_Minimum
							Maximum_Cash = First_Second_Last_Maximum
						elseif (table.contains({'highest','lowest'}, text) and Highest_Lowest) then
							Player_Option = text
							Minimum_Cash = Highest_Lowest_Minimum
							Maximum_Cash = Highest_Lowest_Maximum
						elseif (table.contains({'sequence','seq','succession','series'}, text) and Sequence) then
							Player_Option = 'sequence'
							Minimum_Cash = Sequence_Minimum
							Maximum_Cash = Sequence_Maximum
						elseif (table.contains({'13','14','15','16','23','24','25','26','31','32','35','36','41','42','45','46','51','52','53','54','61','62','63','64'}, text) and Pair_Of_Numbers) then
							Player_Option = text
							Minimum_Cash = Pair_Of_Numbers_Minimum
							Maximum_Cash = Pair_Of_Numbers_Maximum
						elseif (table.contains({'1','2','3','4','5','6'},text) and Single_Numbers) then
							Player_Option = text
							Minimum_Cash = Single_Numbers_Minimum
							Maximum_Cash = Single_Numbers_Maximum
						elseif (table.contains({'blackjack'}, text) and Blackjack) then
							Player_Option = text
							Minimum_Cash = Blackjack_Minimum
							Maximum_Cash = Blackjack_Maximum
						elseif (table.contains({'min', 'max', 'minimum', 'maximum'}, text)) then
							Player_Option = 'limits'
						elseif table.contains({'rate', 'rates', 'payout', 'payouts'}, text) then
							Player_Option = 'payout'
						elseif (table.contains({'games'}, text)) then
							Player_Option = text
						elseif (table.contains({'blackjack rules', 'high/low rules', 'highest/lowest rules', 'odd/even rules', 'first/second/last rules', 'sequence rules', 'pair of numbers rules', 'single numbers rules', 'sum of numbers rules', 'beat that rules', 'blackjack instructions', 'high/low instructions', 'highest/lowest instructions', 'odd/even instructions', 'first/second/last instructions', 'sequence instructions', 'pair of numbers instructions', 'single numbers instructions', 'sum of numbers instructions', 'beat that instructions', 'blackjack info', 'high/low info', 'highest/lowest info', 'odd/even info', 'first/second/last info', 'sequence info', 'pair of numbers info', 'single numbers info', 'sum of numbers info', 'beat that info'}, text)) then
							Player_Option = text
						else
							local PriceRequest = false
							local SumRequest = false
							local BeatThatRequest = false
							for _, Accepted_Item in ipairs (Accepted_Items_List) do
								local itemName = Item.GetName(Accepted_Item.ID):lower()
								local item = string.match(text, 'price '..itemName)
								if item then
									PriceRequest = true
									SendMessage(speaker, 'I accept a '..itemName..' as bet for '..(Accepted_Item.Value/1000)..'k', false)
									
									Last_Activity_Player_In_Spot = os.time()
									ProcessDebugMessage('Casino Debugger', speaker..' chose option "'..text..'"')
									Player_Option = nil
								end
							end
							if not PriceRequest then
								local SumKeyword, SumNumber = text:match('^(sum) (%d+)$')
								if SumKeyword and SumNumber then
									SumNumber = SumNumber + 0
									SumRequest = true
									if SumNumber >= 1 and SumNumber <= Sum_Of_Numbers_Maximum_Rolls*6 then
										Game_Types.Sum.Choice = SumNumber
										Player_Option = SumKeyword
										Minimum_Cash = Sum_Of_Numbers_Minimum
										Maximum_Cash = Sum_Of_Numbers_Maximum
									else
										SendMessage(speaker, 'The number for "sum" game must be between 1 and '..(Sum_Of_Numbers_Maximum_Rolls*6), false)
										
										Last_Activity_Player_In_Spot = os.time()
										ProcessDebugMessage('Casino Debugger', speaker..' chose option "'..text..'"')
										Player_Option = nil
									end
								end
							end
							if not SumRequest then
								local BeatThatKeyword, BeatThatNumber = text:match('^(beat that) (%d+)$')
								if BeatThatKeyword and BeatThatNumber then
									BeatThatNumber = BeatThatNumber + 0
									BeatThatRequest = true
									if BeatThatNumber >= 11 and BeatThatNumber <= 66 then
										Game_Types.BeatThat.Choice = BeatThatNumber
										Player_Option = BeatThatKeyword
										Minimum_Cash = Beat_That_Minimum
										Maximum_Cash = Beat_That_Maximum
									else
										SendMessage(speaker, 'The guessed number for "beat that" game must be between 11 and 66', false)
										
										Last_Activity_Player_In_Spot = os.time()
										ProcessDebugMessage('Casino Debugger', speaker..' chose option "'..text..'"')
										Player_Option = nil
									end
								end
							end
						end
						if Player_Option then
							Last_Activity_Player_In_Spot = os.time()
							ProcessDebugMessage('Casino Debugger', speaker..' chose option "'..Player_Option..'"')
							if Player_Option == 'limits' then
								local LimitsMessage = 'The limits for each game type are'
								local availableGames = {}
								if Blackjack then
									table.insert(availableGames, {'blackjack', Blackjack_Minimum, Blackjack_Maximum})
								end
								if High_Low then
									table.insert(availableGames, {'high/low', High_Low_Minimum, High_Low_Maximum })
								end
								if Odd_Even then
									table.insert(availableGames, {'odd/even', Odd_Even_Minimum, Odd_Even_Maximum })
								end
								if First_Second_Last then
									table.insert(availableGames, {'first/second/last', First_Second_Last_Minimum, First_Second_Last_Maximum })
								end
								if Single_Numbers then
									table.insert(availableGames, {'single numbers', Single_Numbers_Minimum, Single_Numbers_Maximum })
								end
								if Highest_Lowest then
									table.insert(availableGames, {'highest/lowest', Highest_Lowest_Minimum, Highest_Lowest_Maximum })
								end
								if Sequence then
									table.insert(availableGames, {'sequence', Sequence_Minimum, Sequence_Maximum })
								end
								if Pair_Of_Numbers then
									table.insert(availableGames, {'pair of numbers', Pair_Of_Numbers_Minimum, Pair_Of_Numbers_Maximum })
								end
								if Sum_Of_Numbers then
									table.insert(availableGames, {'sum of numbers', Sum_Of_Numbers_Minimum, Sum_Of_Numbers_Maximum })
								end
								if Beat_That then
									table.insert(availableGames, {'beat that', Beat_That_Minimum, Beat_That_Maximum })
								end
								for iterator, game in ipairs(availableGames) do
									if iterator == #availableGames-1 then
										LimitsMessage = LimitsMessage..' '..(game[2]/1000)..'k - '..(game[3]/1000)..'k '..game[1]..' and'
									elseif iterator == #availableGames then
										LimitsMessage = LimitsMessage..' '..(game[2]/1000)..'k - '..(game[3]/1000)..'k '..game[1]
									else
										LimitsMessage = LimitsMessage..' '..(game[2]/1000)..'k - '..(game[3]/1000)..'k '..game[1]..','
									end
								end
								SendMessage(speaker, LimitsMessage, false)
								
								Player_Option = nil
							elseif table.contains({'blackjack rules', 'blackjack info', 'blackjack instructions'}, Player_Option) then
								SendMessage(speaker, 'In the "Blackjack" game the first 5 rolls sum is your count, the last 5 rolls sum is mine. The count that is closer to 21 wins. You get busted if the count is higher than 21', false)
								
								Player_Option = nil
							elseif table.contains({'high/low rules', 'high/low info', 'high/low instructions'}, Player_Option) then
								SendMessage(speaker, '"High/Low" is a game where you try to guess the next roll. If you say "high" and the next roll is 4, 5 or 6 or if you say "low" and the roll is 1, 2 or 3 then you win', false)
								
								Player_Option = nil
							elseif table.contains({'highest/lowest rules', 'highest/lowest info', 'highest/lowest instructions'}, Player_Option) then
								SendMessage(speaker, 'In "Highest/lowest" there are 2 counts, first count and second count. This is a game where you try to guess which count will get the highest or lowest sum. The number of rolls for each count is '..(Highest_Lowest_Rolls / 2), false)
								
								Player_Option = nil
							elseif table.contains({'odd/even rules', 'odd/even info', 'odd/even instructions'}, Player_Option) then
								SendMessage(speaker, 'The game "Odd/Even" is just like High/Low but in this one you try to guess if the next roll is an odd number (1, 3 or 5) or an even number (2, 4 or 6)', false)
								
								Player_Option = nil
							elseif table.contains({'first/second/last rules', 'first/second/last info', 'first/second/last instructions'}, Player_Option) then
								SendMessage(speaker, '"First/Second/Last" is a game where you try to guess the next roll. In this game you can say 1 out of 3 commands. First means: 1 or 2. Second means: 3 or 4. Last means: 5 or 6', false)
								
								Player_Option = nil
							elseif table.contains({'sequence rules', 'sequence info', 'sequence instructions'}, Player_Option) then
								SendMessage(speaker, 'The "Sequence" game is about getting a sequence with 3 rolls. For example: 123, 234, 345 or 456. You can also get an inverted sequence: 654, 543, 432, 321', false)
								
								Player_Option = nil
							elseif table.contains({'pair of numbers rules', 'pair of numbers info', 'pair of numbers instructions'}, Player_Option) then
								SendMessage(speaker, '"Pair Of Numbers" is a game is where you try to guess the next roll by saying 2 different numbers that are not close to each other or repeated. For example: 13, 25 or 64', false)
								
								Player_Option = nil
							elseif table.contains({'single numbers rules', 'single numbers info', 'single numbers instructions'}, Player_Option) then
								SendMessage(speaker, '"Single Numbers" is a simple game. Say a number between 1 and 6 that you think will result in the roll', false)
								
								Player_Option = nil
							elseif table.contains({'sum of numbers rules', 'sum of numbers info', 'sum of numbers instructions'}, Player_Option) then
								SendMessage(speaker, 'The "Sum" game is about adding rolls. If you say "sum 8" then only 2 rolls are needed to sum the number 8. You can try to guess a number between 1 and '..(Sum_Of_Numbers_Maximum_Rolls*6)..'. The higher the number the more the payout percent', false)
								
								Player_Option = nil
							elseif table.contains({'beat that rules', 'beat that info', 'beat that instructions'}, Player_Option) then
								SendMessage(speaker, 'In the "Beat That" game you guess two numbers that will land in a row. For example, if you say "Beat That 15", it means that the rolls will be the number 1 followed by the number 5', false)
								
								Player_Option = nil
							elseif Player_Option == 'games' then
								local availableGames = {}
								local strAvailableGames = ''
								if Blackjack then
									table.insert(availableGames, 'blackjack')
								end
								if High_Low then
									table.insert(availableGames, 'high/low')
								end
								if Odd_Even then
									table.insert(availableGames, 'odd/even')
								end
								if First_Second_Last then
									table.insert(availableGames, 'first/second/last')
								end
								if Single_Numbers then
									table.insert(availableGames, 'single numbers')
								end
								if Highest_Lowest then
									table.insert(availableGames, 'highest/lowest')
								end
								if Sequence then
									table.insert(availableGames, 'sequence')
								end
								if Pair_Of_Numbers then
									table.insert(availableGames, 'pair of numbers')
								end
								if Sum_Of_Numbers then
									table.insert(availableGames, 'sum of numbers')
								end
								if Beat_That then
									table.insert(availableGames, 'beat that')
								end
								for iterator, game in ipairs(availableGames) do
									if iterator == #availableGames-1 then
										strAvailableGames = strAvailableGames..game..' and '
									elseif iterator == #availableGames then
										strAvailableGames = strAvailableGames..game
									else
										strAvailableGames = strAvailableGames..game..', '
									end
								end
								SendMessage(speaker, 'You can play '..strAvailableGames..' with me', false)
								
								Player_Option = nil
							elseif Player_Option == 'payout' then
								local PayoutMessage = 'The payout for each game type is'
								local availableGames = {}
								if Blackjack then
									table.insert(availableGames, {'blackjack', Blackjack_Payout})
								end
								if High_Low then
									table.insert(availableGames, {'high/low', High_Low_Payout })
								end
								if Odd_Even then
									table.insert(availableGames, {'odd/even', Odd_Even_Payout})
								end
								if First_Second_Last then
									table.insert(availableGames, {'first/second/last', First_Second_Last_Payout})
								end
								if Single_Numbers then
									table.insert(availableGames, {'single numbers', Single_Numbers_Payout})
								end
								if Highest_Lowest then
									table.insert(availableGames, {'highest/lowest', Highest_Lowest_Payout })
								end
								if Sequence then
									table.insert(availableGames, {'sequence', Sequence_Payout })
								end
								if Pair_Of_Numbers then
									table.insert(availableGames, {'pair of numbers', Pair_Of_Numbers_Payout })
								end
								if Sum_Of_Numbers then
									table.insert(availableGames, {'sum of numbers', Sum_Of_Numbers_Payout })
								end
								if Beat_That then
									table.insert(availableGames, {'beat that', Beat_That_Payout })
								end
								for iterator, game in ipairs(availableGames) do
									if iterator == #availableGames-1 then
										PayoutMessage = PayoutMessage..' '..game[2]..'% '..game[1]..' and'
									elseif iterator == #availableGames then
										PayoutMessage = PayoutMessage..' '..game[2]..'% '..game[1]
									else
										PayoutMessage = PayoutMessage..' '..game[2]..'% '..game[1]..','
									end
								end
								SendMessage(speaker, PayoutMessage, false)
								
								Player_Option = nil
							else
								local ValueInItems = 0
								if Accept_Items then
									for indexItemCounter=0,Containers.Counter:ItemCount()-1 do
										if indexItemCounter > 28 then
											indexItemCounter = 28
										end
										local tempItemCounter = Containers.Counter:GetItemData(indexItemCounter)
										for _, Accepted_Item in ipairs(Accepted_Items_List) do
											if Accepted_Item.ID == tempItemCounter.id then
												ValueInItems = ValueInItems + (tempItemCounter.count * Accepted_Item.Value)
												break
											end
										end
									end
								end
								local platinumInCounter = Count_Extended(Containers.Counter, {3035})
								local crystalInCounter = Count_Extended(Containers.Counter, {3043})
								local totalCashInCounter = platinumInCounter * 100 + crystalInCounter * 10000 + ValueInItems
								local ItemCount = 0
								if Accept_Items then
									for indexCounter=0,Containers.Counter:ItemCount()-1 do
										local tempItemCounter = Containers.Counter:GetItemData(indexCounter)
										for _, Accepted_Item in ipairs(Accepted_Items_List) do
											if Accepted_Item.ID == tempItemCounter.id then
												ItemCount = ItemCount + 1
												break
											end
										end
									end
								end
								if (totalCashInCounter >= Minimum_Cash and totalCashInCounter <= Maximum_Cash and ((Accept_Items and ItemCount <= 5) or not Accept_Items)) then
									ProcessDebugMessage('Casino Debugger', 'The script started processing data')
									Last_Amount.Crystal = Count_Crystal_Extended() * 10000
									Last_Amount.Platinum = Count_Platinum_Extended() * 100
									Last_Amount.Items = 0
									if Accept_Items then
										for indexItemsContainer=0,Containers.Items:ItemCount()-1 do
											local tempItemsContainer = Containers.Items:GetItemData(indexItemsContainer)
											for _, Accepted_Item in ipairs(Accepted_Items_List) do
												if Accepted_Item.ID == tempItemsContainer.id then
													Last_Amount.Items = Last_Amount.Items + (tempItemsContainer.count * Accepted_Item.Value)
													break
												end
											end
										end
									end
									if table.contains({'blackjack'}, Player_Option) then
										Blackjack_In_Progress = true
									elseif table.contains({'sum'}, Player_Option) then
										Sum_Of_Numbers_In_Progress = true
									elseif table.contains({'beat that'}, Player_Option) then
										Beat_That_In_Progress = true
									elseif table.contains({'highest', 'lowest'}, Player_Option) then
										Highest_Lowest_In_Progress = true
									elseif table.contains({'sequence'}, Player_Option) then
										Sequence_In_Progress = true
									end
									Authenticate_Cash_Check = totalCashInCounter
									Processing_Data = true
									Take_Cash_Signal = true
								else
									if Accept_Items and ItemCount > 5 then
										SendMessage(speaker, "I'm sorry, I only accept 5 items per bet", false)
									else
										local InvalidBidMessage = Invalid_Bid[math.random(1,#Invalid_Bid)]
										local InformInvalidBid = false
										if table.contains({'l','low','123','h','high','456'}, Player_Option) then
											InvalidBidMessage = InvalidBidMessage:gsub('%[min%]', (High_Low_Minimum/1000)..'k'):gsub('%[max%]', (High_Low_Maximum/1000)..'k')
											InvalidBidMessage = InvalidBidMessage:gsub('%[game%]', 'high/low')
											InformInvalidBid = true
										elseif table.contains({'odd','135','even','246'}, Player_Option) then
											InvalidBidMessage = InvalidBidMessage:gsub('%[min%]', (Odd_Even_Minimum/1000)..'k'):gsub('%[max%]', (Odd_Even_Maximum/1000)..'k')
											InvalidBidMessage = InvalidBidMessage:gsub('%[game%]', 'odd/even')
											InformInvalidBid = true
										elseif table.contains({'first','12','second','middle','34','last','56','third'}, Player_Option) then
											InvalidBidMessage = InvalidBidMessage:gsub('%[min%]', (First_Second_Last_Minimum/1000)..'k'):gsub('%[max%]', (First_Second_Last_Maximum/1000)..'k')
											InvalidBidMessage = InvalidBidMessage:gsub('%[game%]', 'first/second/last')
											InformInvalidBid = true
										elseif table.contains({'1','2','3','4','5','6'},Player_Option) then
											InvalidBidMessage = InvalidBidMessage:gsub('%[min%]', (Single_Numbers_Minimum/1000)..'k'):gsub('%[max%]', (Single_Numbers_Maximum/1000)..'k')
											InvalidBidMessage = InvalidBidMessage:gsub('%[game%]', 'single numbers')
											InformInvalidBid = true
										elseif table.contains({'sum'}, Player_Option) then
											InvalidBidMessage = InvalidBidMessage:gsub('%[min%]', (Sum_Of_Numbers_Minimum/1000)..'k'):gsub('%[max%]', (Sum_Of_Numbers_Maximum/1000)..'k')
											InvalidBidMessage = InvalidBidMessage:gsub('%[game%]', 'sum of numbers')
											InformInvalidBid = true
										elseif table.contains({'beat that'}, Player_Option) then
											InvalidBidMessage = InvalidBidMessage:gsub('%[min%]', (Beat_That_Minimum/1000)..'k'):gsub('%[max%]', (Beat_That_Maximum/1000)..'k')
											InvalidBidMessage = InvalidBidMessage:gsub('%[game%]', 'beat that')
											InformInvalidBid = true
										elseif table.contains({'sequence'}, Player_Option) then
											InvalidBidMessage = InvalidBidMessage:gsub('%[min%]', (Sequence_Minimum/1000)..'k'):gsub('%[max%]', (Sequence_Maximum/1000)..'k')
											InvalidBidMessage = InvalidBidMessage:gsub('%[game%]', 'sequence')
											InformInvalidBid = true
										elseif table.contains({'highest', 'lowest'}, Player_Option) then
											InvalidBidMessage = InvalidBidMessage:gsub('%[min%]', (Highest_Lowest_Minimum/1000)..'k'):gsub('%[max%]', (Highest_Lowest_Maximum/1000)..'k')
											InvalidBidMessage = InvalidBidMessage:gsub('%[game%]', 'highest/lowest')
											InformInvalidBid = true
										elseif table.contains({'13','14','15','16','23','24','25','26','31','32','35','36','41','42','45','46','51','52','53','54','61','62','63','64'}, Player_Option) then
											InvalidBidMessage = InvalidBidMessage:gsub('%[min%]', (Pair_Of_Numbers_Minimum/1000)..'k'):gsub('%[max%]', (Pair_Of_Numbers_Maximum/1000)..'k')
											InvalidBidMessage = InvalidBidMessage:gsub('%[game%]', 'pair of numbers')
											InformInvalidBid = true
										elseif table.contains({'blackjack'}, Player_Option) then
											InvalidBidMessage = InvalidBidMessage:gsub('%[min%]', (Blackjack_Minimum/1000)..'k'):gsub('%[max%]', (Blackjack_Maximum/1000)..'k')
											InvalidBidMessage = InvalidBidMessage:gsub('%[game%]', 'blackjack')
											InformInvalidBid = true
										end
										if InformInvalidBid then
											SendMessage(speaker, InvalidBidMessage, false)
											
											Player_Option = nil
											Blackjack_In_Progress = false
										end
									end
								end
							end
						end
					end
				end
			end
			LocalProxyMessage = nil
		end
		Mod:Delay(WorkloadExecutionInterval()*200)
	end)
	Signal.OnReceive('EffectProxySignal', function(signal, data)
		EffectProxyMessage = data["Message"]
	end)
	
	Module('EffectProxySystem', function(Mod)
		if EffectProxyMessage then
			local message = EffectProxyMessage
			if Casino_Loaded then
				if Processing_Data then
					if Pay_Cash_Signal == 0 then
						if Roll_Dice_Signal then
							ProcessDebugMessage('Casino Debugger', 'The script finished processing data')
							local number = string.match(message, Self.Name()..' rolled a (.+).')
							if number then
								ProcessDebugMessage('Casino Debugger', 'The script started processing effects')
								ProcessDebugMessage('Casino Debugger', 'Effect Proxy received data | Message: '..message..' | Script loaded: '..tostring(Casino_Loaded)..' | Processing data: '..tostring(Processing_Data))
								if Blackjack and Blackjack_In_Progress then
									Blackjack_Roll_Count = Blackjack_Roll_Count + 1
									if Blackjack_Roll_Count >= 1 and Blackjack_Roll_Count <= 5 then
										Blackjack_Player_Count = Blackjack_Player_Count + number + 0
									elseif Blackjack_Roll_Count >= 6 and Blackjack_Roll_Count <= 10 then
										Blackjack_Dealer_Count = Blackjack_Dealer_Count + number + 0
										if Blackjack_Roll_Count == 10 then
											Roll_Dice_Signal = false
											Dice_Rolled_Check = 0
											Blackjack_Roll_Count = 0
											Pay_Cash_Signal = 1
										end
									end
								elseif Sum_Of_Numbers and Sum_Of_Numbers_In_Progress then
									Sum_Of_Numbers_Roll_Count = Sum_Of_Numbers_Roll_Count + 1
									Sum_Of_Numbers_Sum = Sum_Of_Numbers_Sum + number + 0
									if Sum_Of_Numbers_Roll_Count == math.ceil(Game_Types.Sum.Choice/6) then
										Roll_Dice_Signal = false
										Dice_Rolled_Check = 0
										Sum_Of_Numbers_Roll_Count = 0
										Pay_Cash_Signal = 1
									end
								elseif Beat_That and Beat_That_In_Progress then
									Beat_That_Roll_Count = Beat_That_Roll_Count + 1
									local strBeatThatCount = Beat_That_Sum..number
									Beat_That_Sum = strBeatThatCount + 0
									if Beat_That_Roll_Count == 2 then
										Roll_Dice_Signal = false
										Dice_Rolled_Check = 0
										Beat_That_Roll_Count = 0
										Pay_Cash_Signal = 1
									end
								elseif Highest_Lowest and Highest_Lowest_In_Progress then
									Highest_Lowest_Roll_Count = Highest_Lowest_Roll_Count + 1
									if Highest_Lowest_Roll_Count >= 1 and Highest_Lowest_Roll_Count <= (Highest_Lowest_Rolls/2) then
										Highest_Lowest_First_Sum = Highest_Lowest_First_Sum + number + 0
									elseif Highest_Lowest_Roll_Count >= ((Highest_Lowest_Rolls/2)+1) and Highest_Lowest_Roll_Count <= Highest_Lowest_Rolls then
										Highest_Lowest_Second_Sum = Highest_Lowest_Second_Sum + number + 0
										if Highest_Lowest_Roll_Count == Highest_Lowest_Rolls then
											Roll_Dice_Signal = false
											Dice_Rolled_Check = 0
											Highest_Lowest_Roll_Count = 0
											Pay_Cash_Signal = 1
										end
									end
								elseif Sequence and Sequence_In_Progress then
									Sequence_Roll_Count = Sequence_Roll_Count + 1
									local strSequenceCount = Sequence_Count..number
									Sequence_Count = strSequenceCount + 0
									if Sequence_Roll_Count == 3 then
										Roll_Dice_Signal = false
										Dice_Rolled_Check = 0
										Sequence_Roll_Count = 0
										Pay_Cash_Signal = 1
									end
								else
									Roll_Dice_Signal = false
									Pay_Cash_Signal = number + 0
								end
							end
						end
					end
				end
			end
			EffectProxyMessage = nil
		end
		Mod:Delay(WorkloadExecutionInterval()*200)
	end)
	print(InformationText)