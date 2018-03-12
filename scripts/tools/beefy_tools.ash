//General tools for scripting

script "beefy_tools.ash";

import "beefy_records.ash";
///////////////////////
//Records
record strint
{
	string str;
	int num;
};


record player_info
{
//viewable info
	string my_name;
	string my_id;
	int my_clan_id;
	string my_clan_name;
	int my_ascensions;
	class my_class;
	int my_level;
	int my_adv_remaining;
	int my_total_turns;
	int my_turn_count;
	int my_daycount;
	int my_pvp_attacks;
	boolean my_pvp_enabled;
	
//character sheet
	string favorite_food;
	string favorite_booze;
	
//stats
	int my_base_mus;
	int my_base_mys;
	int my_base_mox;
	
	int my_buffed_mus;
	int my_buffed_mys;
	int my_buffed_mox;
	
//resources
	int my_hitpoints;
	int my_manapoints;
	int my_max_hitpoints;
	int my_max_manapoints;
	familiar my_current_familiar;

//sign & path
	string my_sign;
	string my_path;
	boolean can_use_mall;
	boolean in_hardcore;
	boolean in_badmoon;

//Consumption
	int my_inebriety;
	int my_inebriety_limit;
	int my_fullness;
	int my_fullness_limit;
	int my_spleen;
	int my_spleen_limit;

//Time and Date
	int my_moonlight;
	int my_moonphase;
};

record time
{
	int hour;
	int minute;
	int second;
	string time_zone;
};

record datetime
{
	string my_date;
	time my_time;
};

record matcher_list
{
	string text;
	string [string] regex;
};

record match_list
{
	string text;
	string [string] regex;
	boolean success;
	boolean [string] found;
	string [string,int,int] matches;
};

///////////////////////
//Constants
boolean [slot] norm_slots()
{
	return $slots[hat,back,weapon,off-hand,shirt,pants,acc1,acc2,acc3,familiar];
}
///////////////////////
//logging
int beefy_logging()
{
	return get_property("beefy_logging").to_int();
}

///////////////////////
//Date-Time functions
	///////////////////////
	//Date-Time conversions
	time to_time(string a)
	{

		string parsed_a = format_date_time("hh:mm:ss z",a,"HH:mm:ss:z");

		string [int] time_array = parsed_a.split_string(":");
		time time_a;
		time_a.hour = time_array[0].to_int();
		time_a.minute = time_array[1].to_int();
		time_a.second = time_array[2].to_int();
		time_a.time_zone = time_array[3];
		return time_a;
	}
	
	///////////////////////
	//Date-Time Math functions
string previous_day(string date)
{//expects date in yyyyMMdd format
	int year = date.substring(0,4).to_int();
	int month = date.substring(4,6).to_int();
	int day = date.substring(6).to_int();
	print(year);
	print(month);
	print(day);
	boolean reduce_month = false;
	boolean reduce_year = false;
	
	if(day == 1)
	{
		switch(month - 1)
		{
			case 0: //december
			case 1:
			case 3:
			case 5:
			case 7:
			case 8:
			case 10:
				day = 31;
				break;			
			case 4:
			case 6:
			case 9:
			case 11:
				day = 30;
				break;
			case 2:
				int year_div4 = year / 4;
				if(year_div4 * 4 == year)
				{
					day = 29;
				}
				else
				{
					day = 28;
				}
				break;
		}
		reduce_month = true;
	}
	else
	{
		day = day - 1;
	}
	
	if(reduce_month)
	{
		if(month == 1)
		{
			month = 12;
			reduce_year = true;
		}
		else
		{
			month = month - 1;
		}
	}
	
	if(reduce_year)
	{
		year = year - 1;
	}
	int prev_date = year * 10000 + month * 100 + day;
	
	return prev_date.to_string();
	
}

int previous_day(int date)
{
	return previous_day(date.to_string()).to_int();
	
}

string previous_day(string date, int days)
{
	if(days < 1)
	{
		abort("previous_day given invalid number of past days, must be 0 or greater");
	}
	else if(days == 0)
	{
		return date;
	}
	else
	{
		string past_day = date;
		for num from 1 to days by 1
		{
			past_day = previous_day(past_day);
		}
		return past_day;
	}
	return date;
}

	///////////////////////
	//Date-Time Comparisons
boolean day_lt(string a, string b)
{
	if(a.to_int() < b.to_int())
	{
		return true;
	}
	return false;
}
boolean day_gt(string a, string b)
{
	if(a.to_int() > b.to_int())
	{
		return true;
	}
	return false;
}
boolean day_lte(string a, string b)
{
	if(a.to_int() >= b.to_int())
	{
		return true;
	}
	return false;
}
boolean day_gte(string a, string b)
{
	if(a.to_int() >= b.to_int())
	{
		return true;
	}
	return false;
}

