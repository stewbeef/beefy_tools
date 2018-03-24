//Beefy_item_ext.ash extension for items

script "Beefy_item_ext.ash";

record item_ext
{
	item it;
	string [string] string_modifiers; // many are for evals
		//delevel_defense, delevel_attack -- delevels each round
		//delevel_defense, delevel_attack -- delevels each round
		//init_delevel_defense, init_delevel_attack  -- delevels at start of combat
		//onhit_delevel_defense, onhit_delevel_attack -- delevels on attack hit
		//crit_delevel_defense, crit_delevel_attack -- delevels on crit
		//run_heal - amount healed on run

	boolean [skill] skills; // grants skills

	boolean [string] bool_modifiers;
	// jiggle -- has jiggle
};

boolean [string] __beefy_string_modifiers = {
	"delevel_defense" : true,
	"delevel_attack" : true,
	"init_delevel_defense" : true,
	"init_delevel_attack" : true,
	"onhit_delevel_defense" : true,
	"onhit_delevel_attack" : true,
	"crit_delevel_defense" : true,
	"crit_delevel_attack" : true,
	"run_heal" : true,
};

boolean [string] __beefy_bool_modifiers = {
	"jiggle" : true
};

item_ext [item] item_ext_array;

string str_mod(item it, string name)
{
	if(__beefy_string_modifiers contains name)
	{
		if(item_ext_array contains it)
		{
			return 	item_ext_array[it].string_modifiers[name];
		}
	}
	else
	{
		print("Modifier Unknown");
	}
	return "";
}

boolean bool_mod(item it, string name)
{
	if(__beefy_bool_modifiers contains name)
	{
		if(item_ext_array contains it)
		{
			return 	item_ext_array[it].bool_modifiers[name];
		}
	}
	else
	{
		print("Modifier Unknown");
	}
	return false;
}

boolean [skill] skills(item it)
{
	if(item_ext_array contains it)
	{
		return 	item_ext_array[it].skills;
	}
	return boolean [skill] {};
}

///////////////////////////////////
//items
//3383 Chester's sunglasses
item_ext_array[to_item(3383)] = new item_ext(
	to_item(3383),
	string [string] {"init_delevel_defense" : "MONDEF*15"}
);

//5698 The Lost Glasses
item_ext_array[to_item(5698)] = new item_ext(
	to_item(5698),
	string [string] {"init_delevel_defense" : "MONDEF*15"}
);

//4307  Fuzzy Slippers of Hatred
item_ext_array[to_item(4307)] = new item_ext(
	to_item(4307),
	string [string]{"init_delevel_defense" : "MONDEF*15", "run_heal" : "50+class(Disco Bandit)*50"},
	boolean [skill] {},
);


//4304 Girdle of Hatred
item_ext_array[to_item(4304)] = new item_ext(
	to_item(4304),
	string [string] {"init_delevel_defense" : "MONDEF*10"}
	boolean [skill] {to_skill("Tighten Girdle") : true},
);

/* work on these later, they do multiple things, one delevels
http://kol.coldfront.net/thekolwiki/index.php/Groll_doll
//7694 Groll doll
item_ext_array[to_item(7694)] = new item_ext(
	to_item(7694),
);

http://kol.coldfront.net/thekolwiki/index.php/Fishy_wand
//3822 Fishy wand
item_ext_array[to_item(3822)] = new item_ext(
	to_item(3822),
);
*/

//4308 Lens of Hatred
item_ext_array[to_item(4308)] = new item_ext(
	to_item(4308),
	string [string] {"init_delevel_defense" : "MONDEF*10"}
	boolean [skill] {to_skill("Hateful Gaze") : true},
);

//4303 Cold Stone of Hatred
item_ext_array[to_item(4303)] = new item_ext(
	to_item(4303),
	string [string] {"init_delevel_defense" : "MONDEF*10"}
	boolean [skill] {to_skill("Chilling Grip") : true}
);

//4903 adhesive tape dolly
item_ext_array[to_item(4903)] = new item_ext(
	to_item(4903),
	string [string] {"delevel_attack" : "1"},
	boolean [skill] {},
);

//4904 Scissor duck
item_ext_array[to_item(4904)] = new item_ext(
	to_item(4904),
	string [string] {"delevel_defense" : "1"},
	boolean [skill] {},
);

//4306 Pantaloons of Hatred
item_ext_array[to_item(4306)] = new item_ext(
	to_item(4306),
	string [string] {"init_delevel_defense" : "MONDEF*10"},
	boolean [skill] {to_skill("Static Shock") : true},
);

//1912 clockwork crossbow
item_ext_array[to_item(1912)] = new item_ext(
	to_item(1912),
	string [string] {"crit_delevel_defense" : "CRIT*4", "crit_delevel_attack" : "CRIT*4"},
	boolean [skill] {},
);



//5557 Rain-Doh yellow laser gun 
item_ext_array[to_item(5557)] = new item_ext(
	to_item(5557),
	string [string] {"onhit_delevel_attack" : "HITCHANCE*4", "onhit_delevel_defense" : "HITCHANCE*4"}, //1-7
	boolean [skill] {},
);//http://kol.coldfront.net/thekolwiki/index.php/Rain-Doh_yellow_laser_gun
//see "super accurate" spading

//1931 Antique spear
item_ext_array[to_item(1931)] = new item_ext(
	to_item(1931),
	string [string] {"onhit_delevel_attack" : "HITCHANCE*2", "onhit_delevel_defense" : "HITCHANCE*2"}, //1-3
	boolean [skill] {}
);

