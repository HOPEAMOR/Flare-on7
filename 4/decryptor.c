#include <stdlib.h>
#include <stdio.h>


// buf has to be ascii hexadecimal
int xor_decrypt(unsigned char *buf, size_t buf_size, unsigned char *out_buf, unsigned char *key, size_t key_size){
    for (int i = 0; i <= (buf_size/2); i++){
        out_buf[i] = buf[(i*2)+1] ^ key[i % key_size];
        //out_buf[i] = buf[(i*2)+1];
    }
    return 0;
}


int main(int argc, char **argv){

    if (argc < 3){
        fprintf(stderr,"not enough arguments given\n");
        return 1;
    }

    FILE *fdin = fopen(argv[1], "rb");
    FILE *fdout = fopen(argv[2], "wb");
    
    size_t buf_size = sizeof(char);
    size_t buf_count = 0x10000;
    unsigned char *buf = malloc(buf_size * buf_count); // big buff
    unsigned char *out_buf = malloc(buf_size * buf_count);

    //unsigned char key[0xe] = {0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99,0xaa,0xbb,0xcc,0xdd,0xee};
    //unsigned char *key = "FLARE-ON";
    unsigned char *key = "NO-ERALF";
    size_t key_size = sizeof(key);

    size_t fread_count = buf_size * buf_count;
    
/*    fread_size = fread(buf, buf_size, buf_count, fdin);
    printf("fread_size: %ld\n",fread_size);
    xor_decrypt(buf, buf_size*buf_count, out_buf, key, key_size);
    fwrite(out_buf, fread_size, (buf_size*buf_count)/2, fdout);
*/
    while (fread_count == (buf_size * buf_count)){
        fread_count = fread(buf, buf_size, buf_count, fdin);
        xor_decrypt(buf, buf_size*buf_count, out_buf, key, key_size);
        fwrite(out_buf, buf_size, (fread_count/2), fdout);
    }

    free(buf);
    free(out_buf);
    fclose(fdin);
    fclose(fdout);

    return 0;
}
