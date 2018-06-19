/// @description Draw event for obj_terminal
event_inherited();

/// Will show / hide window content
if(!window_show)
	exit;
	
draw_set_color(terminal_background_color);
draw_rectangle(terminal_input_box_x1, terminal_input_box_y1, terminal_input_box_x2, terminal_input_box_y2, true);

draw_set_color(c_white);
draw_set_font(fnt_body);


//see obj_terminal step event
if(string_length(terminal_input_text) > 0){
	terminal_input_text = scr_save_string(terminal_input_text, terminal_special_character, " ");
	draw_text(terminal_input_box_x1 , terminal_input_box_y1 + 3, terminal_input_text);
	terminal_input_text = scr_save_string(terminal_input_text, " ", terminal_special_character);
}

/* Alternating blink cursor - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
if(type_cursor_blink_countdown < 30)
	type_cursor_blink = true;
else
	type_cursor_blink = false;

if(type_cursor_blink_countdown < 0)
	type_cursor_blink_countdown = type_cursor_blink_interval;

type_cursor_blink_countdown--;	

if(type_cursor_blink == true){
	var blink_x1 = terminal_input_box_x1  + (type_cursor_current_location*fnt_body_char_width);//string_width(terminal_input_text);
	var blink_y1 = terminal_input_box_y1 + 5;
	var blink_x2 = terminal_input_box_x1  + (type_cursor_current_location*fnt_body_char_width);//string_width(terminal_input_text) //+ 2;
	var blink_y2 = terminal_input_box_y1 + 5 + 12;
	
	draw_rectangle(blink_x1, blink_y1, blink_x2, blink_y2, false);
}


/* Draw text lines - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
initial_line = terminal_input_box_y1 - 3;
line = 1;
for(var i = 0; i < ds_list_size(terminal_line_list); i++){
	draw_text(window_body_text_x, initial_line - (line * fnt_body_char_height), ds_list_find_value(terminal_line_list, i));
	line++;
}


/* Highlight selection- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
draw_set_alpha(0.2);
if(select_highlight_point_1 != select_highlight_point_2){
	var highlight_x1 = terminal_input_box_x1 + (select_highlight_point_1*fnt_body_char_width);//string_width(terminal_input_text);
	var highlight_y1 = terminal_input_box_y1 + 5;
	var highlight_x2 = terminal_input_box_x1 + (select_highlight_point_2*fnt_body_char_width);//string_width(terminal_input_text) //+ 2;
	var highlight_y2 = terminal_input_box_y1 + 5 + 12;
	
	draw_rectangle(highlight_x1, highlight_y1, highlight_x2, highlight_y2, false);
}
draw_set_alpha(1);
