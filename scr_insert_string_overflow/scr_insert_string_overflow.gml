/// @function scr_insert_string_overflow(str, substr, insertion_point, max_string_length)
/// @description Insert substring into a string where there is a maximum string length
/// @param str
/// @param substr
/// @param insertion_point
/// @param max_string_length
/// scr_error("scr_text_overflow: ", 1);

var str = argument[0];
var substr = argument[1];
var insertion_point = argument[2];
var max_string_length = argument[3];
var new_text = "";

var a = string_length(str);
var b = string_length(substr);

//If the combined text is too much
if((a + b) > max_string_length){
	//How many characters over
	var c = (a+b) - max_string_length;
	c = abs(c);
	//If chracters are over and str length is less than max_string_length
	if(c > 0 && string_length(str) != max_string_length && max_string_length > string_length(str)){
		var tmp_substr = string_copy(substr, 1, string_length(substr));
		//Delete the overflowing characters
		tmp_substr = string_delete(tmp_substr, string_length(substr) - c+1, c);
		new_text = string_insert(tmp_substr, str, insertion_point+1);
	}
	else
		new_text = str;
}
else
	new_text = string_insert(substr, str, insertion_point+1);
	
return new_text;