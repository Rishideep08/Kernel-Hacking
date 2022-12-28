In this assignment we have implemented lottery scheduling, dereferencing NULL pointer and modifying the protecting bits. 

1) lotter scheduling : we have created two syscalls settickets and getpinfo. settickets will help in setting a process with high priority and in the scheduler we are running the processes with high priority first and if we have more than one high priority is there then we are doing round robin scheduling.

2)NULL pointer dereferencing : we made that all the NULL handling cases should hit the first page and no process will use first page.

3)modifying the protected bits : we created two more syscalls mprotect and munprotect. mprotect will modify all the pages from that address to the given length to read only and munprotect will modify all the pages to read and write.
