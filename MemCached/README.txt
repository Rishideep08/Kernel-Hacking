In this project, I have created two new operators mult and div. 

For that I have modified the process_command_ascii to find the new operator cmds and route them to the  corresponding arithmetic funcitons. 

I have changed the function signature of do_add_delta from bool to int for incr variable so we can use it for 4 operations along with that I have updated all the functions where we used the do_add_delta so it maintains backward compatability