boolean time_lt(string a, string b)
{
	time time_a = to_time(a);
	time time_b = to_time(b);
	if(time_a.hour < time_b.hour)
	{
		return true;
	}
	else if(time_a.hour > time_b.hour)
	{
		return false;
	}
	else
	{
		if(time_a.minute < time_b.minute)
		{
			return true;
		}
		else if(time_a.minute > time_b.minute)
		{
			return false;
		}
		else
		{
			if(time_a.second < time_b.second)
			{
				return true;
			}
			else if(time_a.second > time_b.second)
			{
				return false;
			}
			else
			{
				return false;
			}
		}
	}
	return false;
}
boolean time_gt(string a, string b)
{
	return time_lt(b,a);
}
boolean time_lte(string a, string b)
{
	if(a == b)
	{
		return true;
	}
	return time_lt(a,b);
}
boolean time_gte(string a, string b)
{
	if(a == b)
	{
		return true;
	}
	return time_lt(b,a);
}
////////////////////////////////////////
//html page writing

record Page
{
	string title;
	buffer head_contents;
	buffer body_contents;
	string [string] body_attributes; //[attribute_name] -> attribute_value
	
    string css_file;
};

record stringwtags
{
	string text;
	boolean [string] tags;
};

void AddTag(stringwtags taggedstring, string tag)
{
	taggedstring.tags[tag] = true;
}



Page _mypage;

Page Page()
{
	return _mypage;
}

buffer HTMLGenerateTagPrefix(string tag, string [string] attributes)
{
	buffer result;
	result.append("<");
	result.append(tag);
	foreach attribute_name, attribute_value in attributes
	{
		//string attribute_value = attributes[attribute_name];
		result.append(" ");
		result.append(attribute_name);
		if (attribute_value != "")
		{
			boolean is_integer = attribute_value.is_integer(); //don't put quotes around integer attributes (i.e. width, height)
			
			result.append("=");
			if (!is_integer)
				result.append("\"");
			result.append(attribute_value);
			if (!is_integer)
				result.append("\"");
		}
	}
	result.append(">");
	return result;
}

buffer HTMLGenerateTagPrefix(string tag)
{
    buffer result;
    result.append("<");
    result.append(tag);
    result.append(">");
    return result;
}

buffer HTMLGenerateTagSuffix(string tag)
{
    buffer result;
    result.append("</");
    result.append(tag);
    result.append(">");
    return result;
}

buffer HTMLGenerateTagWrap(string tag, string source, string [string] attributes)
{
    buffer result;
    result.append(HTMLGenerateTagPrefix(tag, attributes));
    result.append(source);
    result.append(HTMLGenerateTagSuffix(tag));
	return result;
}

buffer HTMLGenerateTagWrap(string tag, string source)
{
    buffer result;
    result.append(HTMLGenerateTagPrefix(tag));
    result.append(source);
    result.append(HTMLGenerateTagSuffix(tag));
	return result;
}
/*
buffer Get_StringWTags_HTML(stringwtags taggedstring)
{
	buffer result;
	foreach tag in taggedstring.tags
	{
		result.append(HTMLGenerateTagPrefix(tag));
		
	}
	result.append(taggedstring.text);
	foreach tag in taggedstring.tags
	{
		result.append(HTMLGenerateTagSuffix(tag));
		
	}
	return result;
}

buffer Get_StringWTags_HTML(stringwtags [int] tagarray)
{
    buffer result;
	int n=0;
	int count=0;
	while(count < tagarray.count())
	{
		if(tagarray contains n)
		{
			result.append(Get_StringWTags_HTML(tagarray[n]));
			count++;
		}
		n++;
	}
	return result;
}

buffer Get_StringWTags_HTML(string [int, stringwtags] tagarray, string tag)
{
    buffer result;
	result.append(HTMLGenerateTagPrefix(tag));
    result.append(Get_StringWTags_HTML(tagarray));
	result.append(HTMLGenerateTagSuffix(tag));
	return result;
}
*/
buffer PageGenerateBodyContents(Page page_in)
{
    return page_in.body_contents;
}

buffer PageGenerateBodyContents()
{
    return Page().PageGenerateBodyContents();
}

buffer PageGenerateStyle(Page page_in)
{
	buffer result;
	if(page_in.css_file != "")
	{
		return result.append("<link rel=stylesheet type=text/css href=\"" + page_in.css_file + "\"");
	}
	else
	{
		return result;
	}
}

