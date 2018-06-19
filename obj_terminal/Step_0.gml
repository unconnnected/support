/// @description Step event for obj_terminal
/// Controls for text input of the terminal window

//game maker bug fix
// if string_length is 7 and last character is a space. it randomly deletes that character
// also see bottom of obj_terminal_step
if(string_length(terminal_input_text) > 0)
	terminal_input_text = scr_save_string(terminal_input_text, terminal_special_character, " ");

// old fix for the game maker bug
// keeping the error message
// if string_length is 7 and last character is a space. it deletes that character
if(type_cursor_current_location > string_length(terminal_input_text)){
	scr_error("string error - type_cursor_current_location > terminal_input_text!",1);
//	terminal_input_text = string_insert(" ", terminal_input_text, string_length(terminal_input_text)+1);
//	type_cursor_current_location = string_length(terminal_input_text);
//	type_cursor_location_max = string_length(terminal_input_text);
}


/* Ctrl + A - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
if(keyboard_check(vk_control) && keyboard_check(ord("A")) && selected_all_text == false){
	
	//scr_error("As All True: type_cursor_location_max" + string(type_cursor_location_max), 1);
	selected_all_text = true;
	type_cursor_current_location = 0;
	
	select_highlight_point_2 = type_cursor_current_location;
	select_highlight_point_1 = type_cursor_location_max;
	shift_select_started = true;
}



/* Shift + left / Shift + right - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
if(keyboard_check(vk_shift) && (keyboard_check(vk_left) || keyboard_check(vk_right)) && type_cursor_movement_countdown < 0){
	
	//Set initial point
	if(shift_select_started == false && (keyboard_check(vk_left) || keyboard_check(vk_right) && type_cursor_current_location < type_cursor_location_max)){
		select_highlight_point_1 = type_cursor_current_location;
		shift_select_started = true;
	}
	
	//Regular shift movement
	if(keyboard_check(vk_left) && type_cursor_current_location > 0){
		type_cursor_current_location--;
		select_highlight_point_2 = type_cursor_current_location;
	}
	else if(keyboard_check(vk_right) && type_cursor_current_location < type_cursor_location_max){
		type_cursor_current_location++;
		select_highlight_point_2 = type_cursor_current_location;
	}
	
	type_cursor_movement_countdown = type_cursor_movement_interval;
}

if(shift_select_started == true && type_cursor_movement_countdown > -1)
	type_cursor_movement_countdown--;
	
//If shifted back to starting position, or cursor move without shift
if(select_highlight_point_1 == select_highlight_point_2 || (!keyboard_check(vk_shift) && (keyboard_check(vk_left) || keyboard_check(vk_right) || keyboard_check(vk_up) || keyboard_check(vk_down)))){
	
	if(selected_all_text == true && keyboard_check(vk_right))
		type_cursor_current_location = type_cursor_location_max;

	select_highlight_point_1 = 0;
	select_highlight_point_2 = 0;
	shift_select_started = false;
	selected_all_text = false;
}


/* Selected Area Key Combinations - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
if(shift_select_started == true){

	//Temporary variables for string manipulation
	var start_point;
	var end_point;
	
	if(select_highlight_point_1 < select_highlight_point_2){
		start_point = select_highlight_point_1;
		end_point = select_highlight_point_2;
	}
	else{
		start_point = select_highlight_point_2;
		end_point = select_highlight_point_1;	
	}
	
	var difference = end_point - start_point;
	
	/* Copy - - - - - - - - - - - - - - -*/
	/* - - - - - - - - - - - - - - - - - */
	if((keyboard_check(vk_control) && keyboard_check(ord("C"))) || (keyboard_check(vk_control) && keyboard_check(ord("X")) && string_length(terminal_input_text) > 0))
		clipboard_set_text(string_copy(terminal_input_text, start_point+1, difference));
	
	
	/* Cut / Delete - - - - - - - - - - -*/
	/* - - - - - - - - - - - - - - - - - */
	if((keyboard_check(vk_control) && keyboard_check(ord("X")) && string_length(terminal_input_text) > 0) || (keyboard_check(vk_backspace) || keyboard_check(vk_delete) || keyboard_check(vk_enter) || keyboard_check(vk_tab))){
		terminal_input_text = string_delete(terminal_input_text, start_point+1, difference);
		type_cursor_location_max = string_length(terminal_input_text);
		
		if(type_cursor_current_location > type_cursor_location_max)
			type_cursor_current_location = type_cursor_location_max;
		else
			type_cursor_current_location = start_point;	
		
		delete_time_countdown = delete_time_interval;
		scr_reset_selected_text_area();
	} 
	
	
	/* Paste - - - - - - - - - - - - - - */
	/* - - - - - - - - - - - - - - - - - */
	if(keyboard_check(vk_control) && keyboard_check(ord("V")) && paste_time_countdown < 0){
		var temp_string_length = string_length(terminal_input_text) + string_length(clipboard_get_text()) - difference;
		if(temp_string_length < terminal_input_text_max){
			//First delete
			terminal_input_text = string_delete(terminal_input_text, start_point+1, difference);
		
			//Then replace
			terminal_input_text = string_insert(clipboard_get_text(), terminal_input_text, start_point+1);
			type_cursor_location_max = string_length(terminal_input_text);
		
			//Work out new cursor location
			if(type_cursor_current_location > type_cursor_location_max || (start_point + 1 + difference) > type_cursor_location_max)
				type_cursor_current_location = type_cursor_location_max;
			else
				type_cursor_current_location = start_point + 1 + difference;	
		}
		
		paste_time_countdown = paste_time_interval;	
		scr_reset_selected_text_area();
	} 
	
	
	/* Regular Input - - - - - - - - - - */
	/* - - - - - - - - - - - - - - - - - */
	if(keyboard_check(vk_anykey) && string_length(terminal_input_text) <= terminal_input_text_max && string_length(keyboard_string) > 0){
		//First delete
		terminal_input_text = string_delete(terminal_input_text, start_point+1, difference);
		
		//Then replace
		terminal_input_text = scr_insert_string_overflow(terminal_input_text, keyboard_string, type_cursor_current_location, type_cursor_location_max);
		type_cursor_location_max = string_length(terminal_input_text);
		
		//Work out new cursor location
		if(type_cursor_current_location > type_cursor_location_max || (type_cursor_current_location + string_length(keyboard_string)) > type_cursor_location_max)
			type_cursor_current_location = type_cursor_location_max;
		else
			type_cursor_current_location = type_cursor_current_location + string_length(keyboard_string);


		keyboard_string = "";
		scr_reset_selected_text_area();
	}
	
	//End of selection based input
	exit;	
}



