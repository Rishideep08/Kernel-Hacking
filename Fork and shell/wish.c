#include <stdio.h>
#include <stdlib.h>
#include<sys/wait.h>
#include<unistd.h>
#include<string.h>
#include <fcntl.h>

void preProcessPaths(char paths[1000][1000]){
    int i=0;
    while(i<1000){
        for(int j=0;j<1000;j++){
            paths[i][j] = '\0';
        }
        i++;
    }
    return;
}

void preprocess(char temp[1000]){
    int i=0;
    while(i<1000){
        temp[i] = '\0';
        i++;
    }
    return;
}

void errorFunc(){
    char error_message[30] = "An error has occurred\n";
    write(STDERR_FILENO, error_message, strlen(error_message)); 
}

void printArgs(char* args[1000], int inputArgsLen){
    int i=0;
    printf("%d\n",inputArgsLen);
    while(args[i]!=NULL){
        printf("%s\n",args[i]);
        i++;
    }
}

void func(char input[1000],char paths[1000][1000],int *pathsLen){

    int redirectionFlag = 0;
    char* token;
    int inputArgsLen=0;
    char* args[1000];
    char* outputFileCollector = (char *)malloc(1000*sizeof(char));;
    char* outputFile;
    char* argsStr = (char*)malloc(1000*sizeof(char));
    int ifFlag = 0;
    char* redirChar;

    if(input[strlen(input)-1] == '>' || input[0] == '>'){
        errorFunc();
        return;
    }


    if(input[0] == 'i' && input[1] =='f'){
        ifFlag =1;
    }
    
    if(ifFlag ==0){
        redirChar = strchr(input,'>');
        argsStr = strtok(input, ">");
    }else{
        strcpy(argsStr,input);
    }

    if(ifFlag == 0 && redirChar != NULL){
        redirectionFlag = 1;
        strcpy(outputFileCollector,redirChar+1);
        // outputFile = strtok(outputFileCollector," \t");
        int i=0;
        while((token = strtok_r(outputFileCollector," \t>", &outputFileCollector)) != NULL){
            // args[i] = strdup(token);
            if(i==0){
                outputFile = strdup(token);
            }
            i++;
        }
        
        if(i!=1 || strlen(outputFile) == 0){
            errorFunc();
            return;
        }
    }
    
    int i=0;
    while((token = strtok_r(argsStr," \t", &argsStr)) != NULL){
        args[i] = strdup(token);
        i++;
    }
    args[i] = NULL;
    inputArgsLen = i;

    if(inputArgsLen == 0){
        if(redirectionFlag == 1){
            errorFunc();
        }
        // continue;
        return;
    }

    //cd case
    if(strcmp(args[0],"cd")==0){
        
        if(inputArgsLen!=2){
           errorFunc();
           return;
        }else{
            // printf("Hi in the cd function\n");
            int cdReturn = chdir(args[1]);
            if(cdReturn !=0){
                errorFunc(); 
                return;
            }
        }
    }else if(strcmp(args[0],"exit")==0){
        // printf("Hi in the exit function\n");
        if(args[1]!=NULL){
            errorFunc(); 
        }else{
            exit(0);
        }
    } //path case
    else if(strcmp(args[0],"path")==0){
        //since the first string is path
        // printf("Hi in the path function\n");
        int i=1;
        preProcessPaths(paths);
        while(args[i]!=NULL){
            if(strcmp(args[i],"./") == 0){
                strncpy(paths[i-1],".",strlen(args[i]));
            }else{
                strncpy(paths[i-1],args[i],strlen(args[i]));
            }
            i++;
        }
        *pathsLen = i-1;
    }else if(strcmp(args[0],"if")==0){
        int flag = 0;
        for(int i=0;i<inputArgsLen;i++){
            if(strcmp(args[i],"then") == 0){
                flag = 1;
            }
        }
        if(flag ==0){
            errorFunc();
            return;
        }

        if(strcmp(args[inputArgsLen-1],"fi")!=0){
            errorFunc();
            return;
        }
        int i=1;
        char* argsForIf[1000];
        while(strcmp(args[i+2],"then") !=0){
            argsForIf[i-1] = strdup(args[i]);
            i++;
        }
        if(!(strcmp(args[i],"!=") ==0 || strcmp(args[i],"==") == 0)){
            errorFunc();
            return;
        }
        int operator = strcmp(args[i],"==");
        int compVal = atoi(args[i+1]);
        pid_t x = fork();
        int stat;
        if(x<0){
           errorFunc();
           return;
        }else if(x == 0){
            char temp[1000];
            for(int i1=0;i1< (*pathsLen);i1++){
                preprocess(temp);
                strcat(temp,paths[i1]);
                strcat(temp,"/");
                strcat(temp,argsForIf[0]);

                if(access(temp,X_OK) == 0){
                    execv(temp,argsForIf);
                    exit(0);
                }
            }
            errorFunc();
            exit(0);
        }else{
            wait(&stat);
            int val = WEXITSTATUS(stat);
             if(operator == 0){
                if(compVal == val){
                    int j = i+3;
                    if(j == inputArgsLen-1){
                        return;
                    }
                    char newInput[1000];
                    while(j<inputArgsLen-1){
                        strcat(newInput,args[j]);
                        strcat(newInput," ");
                        j++;
                    }
                    func(newInput,paths, pathsLen);
                }
            }
            if(operator != 0){
                if(compVal != val){
                    int j = i+3;
                    if(j == inputArgsLen-1){
                        return;
                    }
                    char newInput[1000];
                    while(j<inputArgsLen-1){
                        strcat(newInput,args[j]);
                        strcat(newInput," ");
                        j++;
                    }
                    func(newInput,paths, pathsLen);
                }
            }
        }  
    }else{
        // printf("In the else case");
        int x = fork();
        if(x<0){
           errorFunc();
        }else if(x == 0){
            // execv(,args);
            int fd;
            if(redirectionFlag == 1){
                close(STDOUT_FILENO);
                close(STDERR_FILENO);
                fd = open(outputFile,O_CREAT|O_WRONLY|O_TRUNC, S_IRWXU);
            }

            // printf("%d\n",*pathsLen);
            // printArgs(args,inputArgsLen);
            char temp[1000];
            for(int i=0;i< (*pathsLen);i++){
                preprocess(temp);
                strcat(temp,paths[i]);
                strcat(temp,"/");
                strcat(temp,args[0]);
                // printf("%s\n",temp);
                if(access(temp,X_OK) == 0){
                    // printf("%s\n",temp);
                    // printArgs(args,inputArgsLen);
                    execv(temp,args);
                    exit(0);
                }
            }

            if(redirectionFlag == 1){
                close(fd);
            }
            
            errorFunc();
            exit(0);
        }else{
            wait(NULL);
            // printf("Hi in the parent\n");
        }
    }
}


int main(int argc, char *argv[]){
    if( argc == 2 ) {
        // printf("batch process");
        FILE *fp = fopen(argv[1],"r");
        char line[10000];

        if (fp == NULL) {
            errorFunc();
            return 1;
        }

        char paths[1000][1000];
        strcpy(paths[0],"/bin");
        int pathsLen = 1;

         while(fgets(line, 10000, fp)){
            if(line[0] == '\n'){
                continue;
            }
            line[strlen(line)-1] = '\0';
            func(line,paths,&pathsLen);
        }
    }
    else if( argc > 2 ) {
       errorFunc();
       return 1;
    }
    else {
        char paths[1000][1000];
        strcpy(paths[0],"/bin");
        int pathsLen = 1;
        while(1){
            char *input;
            size_t n = 32;

            printf("wish> ");
            //getting the data from the input.
            getline(&input,&n,stdin);
            input[strlen(input)-1] = '\0';
            func(input,paths,&pathsLen);
        }
       
    }
    return 0;
}