buffer PageGenerate(Page page_in)
{
	buffer result;
	
	result.append("<!DOCTYPE html>\n"); //HTML 5 target
	result.append("<html>\n");
	
	//Head:
	result.append("\t<head>\n");
	result.append("\t\t<title>");
	result.append(page_in.title);
	result.append("</title>\n");
	if (page_in.head_contents.length() != 0)
	{
        result.append("\t\t");
		result.append(page_in.head_contents);
		result.append("\n");
	}
	//Write CSS styles:
    result.append(PageGenerateStyle(page_in));
    result.append("\t</head>\n");
	
	//Body:
	result.append("\t");
	result.append(HTMLGenerateTagPrefix("body", page_in.body_attributes));
	result.append("\n\t\t");
	result.append(page_in.body_contents);
	result.append("\n");
		
	result.append("\t</body>\n");
	

	result.append("</html>");
	
	return result;
}

void PageGenerateAndWriteOut(Page page_in)
{
	write(PageGenerate(page_in));
}

void PageGenerateAndPrintOut(Page page_in)
{
	print_html(PageGenerate(page_in));
}

void PageSetTitle(Page page_in, string title)
{
	page_in.title = title;
}


void PageWriteHead(Page page_in, string contents)
{
	page_in.head_contents.append(contents);
}

void PageWriteHead(Page page_in, buffer contents)
{
	page_in.head_contents.append(contents);
}


void PageWrite(Page page_in, string contents)
{
	page_in.body_contents.append(contents);
}

void PageWrite(Page page_in, buffer contents)
{
	page_in.body_contents.append(contents);
}

void PageSetBodyAttribute(Page page_in, string attribute, string value)
{
	page_in.body_attributes[attribute] = value;
}


//Global:

buffer PageGenerate()
{
	return PageGenerate(Page());
}

void PageGenerateAndWriteOut()
{
	write(PageGenerate());
}
void PageGenerateAndPrintOut()
{
	print_html(PageGenerate());
}

void PageSetTitle(string title)
{
	PageSetTitle(Page(), title);
}


void PageWriteHead(string contents)
{
	PageWriteHead(Page(), contents);
}

void PageWriteHead(buffer contents)
{
	PageWriteHead(Page(), contents);
}

//Writes to body:

void PageWrite(string contents)
{
	PageWrite(Page(), contents);
}

void PageWrite(buffer contents)
{
	PageWrite(Page(), contents);
}

void PageSetBodyAttribute(string attribute, string value)
{
	PageSetBodyAttribute(Page(), attribute, value);
}

///////////////////////
//Player Info

string [string] get_favorite_consumes()
{
	string [string] fav_consumes;
	//<tr><td align="right"><a class="nounder" href="showconsumption.php">Favorite Food:</a></td><td><b>Cheer-E-Os</b></td></tr>
	//<tr><td align="right"><a class="nounder" href="showconsumption.php#booze">Favorite Booze:</a></td><td><b>cheer wine</b></td></tr>
	string charsheet = visit_url("charsheet.php");
	string match_string = "href=\"showconsumption.php.*?\">Favorite (.*?):</a>.*?</td>.*?<td>.*?<b>(.*?)</b>";
	string [int,int] consumptions = group_string(charsheet,match_string);
	foreach num in consumptions
	{
		
		fav_consumes[consumptions[num][1].to_lower_case()] = consumptions[num][2].to_lower_case();
	
	}	
	return fav_consumes;
}

