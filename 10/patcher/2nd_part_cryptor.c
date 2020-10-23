#include <stdio.h>
#include <stdlib.h>

unsigned int strange_data_deob(unsigned int param1, unsigned int param2){
    unsigned char bvar;
    unsigned int return_var;

    bvar = param2 & 0x1f;
    unsigned int tmp1 = param1 >> bvar;
    unsigned int tmp2 = ~bvar + 1; // fake neg
    unsigned int tmp3 = tmp2 & 0x1f;
    unsigned int tmp4 = param1 << tmp3;
    return_var = tmp4 | tmp1;

    return return_var;
}

unsigned int chmod(unsigned int magic_constants_0, unsigned int magic_constants_1, unsigned int magic_constants_2, unsigned int cipher2_working){
    unsigned int uvar;

    uvar = cipher2_working + magic_constants_0;
    uvar = strange_data_deob(uvar, magic_constants_1);
    uvar = uvar ^ magic_constants_2;

    return uvar;
    
}

// the names for encrypt and decrypt functions are flipped from the code from 2nd_part
// this is because the data is encrypted in the binary, and we place plaintext over encrypted data,
// and pass that through a decryption algorithm.
// thus when the 2nd part is compared, it is comparing "decrypted" data even though it looks like garbage
unsigned int encrypt(unsigned int *cipher1, unsigned int *cipher2, unsigned int * magic_constants){
    unsigned int cipher2_working = *cipher1;
    unsigned int cipher1_working = *cipher2;
    unsigned int cipher2_working_dup = 0;
    unsigned int uvar = 0;


    // reverse the decryption, generating uvar's as we go.
    int mc_len = 0x2f; // magic_constants length - 1
    for (int i = 0; i < 0x10; i++){
        cipher2_working_dup = cipher1_working;
        uvar = chmod(magic_constants[mc_len-(i*3)-2], magic_constants[mc_len-(i*3)-1], magic_constants[mc_len-(i*3)], cipher2_working_dup);
        cipher1_working = cipher2_working ^ uvar;
        cipher2_working = cipher2_working_dup;
    }

    *cipher1 = cipher1_working;
    *cipher2 = cipher2_working;
    
    return 0;
}

// the names for encrypt and decrypt functions are flipped from the code from 2nd_part
// this is because the data is encrypted in the binary, and we place plaintext over encrypted data,
// and pass that through a decryption algorithm.
// thus when the 2nd part is compared, it is comparing "decrypted" data even though it looks like garbage
unsigned int decrypt(unsigned int *cipher1, unsigned int *cipher2, unsigned int * magic_constants){
    unsigned int cipher1_working = *cipher1;
    unsigned int cipher2_working = *cipher2;
    unsigned int cipher2_working_dup;
    unsigned int uvar = 0;

    unsigned char loop_max = 0x10;
    for (int i = 0; i < loop_max; i++){
        cipher2_working_dup = cipher2_working;
        uvar = chmod(magic_constants[(i*3)], magic_constants[(i*3)+1], magic_constants[(i*3)+2], cipher2_working);
        cipher2_working = uvar ^ cipher1_working;
        cipher1_working = cipher2_working_dup;
    }
    
    *cipher1 = cipher2_working;
    *cipher2 = cipher1_working;
    
    return 0;
}

int main(int argc, char **argv){
    // magic number for decryption
    // every 3 is a set used for decryption.
    unsigned int magic_constants[0x30] = {0x4b695809, 0xf, 0x674a1dea, 0xe35b9b24, 0x11, 0xad92774c, 0x71adcd92, 0x11, 0x56c93ba6, 0x38d6e6c9, 0x11, 0x2b649dd3, 0x5a844444, 0xc, 0x8b853750, 0x2d422222, 0xc, 0x45c29ba8, 0x16a11111, 0xc, 0x22e14dd4, 0xcdbfbfa8, 0x15, 0x8f47df53, 0xe6dfdfd4, 0x15, 0x47a3efa9, 0xf36fefea, 0x15, 0x23d1f7d4, 0x79b7f7f5, 0x15, 0x11e8fbea, 0xfa34ccda, 0xf, 0x96c3044c, 0x7d1a666d, 0xf, 0x4b618226, 0xf8620416, 0xf, 0xbb87b8aa, 0x7c31020b, 0xf, 0x5dc3dc55, 0x78f7b625, 0x12, 0xb0d69793}; // Little Endian

    // check args
    if (argc < 4){
        fprintf(stderr, "Not Enough Args!\n");
        fprintf(stderr, "./2nd_part_decryptor <e|d> <infile> <outfile>\n");
        return 1;
    }

    // open input file
    FILE *fdin = 0;
    fdin = fopen(argv[2], "rb");
    if (fdin <= 0){
        fprintf(stderr, "Failed to open infile\n");
        return 1;
    }

    // create buffers
    unsigned int *inbuf = 0;
    unsigned int *outbuf = 0;
    unsigned int bufcount = 0x2800;
    unsigned int bufsize = sizeof(unsigned int) * bufcount;
    inbuf = malloc(bufsize);
    outbuf = malloc(bufsize);
    if (inbuf <= 0 || outbuf <= 0){
        fprintf(stderr, "Failed to make buf's\n");
        return 1;
    }

    // read in input data
    size_t in_data_len = 0;
    in_data_len = fread(inbuf, sizeof(unsigned int), bufcount, fdin);
    if (in_data_len <= 0){
        fprintf(stderr, "No data read from file\n");
        return 1;
    }
    fclose(fdin);

    // pass words of ciphertext and the magic_constants array to decryption, save to out buffer
    unsigned int cipher1 = 0;
    unsigned int cipher2 = 0;
    unsigned int stride = 2;
    for (int i = 0; i < (unsigned int)(bufcount); i += stride){
        cipher1 = inbuf[i];
        cipher2 = inbuf[i+1];
    
        if (*argv[1] == 0x65){
            encrypt(&cipher1,&cipher2, magic_constants);
        } else if (*argv[1] == 0x64) {
            decrypt(&cipher1,&cipher2, magic_constants);
        } else {
            fprintf(stderr, "argv[1] needs to be e or d, i got: %c\n",*argv[1]);
            return 1;
        }

        outbuf[i] = cipher1;
        outbuf[i+1] = cipher2;
    }

    // open out file 
    FILE *fdout = 0;
    fdout = fopen(argv[3], "wb");
    if (fdout <= 0){
        fprintf(stderr, "Failed to open outfile\n");
        return 1;
    }

    // write data to out file
    size_t out_data_len = 0;
    out_data_len = fwrite(outbuf, sizeof(unsigned int), in_data_len, fdout);
    if (out_data_len <= 0){
        fprintf(stderr, "No data was written to file\n");
        return 1;
    }
    fclose(fdout);


    return 0;
}
