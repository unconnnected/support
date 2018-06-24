# support
Portfolio of support files written in PHP, Javascript and GML by Paul Bennett.



GML files have been written as part of a game project. 
The game is a hotel management simulation with only command line interface.

obj_terminal
Main window interface for game. Uses only text line input.

scr_insert_string_overflow
Support file for obj_terminal. If text is inserted to the middle of string but the string has a limited size.

scr_predict_string_in_list
Support file for obj_terminal tab command. Checks a string against a list of commands and returns all possible options.

scr_split_string_by_length
Support file to split a string by length of characters. Returns array of strings.

scr_window_size_calc
Support file for obj_terminal and other windows in game. Sets various drawing and positioning variables.



Javascript and PHP files have been written as part of a web applicaiton.
The web application is a tool for management to decide on the building space assigned to departments within a company.

project
Bean object written in PHP.

projectDAO
Project interface for database interactions written in PHP.

projectDAOImp
Implementation of projectDAO for database interactions written in PHP.

loadBuildingNavigation
Javascript file to allow users to cycle between buildings on a webpage in a project.
