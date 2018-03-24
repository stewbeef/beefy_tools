script "beefy_combat_skills.ash";

//////////////////////////////////
//Global Variables

string make_hitchance_string(string statmod)
{
	buffer hitchance;

	hitchance.append("min(1,max(AUTOHIT,(6+WEAPON_STAT");
	if(statmod != "")
	{
		hitchance.append(statmod);
	}
	hitchance.append("-MONDEF)/11))");

	return hitchance.to_string();
}
string make_hitchance_string()
{
	return make_hitchance_string("");
}

string make_max_string(string a, string b)
{
	buffer maxthis;

	maxthis.append("max(");
	maxthis.append(a);
	maxthis.append(",");
	maxthis.append(b);
	maxthis.append(")");

	return maxthis.to_string();
}

string make_min_string(string a, string b)
{
	buffer maxthis;

	maxthis.append("min(");
	maxthis.append(a);
	maxthis.append(",");
	maxthis.append(b);
	maxthis.append(")");

	return maxthis.to_string();
}

	//////////////////////////////////
	//Spells
	string capped_spell_dmg = "(ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE)))";
	string capped_cold_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+COLD_SPELL_DMG))";
	string capped_hot_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+HOT_SPELL_DMG))";
	string capped_sleaze_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SLEAZE_SPELL_DMG))";
	string capped_spooky_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SPOOKY_SPELL_DMG))";
	string capped_stench_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+STENCH_SPELL_DMG))";
	string uncapped_spell_dmg = "(ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE)))";
	string uncapped_cold_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+COLD_SPELL_DMG))";
	string uncapped_hot_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+HOT_SPELL_DMG))";
	string uncapped_sleaze_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SLEAZE_SPELL_DMG))";
	string uncapped_spooky_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SPOOKY_SPELL_DMG))";
	string uncapped_stench_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+STENCH_SPELL_DMG))";
	//Saucerer
	string capped_sauce_spell_dmg = "(ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+min(L,10)*skill(Intrinsic Spiciness))))";
	string capped_sauce_cold_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+COLD_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string capped_sauce_hot_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+HOT_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string capped_sauce_sleaze_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SLEAZE_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string capped_sauce_spooky_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SPOOKY_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string capped_sauce_stench_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+STENCH_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string uncapped_sauce_spell_dmg = "(ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+min(L,10)*skill(Intrinsic Spiciness))))";
	string uncapped_sauce_cold_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+COLD_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string uncapped_sauce_hot_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+HOT_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string uncapped_sauce_sleaze_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SLEAZE_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string uncapped_sauce_spooky_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SPOOKY_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string uncapped_sauce_stench_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+STENCH_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	//PM
	string capped_pm_spell_dmg = "(ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min((class(Pastamancer)*skill(Bringing Up the Rear)+1)*CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE)))";
	string capped_pm_cold_spell_dmg = "PM_COLD*(ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min((class(Pastamancer)*skill(Bringing Up the Rear)+1)*CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+COLD_SPELL_DMG)))";
	string capped_pm_hot_spell_dmg = "PM_HOT*(ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min((class(Pastamancer)*skill(Bringing Up the Rear)+1)*CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+HOT_SPELL_DMG)))";
	string capped_pm_sleaze_spell_dmg = "PM_SLEAZE*(ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min((class(Pastamancer)*skill(Bringing Up the Rear)+1)*CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SLEAZE_SPELL_DMG)))";
	string capped_pm_spooky_spell_dmg = "PM_SPOOKY*(ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min((class(Pastamancer)*skill(Bringing Up the Rear)+1)*CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SPOOKY_SPELL_DMG)))";
	string capped_pm_stench_spell_dmg = "PM_STENCH*(ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*min((class(Pastamancer)*skill(Bringing Up the Rear)+1)*CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+STENCH_SPELL_DMG)))";
	string [element] capped_pm_ele_spell_dmg = {$element[cold] : capped_pm_cold_spell_dmg,$element[hot] : capped_pm_hot_spell_dmg,$element[sleaze] : capped_pm_sleaze_spell_dmg,$element[spooky] : capped_pm_spooky_spell_dmg,$element[stench] : capped_pm_stench_spell_dmg};
	string uncapped_pm_spell_dmg = "(ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE)))";
	string uncapped_pm_hot_spell_dmg = "PM_HOT*ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+COLD_SPELL_DMG))";
	string uncapped_pm_cold_spell_dmg = "PM_COLD*ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+HOT_SPELL_DMG))";
	string uncapped_pm_sleaze_spell_dmg = "PM_SLEAZE*ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SLEAZE_SPELL_DMG))";
	string uncapped_pm_spooky_spell_dmg = "PM_SPOOKY*ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SPOOKY_SPELL_DMG))";
	string uncapped_pm_stench_spell_dmg = "PM_STENCH*ceil(min(MON_GROUP,SPELL_GROUP)*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+STENCH_SPELL_DMG))";
	string [element] uncapped_pm_ele_spell_dmg = {$element[cold] : uncapped_pm_cold_spell_dmg,$element[hot] : uncapped_pm_hot_spell_dmg,$element[sleaze] : uncapped_pm_sleaze_spell_dmg,$element[spooky] : uncapped_pm_spooky_spell_dmg,$element[stench] : uncapped_pm_stench_spell_dmg};

	//Attacks
	string hitchance = make_hitchance_string();
	string attack_non_ele_dmg = "((max(floor(WEAPON_STAT*WPN_TYPE_STAT_MOD)-MONDEF,0)+(max(1,WEAPON_DMG)*(1+CRIT))+BONUS_WEAPON_DAMAGE)*(1+WEAPON_MULT)+OFFHAND)";
	string [element] attack_damage = {
		$element[none] : attack_non_ele_dmg, 
		$element[cold] : "COLD_DMG", 
		$element[hot] : "HOT_DMG", 
		$element[sleaze] : "SLEAZE_DMG", 
		$element[spooky] : "SPOOKY_DMG", 
		$element[stench] : "STENCH_DMG"};

	string smackautohit = "(class(Seal Clubber)*max(mainhand(club),skill(Iron Palm Technique)*mainhand(sword)))";
	
	string attack_non_ele_smack_dmg = "(max(floor(WEAPON_STAT*ATTK_TYPE_STAT_MOD*WPN_TYPE_STAT_MOD)-MONDEF,0)+(max(1,WEAPON_DMG)*(1+CRIT)*ATK_TYPE_WPN_DMG_MOD)+BONUS_WEAPON_DAMAGE*(max(1,ATK_TYPE_WPN_DMG_MOD*class(Seal Clubber)))*(1+WEAPON_MULT)+OFFHAND)";
	string [element] smack_damage = {
		$element[none] : attack_non_ele_smack_dmg,
		$element[cold] : "(COLD_DMG*max(1,ATK_TYPE_WPN_DMG_MOD*class(Seal Clubber)+5*skill(cold shoulder)))",
		$element[hot] : "HOT_DMG*max(1,ATK_TYPE_WPN_DMG_MOD*class(Seal Clubber))",
		$element[sleaze] : "SLEAZE_DMG*max(1,ATK_TYPE_WPN_DMG_MOD*class(Seal Clubber))",
		$element[spooky] : "SPOOKY_DMG*max(1,ATK_TYPE_WPN_DMG_MOD*class(Seal Clubber))",
		$element[stench] : "STENCH_DMG*max(1,ATK_TYPE_WPN_DMG_MOD*class(Seal Clubber))"};
	//skill() 0 1
	//effect() 0 1
	//class() 0 1
	//SAUCE 0 or 1 if sauce spell
	//MON_GROUP monster group size
	//SPELL_GROUP spell group size
	//CAP spell damage cap
	//MYST_SCALING mysticality scaling
	//BONUS_SPELL_DAMAGE bonus spell damage
	//BONUS_ELEMENTAL_DAMAGE bonus elemental damage
	//SPELL_CRIT Spell Critical Percent
	//CRIT Critical Hit Percent
	//SPELL_MULT spell percent damage
	//WEAPON_MULT -- weapon damage mult - includes ranged
	//PASTA 0 or 1 if pasta spell
	//OFFHAND - offhand weapon damage
	//WEAPON_DMG - weapon damage
	//BONUS_WEAPON_DAMAGE - bonus weapon damage
	//ATTK_TYPE_STAT_MOD - 1.25 non-Seal Clubber's lunging thrust-smack, 1.3, seal-clubber's lunging thrust-smack or northern explosion, 1.4 bashing slam smash, 1 otherwise
	//WPN_TYPE_STAT_MOD - 1 for melee, .75 range, .25 no weapon
	//ATK_TYPE_WPN_DMG_MOD - 2 for thrust-smack/mighty axing, 3 for lunging-thrust-smack/northern explosion
	//		5 for bashing slam smash, 5 for cleave, 1 otherwise
	//BONUS_WEAPON_DMG includes ranged damage for ranged weapon

	record combat_skill
	{
		skill sk;
		string [element] damage;
		float [string] dmg_props;
		boolean [string] props;
		string hitchance;
		string [element] dot;
		string [string] effects;
	};
	record skdmg
	{
		skill sk;
		combat_skill cmbtsk;

		float hitchance;
		float dmg; //damage dealt per use
		float hitdmg; //damage * hitchance
		float [element] eldmg; //damage per element inflicted per use
		
		float dotdmg; //dot inflicted per use -- assumes no stacking
		float dothitdmg; //damage * hitchance
		float [element] eldotdmg; //dot per element inflicted per use

		int attack_delevel;
		int defense_delevel;
		int attack_dlot;
		int defense_dlot;
		
		int ttd; // turns to death
		int tot_mana_used;
		int tmtw; //total mana to win
		int dmg_taken; //expected_damage from monster
		int order;
	};
