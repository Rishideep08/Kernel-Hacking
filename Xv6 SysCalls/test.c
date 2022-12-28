// #include "types.h"
// #include "user.h"
// #include "fcntl.h" 

// int main(){
//     // printf(1,"Hello  Xv6!\n");

//     printf(1,"the output of the trace method is + %d\n",trace("abc"));
//     printf(1,"the output of the open method is + %d\n",open("abc",O_CREATE));

//     printf(1,"the output of the getcount method is + %d\n",getcount());
    
//     exit();
// }


#include "types.h"
#include "user.h"

#define PATH1 "pathname1"
#define PATH2 "pathname2"

int main() {
  int iter = 10;

  trace(PATH1);
  int ret0 = getcount();

  trace(PATH2);
  for (int i = 0; i < iter; i++)
    open(PATH2, 0);
  int ret1 = getcount();

  trace(PATH1);
  open(PATH1, 537);
  int ret2 = getcount();

  printf(1, "XV6_TEST_OUTPUT %d %d %d\n", ret0, ret1, ret2);

  exit();
}