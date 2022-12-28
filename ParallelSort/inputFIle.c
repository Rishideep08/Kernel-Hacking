#include <stdio.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/io.h>
#include <sys/mman.h>

int main(int argc, char **argv){
    if(argc != 3){
        return 0;
    }
    printf("%d\n",argc);
    for(int i=0;i<argc;i++){
        printf("%s\n",argv[i]);
    }

    unsigned char *f;
    int size;
    struct stat s;
    const char * file_name = argv[1];
    int fd = open (argv[1], O_RDONLY);
    if(fd<0){
        printf("error\n");
    }

    /* Get the size of the file. */
    int status = fstat (fd, &s);
    size = s.st_size;

    f = (char *) mmap (0, size, PROT_READ, MAP_PRIVATE, fd, 0);
    // printf("%d\n",size);
    for (int i = 0; i < size/100; i++) {
        int* x = (int*)f;
        printf("%d\n",*x);
        f = f+100;
    }

    return 0;
}