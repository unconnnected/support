/// @function scr_split_string_by_length(msg, max_length)
/// @description Split string by a max length. Return array of strings
/// @param msg
/// @param max_length
/// scr_error("scr_split_string_by_length: ", 1);

var msg = argument[0];			//string to split
var max_length = argument[1];	//length to split the string by
var slot = 0;
var splits;						//array to hold all the splits
var str2 = "";					//var to hold the current split we're working on building
var i;

for(i = 1; i<(string_length(msg)+1); i++){
	var currStr = string_copy(msg, i, 1);
	if(string_length(str2)+1 > max_length){
		splits[slot] = str2;
		slot++;
		str2 = string_copy(msg, i, 1);
	} else {
		str2 = str2 + currStr;
		splits[slot] = str2;
	}
}

if(string_length(str2) > 0)
	splits[slot] = str2;
	
return splits;