/////////////////////////////////////////////////
//Function
float [string] copy_dmg_props(combat_skill csk)
{
	float [string] dmg_props;
	foreach name in csk.dmg_props
	{
		dmg_props[name] = csk.dmg_props[name];
	}
	return dmg_props;
}


/////////////////////////////////////////////////
//Combat Skills

	combat_skill [skill] cmbt_skills;
//Saucerer
	cmbt_skills[to_skill("Salsaball")] = new combat_skill(
		to_skill("Salsaball"),
		string [element]  {$element[hot] : capped_sauce_hot_spell_dmg},
		float [string] {"MYST_SCALING" : 0.0, "CAP" : 8.0, "SPELL_GROUP" : 1.0, "MIN_DMG" : 1.0, "MAX_DMG" : 3.0},
		boolean [string] {"spell" : true, "sauce" : true},
		"1"
		);

	cmbt_skills[to_skill("Stream of Sauce")] = new combat_skill(
		to_skill("Stream of Sauce"),
		string [element]  {$element[hot] : capped_sauce_hot_spell_dmg},
		float [string] {"MYST_SCALING" : 0.2, "CAP" : 24.0, "SPELL_GROUP" : 1.0, "MIN_DMG" : 9.0, "MAX_DMG" : 11.0},
		boolean [string] {"spell" : true, "sauce" : true},
		"1"
		);

	cmbt_skills[to_skill("Surge of Icing")] = new combat_skill(
		to_skill("Surge of Icing"),
		string [element]  {$element[none] : capped_sauce_spell_dmg},
		float [string] {"MYST_SCALING" : 0.2, "CAP" : 24.0, "SPELL_GROUP" : 1.0, "MIN_DMG" : 14.0, "MAX_DMG" : 18.0},
		boolean [string] {"spell" : true, "sauce" : true},
		"1"
		);

	cmbt_skills[to_skill("Saucestorm")] = new combat_skill(
		to_skill("Saucestorm"),
		string [element]  {$element[hot] : capped_sauce_hot_spell_dmg,$element[cold] : capped_sauce_cold_spell_dmg},
		float [string] {"MYST_SCALING" : 0.2, "CAP" : 50.0, "SPELL_GROUP" : 2.0, "MIN_DMG" : 20.0, "MAX_DMG" : 24.0},
		boolean [string] {"spell" : true},
		"1"
		);

		//Käsesoßesturm
	cmbt_skills[to_skill(4023)] = new combat_skill(
		to_skill(4023),
		string [element]  {$element[stench] : capped_sauce_stench_spell_dmg},
		float [string] {"MYST_SCALING" : 0.3, "CAP" : 100.0, "SPELL_GROUP" : 5.0, "MIN_DMG" : 40.0, "MAX_DMG" : 44.0},
		boolean [string] {"spell" : true, "sauce" : true},
		"1"
		);

	cmbt_skills[to_skill("Wave of Sauce")] = new combat_skill(
		to_skill("Wave of Sauce"),
		string [element]  {$element[hot] : capped_sauce_hot_spell_dmg},
		float [string] {"MYST_SCALING" : 0.3, "CAP" : 100.0, "SPELL_GROUP" : 2.0, "MIN_DMG" : 45.0, "MAX_DMG" : 50.0},
		boolean [string] {"spell" : true, "sauce" : true},
		"1"
		);

	cmbt_skills[to_skill("Saucecicle")] = new combat_skill(
		to_skill("Saucecicle"),
		string [element]  {$element[cold] : capped_sauce_cold_spell_dmg},
		float [string] {"MYST_SCALING" : 0.4, "CAP" : 150.0, "SPELL_GROUP" : 1.0, "MIN_DMG" : 45.0, "MAX_DMG" : 50.0},
		boolean [string] {"spell" : true, "sauce" : true},
		"1"
		);

	cmbt_skills[to_skill("Saucegeyser")] = new combat_skill(
		to_skill("Saucegeyser"),
		string [element]  {$element[hot] : uncapped_sauce_hot_spell_dmg,$element[cold] : uncapped_sauce_cold_spell_dmg},
		float [string] {"MYST_SCALING" : 0.4, "SPELL_GROUP" : 3.0, "MIN_DMG" : 60.0, "MAX_DMG" : 70.0},
		boolean [string] {"spell" : true,"best" : true, "sauce" : true},
		"1"
		);

	cmbt_skills[to_skill("Saucemageddon")] = new combat_skill(
		to_skill("Saucemageddon"),
		string [element]  {$element[hot] : uncapped_sauce_hot_spell_dmg,$element[cold] : uncapped_sauce_cold_spell_dmg},
		float [string] {"MYST_SCALING" : 0.5, "SPELL_GROUP" : 5.0, "MIN_DMG" : 80.0, "MAX_DMG" : 90.0},
		boolean [string] {"spell" : true,"best" : true, "sauce" : true},
		"1"
		);