//5278 Blammer
item_ext_array[to_item(5278)] = new item_ext(
	to_item(5278),
	string [string] {"onhit_delevel_attack" : "HITCHANCE*2", "onhit_delevel_defense" : "HITCHANCE*2"}, //1-3
	boolean [skill] {}
);

//1720 Curdflinger 
item_ext_array[to_item(1720)] = new item_ext(
	to_item(1720),
	string [string] {"onhit_delevel_attack" : "HITCHANCE*2", "onhit_delevel_defense" : "HITCHANCE*2"}, //1-3
	boolean [skill] {}
);

//6292 Giant safety pin
item_ext_array[to_item(6292)] = new item_ext(
	to_item(6292),
	string [string] {"onhit_delevel_attack" : "HITCHANCE*2", "onhit_delevel_defense" : "HITCHANCE*2"}, //1-3
	boolean [skill] {}
);

//3848 knob bugle
item_ext_array[to_item(3848)] = new item_ext(
	to_item(3848),
	string [string] {"onhit_delevel_attack" : "HITCHANCE*2", "onhit_delevel_defense" : "HITCHANCE*2"}, //1-3
	boolean [skill] {}
);

//4244 Heavy leather-bound tome
item_ext_array[to_item(4244)] = new item_ext(
	to_item(4244),
	string [string] {"onhit_delevel_attack" : "HITCHANCE*2", "onhit_delevel_defense" : "HITCHANCE*2"}, //1-3
	boolean [skill] {}
);

//4213 Skate blade
item_ext_array[to_item(4213)] = new item_ext(
	to_item(4213),
	string [string] {"onhit_delevel_attack" : "HITCHANCE*2", "onhit_delevel_defense" : "HITCHANCE*2"}, //1-3
	boolean [skill] {}
);

//4377 throwing wrench
item_ext_array[to_item(4377)] = new item_ext(
	to_item(4377),
	string [string] {"onhit_delevel_attack" : "HITCHANCE*2", "onhit_delevel_defense" : "HITCHANCE*2"}, //1-3
	boolean [skill] {}
);

//1409 Unionize The Elves sign
item_ext_array[to_item(1409)] = new item_ext(
	to_item(1409),
	string [string] {"onhit_delevel_attack" : "HITCHANCE*2", "onhit_delevel_defense" : "HITCHANCE*2"}, //1-3
	boolean [skill] {}
);

//1031 yak whip
item_ext_array[to_item(1031)] = new item_ext(
	to_item(1031),
	string [string] {"onhit_delevel_attack" : "HITCHANCE*2", "onhit_delevel_defense" : "HITCHANCE*2"}, //1-3
	boolean [skill] {}
);

//2656 Drowsy Sword
item_ext_array[to_item(2656)] = new item_ext(
	to_item(2656),
	string [string] {"onhit_delevel_attack" : "HITCHANCE*5.5", "onhit_delevel_defense" : "HITCHANCE*5.5"}, //1-10
	boolean [skill] {}
);

//362 7-Foot Dwarven mattock
item_ext_array[to_item(362)] = new item_ext(
	to_item(362),
	string [string] {"onhit_delevel_attack" : "HITCHANCE*2", "onhit_delevel_defense" : "HITCHANCE*2"}, //1-3
	boolean [skill] {}
);

//4915 Loathing Legion chainsaw
item_ext_array[to_item(4915)] = new item_ext(
	to_item(4915),
	string [string] {"onhit_delevel_attack" : "HITCHANCE*2", "onhit_delevel_defense" : "HITCHANCE*2"}, //1-3
	boolean [skill] {}
);

//4378 Pair of bolt cutters
item_ext_array[to_item(4378)] = new item_ext(
	to_item(4378),
	string [string] {"onhit_delevel_attack" : "HITCHANCE*2", "onhit_delevel_defense" : "HITCHANCE*2"}, //1-3
	boolean [skill] {}
);
////////////////
//Staves

//3390 Staff of the Deepest Freeze
item_ext_array[to_item(3390)] = new item_ext(
	to_item(3390),
	string [string] {},
	boolean [skill] {},
	boolean [string] {"jiggle" : true}
);

//2740 Staff of the Walk-In Freezer
item_ext_array[to_item(2740)] = new item_ext(
	to_item(2740),
	string [string] {"init_delevel_defense" : "7.5"}, //5-10
	boolean [skill] {},
	boolean [string] {"jiggle" : true}
);
/*
//
item_ext_array[to_item()] = new item_ext(
	to_item(),
	string [string] {"init_delevel_defense" : "7.5"}, //5-10
	boolean [skill] {},
	boolean [string] {"jiggle" : true}
);

//
item_ext_array[to_item()] = new item_ext(
	to_item(),
	string [string] {"init_delevel_defense", 15},
	boolean [skill] {},
	boolean [string] {"jiggle" : true}
);

//
item_ext_array[to_item()] = new item_ext(
	to_item(),
	string [string] {"init_delevel_defense", 15},
	boolean [skill] {},
	boolean [string] {"jiggle" : true}
);

//
item_ext_array[to_item()] = new item_ext(
	to_item(),
	string [string] {"init_delevel_defense", 15},
	boolean [skill] {},
	boolean [string] {"jiggle" : true}
);

//
item_ext_array[to_item()] = new item_ext(
	to_item(),
	string [string] {"init_delevel_defense", 15},
	boolean [skill] {},
	boolean [string] {"jiggle" : true}
);
*/