/* Ctrl + V - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
if(keyboard_check(vk_control) && keyboard_check_pressed(ord("V")) && paste_time_countdown < 0){
	var temp_string_length = string_length(terminal_input_text) + string_length(clipboard_get_text());
	//If the insertion will not go over limit
	if(temp_string_length < terminal_input_text_max){
		//type_cursor_current_location + 1 needed for insertion
		terminal_input_text = string_insert(clipboard_get_text(), terminal_input_text, type_cursor_current_location+1);
		
		type_cursor_current_location = type_cursor_current_location + string_length(clipboard_get_text());
		type_cursor_location_max = type_cursor_location_max + string_length(clipboard_get_text());
	}

	paste_time_countdown = paste_time_interval;	
	exit;
}

if(paste_time_countdown > -1)
	paste_time_countdown--;
	
	 
	
/* Delete - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
if((keyboard_check(vk_backspace) && !keyboard_check_pressed(vk_backspace) && delete_time_countdown < 0) || (keyboard_check(vk_delete) && !keyboard_check_pressed(vk_delete) && delete_time_countdown < 0) || (keyboard_check_pressed(vk_backspace)) || (keyboard_check_pressed(vk_delete)) ){
	if(keyboard_check(vk_backspace) && type_cursor_current_location > 0){
		terminal_input_text = string_delete(terminal_input_text, type_cursor_current_location, 1);
		type_cursor_current_location--;
		type_cursor_location_max --;
	}
	//If Delete type_cursor_current_location stays in same position
	else if(keyboard_check(vk_delete) && (type_cursor_current_location != type_cursor_location_max)){
		terminal_input_text = string_delete(terminal_input_text, type_cursor_current_location+1, 1);
		type_cursor_location_max--;
	}
		
	delete_time_countdown = delete_time_interval;
	keyboard_string = "";
}

//Slows down deletion if backspace is held
if(delete_time_countdown > -1)
	delete_time_countdown--;



/* Cursor Movement - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
if(keyboard_check(vk_left) && type_cursor_movement_countdown < 0 && type_cursor_current_location > 0){
	type_cursor_current_location--;
	type_cursor_movement_countdown = type_cursor_movement_interval;
}
else if(keyboard_check(vk_right) && type_cursor_movement_countdown < 0 && type_cursor_current_location < type_cursor_location_max){
	type_cursor_current_location++;
	type_cursor_movement_countdown = type_cursor_movement_interval;
}

if(type_cursor_movement_countdown > -1)
	type_cursor_movement_countdown--;



/* Terminal Line History - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
if(keyboard_check(vk_up) && history_line_accessed < ds_list_size(terminal_line_list_history) && history_line_access_countdown < 0){
	history_line_accessed++;
	
	terminal_input_text = ds_list_find_value(terminal_line_list_history, history_line_accessed-1);
	
	type_cursor_current_location = string_length(terminal_input_text);
	type_cursor_location_max = string_length(terminal_input_text);
	history_line_access_countdown = history_line_access_interval;
}
else if(keyboard_check(vk_down) && history_line_accessed > 0 && history_line_access_countdown < 0){
	history_line_accessed--;
	
	terminal_input_text = ds_list_find_value(terminal_line_list_history, history_line_accessed-1);
	if(is_undefined(terminal_input_text))
		terminal_input_text = "";
		
	type_cursor_current_location = string_length(terminal_input_text);
	type_cursor_location_max = string_length(terminal_input_text);
	history_line_access_countdown = history_line_access_interval;
}

if(history_line_access_countdown > -1)
	history_line_access_countdown--;


/* Regular Input - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
if(keyboard_check(vk_anykey) && string_length(terminal_input_text) <= terminal_input_text_max && string_length(keyboard_string) > 0){
	
	//To prevent type spam overflow
	var new_total_length = string_length(terminal_input_text) + string_length(keyboard_string);
	if(new_total_length <= terminal_input_text_max){
		//type_cursor_current_location + 1 needed for insertion
		terminal_input_text = string_insert(string(keyboard_string), terminal_input_text, type_cursor_current_location+1);
	
		type_cursor_current_location = type_cursor_current_location + string_length(keyboard_string);
		type_cursor_location_max = type_cursor_location_max + string_length(keyboard_string);
	}
	
	keyboard_string = "";
}


//Split input text here. Use split version in tab auto complete and enter
if(string_length(terminal_input_text) > 0)
	terminal_input_split = scr_split_string_by_delim(terminal_input_text, " ");


/* Set possible menu options - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Used in tab & enter - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
var first_list;
var second_list;
var third_list;

if((keyboard_check_pressed(vk_tab) && string_length(terminal_input_text) > 0) || (keyboard_check_pressed(vk_enter) && string_length(terminal_input_text) > 0)){
	//Check what current connection is for possible menu options
	if(scr_check_default_connection() == true){
		first_list = m_.terminal_menu_list;
		//second_list = e_.host_name_list; //TODO: This should combine with hosts and host rooms?
		if(array_length_1d(terminal_input_split) >= 2){
			if(terminal_input_split[0] == "open" 
			|| terminal_input_split[0] == "close")
				second_list = e_.connective_building_entity_name_list;
			else if(terminal_input_split[0] == "refuse")
				second_list = e_.client_entity_name_list;
			else
				second_list = e_.connective_entity_name_list;
		}
		else
			second_list = undefined;
			
		third_list = undefined;
	}
	
	else if(scr_check_host_connection() == true){
		first_list = m_.host_submenu_list;	
		
		if(terminal_input_split[0] == "auto")
			second_list = m_.host_binary_list;
		else if(terminal_input_split[0] == "entertain")
			second_list = e_.host_order_name_list;
		else if(terminal_input_split[0] == "clean")
			second_list = e_.unit_clean_name_list;
		else if(terminal_input_split[0] == "scrub")
			second_list = e_.unit_out_of_order_name_list;
		else if(terminal_input_split[0] == "rescue")
			second_list = e_.host_disabled_name_list;
		else if(terminal_input_split[0] == "kill")	
			second_list = e_.client_entity_name_list;
		else if(terminal_input_split[0] == "dispose")
			second_list = e_.client_dead_entity_name_list;
		else
			second_list = m_.host_options_list;
		
		if(array_length_1d(terminal_input_split) >= 2 && terminal_input_split[1] == "job")
			third_list = m_.host_job_list;
		else if(array_length_1d(terminal_input_split) >= 2 && terminal_input_split[1] == "personality")
			third_list = m_.host_persona_list;
		else if(array_length_1d(terminal_input_split) >= 2 && terminal_input_split[1] == "hair")
			third_list = m_.hair_color_list;
		else if(array_length_1d(terminal_input_split) >= 2 && terminal_input_split[1] == "body")
			third_list = m_.body_type_list;
		else if(array_length_1d(terminal_input_split) >= 2 && (terminal_input_split[1] == "overdrive" || terminal_input_split[1] == "lock"))
			third_list = m_.host_binary_list;
		else
			third_list = undefined;
	}

	else if(scr_check_building_connection() == true){
		first_list = m_.building_submenu_list;
		second_list = m_.building_options_list;
		third_list = undefined;	
	}
	else if(scr_check_floor_connection() == true){
		first_list = m_.floor_submenu_list;
		second_list = m_.floor_options_list;
		third_list = undefined;
	}
	else if(scr_check_unit_connection() == true){
		first_list = m_.unit_submenu_list;
		second_list = m_.unit_options_list;
		third_list = undefined;
	}
	else if(scr_check_entrance_connection() == true){
		first_list = m_.entrance_submenu_list;
		second_list = undefined;
		third_list = undefined;
	}
	else if(scr_check_mail_connection() == true){
		first_list = m_.mail_submenu_list;
		second_list = u_.user_mail_subject_list;
		third_list = undefined;
	}
}

	
	
/* Tab Auto complete - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
if(keyboard_check_pressed(vk_tab) && string_length(terminal_input_text) > 0){
	
	//If valid command and multiple possible commands
	if(array_length_1d(terminal_input_split) >= 1 && scr_predict_string_in_list(terminal_input_split[0], first_list) != undefined && array_height_2d(scr_predict_string_in_list(terminal_input_split[0], first_list)) > 1)
		scr_update_terminal_line_list(terminal_input_text + ": ");
	
	//If only single command
	if(array_length_1d(terminal_input_split) == 1){
		var auto_text = scr_display_predicted_results(terminal_input_split[0], first_list, terminal_input_split[0], "");
		
		if(auto_text != undefined)
			terminal_input_text = auto_text;	
	}
	//Check first command is valid, then check second part
	//Format: first + second
	else if((scr_check_default_connection() == true || scr_check_host_connection() == true || scr_check_building_connection() || scr_check_floor_connection() || scr_check_unit_connection() || scr_check_mail_connection()) && array_length_1d(terminal_input_split) == 2 && scr_validate_string_in_list(terminal_input_split[0], first_list)){	
		var auto_text = scr_display_predicted_results(terminal_input_split[1],  second_list, terminal_input_split[0], terminal_input_split[1]);
		
		if(auto_text != undefined)
			terminal_input_text = terminal_input_split[0] + " " + auto_text;
	}
	//To set host personality, job, hair, body or overdrive option
	else if(scr_check_host_connection() == true && array_length_1d(terminal_input_split) == 3 && scr_validate_string_in_list(terminal_input_split[0], first_list) && scr_validate_string_in_list(terminal_input_split[1], second_list) && scr_check_host_set_option(terminal_input_split[1])){
		var auto_text = scr_display_predicted_results(terminal_input_split[2], third_list, terminal_input_split[0], terminal_input_split[1]);
		
		if(auto_text != undefined)
			terminal_input_text = terminal_input_split[0] + " " + terminal_input_split[1] + " " + auto_text;
	}
	//Don't need to tab other values
	
	//Set cursor to end of auto complete
	type_cursor_current_location = string_length(terminal_input_text);
	type_cursor_location_max = string_length(terminal_input_text);
	
	keyboard_string = "";
}



/* Enter Command - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
if(keyboard_check_pressed(vk_enter) && string_length(terminal_input_text) > 0){
	
	//Create the new terminal line
	var terminal_line = e_.connected_user_name + "@" + e_.connected_host_name + ": " + terminal_input_text + " ";
	
	//Check the new terminal line will fit inside the width of the window
	//If not break it up
	if(string_length(terminal_line) > window_max_horizontal_characters){
		var terminal_line_split = scr_split_string_by_length(terminal_line, window_max_horizontal_characters);
		for(var i = 0; i < array_length_1d(terminal_line_split); i++)
			scr_update_terminal_line_list(terminal_line_split[i]);
	}
	else
		scr_update_terminal_line_list(terminal_line);



	/* Enter functionality - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
	/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
	if(scr_validate_string_in_list(terminal_input_split[0], first_list) == true){
		
		/* Default connection menu - - - - - */
		/* - - - - - - - - - - - - - - - - - */
		if(scr_check_default_connection() == true){
			if(array_length_1d(terminal_input_split)>1 && scr_check_t_menu_exception(terminal_input_split[0]) == false){
				//Validate connection with entity in second_list
				if(scr_validate_string_in_list(terminal_input_split[1], second_list) == true)
					scr_execute_terminal_menu(terminal_input_split[0], terminal_input_split[1]);
				//Help + optional page number
				else if(terminal_input_split[0] == "help" || terminal_input_split[1] == "?")
					scr_execute_terminal_menu(terminal_input_split[0], terminal_input_split[1]);
				//Error message entity was not in second_list
				else{
					scr_update_terminal_line_list("Failed to Execute:");
					scr_update_terminal_line_list("Could Not Find " + terminal_input_split[1]);
				}
			}
			//Execution for single word commands
			else if(array_length_1d(terminal_input_split) == 1 && scr_check_t_menu_exception(terminal_input_split[0]))
				scr_execute_terminal_menu(terminal_input_split[0], undefined);
			//Help + no optional page number
			else if(terminal_input_split[0] == "help" && array_length_1d(terminal_input_split) == 1)
				scr_execute_terminal_menu(terminal_input_split[0], "1");
			//Error message if single word command followed by more text
			else if(scr_check_t_menu_exception(terminal_input_split[0])){
				scr_update_terminal_line_list("Failed to Execute:");
				scr_update_terminal_line_list("Too Many Arguments");
			}
			//Error message no entity was given
			else{
				scr_update_terminal_line_list("Failed to Execute:");
				scr_update_terminal_line_list("Usage: " + terminal_input_split[0] + " " + "[WHERE TO CONNECT TO]");	
			}
		}	
				
				
		/* Host connection menu - - - - - - -*/
		/* - - - - - - - - - - - - - - - - - */
		else if(scr_check_host_connection() == true){
			if(array_length_1d(terminal_input_split)>1 && scr_check_h_submenu_exception(terminal_input_split[0]) == false){
				//Validate option in second list
				if(scr_validate_string_in_list(terminal_input_split[1], second_list) == true){
					//Validate if personality, job or overdrive due to sublists
					if(scr_check_host_set_option(terminal_input_split[1])){
						//if(array_length_1d(terminal_input_split)>2 && scr_validate_string_in_list(terminal_input_split[2], third_list) == true)
						if(array_length_1d(terminal_input_split)>2 && (terminal_input_split[2] == "?" || scr_validate_string_in_list(terminal_input_split[2], third_list) == true))
							scr_execute_host_submenu(terminal_input_split[0], terminal_input_split[1], terminal_input_split[2]);
						//Error message invalid personality, job or overdrive option	
						else if(array_length_1d(terminal_input_split)>2){
							if(terminal_input_split[1] == "personality")
								scr_update_terminal_line_list("No Personality " + terminal_input_split[2] + " - Check Syntax");
							else if(terminal_input_split[1] == "job")	
								scr_update_terminal_line_list("No Job " + terminal_input_split[2] + " - Check Syntax");
							else if(terminal_input_split[1] == "hair")	
								scr_update_terminal_line_list("No Hair " + terminal_input_split[2] + " - Check Syntax");
							else if(terminal_input_split[1] == "body")	
								scr_update_terminal_line_list("No Body " + terminal_input_split[2] + " - Check Syntax");
							else if(terminal_input_split[1] == "overdrive" || terminal_input_split[1] == "lock")
								scr_update_terminal_line_list("No Option " + terminal_input_split[2] + " - Check Syntax");	
						}
						//Error message no third value submitted
						else if(terminal_input_split[1] == "?")
							scr_execute_host_submenu(terminal_input_split[0], terminal_input_split[1], undefined);	
						else{
							scr_update_terminal_line_list("Failed to Execute:");
							scr_update_terminal_line_list("Usage: " + terminal_input_split[0] + " " + terminal_input_split[1] + " " + "[VALUE]");
						}
					}
					//Client specific commands
					else if(
					terminal_input_split[0] == "auto"
					|| terminal_input_split[0] == "entertain"
					|| terminal_input_split[0] == "clean"
					|| terminal_input_split[0] == "scrub"
					|| terminal_input_split[0] == "rescue" 
					|| terminal_input_split[0] == "kill" 
					|| terminal_input_split[0] == "dispose" 
					)
						scr_execute_host_submenu(terminal_input_split[0], terminal_input_split[1], undefined);	
					//Third value is a number
					/*else if(array_length_1d(terminal_input_split)>2){
						if(real(terminal_input_split[2]) && (floor(real(terminal_input_split[2]))>=0 && floor(real(terminal_input_split[2]))<=10)){
							scr_execute_host_submenu(terminal_input_split[0], terminal_input_split[1], terminal_input_split[2]);
						}
						//Error message number outside of range
						else{
							scr_update_terminal_line_list("Failed to Execute:");
							scr_update_terminal_line_list("" + terminal_input_split[2] + " - Outside Range");	
						}
							
					}*/
					//Error message no third value submitted
					else{
						scr_update_terminal_line_list("Failed to Execute:");
						scr_update_terminal_line_list("Usage: " + terminal_input_split[0] + " " + terminal_input_split[1] + " " + "[VALUE]");
					}
				}
				//Help + optional page number
				else if(terminal_input_split[0] == "help" || terminal_input_split[1] == "?")
					scr_execute_host_submenu(terminal_input_split[0], terminal_input_split[1], undefined);
				else
					scr_update_terminal_line_list("No Option " + terminal_input_split[1] + " - Check Syntax");
				
			}
			//Execution for single word commands
			else if(array_length_1d(terminal_input_split) == 1 && scr_check_h_submenu_exception(terminal_input_split[0]))
				scr_execute_host_submenu(terminal_input_split[0], undefined, undefined);
			//Help + no optional page number
			else if(array_length_1d(terminal_input_split) == 1 && terminal_input_split[0] == "help")
				scr_execute_host_submenu(terminal_input_split[0], "1", undefined);
			//Error message if single word command followed by more text
			else if(scr_check_h_submenu_exception(terminal_input_split[0])){
				scr_update_terminal_line_list("Failed to Execute:");
				scr_update_terminal_line_list("Too Many Arguments");
			}
			//Error message not enough arguments
			else{
				scr_update_terminal_line_list("Failed to Execute:");
				scr_update_terminal_line_list("Usage: " + terminal_input_split[0] + " " + "[OPTION]" + " " + "[VALUE]");
			}
		}
		
		
		/* Building Connection Menu - - - - -*/
		/* - - - - - - - - - - - - - - - - - */
		else if(scr_check_building_connection() == true){
			if(array_length_1d(terminal_input_split)>1 && scr_check_b_submenu_exception(terminal_input_split[0]) == false){
				//Validate building option in second_list
				if(scr_validate_string_in_list(terminal_input_split[1], second_list) == true){
					if(terminal_input_split[1] == "name"){
						//Error message too many arguments. Name cannot be seperated by space
						if(array_length_1d(terminal_input_split) > 3){
							scr_update_terminal_line_list("Failed to Execute:");
							scr_update_terminal_line_list("Too Many Arguments");
						}
						//Error message name was not unique
						else if(!scr_validate_unique_name(terminal_input_split[2])){
							scr_update_terminal_line_list("Failed to Execute:");
							scr_update_terminal_line_list("Usage: " + terminal_input_split[0] + " " + terminal_input_split[1] + " " + "[UNIQUE VALUE]");
						}
						else
							scr_execute_building_submenu(terminal_input_split[0], terminal_input_split[1], terminal_input_split[2]);
					}
					//Error message
					else if(terminal_input_split[0] == "refuse" && array_length_1d(terminal_input_split) > 2){
						scr_update_terminal_line_list("Failed to Execute:");
						scr_update_terminal_line_list("Too Many Arguments");
					}
					else if(terminal_input_split[0] == "refuse" || terminal_input_split[1] == "?")
						scr_execute_building_submenu(terminal_input_split[0], terminal_input_split[1], undefined);
				}
				//Help + optional page number
				else if(terminal_input_split[0] == "help")
					scr_execute_building_submenu(terminal_input_split[0], terminal_input_split[1], undefined);
				//Error message invalid entity name
				else if(scr_validate_string_in_list(terminal_input_split[1], second_list) == false){
					scr_update_terminal_line_list("Failed to Execute:");
					scr_update_terminal_line_list("Could Not Find " + terminal_input_split[1]);
				}
				else
					scr_update_terminal_line_list("No Option " + terminal_input_split[0] + " - Check Syntax");
			}
			//Execution for single word commands
			else if(array_length_1d(terminal_input_split) == 1 && scr_check_b_submenu_exception(terminal_input_split[0]))
				scr_execute_building_submenu(terminal_input_split[0], undefined, undefined);
			//Help + no optional page number
			else if(array_length_1d(terminal_input_split) == 1 && terminal_input_split[0] == "help")
				scr_execute_building_submenu(terminal_input_split[0], "1", undefined);
			//Error message if single word command followed by more text
			else if(scr_check_b_submenu_exception(terminal_input_split[0])){
				scr_update_terminal_line_list("Failed to Execute:");
				scr_update_terminal_line_list("Too Many Arguments");
			}
			else{
				scr_update_terminal_line_list("Failed to Execute:");
				scr_update_terminal_line_list("Usage: " + terminal_input_split[0] + " " + "[OPTION]" + " " + "[VALUE]");
			}
		}
		
		
		/* Floor Connection Menu - - - - - - */
		/* - - - - - - - - - - - - - - - - - */
		else if(scr_check_floor_connection() == true){
			if(array_length_1d(terminal_input_split)>1 && scr_check_f_submenu_exception(terminal_input_split[0]) == false){
				//Validate floor option	in second_list
				if(scr_validate_string_in_list(terminal_input_split[1], second_list) == true){
					if(terminal_input_split[1] == "name"){
						//Error message too many arguments. Name cannot be seperated by space
						if(array_length_1d(terminal_input_split) > 3){
							scr_update_terminal_line_list("Failed to Execute:");
							scr_update_terminal_line_list("Too Many Arguments");
						}
						//Error message name was not unique
						else if(!scr_validate_unique_name(terminal_input_split[2])){
							scr_update_terminal_line_list("Failed to Execute:");
							scr_update_terminal_line_list("Usage: " + terminal_input_split[0] + " " + terminal_input_split[1] + " " + "[UNIQUE VALUE]");
						}
						else
							scr_execute_floor_submenu(terminal_input_split[0], terminal_input_split[1], terminal_input_split[2]);
					}
					else if(terminal_input_split[1] == "?")
						scr_execute_building_submenu(terminal_input_split[0], terminal_input_split[1], undefined);
				}
				//Help + optional page number
				else if(terminal_input_split[0] == "help")
					scr_execute_floor_submenu(terminal_input_split[0], terminal_input_split[1], undefined);
				else
					scr_update_terminal_line_list("No Option " + terminal_input_split[0] + " - Check Syntax");
				
			}
			//Execution for single word commands
			else if(array_length_1d(terminal_input_split) == 1 && scr_check_f_submenu_exception(terminal_input_split[0]))
				scr_execute_floor_submenu(terminal_input_split[0], undefined, undefined);
			//Help + no optional page number
			else if(array_length_1d(terminal_input_split) == 1 && terminal_input_split[0] == "help")
				scr_execute_floor_submenu(terminal_input_split[0], "1", undefined);
			//Error message if single word command followed by more text
			else if(scr_check_f_submenu_exception(terminal_input_split[0])){
				scr_update_terminal_line_list("Failed to Execute:");
				scr_update_terminal_line_list("Too Many Arguments");
			}
			else{
				scr_update_terminal_line_list("Failed to Execute:");
				scr_update_terminal_line_list("Usage: " + terminal_input_split[0] + " " + "[OPTION]" + " " + "[VALUE]");
			}
		}
		
		
		/* Unit Connection Menu - - - - - - -*/
		/* - - - - - - - - - - - - - - - - - */
		else if(scr_check_unit_connection() == true){
			if(array_length_1d(terminal_input_split)>1 && scr_check_u_submenu_exception(terminal_input_split[0]) == false){
				//Validate unit option in second_list
				if(scr_validate_string_in_list(terminal_input_split[1], second_list) == true){
					if(terminal_input_split[1] == "name"){
						//Error message too many arguments. Name cannot be seperated by space
						if(array_length_1d(terminal_input_split) > 3){
							scr_update_terminal_line_list("Failed to Execute:");
							scr_update_terminal_line_list("Too Many Arguments");
						}
						//Error message name was not unique
						else if(!scr_validate_unique_name(terminal_input_split[2])){
							scr_update_terminal_line_list("Failed to Execute:");
							scr_update_terminal_line_list("Usage: " + terminal_input_split[0] + " " + terminal_input_split[1] + " " + "[UNIQUE VALUE]");
						}
						else
							scr_execute_unit_submenu(terminal_input_split[0], terminal_input_split[1], terminal_input_split[2]);
					}
					else if(terminal_input_split[1] == "?")
						scr_execute_building_submenu(terminal_input_split[0], terminal_input_split[1], undefined);
				}
				//Help + optional page number
				else if(terminal_input_split[0] == "help")
					scr_execute_unit_submenu(terminal_input_split[0], terminal_input_split[1], undefined);
				else
					scr_update_terminal_line_list("No Option " + terminal_input_split[0] + " - Check Syntax");
				
			}
			//Execution for single word commands
			else if(array_length_1d(terminal_input_split) == 1 && scr_check_u_submenu_exception(terminal_input_split[0]))
				scr_execute_unit_submenu(terminal_input_split[0], undefined, undefined);
			//Help + no optional page number
			else if(terminal_input_split[0] == "help" && array_length_1d(terminal_input_split) == 1)
				scr_execute_unit_submenu(terminal_input_split[0], "1", undefined);
			//Error message if single word command followed by more text
			else if(scr_check_u_submenu_exception(terminal_input_split[0])){
				scr_update_terminal_line_list("Failed to Execute:");
				scr_update_terminal_line_list("Too Many Arguments");
			}
			else{
				scr_update_terminal_line_list("Failed to Execute:");
				scr_update_terminal_line_list("Usage: " + terminal_input_split[0] + " " + "[OPTION]" + " " + "[VALUE]");
			}			
		}
		
		
		/* Entrance Connection Menu - - - - -*/
		/* - - - - - - - - - - - - - - - - - */
		else if(scr_check_entrance_connection()){
			//TODO: extra commands?
			if(array_length_1d(terminal_input_split)>1 && scr_check_e_submenu_exception(terminal_input_split[0]) == false){
				if(terminal_input_split[0] == "help")
					scr_execute_entrance_submenu(terminal_input_split[0], terminal_input_split[1], undefined);
				else
					scr_update_terminal_line_list("No Option " + terminal_input_split[1] + " - Check Syntax");
			}
			//Execution for single word commands
			else if(array_length_1d(terminal_input_split) == 1 && scr_check_e_submenu_exception(terminal_input_split[0]))
				scr_execute_entrance_submenu(terminal_input_split[0], undefined, undefined);
			//Help + no optional page number
			else if(terminal_input_split[0] == "help" && array_length_1d(terminal_input_split) == 1)
				scr_execute_entrance_submenu(terminal_input_split[0], "1", undefined);
			else if(scr_check_e_submenu_exception(terminal_input_split[0])){
				scr_update_terminal_line_list("Failed to Execute: ");
				scr_update_terminal_line_list("Too Many Arguments");
			}	
		}
		
		
		/* Mail Connection Menu - - - - - - -*/
		/* - - - - - - - - - - - - - - - - - */
		else if(scr_check_mail_connection()){
			scr_error("inside mail connect", 1);
			//TODO: extra commands?
			if(array_length_1d(terminal_input_split)>1 && scr_check_m_submenu_exception(terminal_input_split[0]) == false){
				//Validate mail option in second list
				if(scr_validate_string_in_list(terminal_input_split[1], second_list) == true){	
					if(terminal_input_split[0] == "open"){
						//Error message too many arguments. Name cannot be seperated by space
						if(array_length_1d(terminal_input_split) >= 3){
							scr_update_terminal_line_list("Failed to Execute:");
							scr_update_terminal_line_list("Too Many Arguments");
						}
						else
							scr_execute_mail_submenu(terminal_input_split[0], terminal_input_split[1], undefined);
					}
					else if(terminal_input_split[1] == "?")
							scr_execute_mail_submenu(terminal_input_split[0], terminal_input_split[1], undefined);
				}
				//Help + optional page number
				else if(terminal_input_split[0] == "help" || terminal_input_split[1] == "?")
					scr_execute_mail_submenu(terminal_input_split[0], terminal_input_split[1], undefined);
				else
					scr_update_terminal_line_list("No Option " + terminal_input_split[1] + " - Check Syntax");
					
			}
			//Execution for single word commands
			else if(array_length_1d(terminal_input_split) == 1 && scr_check_m_submenu_exception(terminal_input_split[0]))
				scr_execute_mail_submenu(terminal_input_split[0], undefined, undefined);
			//Help + no optional page number
			else if(terminal_input_split[0] == "help" && array_length_1d(terminal_input_split) == 1)
				scr_execute_mail_submenu(terminal_input_split[0], "1", undefined);
			else if(scr_check_m_submenu_exception(terminal_input_split[0])){
				scr_update_terminal_line_list("Failed to Execute: ");
				scr_update_terminal_line_list("Too Many Arguments");
			}
		}
		
		
	}
	else
		scr_update_terminal_line_list("No Command " + terminal_input_split[0] + " - Check Syntax");


	scr_extend_ds_list(terminal_line_list_history, terminal_input_text);
	terminal_input_text = "";
	type_cursor_current_location = 0;
	type_cursor_location_max = 0;
	
	keyboard_string = "";
}


//game maker bug fix
if(string_length(terminal_input_text) > 0)
	terminal_input_text = scr_save_string(terminal_input_text, " ", terminal_special_character);