//Pastamancer
	cmbt_skills[to_skill("Spaghetti Spear")] = new combat_skill(
		to_skill("Spaghetti Spear"),
		string [element]  {$element[none] : capped_pm_spell_dmg},
		float [string] {"MYST_SCALING" : 0.2, "CAP" : 8.0, "SPELL_GROUP" : 1.0, "MIN_DMG" : 2.0, "MAX_DMG" : 3.0},
		boolean [string] {"spell" : true, "pasta" : true},
		"1"
		);
	

	cmbt_skills[to_skill("Ravioli Shurikens")] = new combat_skill(
		to_skill("Ravioli Shurikens"),
		string [element]  {
				$element[cold] : "3*"+capped_pm_cold_spell_dmg,
				$element[hot] : "3*"+capped_pm_hot_spell_dmg,
				$element[sleaze] : "3*"+capped_pm_sleaze_spell_dmg,
				$element[spooky] : "3*"+capped_pm_spooky_spell_dmg,
				$element[stench] : "3*"+capped_pm_stench_spell_dmg
				},
		float [string] {"MYST_SCALING" : 0.0, "CAP" : 10.0, "SPELL_GROUP" : 1.0, "MIN_DMG" : 2.0, "MAX_DMG" : 4.0},
		boolean [string] {"spell" : true, "pasta" : true},
		"1"
		);

	cmbt_skills[to_skill("Candyblast")] = new combat_skill(
		to_skill("Candyblast"),
		string [element] {$element[none] : capped_pm_spell_dmg},
		float [string] {"MYST_SCALING" : 0.25, "CAP" : 50.0, "SPELL_GROUP" : 1.0, "MIN_DMG" : 8.0, "MAX_DMG" : 16.0},
		boolean [string] {"spell" : true, "pasta" : true},
		"1"
		);

	cmbt_skills[to_skill("Cannelloni Cannon")] = new combat_skill(
		to_skill("Cannelloni Cannon"),
		capped_pm_ele_spell_dmg,
		float [string] {"MYST_SCALING" : 0.25, "CAP" : 50.0, "SPELL_GROUP" : 2.0, "MIN_DMG" : 16.0, "MAX_DMG" : 32.0},
		boolean [string] {"spell" : true, "pasta" : true},
		"1"
		);

	cmbt_skills[to_skill("Stringozzi Serpent")] = new combat_skill(
		to_skill("Stringozzi Serpent"),
		string [element]  {$element[none] : capped_pm_spell_dmg},
		float [string] {"MYST_SCALING" : 0.25, "CAP" : 75.0, "SPELL_GROUP" : 2.0, "MIN_DMG" : 16.0, "MAX_DMG" : 32.0},
		boolean [string] {"spell" : true, "pasta" : true},
		"1"
		);

	cmbt_skills[to_skill("Stuffed Mortar Shell")] = new combat_skill(
		to_skill("Stuffed Mortar Shell"),
		uncapped_pm_ele_spell_dmg,
		float [string] {"MYST_SCALING" : 0.5, "SPELL_GROUP" : 3.0, "MIN_DMG" : 32.0, "MAX_DMG" : 64.0},
		boolean [string] {"spell" : true, "once" : true, "pasta" : true},
		"1"
		);

	cmbt_skills[to_skill("Weapon of the Pastalord")] = new combat_skill(
		to_skill("Weapon of the Pastalord"),
		string [element]  {$element[none] : uncapped_pm_spell_dmg},
		float [string] {"MYST_SCALING" : 0.5, "SPELL_GROUP" : 1.0, "MIN_DMG" : 32.0, "MAX_DMG" : 64.0},
		boolean [string] {"pastalord" : true,"spell" : true, "pasta" : true},
		"1"
		);

	cmbt_skills[to_skill("Fearful Fettucini")] = new combat_skill(
		to_skill("Fearful Fettucini"),
		string [element]  {$element[spooky] : uncapped_spooky_spell_dmg},
		float [string] {"MYST_SCALING" : 0.5, "SPELL_GROUP" : 1.0, "MIN_DMG" : 32.0, "MAX_DMG" : 64.0},
		boolean [string] {"spell" : true, "pasta" : true},
		"1"
		);

