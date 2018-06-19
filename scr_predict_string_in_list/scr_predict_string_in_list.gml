/// @function scr_predict_string_in_list(input_text, comparison_list)
/// @description Check text inputted against list of possible input. Remove any matches where initial text does not match
/// @param input_text
/// @param comparison_list
/// scr_error("scr_predict_string_in_list: ", 1);

var input_text = argument[0];
var comparison_list = argument[1];
var initial_results = scr_find_text_in_list(input_text, comparison_list);
var sorted_results;
sorted_results[0, 0] = undefined;
var slots = 0;
var complete_match = false;

if(initial_results != undefined){
	//Go through all matches in initial_results
	for(var i=0; i<array_length_1d(initial_results); i++){
		complete_match = false;
		//Look for complete match against the input_text from first character
		for(var j=0; j<string_length(input_text); j++){
			if(string_char_at(initial_results[i], j) == string_char_at(input_text, j)){
				complete_match = true;
			}
			else{
				complete_match = false;
				break;
			}
		}
		if(complete_match == true){
			sorted_results[slots, 0] = initial_results[i];
			slots++;	
		}
	}
	
	//Find the most matching characters along all sorted_results
	if(array_height_2d(sorted_results) >= 2){
		var comparison_string = sorted_results[0, 0];
		var auto_complete_to = "";
		//Find the shortest (by string length) possible match
		for(var i=0; i<array_height_2d(sorted_results); i++){
			if(string_length(comparison_string) > string_length(sorted_results[i, 0]))
				comparison_string = sorted_results[i, 0];
		}
		
		//Check all characters of shortest string against other matches. Build new string to autocomplete to
		for(var i=1; i<string_length(comparison_string)+1; i++){
			var current_character = string_copy(comparison_string, i, 1);
			var match = true;
			
			for(var j=0; j<array_height_2d(sorted_results); j++){
				var compared_character = string_copy(sorted_results[j, 0], i, 1);
				
				if(current_character == compared_character && match == true)
					match = true;
				else
					match = false;
			}
			
			//Add after checking character against all other matches
			if(match == true)
				auto_complete_to = auto_complete_to + current_character;
			else
				break;
			
		}
		//How far to autocomplete to
		sorted_results[0, 1] = auto_complete_to;
		
	}
	else
		//Autocomplete to the single answer
		sorted_results[0, 1] = sorted_results[0, 0];

	
	if(sorted_results[0, 0] != undefined)
		return sorted_results;
	else
		return undefined;
}
else 
	return undefined;