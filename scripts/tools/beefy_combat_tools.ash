script "beefy_combat_tools.ash";
import "beefy_tools.ash";

//////////////////////////////////
//Global Variables

string get_hitchance(string statmod)
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
string get_hitchance()
{
	return get_hitchance("");
}

string max(string a, string b)
{
	buffer maxthis;

	maxthis.append("max(");
	maxthis.append(a);
	maxthis.append(",");
	maxthis.append(b);
	maxthis.append(")");

	return maxthis.to_string();
}

string min(string a, string b)
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
	string capped_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE))";
	string capped_cold_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+COLD_SPELL_DMG))";
	string capped_hot_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+HOT_SPELL_DMG))";
	string capped_sleaze_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SLEAZE_SPELL_DMG))";
	string capped_spooky_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SPOOKY_SPELL_DMG))";
	string capped_stench_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+STENCH_SPELL_DMG))";
	string uncapped_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE))";
	string uncapped_cold_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+COLD_SPELL_DMG))";
	string uncapped_hot_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+HOT_SPELL_DMG))";
	string uncapped_sleaze_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SLEAZE_SPELL_DMG))";
	string uncapped_spooky_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SPOOKY_SPELL_DMG))";
	string uncapped_stench_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+STENCH_SPELL_DMG))";
	//Saucerer
	string capped_sauce_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+min(L,10)*skill(Intrinsic Spiciness)))";
	string capped_sauce_cold_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+COLD_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string capped_sauce_hot_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+HOT_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string capped_sauce_sleaze_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SLEAZE_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string capped_sauce_spooky_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SPOOKY_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string capped_sauce_stench_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min(CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+STENCH_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string uncapped_sauce_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+min(L,10)*skill(Intrinsic Spiciness)))";
	string uncapped_sauce_cold_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+COLD_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string uncapped_sauce_hot_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+HOT_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string uncapped_sauce_sleaze_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SLEAZE_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string uncapped_sauce_spooky_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SPOOKY_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	string uncapped_sauce_stench_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+STENCH_SPELL_DMG+min(L,10)*skill(Intrinsic Spiciness)))";
	//PM
	string capped_pm_spell_dmg = "(ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min((class(Pastamancer)*skill(Bringing Up the Rear)+1)*CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE)))";
	string capped_pm_cold_spell_dmg = "PM_COLD*(ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min((class(Pastamancer)*skill(Bringing Up the Rear)+1)*CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+COLD_SPELL_DMG)))";
	string capped_pm_hot_spell_dmg = "PM_HOT*(ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min((class(Pastamancer)*skill(Bringing Up the Rear)+1)*CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+HOT_SPELL_DMG)))";
	string capped_pm_sleaze_spell_dmg = "PM_SLEAZE*(ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min((class(Pastamancer)*skill(Bringing Up the Rear)+1)*CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SLEAZE_SPELL_DMG)))";
	string capped_pm_spooky_spell_dmg = "PM_SPOOKY*(ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min((class(Pastamancer)*skill(Bringing Up the Rear)+1)*CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SPOOKY_SPELL_DMG)))";
	string capped_pm_stench_spell_dmg = "PM_STENCH*(ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min((class(Pastamancer)*skill(Bringing Up the Rear)+1)*CAP,((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+STENCH_SPELL_DMG)))";
	string [element] capped_pm_ele_spell_dmg = {$element[cold] : capped_pm_cold_spell_dmg,$element[hot] : capped_pm_hot_spell_dmg,$element[sleaze] : capped_pm_sleaze_spell_dmg,$element[spooky] : capped_pm_spooky_spell_dmg,$element[stench] : capped_pm_stench_spell_dmg};
	string uncapped_pm_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE))";
	string uncapped_pm_hot_spell_dmg = "PM_HOT*ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+COLD_SPELL_DMG))";
	string uncapped_pm_cold_spell_dmg = "PM_COLD*ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+HOT_SPELL_DMG))";
	string uncapped_pm_sleaze_spell_dmg = "PM_SLEAZE*ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SLEAZE_SPELL_DMG))";
	string uncapped_pm_spooky_spell_dmg = "PM_SPOOKY*ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+SPOOKY_SPELL_DMG))";
	string uncapped_pm_stench_spell_dmg = "PM_STENCH*ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*(((MAX_DMG+MIN_DMG)/2+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+STENCH_SPELL_DMG))";
	string [element] uncapped_pm_ele_spell_dmg = {$element[cold] : uncapped_pm_cold_spell_dmg,$element[hot] : uncapped_pm_hot_spell_dmg,$element[sleaze] : uncapped_pm_sleaze_spell_dmg,$element[spooky] : uncapped_pm_spooky_spell_dmg,$element[stench] : uncapped_pm_stench_spell_dmg};

	//Attacks
	string hitchance = get_hitchance();
	string attack_non_ele_dmg = "((max(floor(WEAPON_STAT*WPN_TYPE_STAT_MOD)-MONDEF,0)+(max(1,WEAPON_DMG)*CRIT)+BONUS_WEAPON_DAMAGE)*(1+WEAPON_MULT)+OFFHAND)";
	string [element] attack_damage = {
		$element[none] : attack_non_ele_dmg, 
		$element[cold] : "COLD_DMG", 
		$element[hot] : "HOT_DMG", 
		$element[sleaze] : "SLEAZE_DMG", 
		$element[spooky] : "SPOOKY_DMG", 
		$element[stench] : "STENCH_DMG"};

	string smackautohit = "(class(Seal Clubber)*max(mainhand(club),skill(Iron Palm Technique)*mainhand(sword)))";
	
	string attack_non_ele_smack_dmg = "(max(floor(WEAPON_STAT*ATTK_TYPE_STAT_MOD*WPN_TYPE_STAT_MOD)-MONDEF,0)+(max(1,WEAPON_DMG)*CRIT*ATK_TYPE_WPN_DMG_MOD)+BONUS_WEAPON_DAMAGE*(max(1,ATK_TYPE_WPN_DMG_MOD*class(Seal Clubber)))*(1+WEAPON_MULT)+OFFHAND)";
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

		int ttd; // turns to death
		int tot_mana_used;
		int tmtw; //total mana to win
		int dmg_taken; //expected_damage from monster
		int order;
	};

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
		to_skill("4023"),
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
		string [element]  {$element[none] : attack_non_ele_dmg+"+5", $element[cold] : "COLD_DMG", $element[hot] : "HOT_DMG", $element[sleaze] : "SLEAZE_DMG", $element[spooky] : "SPOOKY_DMG", $element[stench] : "STENCH_DMG"},
		float [string] {"ATTK_TYPE_STAT_MOD" : 1, "ATK_TYPE_WPN_DMG_MOD" : 1},
		boolean [string] {"attack" : true},
		max(smackautohit,get_hitchance(""))
		);
	cmbt_skills[to_skill("Thrust-Smack")] = new combat_skill(
		to_skill("Thrust-Smack"),
		smack_damage,
		float [string] {"ATTK_TYPE_STAT_MOD" : 1, "ATK_TYPE_WPN_DMG_MOD" : 2},
		boolean [string] {"attack" : true},
		max(smackautohit,get_hitchance("+20"))
		);
	cmbt_skills[to_skill("Lunging Thrust-Smack")] = new combat_skill(
		to_skill("Lunging Thrust-Smack"),
		smack_damage,
		float [string] {"ATTK_TYPE_STAT_MOD" : 1.25, "ATK_TYPE_WPN_DMG_MOD" : 3},
		boolean [string] {"attack" : true},
		max(smackautohit,max(get_hitchance("+30"),get_hitchance("*max(class(Seal Clubber)*30,25)")))
		);
	cmbt_skills[to_skill("Northern Explosion")] = new combat_skill(
		to_skill("Northern Explosion"),
		string [element]  {$element[cold] : attack_non_ele_dmg+"+COLD_DMG*ATK_TYPE_WPN_DMG_MOD*class(Seal Clubber)"},
		float [string] {"ATTK_TYPE_STAT_MOD" : 1.3, "ATK_TYPE_WPN_DMG_MOD" : 3},
		boolean [string] {"attack" : true},
		max(smackautohit,get_hitchance(""))
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
		get_hitchance("+min(20,L*2)"),
		string [element]  {},
		string [string]  {
			"mon_defense" : "-5*WARSNAP-11*GRANDWARSNAP-19*GLORWARSNAP",
			"mon_attack" : "-5*SHEWHOWAS-11*GRANDSHEWHOWAS-19*GLORSHEWHOWAS"
			}
		);

	cmbt_skills[to_skill("Spirit Snap")] = new combat_skill(
		to_skill("Spirit Snap"),
		string [element] {
			$element[none] : ".10*MUS*NOTTBLESS+.3*WARSNAP*MUS+.4*GRANDWARSNAP*MUS+.5*GLORWARSNAP*MUS",
			$element[spooky] : ".25*SHEWHOWAS*MUS+.3*GRANDSHEWHOWAS*MUS+.35*GLORSHEWHOWAS*MUS"
			},
		float [string] {},
		boolean [string] {"once" : true},
		"1",
		string [element]  {
			$element[none] : ".15*STORMTORT*MUS+.2*GRANDSTORMTORT*MUS+.25*GLORSTORMTORT*MUS"
			},
		);

	cmbt_skills[to_skill("Shieldbutt")] = new combat_skill(
		to_skill("Shieldbutt"),
		string [element] {
			$element[none] : "(((1+skill(butts of steel))*SHIELD_POWER*.15+10*GRANDWARSNAP+20*GLORWARSNAP+" + attack_non_ele_dmg + ")", 
			$element[cold] : "COLD_DMG", 
			$element[hot] : "HOT_DMG", 
			$element[sleaze] : "SLEAZE_DMG", 
			$element[spooky] : "(((1+skill(butts of steel))*ANYSHEWHOWAS*SHIELD_POWER/7.5)+SPOOKY_DMG)", 
			$element[stench] : "STENCH_DMG"},
		float [string] {},
		boolean [string] {"attack" : true},
		max("class(Turtle Tamer)",hitchance),
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

//////////////////////////////////
//Helper functions

element PM_Element()
{
	if((have_effect(to_effect("Spirit of Wormwood")) > 0) || have_equipped(to_item(2494)))
	{//Necrotelicomnicon 2494
		return $element[spooky];
	}
	else if((have_effect(to_effect("Spirit of Cayenne")) > 0) || have_equipped(to_item(1547)))
	{//Codex of Capsaicin Conjuration 1547
		return $element[hot];
	}
	else if ((have_effect(to_effect("Spirit of Peppermint")) > 0) || have_equipped(to_item(1548)))
	{//Gazpacho's Glacial Grimoire 1548
		return $element[cold];
	}
	else if ((have_effect(to_effect("Spirit of Garlic")) > 0) || have_equipped(to_item(2495)))
	{//Cookbook of the Damned 2495
		return $element[stench];
	}
	else if ((have_effect(to_effect("Spirit of Bacon Grease")) > 0) || have_equipped(to_item(2496)))
	{//Sinful Desires
		return $element[sleaze];
	}
	else
	{
		return $element[none];
	}
}

//////////////////////////////////
//Spell damage

float dmg_eval(string expr, float[string] vars)
{
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

	//WEAPON_DMG - weapon damage
	//BONUS_WEAPON_DAMAGE - bonus weapon damage
	//ATTK_TYPE_STAT_MOD - 1.25 non-Seal Clubber's lunging thrust-smack, 1.3, seal-clubber's lunging thrust-smack or northern explosion, 1.4 bashing slam smash, 1 otherwise
	//WPN_TYPE_STAT_MOD - 1 for melee, .75 range, .25 no weapon
	//ATK_TYPE_WPN_DMG_MOD - 2 for thrust-smack/mighty axing, 3 for lunging-thrust-smack/northern explosion
	//		5 for bashing slam smash, 5 for cleave, 1 otherwise
	//BONUS_WEAPON_DMG includes ranged damage for ranged weapon  
	buffer b;
	matcher m = create_matcher( "\\b[a-zA-Z0-9_]*\\b", expr );
	while (m.find()) {
		string var = m.group(0);
		switch (m.group(0))
		{
			case "MUS":
				m.append_replacement(b, my_buffedstat($stat[muscle]).to_string());
			break;
			case "MYS":
				m.append_replacement(b, my_buffedstat($stat[mysticality]).to_string());
			break;
			case "MOX":
				m.append_replacement(b, my_buffedstat($stat[moxie]).to_string());
			break;
			case "WEAPON_DMG":
				m.append_replacement(b, to_float(equipped_item($slot[weapon]).get_power()*.15).to_string());
			break;
			case "WEAPON_STAT":
				if(weapon_type(equipped_item($slot[weapon])) == $stat[moxie])
				{
					m.append_replacement(b, my_buffedstat($stat[moxie]).to_string());
				}
				else
				{
					m.append_replacement(b, my_buffedstat($stat[muscle]).to_string());
				}
			break;
			case "OFFHAND":
				if(equipped_item($slot[off-hand]) != $item[none])
				{
					if(weapon_type(equipped_item($slot[off-hand])) != $stat[none])
					{
						m.append_replacement(b, "0");
					}
					else
					{
						m.append_replacement(b, (to_float(equipped_item($slot[off-hand]).get_power()*.15)).to_string());
					}
				}
				else
				{
					m.append_replacement(b, "0");
				}
			break;
			case "HAT_POWER":
				m.append_replacement(b, to_float(equipped_item($slot[hat]).get_power()).to_string());
			break;
			case "PANTS_POWER":
				m.append_replacement(b, to_float(equipped_item($slot[pants]).get_power()).to_string());
			break;
			case "SHIELD_POWER":
				if(item_type(equipped_item($slot[off-hand])) == "shield")
				{
					m.append_replacement(b, to_float(equipped_item($slot[off-hand]).get_power()).to_string());
				}
				else
				{
					m.append_replacement(b, to_float(equipped_item($slot[off-hand]).get_power()).to_string());
				}
			break;
			case "ANYWARSNAP":
				if(have_effect(to_effect("Blessing of War Snapper")) > 0
				|| have_effect(to_effect("Grand Blessing of War Snapper")) > 0
				|| have_effect(to_effect("Glorious Blessing of War Snapper")) > 0
				)
				{
					m.append_replacement(b, "1".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "WARSNAP":
				if(have_effect(to_effect("Blessing of War Snapper")) > 0)
				{
					m.append_replacement(b, "1".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "GRANDWARSNAP":
				if(have_effect(to_effect("Grand Blessing of War Snapper")) > 0)
				{
					m.append_replacement(b, "1".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "GLORWARSNAP":
				if(have_effect(to_effect("Glorious Blessing of War Snapper")) > 0)
				{
					m.append_replacement(b, "1".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "ANYSTORMTORT":
				if(have_effect(to_effect("Blessing of Storm Tortoise")) > 0
				|| have_effect(to_effect("Grand Blessing of Storm Tortoise")) > 0
				|| have_effect(to_effect("Glorious Blessing of Storm Tortoise")) > 0
				)
				{
					m.append_replacement(b, "1".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "STORMTORT":
				if(have_effect(to_effect("Blessing of Storm Tortoise")) > 0)
				{
					m.append_replacement(b, "1".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "GRANDSTORMTORT":
				if(have_effect(to_effect("Grand Blessing of Storm Tortoise")) > 0)
				{
					m.append_replacement(b, "1".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "GLORSTORMTORT":
				if(have_effect(to_effect("Glorious Blessing of Storm Tortoise")) > 0)
				{
					m.append_replacement(b, "1".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "ANYSHEWHOWAS":
				if(have_effect(to_effect("Blessing of She-Who-Was")) > 0
				|| have_effect(to_effect("Grand Blessing of She-Who-Was")) > 0
				|| have_effect(to_effect("Glorious Blessing of She-Who-Was")) > 0
				)
				{
					m.append_replacement(b, "1".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "SHEWHOWAS":
				if(have_effect(to_effect("Blessing of She-Who-Was")) > 0)
				{
					m.append_replacement(b, "1".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "GRANDSHEWHOWAS":
				if(have_effect(to_effect("Grand Blessing of She-Who-Was")) > 0)
				{
					m.append_replacement(b, "1".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "GLORSHEWHOWAS":
				if(have_effect(to_effect("Glorious Blessing of She-Who-Was")) > 0)
				{
					m.append_replacement(b, "1".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "NOTTBLESS":
				if(have_effect(to_effect("Blessing of She-Who-Was")) > 0
				|| have_effect(to_effect("Grand Blessing of She-Who-Was")) > 0
				|| have_effect(to_effect("Glorious Blessing of She-Who-Was")) > 0
				|| have_effect(to_effect("Blessing of Storm Tortoise")) > 0
				|| have_effect(to_effect("Grand Blessing of Storm Tortoise")) > 0
				|| have_effect(to_effect("Glorious Blessing of Storm Tortoise")) > 0
				|| have_effect(to_effect("Blessing of War Snapper")) > 0
				|| have_effect(to_effect("Grand Blessing of War Snapper")) > 0
				|| have_effect(to_effect("Glorious Blessing of War Snapper")) > 0
				)
				{
					m.append_replacement(b, "0".to_string());
				}
				else
				{
					m.append_replacement(b, "1".to_string());
				}
			break;
			case "PM_COLD":
				if(PM_Element() == $element[cold])
				{
					m.append_replacement(b, "1".to_string());
				}
				else if(PM_Element() == $element[none])
				{
					m.append_replacement(b, ".2".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "PM_HOT":
				if(PM_Element() == $element[hot])
				{
					m.append_replacement(b, "1".to_string());
				}
				else if(PM_Element() == $element[none])
				{
					m.append_replacement(b, ".2".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "PM_SLEAZE":
				if(PM_Element() == $element[sleaze])
				{
					m.append_replacement(b, "1".to_string());
				}
				else if(PM_Element() == $element[none])
				{
					m.append_replacement(b, ".2".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "PM_SPOOKY":
				if(PM_Element() == $element[spooky])
				{
					m.append_replacement(b, "1".to_string());
				}
				else if(PM_Element() == $element[none])
				{
					m.append_replacement(b, ".2".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "PM_STENCH":
				if(PM_Element() == $element[stench])
				{
					m.append_replacement(b, "1".to_string());
				}
				else if(PM_Element() == $element[none])
				{
					m.append_replacement(b, ".2".to_string());
				}
				else
				{
					m.append_replacement(b, "0".to_string());
				}
			break;
			case "WPN_TYPE_STAT_MOD":
				if(weapon_type(equipped_item($slot[weapon])) == $stat[moxie])
				{
					m.append_replacement(b, (0.75).to_string());
				}
				else if (equipped_item($slot[weapon]) == $item[none])
				{
					m.append_replacement(b, (0.25).to_string());
				}
				else
				{
					m.append_replacement(b, (1).to_string());
				}
			break;
			case "BONUS_SPELL_DAMAGE":
				m.append_replacement(b, numeric_modifier("Spell Damage").to_string());
			break;
			case "COLD_SPELL_DMG":
				m.append_replacement(b, numeric_modifier("Cold Damage").to_string());
			break;
			case "HOT_SPELL_DMG":
				m.append_replacement(b, numeric_modifier("Hot Damage").to_string());
			break;
			case "SLEAZE_SPELL_DMG":
				m.append_replacement(b, numeric_modifier("Sleaze Damage").to_string());
			break;
			case "SPOOKY_SPELL_DMG":
				m.append_replacement(b, numeric_modifier("Spooky Damage").to_string());
			break;
			case "STENCH_SPELL_DMG":
				m.append_replacement(b, numeric_modifier("Stench Damage").to_string());
			break;
			case "BONUS_WEAPON_DAMAGE":
				if(weapon_type(equipped_item($slot[weapon])) == $stat[moxie])
				{
					m.append_replacement(b, (numeric_modifier("Ranged Damage") + numeric_modifier("Weapon Damage")).to_string());
				}
				else
				{
					m.append_replacement(b, numeric_modifier("Weapon Damage").to_string());
				}
			break;     
			case "SPELL_CRIT":
				m.append_replacement(b, (numeric_modifier("Spell Critical Percent")/100).to_string());
			break;
			case "CRIT":
				m.append_replacement(b, (numeric_modifier("Critical Hit Percent")/100).to_string());
			break;
			case "SPELL_MULT":
				m.append_replacement(b, (numeric_modifier("spell damage percent")/100).to_string());
			break;
			case "WEAPON_MULT":
				if(weapon_type(equipped_item($slot[weapon])) == $stat[moxie])
				{
					m.append_replacement(b, ((numeric_modifier("Ranged Damage Percent") + numeric_modifier("Weapon Damage Percent"))/100).to_string());
				}
				else
				{
					m.append_replacement(b, (numeric_modifier("Weapon Damage Percent")/100).to_string());
				}
			break;
			case "AUTOHIT":
				if((have_effect(to_effect("chalked weapon")) > 0)
				|| (have_effect(to_effect("comic violence")) > 0)
				|| (have_effect(to_effect("Song of Battle")) > 0)
				|| (have_equipped(to_item("thor's pliers")))
				|| (have_equipped(to_item("red fox glove")))
				)
				{
					m.append_replacement(b, "1");
				}
				else
				{
					m.append_replacement(b, "0");
				}
			break;
			case "RANGED_MULT":
				m.append_replacement(b, (numeric_modifier("Ranged Damage Percent")/100).to_string());
			break;
			case "COLD_DMG":
				m.append_replacement(b, numeric_modifier("Cold Damage").to_string());
			break;
			case "HOT_DMG":
				m.append_replacement(b, numeric_modifier("Hot Damage").to_string());
			break;
			case "SLEAZE_DMG":
				m.append_replacement(b, numeric_modifier("Sleaze Damage").to_string());
			break;
			case "SPOOKY_DMG":
				m.append_replacement(b, numeric_modifier("Spooky Damage").to_string());
			break;
			case "STENCH_DMG":
				m.append_replacement(b, numeric_modifier("Stench Damage").to_string());
			break;
			case "BONUS_ELEMENTAL_DAMAGE":
				m.append_replacement(b,
				(numeric_modifier("Cold Damage")
				+numeric_modifier("Hot Damage")
				+numeric_modifier("Sleaze Damage")
				+numeric_modifier("Spooky Damage")
				+numeric_modifier("Stench Damage")).to_string());
			break;
			default:
				if (vars contains var)
				{
					m.append_replacement(b, vars[var].to_string());
				}
			break;
		}
		// could implement functions, pref access, etc. here
	}
	m.append_tail(b);
	//print(b.to_string());
	return modifier_eval(b.to_string());
}

float dmg_eval(combat_skill spell, element el, monster mon, boolean dot)
{
	//print (spell.sk.to_string());
	/*
	string capped_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min((class(Pastamancer)*skill(Bringing Up the Rear)*PASTA+1)*CAP,(base+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+BONUS_ELEMENTAL_DAMAGE+SAUCE*min(L,10)*skill(Intrinsic Spiciness)))";
	string uncapped_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*((base+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+BONUS_ELEMENTAL_DAMAGE+SAUCE*min(L,10)*skill(Intrinsic Spiciness)))";
	*/
	float [string] vars;
	foreach var in spell.dmg_props
	{
		vars[var] = spell.dmg_props[var];
	}
	vars["MON_GROUP"] = 1; // to replace
	vars["MONDEF"] = mon.monster_defense();
	switch(el)
	{
		case $element[hot]:
			vars["BONUS_ELEMENTAL_DAMAGE"] = numeric_modifier("hot spell damage");
			switch(mon.monster_element())
			{
				case $element[hot]:
					vars["EL_MULT"] = 0;
				break;
				case $element[cold]:
				case $element[spooky]:
					vars["EL_MULT"] = 2;
				break;
				default:
					vars["EL_MULT"] = 1;
				break;
			}
		break;
		case $element[cold]:
			vars["BONUS_ELEMENTAL_DAMAGE"] = numeric_modifier("cold spell damage");
			switch(mon.monster_element())
			{
				case $element[cold]:
					vars["EL_MULT"] = 0;
				break;
				case $element[sleaze]:
				case $element[stench]:
					vars["EL_MULT"] = 2;
				break;
				default:
					vars["EL_MULT"] = 1;
				break;
			}
		break;
		case $element[sleaze]:
			vars["BONUS_ELEMENTAL_DAMAGE"] = numeric_modifier("sleaze spell damage");
			switch(mon.monster_element())
			{
				case $element
				[hot]:
				case $element[stench]:
					vars["EL_MULT"] = 2;
				break;
				case $element[sleaze]:
					vars["EL_MULT"] = 0;
				break;
				default:
					vars["EL_MULT"] = 1;
				break;
			}
		break;
		case $element[spooky]:
			vars["BONUS_ELEMENTAL_DAMAGE"] = numeric_modifier("spooky spell damage");
			switch(mon.monster_element())
			{
				case $element[cold]:
				case $element[sleaze]:
					vars["EL_MULT"] = 2;
				break;
				case $element[spooky]:
					vars["EL_MULT"] = 0;
				break;
				default:
					vars["EL_MULT"] = 1;
				break;
			}
		break;
		case $element[stench]:
			vars["BONUS_ELEMENTAL_DAMAGE"] = numeric_modifier("stench spell damage");
			switch(mon.monster_element())
			{
				case $element[hot]:
				case $element[spooky]:
					vars["EL_MULT"] = 2;
				break;
				case $element[stench]:
					vars["EL_MULT"] = 0;
				break;
				default:
					vars["EL_MULT"] = 1;
				break;
			}
		break;
		default:
			vars["BONUS_ELEMENTAL_DAMAGE"] = 1;
			vars["EL_MULT"] = 1;
		break;
	}

	float damage;
	if(dot)
	{
		dmg_eval(spell.dot[el], vars);
	}
	else
	{
		dmg_eval(spell.damage[el], vars);
	}
	return damage;
}
float hit_eval(combat_skill csk, monster mon)
{
	float [string] vars;
	foreach var in spell.dmg_props
	{
		vars[var] = spell.dmg_props[var];
	}
	vars["MON_GROUP"] = 1; // to replace
	vars["MONDEF"] = mon.monster_defense();

	float dmg_eval(csk.hitchance, vars);
}

skdmg attack_eval(combat_skill csk, monster mon)
{
	skdmg result = new skdmg();
	//print(csk.sk.to_string());
	foreach el in csk.damage
	{
		float damage = dmg_eval(csk, el, mon, false);
		if(csk.props["best"] == true)
		{
			
			result.dmg = max(result.dmg,damage);
			result.eldmg[el] = damage;
		}
		else
		{
			result.dmg += damage;
		}
	}
	foreach el in csk.dot
	{
		float damage = dmg_eval(csk, el, mon, true);
		if(csk.props["best"] == true)
		{
			
			result.dotdmg = max(result.dmg,damage);
			result.eldotdmg[el] = damage;
		}
		else
		{
			result.eldotdmg[el] += damage;
		}
	}

	result.hitchance = hit_eval(csk.hitchance);
	result.hitdmg = result.hitchance * result.dmg;
	result.dothitdmg = result.hitchance * result.dotdmg;
	result.sk = csk.sk;
	result.cmbtsk = csk;
	result.ttd = ceil(mon.monster_hp()/ max(1,result.hitdmg));
	result.dmg_taken = mon.expected_damage() * result.ttd;
	result.tot_mana_used = result.ttd * mp_cost(sk);
	result.tmtw = result.tot_mana_used + 20*result.dmg_taken / (.5*my_maxhp());	

	return result;
}
float attack_eval(combat_skill spell)
{
	return attack_eval(spell,last_monster());
}
float attack_eval(skill spell, monster mon)
{
	return attack_eval(cmbt_skills[spell],mon);
}
float attack_eval(skill spell)
{
	return attack_eval(cmbt_skills[spell],last_monster());
}
//////////////////////////////////
//Skill Picking

	skdmg [int] best_skills(string sktype,monster mon, boolean have_only)
	{
		float mp_regen = (numeric_modifier("mp regen min") + numeric_modifier("mp regen max"))/2;
		boolean [skill] choices;
		foreach sk in cmbt_skills
		{
			//print(sk.to_string());
			//print(cmbt_skills[sk].dmg_exp);
			if (sktype == "" || cmbt_skills[sk].props contains sktype)
			{
				if((have_skill(sk) && have_only) || sk == $skill[none])
				{
					choices[sk] = true;
				}
				else if (!have_only)
				{
					choices[sk] = true;
				}
			}
			/*
			if(mp_cost(sk) < mp_regen && have_skill(sk))
			{
				choices[sk] = true;
			}*/
		}
		skdmg [int] skillranks;
		foreach sk in choices
		{
			skdmg myskdmg = attack_eval(sk,mon);
			skillranks[skillranks.count()] = myskdmg;
		}
		foreach num in skillranks
		{
			if(skillranks[num].ttd > 15)
			{
				remove skillranks[num];
			}
		}
		sort skillranks by value.tmtw;
		return skillranks;
	}
	skdmg [int] best_skills(monster mon)
	{
		return best_skills("", mon, true);
	}
	skdmg [int] best_skills(string sktype, monster mon)
	{
		return best_skills(sktype, mon, true);
	}
	skdmg [int] best_skills(boolean have_only)
	{
		return best_skills("",last_monster(), have_only);
	}
	skdmg [int] best_skills(string sktype, boolean have_only)
	{
		return best_skills(sktype, last_monster(), have_only);
	}
	skdmg [int] best_skills()
	{
		return best_skills("",last_monster(), true);
	}
	skdmg [int] best_skills(string sktype)
	{
		return best_skills(sktype, last_monster(), true);
	}

	void print_best_skills(string sktype, monster mon, boolean have_only)
	{
		print("monster is: " +  mon.to_string());
		skdmg [int] bs = best_skills(sktype,mon, have_only);
		foreach num in bs
		{
			print_html("%s has damage %s, ttd %s, mana used %s, dmg_taken %s",string [int] {to_string(bs[num].sk),to_string(bs[num].dmg),to_string(bs[num].ttd),to_string(bs[num].tmtw),to_string(bs[num].dmg_taken)});
		}
	}
	void print_best_skills(string sktype,boolean have_only)
	{
		print_best_skills(sktype,last_monster(), have_only);
	}
	void print_best_skills(boolean have_only)
	{
		print_best_skills("",last_monster(), have_only);
	}
	void print_best_skills(string sktype, monster mon)
	{
		print_best_skills(sktype,mon, true);
	}
	void print_best_skills(monster mon)
	{
		print_best_skills("",mon, true);
	}
	void print_best_skills(string sktype)
	{
		print_best_skills(sktype,last_monster(), true);
	}
	void print_best_skills()
	{
		print_best_skills("",last_monster(), true);
	}

void beefy_combat_tools_parse(string command)
{
	string [int] arry = command.split_string(",");
	switch (arry[0])
	{
		case "all spells":
			switch(arry.count())
			{
				case 1:
					print_best_skills("spell",false);
				break;
				case 2:
					print_best_skills("spell",arry[1].to_monster(),false);
				break;
			}
		case "spell":
			switch(arry.count())
			{
				case 1:
					print_best_skills("spell");
				break;
				case 2:
					print_best_skills("spell",arry[1].to_monster());
				break;
			}
		break;
		case "all":
			switch(arry.count())
			{
				case 1:
					print_best_skills("",false);
				break;
				case 2:
					print_best_skills("",arry[1].to_monster(),false);
				break;
			}
		break;
		case "allhave":
			switch(arry.count())
			{
				case 1:
					print_best_skills("");
				break;
				case 2:
					print_best_skills("",arry[1].to_monster());
				break;
			}
		break;
		case "attack":
			switch(arry.count())
			{
				case 1:
					print_best_skills("attack");
				break;
				case 2:
					print_best_skills("attack",arry[1].to_monster());
				break;
			}
		break;
		case "all attacks":
			switch(arry.count())
			{
				case 1:
					print_best_skills("attack",false);
				break;
				case 2:
					print_best_skills("attack",arry[1].to_monster(),false);
				break;
			}
		break;
		default:
		break;
	}
}

void main(string command)
{
	beefy_combat_tools_parse(command);
}