//Attacks and Smacks
	cmbt_skills[to_skill("none")] = new combat_skill(
		to_skill("none"),
		attack_damage,
		float [string] {"ATTK_TYPE_STAT_MOD" : 1, "ATK_TYPE_WPN_DMG_MOD" : 1},
		boolean [string] {"attack" : true},
		hitchance
		);
	cmbt_skills[to_skill("Lunge Smack")] = new combat_skill(
		to_skill("Lunge Smack"),
		string [element]  {
			$element[none] : "(" + attack_non_ele_dmg+"+5)",
			$element[cold] : "COLD_DMG",
			$element[hot] : "HOT_DMG",
			$element[sleaze] : "SLEAZE_DMG",
			$element[spooky] : "SPOOKY_DMG",
			$element[stench] : "STENCH_DMG"
		},
		float [string] {"ATTK_TYPE_STAT_MOD" : 1, "ATK_TYPE_WPN_DMG_MOD" : 1},
		boolean [string] {"attack" : true},
		make_max_string(smackautohit,make_hitchance_string(""))
		);
	cmbt_skills[to_skill("Thrust-Smack")] = new combat_skill(
		to_skill("Thrust-Smack"),
		smack_damage,
		float [string] {"ATTK_TYPE_STAT_MOD" : 1, "ATK_TYPE_WPN_DMG_MOD" : 2},
		boolean [string] {"attack" : true},
		make_max_string(smackautohit,make_hitchance_string("+20"))
		);
	cmbt_skills[to_skill("Lunging Thrust-Smack")] = new combat_skill(
		to_skill("Lunging Thrust-Smack"),
		smack_damage,
		float [string] {"ATTK_TYPE_STAT_MOD" : 1.25, "ATK_TYPE_WPN_DMG_MOD" : 3},
		boolean [string] {"attack" : true},
		make_max_string(smackautohit,make_max_string(make_hitchance_string("+30"),make_hitchance_string("*max(class(Seal Clubber)*30,25)")))
		);
	cmbt_skills[to_skill("Northern Explosion")] = new combat_skill(
		to_skill("Northern Explosion"),
		string [element]  {$element[cold] : attack_non_ele_dmg+"+COLD_DMG*ATK_TYPE_WPN_DMG_MOD*class(Seal Clubber)"},
		float [string] {"ATTK_TYPE_STAT_MOD" : 1.3, "ATK_TYPE_WPN_DMG_MOD" : 3},
		boolean [string] {"attack" : true},
		make_max_string(smackautohit,make_hitchance_string(""))
		);