player_info get_player_info()
{
//viewable info
	player_info my_info;
	my_info.my_name = my_name();
	my_info.my_id = my_id();
	my_info.my_clan_id = get_clan_id();
	my_info.my_clan_name = get_clan_name();
	my_info.my_ascensions = my_ascensions();
	my_info.my_class = my_class();
	my_info.my_level = my_level();
	my_info.my_adv_remaining = my_adventures();
	my_info.my_total_turns = total_turns_played();
	my_info.my_turn_count = my_turncount();
	my_info.my_daycount = my_daycount();
	my_info.my_pvp_attacks = pvp_attacks_left();
	my_info.my_pvp_enabled = hippy_stone_broken();

//character sheet
	string [string] fav_consumes = get_favorite_consumes();
	my_info.favorite_food = fav_consumes["food"];
	my_info. favorite_booze = fav_consumes["booze"];
//stats
	my_info.my_base_mus =  my_basestat($stat[muscle]);
	my_info.my_base_mys = my_basestat($stat[mysticality]);
	my_info.my_base_mox = my_basestat($stat[moxie]);
	
	my_info.my_buffed_mus = my_buffedstat($stat[muscle]);
	my_info.my_buffed_mys = my_buffedstat($stat[mysticality]);
	my_info.my_buffed_mox = my_buffedstat($stat[moxie]);
	
//resources
	my_info.my_hitpoints = my_hp();
	my_info.my_manapoints = my_mp();
	my_info.my_max_hitpoints = my_maxhp();
	my_info.my_max_manapoints = my_maxmp();
	my_info.my_current_familiar = my_familiar();

	string favorite_food;
//sign & path
	my_info.my_sign = my_sign();
	my_info.my_path = my_path();
	my_info.can_use_mall = can_interact();
	my_info.in_hardcore = in_hardcore();
	my_info.in_badmoon = in_bad_moon();
	
//Consumption	
	my_info.my_inebriety = my_inebriety();
	my_info.my_inebriety_limit = inebriety_limit();
	my_info.my_fullness = my_fullness();
	my_info.my_fullness_limit = fullness_limit();
	my_info.my_spleen;
	my_info.my_spleen_limit;

//Time and Date
	my_info.my_moonlight;
	my_info. my_moonphase;
	
	return my_info;
}

///////////////////////
//String Handling
boolean contains_rgx(string text, string match)
{
	matcher m = create_matcher(match,text);
	if(m.find())
	{
		return true;
	}
	return false;
}


///////////////////////
//Array Tools
	int last(string [int] list)
	{
		return (list.count() - 1);
	}
	///////////////////////
	//Add Conversions
	string [int] Add(string [int] list, string a)
	{
		

		if(list contains list.last())
		{
			print_html("Array Addition Error, map not in array format");
		}	
		else
		{
			list[list.last()] = a;
		}

		return list;
	}

	///////////////////////
	//Array Conversions To (type) [int]
string [int] ItemToStringArray(item [int] it_array)
{
	string [int] string_array;
	foreach num in it_array
	{
		string_array[num] = it_array[num].to_string();
	}
	return string_array;
}

string [int] BooleanItemToStringArray(boolean [item] bool_it)
{
	string [int] string_array;
	int index = 0;
	foreach it in bool_it
	{
		string_array[index] = it.to_string();
		index++;
	}
	return string_array;
}

string [int] BooleanSlotToStringArray(boolean [slot] bool_slot)
{
	string [int] string_array;
	int index = 0;
	foreach slt in bool_slot
	{
		string_array[index] = slt.to_string();
		index++;
	}
	return string_array;
}
string [int] BooleanStringToStringArray(boolean [string] bool_str)
{
	string [int] string_array;
	int index = 0;
	foreach str in bool_str
	{
		string_array[index] = str;
		index++;
	}
	return string_array;
}

item [int] BooleanItemToArray(boolean [item] bool_it)
{
	item [int] item_array;
	int index = 0;
	foreach it in bool_it
	{
		item_array[index] = it;
		index++;
	}
	return item_array;
}

slot [int] BooleanSlotToArray(boolean [slot] bool_slot)
{
	slot [int] slot_array;
	int index = 0;
	foreach slt in bool_slot
	{
		slot_array[index] = slt;
		index++;
	}
	return slot_array;
}
	///////////////////////
	//Array Conversions To boolean [(type)]
boolean [string] StringInt2BooleanString(string [int] str_int)
{
	boolean [string] bool_string;
	foreach num in str_int
	{
		bool_string[str_int[num]] = true;
	}
	return bool_string;
}

boolean [int] StringInt2BooleanInt(string [int] str_int)
{
	boolean [int] bool_int;
	foreach num in str_int
	{
		bool_int[str_int[num].to_int()] = true;
	}
	return bool_int;
}

boolean [int] IntInt2BooleanInt(int [int] int_int)
{
	boolean [int] bool_int;
	foreach num in int_int
	{
		bool_int[int_int[num]] = true;
	}
	return bool_int;
}

	///////////////////////
	//Array Subarray
