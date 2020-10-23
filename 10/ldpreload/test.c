#include <stdio.h>
#include <string.h>


int main(){
    
    printf("getting strlen\n");
    
    char *str = "teststring";
    size_t str_len = strlen(str);

    printf("got strlen: %d\n",str_len);


    char *str2 = "teststring2";
    int result = strcmp(str,str2);
    
    printf("strcmp_result: %d\n",result);

    return 0;
}
