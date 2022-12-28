#include <stdio.h>
#include <time.h>
#include <pthread.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/io.h>
#include <sys/mman.h>
#include <string.h>
#include <unistd.h>
#include <sys/sysinfo.h>

typedef struct data{
    int key;
    unsigned char* record;
  
} KeyValueData; 


typedef struct params{
  KeyValueData *a;
  int l;
  int r;
} thread_params;


void errorFunc(){
    char error_message[30] = "An error has occurred\n";
    ssize_t  x = write(STDERR_FILENO, error_message, strlen(error_message)); 
    if(x<0){
       printf("write failed\n"); 
    }
    return;
}

 

pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t c = PTHREAD_COND_INITIALIZER;
int maxPthreads = 100;
int currPthreads=1;
int maxValuePerthread = 1000;


void swap(KeyValueData* a, KeyValueData* b){
    KeyValueData tmp = *a;
    *a = *b;
    *b = tmp;
}

 

int partition(KeyValueData a[], int l, int r){
    KeyValueData pivot = a[r];
    int i = l-1;
    for (int j = l; j < r; j++)
    {
        if (a[j].key <= pivot.key)
        {
            i+=1;
            swap(&a[i],&a[j]);
        }
    }
    swap(&a[i+1],&a[r]);
    return i + 1;
}

 
void quickSort(KeyValueData a[], int l, int r){
    if (l < r)
    {
        int pivot = partition(a, l, r);
        quickSort(a, l, pivot - 1);
        quickSort(a, pivot + 1, r);
    }
}

 

// Paraller quick sort

void * parallelquickSort(void * fparams){
    thread_params* p = fparams;
    if(p->l < p->r){
        int pivot = partition(p->a,p->l, p->r);
        if((p->r)- (p->l)>maxValuePerthread){
            thread_params tParams = {p->a, p->l, pivot-1};
            pthread_t thread;
            pthread_create(&thread, NULL, parallelquickSort, &tParams);
            thread_params tParamsR = {p->a, pivot+1, p->r};
            parallelquickSort(&tParamsR);
            pthread_join(thread, NULL);
        }
        else{
            quickSort(p->a, p->l, pivot - 1);
            quickSort(p->a, pivot + 1, p->r);
        }
    }
    return NULL;
}

int main(int argc, char** argv)
{
    
    if(argc != 3){
        return 0;
    }
    unsigned char *f;
    int size;
    struct stat s;
    int fd = open(argv[1], O_RDONLY);
    /* Get the size of the file. */
    fstat (fd, &s);
    size = s.st_size;
    int n = size/100;
    if(fd<0 || n==0){
        errorFunc();
        return 0;
    }
    
    int noOfThreads = get_nprocs();
    maxValuePerthread = n/noOfThreads;
    
    f = (unsigned char *) mmap(0, size, PROT_READ, MAP_PRIVATE, fd, 0);
    KeyValueData* input= (KeyValueData*) malloc(n * sizeof(KeyValueData));
    // printf("%d\n",size);
    for (int i = 0; i < n; i++) {
        int* x = (int*)f;
        // printf("%d\n",*x);
        input[i].key = *x;
        input[i].record = f;
        f = f+100;
    }
    close(fd);
    // printf("intializing array complete\n");
    thread_params tParams = {input, 0, n-1};
    parallelquickSort(&tParams);
    // printf("sorting complete\n");
    FILE *fp;
    fp = fopen(argv[2], "wb");
    for (int i = 0; i < n; i++) {
        // printf("%d\n",input[i].key);
        fwrite(input[i].record, 1 , 100 , fp );
        // fputs("This is testing for fputs...\n", fp);
        // int* x = (int*)f;
        // input[i].key = *x;
        // input[i].record = f;
        // f = f+100;
    }
    fclose(fp);
    return 0;
}