string [int] FromXtoY(string[int] my_array, int start, int end)
{
	string[int] new_array;
	for num from start to end by 1
	{
		new_array[num - start] = my_array[num];
	}
	return new_array;
}
string [int] FromX(string[int] my_array, int start)
{
	int count = my_array.count() - 1;
	string[int] new_array;
	//print_html("Count %s, size %s, start %s", string[int]{count,my_array.count(), start});
	for num from start to count by 1
	{
		new_array[num - start] = my_array[num];
	}
	return new_array;
}
	///////////////////////
	//Array Conversions To string
	string concat(string [int] intstr_array, string sep)
	{
		buffer output;
		int count = 0;
		foreach num in intstr_array
		{
			output.append(intstr_array[num]);
			count++;
			if(count < intstr_array.count())
			{
				output.append(sep);
			}			
		}
		return output.to_string();
	}

	string concat(boolean [string] str_array, string sep)
	{
		buffer output;
		int count = 0;
		foreach str in str_array
		{
			output.append(str);
			count++;
			if(count < str_array.count())
			{
				output.append(sep);
			}			
		}
		return output.to_string();
	}

	string concat(boolean [slot] slot_array, string sep)
	{
		buffer output;
		int count = 0;
		foreach slt in slot_array
		{
			output.append(slt.to_string());
			count++;
			if(count < slot_array.count())
			{
				output.append(sep);
			}			
		}
		return output.to_string();
	}

	string concat(boolean [item] item_array, string sep)
	{
		buffer output;
		int count = 0;
		foreach it in item_array
		{
			output.append(it.to_string());
			count++;
			if(count < item_array.count())
			{
				output.append(sep);
			}			
		}
		return output.to_string();
	}
	///////////////////////
	//Array Merge
string [int] merge(string [int] array1, string [int] array2)
{
	string [int] merge_array;
	int index = 0;
	foreach num in array1
	{
		merge_array[index] = array1[num];
		index++;
	}
	foreach num in array2
	{
		merge_array[index] = array2[num];
		index++;
	}
	return merge_array;
}

item [int] merge(item [int] array1, item [int] array2)
{
	item [int] merge_array;
	int index = 0;
	foreach num in array1
	{
		merge_array[index] = array1[num];
		index++;
	}
	foreach num in array2
	{
		merge_array[index] = array2[num];
		index++;
	}
	return merge_array;
}

effect [int] merge(effect [int] array1, effect [int] array2)
{
	effect [int] merge_array;
	int index = 0;
	foreach num in array1
	{
		merge_array[index] = array1[num];
		index++;
	}
	foreach num in array2
	{
		merge_array[index] = array2[num];
		index++;
	}
	return merge_array;
}

skill [int] merge(skill [int] array1, skill [int] array2)
{
	skill [int] merge_array;
	int index = 0;
	foreach num in array1
	{
		merge_array[index] = array1[num];
		index++;
	}
	foreach num in array2
	{
		merge_array[index] = array2[num];
		index++;
	}
	return merge_array;
}