//TT Attacks
	cmbt_skills[to_skill("Headbutt")] = new combat_skill(
		to_skill("Headbutt"),
			string [element] {
		$element[none] : "((ANYWARSNAP+ANYSTORMTORT)*HAT_POWER/7.5+" + attack_non_ele_dmg + ")", 
		$element[cold] : "COLD_DMG", 
		$element[hot] : "HOT_DMG",
		$element[sleaze] : "SLEAZE_DMG", 
		$element[spooky] : "((ANYSHEWHOWAS*HAT_POWER/7.5)+SPOOKY_DMG)", 
		$element[stench] : "STENCH_DMG"},
		float [string] {},
		boolean [string] {"attack" : true},
		hitchance
		);

	string kneebutt_hitchance = "min(1,max(AUTOHIT,(6+(WEAPON_STAT+min(20,2*L))-MONDEF)/11))";
	cmbt_skills[to_skill("Kneebutt")] = new combat_skill(
		to_skill("Kneebutt"),
		string [element] {
			$element[none] : "((2*(ANYWARSNAP+ANYSTORMTORT))*PANTS_POWER/7.5+" + attack_non_ele_dmg + ")", 
			$element[cold] : "COLD_DMG", 
			$element[hot] : "HOT_DMG", 
			$element[sleaze] : "SLEAZE_DMG", 
			$element[spooky] : "((ANYSHEWHOWAS*PANTS_POWER/7.5)+SPOOKY_DMG)", 
			$element[stench] : "STENCH_DMG"},
		float [string] {},
		boolean [string] {"attack" : true},
		make_hitchance_string("+min(20,L*2)"),
		string [element]  {},
		string [string]  {
			"mon_defense" : "-5*WARSNAP-11*GRANDWARSNAP-19*GLORWARSNAP",
			"mon_attack" : "-5*SHEWHOWAS-11*GRANDSHEWHOWAS-19*GLORSHEWHOWAS"
			}
		);

	cmbt_skills[to_skill("Spirit Snap")] = new combat_skill(
		to_skill("Spirit Snap"),
		string [element] {
			$element[none] : "(.10*MUS*NOTTBLESS+.3*WARSNAP*MUS+.4*GRANDWARSNAP*MUS+.5*GLORWARSNAP*MUS)",
			$element[spooky] : ".25*SHEWHOWAS*MUS+.3*GRANDSHEWHOWAS*MUS+.35*GLORSHEWHOWAS*MUS"
			},
		float [string] {},
		boolean [string] {"once" : true},
		"1",
		string [element]  {
			$element[none] : "(.15*STORMTORT*MUS+.2*GRANDSTORMTORT*MUS+.25*GLORSTORMTORT*MUS)"
			},
		);

	cmbt_skills[to_skill("Shieldbutt")] = new combat_skill(
		to_skill("Shieldbutt"),
		string [element] {
			$element[none] : "((1+skill(butts of steel))*SHIELD_POWER*.15+10*GRANDWARSNAP+20*GLORWARSNAP+" + attack_non_ele_dmg + ")", 
			$element[cold] : "COLD_DMG", 
			$element[hot] : "HOT_DMG", 
			$element[sleaze] : "SLEAZE_DMG", 
			$element[spooky] : "(((1+skill(butts of steel))*ANYSHEWHOWAS*SHIELD_POWER/7.5)+SPOOKY_DMG)", 
			$element[stench] : "STENCH_DMG"},
		float [string] {},
		boolean [string] {"attack" : true},
		make_max_string("class(Turtle Tamer)",hitchance),
		string [element]  {
			$element[none] : "((1+skill(butts of steel))*SHIELD_POWER*.15+5*GRANDSTORMTORT+10*GLORSTORMTORT+" + attack_non_ele_dmg + ")"
			},
		string [string] {
			"hp" : "7*SHEWHOWAS+11*GRANDSHEWHOWAS+19*GLORSHEWHOWAS",
			"stagger" : ".5*ANYWARSNAP"
			}
		);
