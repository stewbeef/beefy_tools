script "beefy_combat_tools.ash";
import "beefy_tools.ash";
import "beefy_item_ext.ash";
import "beefy_combat_skills.ash";
import "beefy_monsters.ash";

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

float combat_eval(string expr, float[string] vars)
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
				m.append_replacement(b, numeric_modifier("Cold Spell Damage").to_string());
			break;
			case "HOT_SPELL_DMG":
				m.append_replacement(b, numeric_modifier("Hot Spell Damage").to_string());
			break;
			case "SLEAZE_SPELL_DMG":
				m.append_replacement(b, numeric_modifier("Sleaze Spell Damage").to_string());
			break;
			case "SPOOKY_SPELL_DMG":
				m.append_replacement(b, numeric_modifier("Spooky Spell Damage").to_string());
			break;
			case "STENCH_SPELL_DMG":
				m.append_replacement(b, numeric_modifier("Stench Spell Damage").to_string());
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

float _hitchance_on_monster(monster_status mon, combat_skill csk, float [string] vars)
{
	return combat_eval(csk.hitchance, vars);
}

skdmg _attack_eval(monster_status mon, combat_skill csk, float [string] vars)
{
	skdmg result = new skdmg();
	//print(csk.sk.to_string());
	foreach el in csk.damage
	{
		float damage =  mon.damage_mult(el)*combat_eval(csk.damage[el], vars);
		//print(damage.to_string());
		if(csk.props["best"] == true)
		{
			
			result.dmg = max(result.dmg,damage);
		}
		else
		{
			result.dmg += damage;
			result.eldmg[el] = damage;
		}
	}
	foreach el in csk.dot
	{
		float damage = damage_mult(mon,el)*combat_eval(csk.dot[el], vars);

		if(csk.props["best"] == true)
		{
			
			result.dotdmg = max(result.dmg,damage);
			
		}
		else
		{
			result.dotdmg += damage;
			result.eldotdmg[el] = damage;
		}
	}

	result.hitchance = mon._hitchance_on_monster(csk,vars);
	result.hitdmg = result.hitchance * result.dmg;
	result.dothitdmg = result.hitchance * result.dotdmg;
	result.sk = csk.sk;
	result.cmbtsk = csk;

	result.ttd = ceil(mon.hp() / max(1,result.hitdmg));
	result.dmg_taken = mon.damage() * result.ttd;
	result.tot_mana_used = result.ttd * mp_cost(result.sk);
	if(result.dmg_taken > my_maxhp())
	{
		result.tmtw = 10*(result.tot_mana_used + 20*result.dmg_taken / (.5*my_maxhp()));	
	}
	else if(result.dmg_taken > .8*my_maxhp())
	{
		result.tmtw = 5*(result.tot_mana_used + 20*result.dmg_taken / (.5*my_maxhp()));
	}
	else if(result.dmg_taken > .6*my_maxhp())
	{
		result.tmtw = 2*(result.tot_mana_used + 20*result.dmg_taken / (.5*my_maxhp()));
	}
	else
	{
		result.tmtw = result.tot_mana_used + 20*result.dmg_taken / (.5*my_maxhp());	
	}
	

	return result;
}
skdmg _attack_eval(monster_status mon, skill sk, float [string] vars)
{
	return mon._attack_eval(cmbt_skills[sk], vars);
}

skdmg test_skill_on_monster(monster_status mon, combat_skill csk, float [string] vars)
{
	return mon._attack_eval(csk, vars);
}
skdmg test_skill_on_monster(monster_status mon, combat_skill csk)
{
	float [string] vars = csk.copy_dmg_props();
	vars["MON_GROUP"] = 1; // to replace
	vars["MONDEF"] = mon.defense();
	vars["MONATK"] = mon.attack();
	return test_skill_on_monster(mon, csk, vars);
}

skdmg test_skill_on_monster(monster_status mon, skill sk)
{
	return test_skill_on_monster(mon, cmbt_skills[sk]);
}

monster_status skill_on_monster(monster_status mon, combat_skill csk)
{
	float [string] vars = csk.copy_dmg_props();
	vars["MON_GROUP"] = 1; // to replace
	vars["MONDEF"] = mon.defense();
	vars["MONATK"] = mon.attack();
	skdmg result = mon.test_skill_on_monster(csk, vars);
	return mon.apply_skill(result);	
}
monster_status skill_on_monster(monster_status mon, skill sk)
{
	return skill_on_monster(mon, cmbt_skills[sk]);
}



//////////////////////////////////
//Skill Picking

	skdmg [int] best_skills(string sktype,monster_status mon, boolean have_only)
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
			skdmg myskdmg = mon.test_skill_on_monster(sk);
			skillranks[skillranks.count()] = myskdmg;
		}
		/*
		foreach num in skillranks
		{
			if(skillranks[num].ttd > 15)
			{
				remove skillranks[num];
			}
		}
		*/
		sort skillranks by value.tmtw;
		return skillranks;
	}
	skdmg [int] best_skills(monster_status mon)
	{
		return best_skills("", mon, true);
	}
	skdmg [int] best_skills(string sktype, monster_status mon)
	{
		return best_skills(sktype, mon, true);
	}


	void print_best_skills(string sktype, monster_status mon, boolean have_only)
	{
		print("monster is: " +  mon.to_string());
		skdmg [int] bs = best_skills(sktype,mon, have_only);
		foreach num in bs
		{
			print_html("%s has damage %s, %s hit chance, ttd %s, mana used %s, dmg_taken %s",string [int] {to_string(bs[num].sk),to_string(bs[num].dmg),to_string(bs[num].hitchance),to_string(bs[num].ttd),to_string(bs[num].tmtw),to_string(bs[num].dmg_taken)});
		}
	}

	void print_best_skills(string sktype, monster_status mon)
	{
		print_best_skills(sktype, mon, true);
	}
	void print_best_skills(monster_status mon)
	{
		print_best_skills("",mon, true);
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
					print_best_skills("spell",mon_init(last_monster(),false),false);
				break;
				case 2:
					print_best_skills("spell",mon_init(arry[1].to_monster(),true),false);
				break;
			}
		case "spell":
			switch(arry.count())
			{
				case 1:
					print_best_skills("spell", mon_init(last_monster(),false), true);
				break;
				case 2:
					print_best_skills("spell",mon_init(arry[1].to_monster(),true), true);
				break;
			}
		break;
		case "all":
			switch(arry.count())
			{
				case 1:
					print_best_skills("", mon_init(last_monster(),false), false);
				break;
				case 2:
					print_best_skills("",mon_init(arry[1].to_monster(),true),false);
				break;
			}
		break;
		case "allhave":
			switch(arry.count())
			{
				case 1:
					print_best_skills("", mon_init(last_monster(),false), true);
				break;
				case 2:
					print_best_skills("",mon_init(arry[1].to_monster(),true), true);
				break;
			}
		break;
		case "attack":
			switch(arry.count())
			{
				case 1:
					print_best_skills("attack", mon_init(last_monster(),false), true);
				break;
				case 2:
					print_best_skills("attack",mon_init(arry[1].to_monster(),true), true);
				break;
			}
		break;
		case "all attacks":
			switch(arry.count())
			{
				case 1:
					print_best_skills("attack",mon_init(last_monster(),false), false);
				break;
				case 2:
					print_best_skills("attack",mon_init(arry[1].to_monster(),true),false);
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