monster [int] merge(monster [int] array1, monster [int] array2)
{
	monster [int] merge_array;
	int index = 0;
	foreach num in array1
	{
		merge_array[index] = array1[num];
		index++;
	}
	foreach num in array2
	{
		merge_array[index] = array2[num];
		index++;
	}
	return merge_array;
}
///////////////////////
//Properties
	///////////////////////
	//Property Set
		///////////////////////
		//Property Set Get
		
		boolean [string] get_property_set(string name, string delim)
		{
			string raw_property = get_property(name);
			return StringInt2BooleanString(raw_property.split_string(delim));
		}
		boolean [string] get_property_set(string name)
		{
			return get_property_set(name,";");
		}
		
		///////////////////////
		//Property Set Set
		
		void set_property_set(string name, string value)
		{
			set_property(name, value);
		}
		void set_property_set(string name, boolean [string] values, string delim)
		{
			buffer my_property;
			int count = 0;
			foreach val in values
			{
				if(val != "")
				{
					my_property.append(val);
					count++;
					if(count < values.count())
					{
						my_property.append(delim);
					}
				}
			}
			set_property(name,my_property.to_string());
		}
		void set_property_set(string name, string [int] values, string delim)
		{
			boolean [string] strbool_array = StringInt2BooleanString(values);
			set_property_set(name, strbool_array, delim);
		}
		void set_property_set(string name, boolean [string] values)
		{
			set_property_set(name,values,";");
		}
		void set_property_set(string name, string [int] values)
		{
			set_property_set(name,values,";");
		}
		///////////////////////
		//Property Set Add
		void property_set_add(string name, boolean [string] values, string delim)
		{
			boolean [string] prop_array = get_property_set(name);
			foreach val in values
			{
				prop_array[val] = true;
			}
			
			set_property_set(name, prop_array, delim);
		}
		void property_set_add(string name, string [int] values, string delim)
		{
			boolean [string] prop_array = get_property_set(name);
			foreach num in values
			{
				prop_array[values[num]] = true;
			}
			
			set_property_set(name, prop_array, delim);
		}
		void property_set_add(string name, string value, string delim)
		{
			boolean [string] prop_array;
			prop_array[value] = true;
			property_set_add(name, prop_array, delim);
		}
		void property_set_add(string name, boolean [string] values)
		{
			property_set_add(name, values, ";");
		}
		void property_set_add(string name, string [int] values)
		{
			property_set_add(name, values, ";");
		}
		void property_set_add(string name, string value)
		{
			property_set_add(name, value, ";");
		}		
		///////////////////////
		//Property Set Remove
		void property_set_remove(string name, boolean [string] values, string delim)
		{
			boolean [string] prop_array = get_property_set(name);
			foreach val in values
			{
				if(prop_array contains val)
				{
					remove prop_array[val];
				}
			}
			
			set_property_set(name, prop_array, delim);
		}
		void property_set_remove(string name, string [int] values, string delim)
		{
			boolean [string] prop_array = get_property_set(name);
			foreach num in values
			{
				if(prop_array contains values[num])
				{
					remove prop_array[values[num]];
				}
			}
			
			set_property_set(name, prop_array, delim);
		}
		void property_set_remove(string name, string value, string delim)
		{
			boolean [string] prop_array;
			prop_array[value] = true;
			property_set_remove(name, prop_array, delim);
		}
		void property_set_remove(string name, boolean [string] values)
		{
			property_set_remove(name, values, ";");
		}
		void property_set_remove(string name, string [int] values)
		{
			property_set_remove(name, values, ";");
		}
		void property_set_remove(string name, string value)
		{
			property_set_remove(name, value, ";");
		}
		///////////////////////
		//Property Set Command
		void property_set_cmd(string name, string command, boolean [string] values, string delim)
		{
			switch(command.to_lower_case())
			{
				case "set":
					set_property_set(name, values, delim);
					break;
				case "add":
					property_set_add(name, values, delim);
					break;
				case "remove":
					property_set_remove(name, values, delim);
					break;
				default:
					abort("Invalid command " + command + " sent to property_set_cmd");
					break;
			}
		}
		void property_set_cmd(string name, string command, string [int] values, string delim)
		{
			boolean [string] prop_array = StringInt2BooleanString(values);
			
			property_set_cmd(name, command, prop_array, delim);
		}
		void property_set_cmd(string name, string command, string value, string delim)
		{
			boolean [string] prop_array;
			prop_array[value] = true;
			property_set_cmd(name, command, prop_array, delim);
		}
		void property_set_cmd(string name, string command, boolean [string] values)
		{
			property_set_cmd(name, command, values, ";");
		}
		void property_set_cmd(string name, string command, string [int] values)
		{
			property_set_cmd(name, command, values, ";");
		}
		void property_set_cmd(string name, string command, string value)
		{
			property_set_cmd(name, command, value, ";");
		}
///////////////////////
//pvp related
boolean is_pvp_stealable()
{
	if(hippy_stone_broken() && can_interact())
	{
		return true;
	}
	return false;
}

///////////////////////
//Print Tools

string Remove_Tags(string html)
{
	matcher tags_gone = create_matcher("<.+?>",html);
	return replace_all(tags_gone,"").to_string();
}
	///////////////////////
	//Printing
void print(string text, int logging)
{
	switch(logging)
	{
		case 1:
			print_html(text);
			break;
		case 2:
			logprint(text);
			break;
		default:
			//do nothing
			break;
	}
}

void print(string text, string [int] words, int logging)
{
	matcher replacer = create_matcher("%s",text);
	buffer output;
	for num from 0 to words.count() - 1 by 1
	{
		replacer.find();
		append_replacement(replacer,output,words[num]);		
	}
	append_tail(replacer,output);
	print(output.to_string(), logging);
}

void log_print(string text)
{
	logprint(text);
	if(get_property("print_logging") == "true")
	{
		print(text);
	}
}
	///////////////////////
	//HTML Printing
void print_html(string html, int logging)
{
	switch(logging)
	{
		case 1:
			print_html(html);
			break;
		case 2:
			logprint(Remove_Tags(html));
			break;
		default:
			//do nothing
			break;
	}
}

void print_html(string text, string word, string tag, int logging)
{
	string wrapped = HTMLGenerateTagWrap(tag,word);
	string output = to_string(replace_string(text,"%s",wrapped));
	print_html(output, logging);
}

void print_html(string text, string word, string tag)
{
	print_html(text, word, tag, 1);
}
void print_html(string text, string word)
{
	print_html(text, word, "b", 1);
}
void print_html(string text, string word, int logging)
{
	print_html(text, word, "b", logging);
}