//Disco Attacks


//Non-spell Base Attacks
	cmbt_skills[to_skill("suckerpunch")] = new combat_skill(
		to_skill("suckerpunch"),
		string [element]  {$element[none] : "1"},
		float [string] {},
		boolean [string] {"base" : true},
		"1",
		string [element]  {},
		string [string]  {
			"mon_defense" : "-1",
			"mon_attack" : "-1"
			}
		);
	cmbt_skills[to_skill("Clobber")] = new combat_skill(
		to_skill("Clobber"),
		string [element]  {
				$element[none] : "WEAPON_DMG+ceil(sqrt(BONUS_WEAPON_DAMAGE))",
				$element[cold] : "ceil(sqrt(COLD_DMG))",
				$element[hot] : "ceil(sqrt(HOT_DMG))",
				$element[sleaze] : "ceil(sqrt(SLEAZE_DMG))",
				$element[spooky] : "ceil(sqrt(SPOOKY_DMG))",
				$element[stench] : "ceil(sqrt(STENCH_DMG))"
				},
		float [string] {},
		boolean [string] {"base" : true},
		"1"
		);

	cmbt_skills[to_skill("Toss")] = new combat_skill(
		to_skill("Toss"),
		string [element]  {$element[none] : "min(W+3,10+floor(sqrt(W-7)))"},
		float [string] {},
		boolean [string] {"base" : true},
		"1"
		);