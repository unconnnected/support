/// @function scr_window_size_calc(window)
/// @description Calculate the variables to draw window according to size and pos
/// Call after x, y, width, height etc have been set
/// @param window

var window = argument[0];

//Calculate title rectangle coords
window.window_title_box_x1 = window.x;
window.window_title_box_y1 = window.y + window.window_outline_padding;
window.window_title_box_x2 = window.x + window.window_width;
window.window_title_box_y2 = window.y + window.window_outline_padding + window.window_title_box_height;

//Calculate body rectangle coords
window.window_body_box_x1 = window.x + window.window_outline_padding;
window.window_body_box_y1 = window.y + window.window_outline_padding*2 + window.window_title_box_height;
window.window_body_box_x2 = window.x + window.window_width - window.window_outline_padding;
window.window_body_box_y2 = window.y + window.window_height - window.window_outline_padding;

//Calculate title text coords
window.window_title_text_x = window.x + window.window_outline_padding + 2;	//2 is margin
window.window_title_text_y = window.y + 1;

//Calculate body text coords
window.window_body_text_x = window.x + window.window_outline_padding + window.window_content_indentation;
window.window_body_text_y = window.y + window.window_title_box_height + window.window_content_indentation;

//For text wrapping
window.window_body_text_height = point_distance(window.window_body_box_x1, window.window_body_box_y1, window.window_body_box_x1, window.window_body_box_y2);
window.window_body_text_width = point_distance(window.window_body_box_x1 + window.window_content_indentation, window.window_body_box_y1, window.window_body_box_x2 - window.window_content_indentation, window.window_body_box_y1);

window.window_max_vertical_lines = floor(window.window_body_text_height/window.fnt_body_char_height);
window.window_max_horizontal_characters = floor(window.window_body_text_width/window.fnt_body_char_width);