void print_html(string text, string [int] words, string tag, int logging)
{
	matcher replacer = create_matcher("%s",text);
	//print(text);
	buffer output;
	for num from 0 to words.count() - 1 by 1
	{
		replacer.find();
		//print(num);
		replacer.append_replacement(output,HTMLGenerateTagWrap(tag,words[num]));
		//print(replacer.group());
	}
	append_tail(replacer,output);
	print_html(output.to_string(), logging);
}

void print_html(string text, string [int] words, int logging)
{
	print_html(text, words, "b", logging);
}
void print_html(string text, string [int] words)
{
	print_html(text, words, "b", 1);
}
void print_html(string text, string [int] words, string tag)
{
	print_html(text, words, tag, 1);
}

void print_html_list(string text, string name, string [int] my_array)
{
	buffer my_list;
	my_list.append(HTMLGenerateTagWrap("b",my_array[0]));
	if(my_array.count() > 1)
	{
		for num from 1 to my_array.count() - 1 by 1
		{
			my_list.append(", ");
			my_list.append(HTMLGenerateTagWrap("b",my_array[num]));
		}
	}
	buffer output;
	matcher replacer = create_matcher("%s",text);
	if(name != "")
	{
		replacer.find();
		append_replacement(replacer,output,HTMLGenerateTagWrap("b",name));
	}
	replacer.find();
	append_replacement(replacer,output,my_list.to_string());
	append_tail(replacer,output);
	print_html(output.to_string());
}
void print_html_list(string text, string name, boolean [string] my_array)
{
	print_html_list(text,name,BooleanStringToStringArray(my_array));
}
void print_html_list(string text, string [int] my_array)
{
	print_html_list(text, "", my_array);
}
void print_html_list(string text, boolean [string] my_array)
{
	print_html_list(text,"",BooleanStringToStringArray(my_array));
}


void print_html_list(string text, string [int] words, string [int] my_array)
{
	buffer my_list;
	my_list.append(HTMLGenerateTagWrap("b",my_array[0]));
	for num from 1 to my_array.count() - 1 by 1
	{
		my_list.append(", ");
		my_list.append(HTMLGenerateTagWrap("b",my_array[num]));
	}
	
	buffer output;
	matcher replacer = create_matcher("%s",text);
	for num from 0 to words.count() - 1 by 1
	{
		replacer.find();
		append_replacement(replacer,output,HTMLGenerateTagWrap("b",words[num]));
	}
	replacer.find();
	append_replacement(replacer,output,my_list.to_string());
	append_tail(replacer,output);
	print_html(output.to_string());
}
///////////////////////
//Inventory

void getbuy(int quantity, item it)
{
	int inv_amount = item_amount(it);
	if(inv_amount > quantity)
	{
		return;
	}
	else if (closet_amount(it) > 0 )
	{
		take_closet(min(closet_amount(it),quantity - inv_amount), it);
	}

	if(item_amount(it) < quantity)
	{
		buy(quantity - item_amount(it) - , it);
	}	
}
///////////////////////
//Food/Booze related

record consumables
{
	boolean loaded;
	int [item] food;
	int [item] booze;
	int [item] spleen;
	int [item] multi;
	int [item] potions;
	int [item] all_usables;
	int [item] reusables;
	int [item] other_usables;
	int [item] candy;
	int [item] other;
};

boolean is_potion(item potion)
{
	if(effect_modifier(potion, "effect") != $effect[none])
	{
		return true;
	}
	return false;
}

consumables get_consumables()
{

	consumables my_consumables;
	foreach it in $items[]
	{
		int number = available_amount(it) + creatable_amount(it);
		if(number > 0)
		{
			if(it.fullness > 0 && it.inebriety == 0 && it.spleen == 0)
			{
				my_consumables.food[it] = number;
			}
			else if(it.fullness == 0 && it.inebriety > 0 && it.spleen == 0)
			{
				my_consumables.booze[it] = number;
			}
			else if(it.fullness == 0 && it.inebriety == 0 && it.spleen > 0)
			{
				my_consumables.spleen[it] = number;
			}
			else if(it.fullness > 0 || it.inebriety > 0 || it.spleen > 0)
			{
				my_consumables.multi[it] = number;
			}
			else if(it.usable)
			{
				my_consumables.all_usables[it] = number;
				
				if(is_potion(it))
				{
					my_consumables.potions[it] = number;
				}
				
				if(it.reusable)
				{
					my_consumables.reusables[it] = number;
				}

				if(!it.reusable && !is_potion(it))
				{
					my_consumables.other_usables[it] = number;
				}
			}
			else if(!it.candy)
			{
				my_consumables.other[it] = number;
			}
			
			if(it.candy)
			{
				my_consumables.candy[it] = get_inventory()[it];
			}		
		}
	}
	return my_consumables;
}

