#include <stdio.h>
#include <stdlib.h>


int main(){
    // this is our sample ciphertext which decrypts to 32 A's
//    unsigned int sample_ciphertext[0x8] = {0xd63f6a10,0xaa92dcf4,0xd63f6a10,0xaa92dcf4,0xd63f6a10,0xaa92dcf4,0xd63f6a10,0xaa92dcf4}; // Big Endian
//    unsigned int sample_ciphertext[0x8] = {0x106a3fd6,0xf4dc92aa,0x106a3fd6,0xf4dc92aa,0x106a3fd6,0xf4dc92aa,0x106a3fd6,0xf4dc92aa}; // Little Endian

    // this is our sample plaintext which is based off of our sample ciphertext
    unsigned int sample_plaintext[0x8] = {0x41414141, 0x41414141, 0x41414141, 0x41414141, 0x41414141, 0x41414141, 0x41414141, 0x41414141};

    // this is the uvar list for the default sample ciphertext in the file which results in 32 A'x
    unsigned int uvar_arr[0x10] = {0x8d0f391d, 0xa90d4cab, 0x9f8679f6, 0x9b4e23e2, 0x6307de21, 0x2f54febe, 0x15d4f5aa, 0x9fec47f6, 0x5df09bd8, 0x1249b518, 0x26d68fc, 0x5f1867e1, 0x3d25fe32, 0x2cade70e, 0xb37fb59d, 0xb22c9d61};

    // init our block and relevant variables.
    // we're only doing 1 block for testing
    unsigned int cipher1_working = sample_plaintext[0];
    unsigned int cipher2_working = sample_plaintext[1];
    unsigned int cipher2_working_dup = 0;
    // do 16 rounds of reverse encryption per block
    for (int i = 0; i < 0x10; i++){
        // store the original cipher2_working, before it was encrypted in the current round
        cipher2_working_dup = cipher1_working;
        // discover what the original cipher1_working was by xoring the current cipher2_working with uvar
        cipher1_working = cipher2_working ^ uvar_arr[i];
        // set cipher2_working for the next round
        cipher2_working = cipher2_working_dup;
        // print the result for debugging
        printf("round: %d\ncipher1_working, cipher2_working: %x %x\n", i, cipher1_working, cipher2_working);
    }
}
