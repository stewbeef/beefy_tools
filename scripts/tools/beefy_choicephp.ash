script "beefy_choicephp.ash";

buffer get_initial_url(int choice_id, int option)
{
	buffer url_text;
	url_text.append("choice.php?whichchoice=");
	url_text.append(choice_id.to_string());
	url_text.append("&pwd&option=");
	url_text.append(option.to_string());

	return url_text;
}

string visit_choicephp(int choice_id, int option, string [string] choices)
{
	buffer url_text = get_initial_url(choice_id, option);
	foreach name in choices
	{
		url_text.append("&");
		url_text.append(name);
		url_text.append("=");
		url_text.append(choices[name]);
	}
	print(url_text);
	return visit_url(url_text,true);
}
string visit_choicephp(int id, string [string] choices)
{
	return visit_choicephp(id, 1, choices);
}

string visit_choicephp(int id, int option, string [int] choices)
{
	buffer url_text = get_initial_url(id, option);
	foreach num in choices
	{
		url_text.append("&");
		url_text.append(choices[num]);
	}
	
	return visit_url(url_text,true);
}
string visit_choicephp(int id, string [int] choices)
{
	return visit_choicephp(id, 1, choices);
}

void main()
{

}