int inebriety_left()
{
	return inebriety_limit() - my_inebriety();
}

int fullness_left()
{
	return fullness_limit() - my_fullness();
}

int spleen_left()
{
	return spleen_limit() - my_spleen_use();
}

float get_adv(item it)
{
	string [int] nums = it.adventures.split_string("-");
	switch(nums.count())
	{
		case 0:
			return 0;
		case 1:
			return it.adventures.to_float();
		case 2:
			return nums[0].to_float() + (nums[1].to_float() - nums[0].to_float())/2;
		default:
			print_html("Adventure format %s unrecognized for item %s, returning 0",string[int]{it.adventures,it.to_string()});
			return 0;
	}
}

int adv_meat_gain(item it,int meat_per_adventure)
{
	int price = max(it.mall_price(),it.autosell_price());

	int adv_meat_gain = (it.get_adv()*meat_per_adventure - price);
	return adv_meat_gain;
}

int adv_from_items(int [item] it_list)
{
	int adv = 0;
	foreach it in it_list
	{
		adv += it_list[it] * it.get_adv();
	}
	return adv;

}

float adv_per_space(item it)
{
	float space = it.fullness + it.inebriety + it.spleen;
	return it.get_adv() / space;
}

float meat_per_adv_per_space(item it)
{
	float price = max(it.mall_price(),it.autosell_price()).to_float();
	if(it.adv_per_space() == 0)
	{
		return 1000000;
	}
	if(price == 0)
	{
		price = 1000;	
	}
	return price / adv_per_space(it);
}

boolean is_multiconsume(item it)
{
	int composite = it.spleen * it.inebriety + it.fullness * it.spleen + it.inebriety * it.fullness;
	if (composite > 0)
	{
		return true;
	}
	return false;
}

////////////////////
//Mail Functions
record mail
{
	string from_player;
	int from_id;

	string date;
	string day;
	string time;

	string body;

	item [int] attached_items;
	string [int] item_strings;
};

mail _add_mail_items(mail my_mail, string item_table)
{
	//matcher m = create_matcher("alt=\"(.*\\?)\"",item_table);
	string [int,int] item_strings = item_table.group_string("alt=\"(.*?)\"");
	foreach num in item_strings
	{
		my_mail.attached_items[num] = item_strings[num][1].to_item();
		my_mail.item_strings[num] = item_strings[num][1];
	}
	return my_mail;
}

mail [int] get_mail()
{
	mail [int] my_mail;

	string mail_page = visit_url("messages.php");
	buffer mail_matcher;

	//player name and id
	mail_matcher.append("<b>From</b>.*?<a href=\"showplayer.php\\?who=(\\d*)\">(.*?)</a>");
	
	//date
	mail_matcher.append(".*?<b>Date:</b>.*?!--(.*?)-->");

	//body and items (if any)
	mail_matcher.append(".*?<blockquote>(.*?)(<center>.*?</center>)?</blockquote>");

	//matcher message_match = create_matcher(mail_matcher,mail_page);
	//print(mail_matcher.to_string());
	string [int,int] messages = group_string(mail_page,mail_matcher.to_string());

	print(messages.count().to_string());
	foreach num in messages
	{
		mail new_mail;
		new_mail.from_id =  messages[num][1].to_int();
		new_mail.from_player =  messages[num][2];
		new_mail.date = messages[num][3];
		new_mail.day = format_date_time("MM/dd/yy hh:mm:ss",new_mail.date,"yyyyMMdd");
		new_mail.time = format_date_time("MM/dd/yy hh:mm:ss",new_mail.date,"HH:mm:ss");
		
		
		new_mail.body = messages[num][4];
		if(messages[num].count() > 5 )
		{
			new_mail = new_mail._add_mail_items(messages[num][5]);
		}
		my_mail[num] = new_mail;
	}
	/*
	int index = 0;
	while(message_match.find())
	{
		mail new_mail;
		new_mail.from_id =  message_match.group(1).to_int();
		new_mail.from_id =  message_match.group(2);
		new_mail.date = message_match.group(1);
		
		results[index] = message_match.group(0);
	}
	*/
	return my_mail;
}

mail [string,string,int] sort_mail_by_name_date(mail [int] raw_mail)
{
	mail [string,string,int] sorted_mail;
	foreach num in raw_mail
	{
		string the_sender = raw_mail[num].from_player;
		string the_day = raw_mail[num].day;
		int count = sorted_mail[the_sender,the_day].count();
		
		sorted_mail[the_sender,the_day,count] =  raw_mail[num];
		
	}
	return sorted_mail;
}