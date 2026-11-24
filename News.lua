-- Azeroth After Dark news edition 2026-11-24. Written by the After Dark newsroom (tools/addon-news.mjs in
-- the show's app); replaced with every addon update. Don't edit by hand.
AzerothAfterDarkNews = {
  generated = 1795483345,
  edition = "2026-11-24",
  stories = {
    {
      id = "s45a14e7611",
      time = 1795482906,
      category = "Guides",
      headline = "Stealthblade dagger lets almost any class go stealth",
      dek = "A Sunken Temple area BoE grants a short Stealth to every dagger user, so Paladins are the only ones left out.",
      body = { "The Stealthblade, a level 44 main-hand dagger, has a Forever-only twist: non-Rogues can use it to enter Stealth out of combat. The catch is a 20 second duration, 50% slower movement and a 30 minute cooldown.", "For Rogues it instead raises effective stealth level by 2. Hunters, Mages, Priests, Warlocks, Druids and Shamans can all use it, so Paladins are the only class shut out.", "It drops from mobs in the Sunken Temple, and Icy Veins also points to Mummified and Cursed Atal'ai in the Swamp of Sorrows, at about a 0.2% rate. It is Bind on Equip, so the Auction House is the shortcut. One listing was going for 20 gold." },
      bullets = { "Non-Rogues: Stealth out of combat for 20 seconds at 50% movement speed.", "Rogues: effective stealth level raised by 2.", "30 minute cooldown; Bind on Equip.", "Drops from Sunken Temple mobs and Atal'ai in Swamp of Sorrows." },
      sources = {
        {
          name = "Icy Veins",
          url = "https://www.icy-veins.com/wow-forever/news/most-classes-can-stealth-with-this-boe-in-wow-forever/",
        },
        {
          name = "Icy Veins",
          url = "https://www.icy-veins.com/wow-forever/news/this-weapon-lets-you-stealth-without-needing-to-be-a-rogue/",
        },
      },
      images = {
        {
          file = "news\\s45a14e7611-1",
          credit = "Icy Veins",
        },
        {
          file = "news\\s45a14e7611-2",
          credit = "Icy Veins",
        },
        {
          file = "news\\s45a14e7611-3",
          credit = "Icy Veins",
        },
      },
    },
    {
      id = "s9c05f20e2b",
      time = 1795474858,
      category = "News",
      headline = "Players report armor debuffs do nothing in Forever dungeons",
      dek = "Sunder Armor, Faerie Fire, Expose Armor and Curse of Recklessness may not be boosting physical damage in dungeons.",
      body = { "Reports on the Classic WoW community GitHub say armor-reducing debuffs are not working in WoW: Forever dungeons. The combat log shows the target's armor going down, but players' and pets' physical hits are mitigated as if the debuff was never applied.", "It hits every level 60 dungeon checked so far, from Blackrock Spire and Stratholme to Scholomance, Dire Maul, Blackrock Depths, The Shaper's Terrace and Blackmaw Hold. NPC allies do benefit, and the debuffs work for players out in the open world.", "Blizzard has not confirmed it yet, and players say it may date back to Beta. Until then, Sunder Armor is still useful for threat, just not for damage inside dungeons." },
      bullets = { "Affected: Sunder Armor, Faerie Fire, Expose Armor and Curse of Recklessness.", "Player and pet physical damage ignores the armor drop in dungeons.", "Open world and NPC allies are not affected.", "Not yet confirmed by Blizzard." },
      sources = {
        {
          name = "Wowhead",
          url = "https://www.wowhead.com/news=383969/players-reporting-that-sunder-armor-effects-dont-work-in-wow-forever-dungeons",
        },
      },
      images = {
        {
          file = "news\\s9c05f20e2b-1",
          credit = "Wowhead",
        },
      },
    },
    {
      id = "sb01312ac57",
      time = 1795468840,
      category = "Hotfixes",
      headline = "Uldaman's Obsidian Sentinel drops loot again, vendor prices halved",
      dek = "Levelers can chase Pendulum of Doom again, but the quick vendor gold farm is now worth far less.",
      body = { "The Obsidian Sentinel in Uldaman has its loot table back after Blizzard stripped it out a couple of days ago to stop a fast max-level gold farm.", "There is a catch: the vendor price of its drops has been cut in half. Combined with the new limit of 5 dungeons per hour, Wowhead works it out to roughly 4.42 gold for about 7.5 minutes of farming.", "For anyone actually leveling through Uldaman, it is a win. The boss rewards gear again, Pendulum of Doom included." },
      bullets = { "Uldaman: Obsidian Sentinel rare drops restored to its loot table.", "Uldaman: vendor price of Obsidian Sentinel drops reduced 50%.", "Affected items include Rock Sentinel Slicer, Dark Golem Breastplate, White Obsidian Wand and Axe of Lingering Dread." },
      sources = {
        {
          name = "Wowhead",
          url = "https://www.wowhead.com/news=383968/uldaman-boss-drops-loot-again-but-item-vendor-price-nerfed",
        },
      },
      images = {
        {
          file = "news\\sb01312ac57-1",
          credit = "Wowhead",
        },
      },
    },
    {
      id = "s9a3560969a",
      time = 1795462742,
      category = "Hotfixes",
      headline = "World Buffs survive loading screens again, Fengus' Ferocity halved",
      dek = "Your world buffs now follow you into dungeons, but Dire Maul's spell power buff is weaker and none of them work in raids.",
      body = { "Good news for anyone who likes to buff up before a run: the bug that wiped world buffs every time you hit a loading screen is fixed. Grab a buff, zone into your dungeon, and it stays with you.", "The same round of hotfixes trimmed one of the Dire Maul Tribute buffs. Fengus' Ferocity now gives half the spell power it used to.", "Blizzard also flagged a long list of world buffs so they no longer work inside raid instances, which lines up with what their tooltips already said. Dungeons are fine, raids are off the table." },
      bullets = { "World Buffs: no longer removed when a loading screen triggers.", "Dire Maul Tribute: Fengus' Ferocity spell power cut 50%, to 115 from 230.", "Raids: Songflower Serenade, Warchief's Blessing and Rallying Cry of the Dragonslayer no longer work in raids.", "Raids: Spirit of Zandalar and Might of Stormwind no longer work in raids.", "Raids: every Sayge's Dark Fortune buff from the Darkmoon Faire no longer works in raids.", "Raids: Slip'kik's Savvy, Fengus' Ferocity and Mol'dar's Moxie no longer work in raids." },
      sources = {
        {
          name = "Wowhead",
          url = "https://www.wowhead.com/news=383967/world-buffs-now-persist-through-loading-screen-and-nerf-to-dire-maul-tribute",
        },
      },
      images = {
        {
          file = "news\\s9a3560969a-1",
          credit = "Wowhead",
        },
        {
          file = "news\\s9a3560969a-2",
          credit = "Wowhead",
          caption = "Warchief's Blessing in Ragefire Chasm dungeon.",
        },
      },
    },
    {
      id = "s5229c36a64",
      time = 1795460726,
      category = "News",
      headline = "Paladin and Warlock epic mount quests aren't granting riding skill",
      dek = "Finished your class mount chain but can't ride other fast mounts? Blizzard knows, and a fix is a day or two away.",
      body = { "Paladins and Warlocks who complete their epic mount questline are not getting the 150 riding skill that should come with it. Their class mounts still work, but other 100% speed mounts like the Cerulean Prideclaw are off limits.", "Blizzard has found the bug and confirmed it hits both classes. The fix needs another day or two.", "If you can't wait, you can still buy the riding skill the normal way like every other class. Otherwise, sit tight and it should be sorted soon." },
      bullets = { "Affects Paladins and Warlocks who finish the epic mount questline.", "Class mounts work; other 100% speed mounts don't.", "Blizzard says the fix needs another day or two.", "Buying the riding skill normally works as a workaround." },
      sources = {
        {
          name = "Wowhead",
          url = "https://www.wowhead.com/news=383965/blizzard-working-on-a-fix-for-paladin-and-warlocks-not-getting-epic-riding",
        },
        {
          name = "Icy Veins",
          url = "https://www.icy-veins.com/wow-forever/news/paladin-and-warlock-riding-skill-bug-fix-coming/",
        },
      },
      images = {
        {
          file = "news\\s5229c36a64-1",
          credit = "Wowhead",
        },
        {
          file = "news\\s5229c36a64-2",
          credit = "Icy Veins",
        },
      },
    },
    {
      id = "scfb8fd7a62",
      time = 1795458705,
      category = "Guides",
      headline = "Mages can craft the Coldflame Saber with the new Comprehend Scroll",
      dek = "A Mage-only sword with spell power and bonus fire damage on frozen targets is waiting, if you can find the right scroll.",
      body = { "The Coldflame Saber is a Mage-exclusive main-hand sword unlocked through the new Comprehend Scroll ability. It needs level 21, carries +7 intellect, adds up to 32 spell damage and healing, and its melee hits deal 98 extra fire damage to frozen targets.", "Step one: kill Baron Silverlaine in Shadowfang Keep until the Blade of Silverlaine drops. Step two: decipher Untranslated Scrolls of Comprehension level 15 or higher until you get the Scroll of the Saber. Some players got it fast, others needed close to 120 scrolls.", "Scrolls drop in the world or can be bought on the Auction House, but the Scroll of the Saber itself is Bind on Pickup. Use it on the Blade, wait out a roughly 10 second cast, and the Saber is yours." },
      bullets = { "Requires level 21 and Comprehension skill 15 or higher.", "Get Blade of Silverlaine from Baron Silverlaine in Shadowfang Keep.", "Decipher Untranslated Scrolls for the Bind on Pickup Scroll of the Saber.", "Comprehension rises about 5 points per character level." },
      sources = {
        {
          name = "Icy Veins",
          url = "https://www.icy-veins.com/wow-forever/news/mages-can-get-a-secret-weapon-in-wow-forever-with-the-new-scroll-deciphering-skill/",
        },
      },
      images = {
        {
          file = "news\\scfb8fd7a62-1",
          credit = "Icy Veins",
        },
        {
          file = "news\\scfb8fd7a62-2",
          credit = "Icy Veins",
        },
      },
    },
    {
      id = "s161d65b411",
      time = 1795451950,
      category = "News",
      headline = "Lockbox peeking and partial looting will return, Blizzard says",
      dek = "The lockbox change was only a stopgap; a proper fix is in the works, though there is no date yet.",
      body = { "Blizzard says the lockbox change that went live yesterday at 9:55 a.m. PST was a temporary measure, not the final word.", "The team is now working on a proper fix that brings back peeking inside lockboxes and partial looting, and makes them otherwise behave as intended. There is no ETA, but Blizzard says it will post when the fix is done.", "The stopgap likely came in response to the lockbox exploit found over the weekend. One side effect players noticed: junkboxes can no longer be partially looted and then turned in. Hang on to them for now." },
      bullets = { "The change went live yesterday at 9:55 a.m. PST as a temporary measure.", "The fix restores peeking and partial looting.", "No ETA yet; Blizzard will post when it lands.", "Junkboxes currently can't be partially looted and turned in." },
      sources = {
        {
          name = "Icy Veins",
          url = "https://www.icy-veins.com/wow-forever/news/your-wow-forever-lockboxes-will-get-peeking-and-partial-looting-back-blizzard-says/",
        },
        {
          name = "Wowhead",
          url = "https://www.wowhead.com/news=383963/blizzard-announces-lockbox-change-is-temporary-and-peeking-inside-lockboxes-will",
        },
      },
      images = {
        {
          file = "news\\s161d65b411-1",
          credit = "Icy Veins",
        },
        {
          file = "news\\s161d65b411-2",
          credit = "Wowhead",
        },
      },
    },
    {
      id = "s0493086909",
      time = 1795447831,
      category = "Community",
      headline = "200 dwarves of Clan Battlehammer march on Orgrimmar",
      dek = "A huge dwarf guild on the US RP-PvP realm has taken Thunder Bluff and set its sights on the Horde capital.",
      body = { "On WoW Forever's US RP-PvP ruleset, a guild called Clan Battlehammer has been putting on quite a show. Around 200 dwarves lined up in tight formation outside The Commons in Ironforge to guard their home city.", "Defense was only the start. The army struck Thunder Bluff and took it, then marched on the gates of Orgrimmar. Whether 200 stubborn dwarves could actually break the Horde capital is another question, but it is a sight worth seeing if you are on that realm tonight." },
      bullets = {},
      sources = {
        {
          name = "Icy Veins",
          url = "https://www.icy-veins.com/wow-forever/news/200-dwarves-lay-siege-to-orgrimmar-in-clan-battlehammer-assault/",
        },
      },
      images = {
        {
          file = "news\\s0493086909-1",
          credit = "Icy Veins",
        },
      },
    },
    {
      id = "se850d26fbc",
      time = 1795395637,
      category = "Hotfixes",
      headline = "Uldaman's Obsidian Sentinel stops dropping loot after gold farm",
      dek = "A favorite quick solo gold farm is gone, and with it the only way to build the Pendulum of Doom leveling weapon.",
      body = { "The Obsidian Sentinel, the Uldaman boss sitting just inside the back entrance, has had its blue loot table wiped. Solo farmers could reach him with no trash and finish a run in under five minutes, averaging around 1.77 gold per kill. Wowhead's test kill now coughs up only junk and Solid Stone.", "Blizzard has not listed the change in any hotfix post, but the target looks like the gold farm. The side effect hurts levelers: the Sentinel's Axe of Lingering Dread was one half of the Pendulum of Doom, combined with Ironaya's Axe of Inevitable Ruin. Without it, the Pendulum can no longer be made." },
      bullets = { "Uldaman: Obsidian Sentinel no longer drops any blue gear.", "Removed drops include Rock Sentinel Slicer, Dark Golem Breastplate, White Obsidian Wand and Axe of Lingering Dread.", "Pendulum of Doom can no longer be obtained, since one of its two axes is gone.", "Change was undocumented in Blizzard's hotfix posts." },
      sources = {
        {
          name = "Wowhead",
          url = "https://www.wowhead.com/news=383955/uldaman-boss-no-longer-drops-loot-nerf-targets-gold-farming-strategy",
        },
        {
          name = "Icy Veins",
          url = "https://www.icy-veins.com/wow-forever/news/blizzard-removes-uldaman-gold-farm-but-could-solo-dungeon-farming-be-next/",
        },
      },
      images = {
        {
          file = "news\\se850d26fbc-1",
          credit = "Wowhead",
        },
        {
          file = "news\\se850d26fbc-2",
          credit = "Wowhead",
          caption = "Obsidian Sentinel Loot",
        },
      },
    },
    {
      id = "s0af5a09740",
      time = 1795391897,
      category = "News",
      headline = "World Buffs vanishing on loading screens is a bug, fix promised",
      dek = "Warchief's Blessing, Might of Stormwind and DMT buffs drop on any loading screen for now, so keep them for the open world until the fix lands.",
      body = { "If your world buffs have been evaporating the second a loading screen pops, you are not imagining it. Warchief's Blessing, Might of Stormwind and the Dire Maul Tribute buffs were all being wiped on any load, including logging in, hearthing between cities, portals and dungeon entrances.", "That quietly killed the popular trick of carrying those buffs into dungeons or onto the other continent. Some players assumed Blizzard did it on purpose, but Senior Game Designer Aidan Moon said on X that it is not intended.", "According to Moon, the culprit was a fix for the Battle Shout from the Diamond Flask quest, which was recasting on every zone change and spreading from player to player. Patching that broke world buffs, and he said a fix was due the day after his November 22 post. Until it is confirmed live, avoid loading screens while buffed." },
      bullets = { "World Buffs: currently removed by any loading screen, including login, hearth, portals and dungeons.", "Aidan Moon confirmed it is a bug caused by a Diamond Flask Battle Shout fix.", "Once fixed, buffs should work again in dungeons and on the opposite continent. They still do not work in raids." },
      sources = {
        {
          name = "Icy Veins",
          url = "https://www.icy-veins.com/wow-forever/news/blizzard-accidentally-changed-world-buffs-in-wow-forever-making-them-disappear-during-loading-screens/",
        },
        {
          name = "Wowhead",
          url = "https://www.wowhead.com/news=383959/aidan-moon-announces-that-world-buffs-dropping-on-loading-screen-is-bug",
        },
        {
          name = "Wowhead",
          url = "https://www.wowhead.com/news=383954/world-buffs-removed-on-any-loading-screen-in-wow-forever",
        },
      },
      images = {
        {
          file = "news\\s0af5a09740-1",
          credit = "Icy Veins",
        },
        {
          file = "news\\s0af5a09740-2",
          credit = "Wowhead",
        },
        {
          file = "news\\s0af5a09740-3",
          credit = "Wowhead",
        },
      },
    },
    {
      id = "s675a4b09be",
      time = 1795384087,
      category = "Guides",
      headline = "Four echoes and a statue puzzle unlock the Scarlet Banner",
      dek = "A hidden Scarlet Monastery puzzle rewards a cosmetic campfire decoration that may matter more later on.",
      body = { "Campfires got a new trick in Forever: you can dress them up with extra features. One of them, the Scarlet Banner, is hidden behind a little scavenger hunt. Right now it is purely cosmetic, but it could pick up a use down the line.", "Collect four echoes, keep them in your bags and head into the Scarlet Monastery Library. Use each echo on its matching statue in the right order and a glowing item appears in the middle of the room. Get the order wrong and you will have to reset the instance." },
      bullets = { "Echoes: SM Graveyard, Gooch Farm in Arathi (62, 54), Dustwallow Marsh (63.7, 42.5), Swamp of Sorrows (16.8, 53.8).", "Statue order: Warrior with Swamp, Mage with Arathi, Paladin with Theramore, Priest with Graveyard.", "A wrong order means resetting the instance and starting over." },
      sources = {
        {
          name = "Icy Veins",
          url = "https://www.icy-veins.com/wow-forever/news/scarlet-monastery-has-a-hidden-scarlet-banner-reward-in-wow-forever-heres-how-to-get-it/",
        },
      },
      images = {
        {
          file = "news\\s675a4b09be-1",
          credit = "Icy Veins",
        },
        {
          file = "news\\s675a4b09be-2",
          credit = "Icy Veins",
        },
      },
    },
    {
      id = "s12cfe61cd9",
      time = 1795381335,
      category = "Guides",
      headline = "Sing to a frog on Zephras Isle to earn the Musical Gustjumper",
      dek = "A secret pet hides in the Skyborne starting zone, and you can grab it at level one if you dodge the locals.",
      body = { "Before you leave Zephras Isle, swing by the waterfalls at 51.5, 72.3 on the road from Thendal Village. A group of Musical Gustjumper frogs sits on a rock at the top, and a log next to it lets you hop up to them.", "Target a frog and use the /sing emote. It sings back, the rest vanish, and a new frog appears on the log. Interact with it and it is yours. You can do it at level one, but watch for the level 5 and 6 Prideclaw and Vuldren nearby." },
      bullets = { "Location: Zephras Isle, 51.5, 72.3, top of the waterfalls.", "Target a frog, type /sing, then interact with the frog that spawns on the log.", "Level 5 and 6 enemies patrol the area." },
      sources = {
        {
          name = "Icy Veins",
          url = "https://www.icy-veins.com/wow-forever/news/dont-leave-zephras-isle-without-finding-this-secret-pet-in-wow-forever/",
        },
      },
      images = {
        {
          file = "news\\s12cfe61cd9-1",
          credit = "Icy Veins",
        },
        {
          file = "news\\s12cfe61cd9-2",
          credit = "Icy Veins",
        },
        {
          file = "news\\s12cfe61cd9-3",
          credit = "Icy Veins",
        },
      },
    },
    {
      id = "saac2434284",
      time = 1795381203,
      category = "Hotfixes",
      headline = "Rogues can no longer peek inside lockboxes after reroll exploit",
      dek = "Opening a lockbox with auto-loot off now just loots it straight to your bags, closing a trick that could reroll the contents.",
      body = { "Rogues used to switch off auto-loot, pick a lockbox and take a look at what was inside before mailing it back to its owner. With Mithril Lockboxes holding pricey items like recipes, it was a fun bit of nosiness.", "Then a Reddit user found the contents shown to the peeking Rogue could differ from what the owner got after the box came back in the mail, meaning loot could be rerolled. A recent hotfix ends it: trying to peek now automatically loots the box into your inventory. Picking locks for other players still works, just no browsing." },
      bullets = { "Lockpicking: peeking inside an unlooted lockbox is no longer possible.", "Opening a lockbox now auto-loots its contents into your bags.", "Change follows reports that peeking could reroll lockbox contents." },
      sources = {
        {
          name = "Wowhead",
          url = "https://www.wowhead.com/news=383956/players-can-no-longer-peek-inside-lockboxes-due-to-reroll-exploit",
        },
      },
      images = {
        {
          file = "news\\saac2434284-1",
          credit = "Wowhead",
        },
      },
    },
    {
      id = "scb744c8b3c",
      time = 1795373544,
      category = "Guides",
      headline = "Forsaken Paladins can earn Wolfsbane, an exclusive two-hander",
      dek = "A hidden questline from level 18 ends in a rare weapon well ahead of normal quest rewards, if you can take down a level 25 elite.",
      body = { "Forsaken Paladins get a weapon nobody else can have. Wolfsbane is a rare, item level 31 two-hander with 69 to 105 damage, 3.40 speed, plus 9 Stamina and 10 Intellect. Its chance on hit blasts the target with Holystorm damage, and it hits Wolves and Worgen three times as hard.", "Start at level 18 by talking to Danitha Morr at Bandarion Keep in the Whispering Wood, Tirisfal Glades (around 22.0, 44.6). At level 20 you can take A Moon-Kissed Blade, forge the Moonsilver Blade, and finish by beating the level 25 elite worgen Old Fire-Eye." },
      bullets = { "Start: Danitha Morr, Bandarion Keep, Tirisfal Glades, level 18.", "Follow-up quest A Moon-Kissed Blade needs level 20.", "Final step: defeat Old Fire-Eye, a level 25 elite worgen." },
      sources = {
        {
          name = "Icy Veins",
          url = "https://www.icy-veins.com/wow-forever/news/forsaken-paladins-in-wow-forever-get-a-hidden-weapon-other-classes-cant-have/",
        },
      },
      images = {
        {
          file = "news\\scb744c8b3c-1",
          credit = "Icy Veins",
        },
        {
          file = "news\\scb744c8b3c-2",
          credit = "Icy Veins",
        },
      },
    },
    {
      id = "sc835e266be",
      time = 1795369748,
      category = "Guides",
      headline = "40 hidden books earn every class rings, amulets and a bow",
      dek = "Those books you keep walking past can be turned in at the library for real gear, and in Forever every class can claim the rewards.",
      body = { "Scattered across the world are 40 hidden books that most players spot and ignore. Hand them in and you get lore-heavy questlines plus actual gear. They came from Season of Discovery, where they were tied to a Mage rune, but in Forever any class can cash them in.", "There are four questlines at different book counts, and the last set needs you to be level 50. Alliance hands books to the Librarian in the Stormwind Mage Tower (49.0, 86.4); Horde goes to the Undercity Magic Quarter (74.0, 32.4). Mages also get the Study ability at level 6 for their first book." },
      bullets = { "10 books: Scholarly Pendant or Erudite's Amulet.", "20 books: Field Researcher's Loop or Philanthropist's Ring.", "25 books: Truthseeker's Bow, Crest of Elucidation or Researcher's Night Light.", "Books turn up in Arathi Highlands, Dustwallow Marsh, Alterac Mountains, The Barrens, Ironforge and more." },
      sources = {
        {
          name = "Icy Veins",
          url = "https://www.icy-veins.com/wow-forever/news/wow-forever-players-are-skipping-40-hidden-books-that-give-gear/",
        },
      },
      images = {
        {
          file = "news\\sc835e266be-1",
          credit = "Icy Veins",
        },
        {
          file = "news\\sc835e266be-2",
          credit = "Icy Veins",
        },
        {
          file = "news\\sc835e266be-3",
          credit = "Icy Veins",
        },
      },
    },
    {
      id = "s27eaea43eb",
      time = 1795359600,
      category = "Guides",
      headline = "Blackrock Depths lockpicking trick is out, Tyr's Hand is in",
      dek = "Rogues pushing Lockpicking to 300 should skip the old BRD door route and head to Eastern Plaguelands instead.",
      body = { "In Classic, Rogues took Lockpicking from 250 to 300 by working the Shadowforge doors and lock in Blackrock Depths. In Forever, testing shows the Shadowforge lock goes grey around 265, so that route stalls early.", "The new go-to is Tyr's Hand in Eastern Plaguelands, packed with elite mobs and Scarlet Footlockers to pick. It is worth the trouble: at 300 you can open the Dire Maul North door without the Crescent Key, plus earn some gold opening lockboxes for other players." },
      bullets = { "Shadowforge lock in BRD turns grey around Lockpicking 265.", "Best spot now: Scarlet Footlockers at Tyr's Hand, Eastern Plaguelands.", "300 Lockpicking opens the Dire Maul North door without the Crescent Key." },
      sources = {
        {
          name = "Wowhead",
          url = "https://www.wowhead.com/news=383884/the-best-way-to-level-lockpicking-to-max-in-wow-forever",
        },
      },
      images = {
        {
          file = "news\\s27eaea43eb-1",
          credit = "Wowhead",
        },
        {
          file = "news\\s27eaea43eb-2",
          credit = "Wowhead",
          caption = "Lockpicking Level 268",
        },
        {
          file = "news\\s27eaea43eb-3",
          credit = "Wowhead",
          caption = "Lockpicking in Tyr's Hand",
        },
      },
    },
  },
}
