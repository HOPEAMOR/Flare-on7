#include <stdio.h>
#include <stdlib.h>

unsigned int strange_data_deob(unsigned int param1, unsigned int param2){
    unsigned char bvar;
    unsigned int return_var;

//    printf("param1: %x\n",param1);
    bvar = param2 & 0x1f;
//    printf("bvar: %x\n",bvar);
    unsigned int tmp1 = param1 >> bvar;
//    printf("param1 >> bvar: %x\n",tmp1);
    unsigned int tmp2 = ~bvar + 1; // fake neg
//    printf("!bvar: %x\n",tmp2);
    unsigned int tmp3 = tmp2 & 0x1f;
//    printf("!bvar & 0x1f: %x\n",tmp3);
    unsigned int tmp4 = param1 << tmp3;
//    printf("param1 << !bvar & 0x1f: %x\n",tmp4);
    return_var = tmp4 | tmp1;
//    printf("return_var: %x\n",return_var);

    //return_var = (param1 << ((!bvar) & 0x1f)) | (param1 >> bvar);

    return return_var;
}

unsigned int chmod(unsigned int magic_constants_0, unsigned int magic_constants_1, unsigned int magic_constants_2, unsigned int cipher2_working){
    unsigned int uvar;

    uvar = cipher2_working + magic_constants_0;
    uvar = strange_data_deob(uvar, magic_constants_1);
//    printf("string_deob uvar: %x\n",uvar);

    uvar = uvar ^ magic_constants_2;

    return uvar;
    
}

unsigned int decrypt(unsigned int cipher1, unsigned int cipher2, unsigned int * magic_constants){
    unsigned int cipher2_working = cipher1; // cipher1 and cipher2_working are flipped at the end of encryption, so we have to do the same
    unsigned int cipher1_working = cipher2;
    unsigned int cipher2_working_dup = 0;
    unsigned int uvar = 0;

    // reverse the encryption, generating uvar's as we go.
    int mc_len = 0x2f; // magic_constants length - 1
    for (int i = 0; i < 0x10; i++){
        // store the original cipher2_working, before it was encrypted in the current round
        cipher2_working_dup = cipher1_working;
        // generate a uvar for this round.
        // we have to use the magic constants backwards because we're doing our rounds backwards.
        // we also have to pass in the cipher2_working that existed before it got encrypted in the round. 
        uvar = chmod(magic_constants[mc_len-(i*3)-2], magic_constants[mc_len-(i*3)-1], magic_constants[mc_len-(i*3)], cipher2_working_dup);
//        printf("uvar: %x\n",uvar);
        // discover what the original cipher1_working was by xoring the current cipher2_working with uvar
        cipher1_working = cipher2_working ^ uvar;
        // set cipher2_working for the next round
        cipher2_working = cipher2_working_dup;
        // print the result for debugging
//        printf("round: %d\ncipher1_working, cipher2_working: %x %x\n", i, cipher1_working, cipher2_working);
    }

    

    printf("cipher1_working: %x\n",cipher1_working);
    printf("cipher2_working: %x\n",cipher2_working);
    
    return 0;
}

unsigned int encrypt(unsigned int cipher1, unsigned int cipher2, unsigned int * magic_constants){
    unsigned int cipher1_working = cipher1;
    unsigned int cipher2_working = cipher2;
    unsigned int cipher2_working_dup;
    unsigned int uvar = 0;

    unsigned char loop_max = 0x10;
    for (int i = 0; i < loop_max; i++){
        cipher2_working_dup = cipher2_working;
        uvar = chmod(magic_constants[(i*3)], magic_constants[(i*3)+1], magic_constants[(i*3)+2], cipher2_working);
        cipher2_working = uvar ^ cipher1_working;
        cipher1_working = cipher2_working_dup;
    }
    
    cipher1 = cipher2_working;
    cipher2 = cipher1_working;
    
    printf("cipher1: %x\n",cipher1);
    printf("cipher2: %x\n",cipher2);
    
    return 0;
}

int main(){
    // hardcoded values
    // comparison_ciphertext is our encrypted answer that we need to decrypt
    // sample_ciphertext is the hardcoded ciphertext that we overwrite with our input
    // sample_plaintext is the decrypted version of the hardcoded ciphertext that we overwrite with our input.
//    unsigned int comparison_ciphertext[0x8] = {0x64a06002,0xea8a877d,0x6ce97ce4,0x823f2d0c,0x8cb7b5eb,0xcf354f42,0x4fad2b49,0x20287ce0}; // Big Endian
    unsigned int comparison_ciphertext[0x8] = {0x0260a064,0x7d878aea,0xe47ce96c,0x0c2d3f82,0xebb5b78c,0x424f35cf,0x492bad4f,0xe07c2820}; // Little Endian
//    unsigned int sample_ciphertext[0x8] = {0xd63f6a10,0xaa92dcf4,0xd63f6a10,0xaa92dcf4,0xd63f6a10,0xaa92dcf4,0xd63f6a10,0xaa92dcf4}; // Big Endian
    unsigned int sample_plaintext[0x8] = {0x106a3fd6,0xf4dc92aa,0x106a3fd6,0xf4dc92aa,0x106a3fd6,0xf4dc92aa,0x106a3fd6,0xf4dc92aa}; // Little Endian
    unsigned int sample_ciphertext[0x8] = {0x41414141, 0x41414141, 0x41414141, 0x41414141, 0x41414141, 0x41414141, 0x41414141, 0x41414141};
    // custom input samples
    unsigned int sample_input_plaintext[0x8] = {0x34333231, 0x38373635, 0x63626139, 0x67666564, 0x6b6a6968, 0x6f6e6d6c, 0x73727170, 0x77767574}; // Little Endian
    unsigned int sample_input_ciphertext[0x8] = {0xd056fb8e, 0x80d61eed, 0x6c6616b5, 0xa4e50832, 0x722eff94, 0xd1185c23, 0xd5001304, 0x24b521d1}; // Little Endian


    // magic number for decryption
    // every 3 is a set used for decryption.
    unsigned int magic_constants[0x30] = {0x4b695809, 0xf, 0x674a1dea, 0xe35b9b24, 0x11, 0xad92774c, 0x71adcd92, 0x11, 0x56c93ba6, 0x38d6e6c9, 0x11, 0x2b649dd3, 0x5a844444, 0xc, 0x8b853750, 0x2d422222, 0xc, 0x45c29ba8, 0x16a11111, 0xc, 0x22e14dd4, 0xcdbfbfa8, 0x15, 0x8f47df53, 0xe6dfdfd4, 0x15, 0x47a3efa9, 0xf36fefea, 0x15, 0x23d1f7d4, 0x79b7f7f5, 0x15, 0x11e8fbea, 0xfa34ccda, 0xf, 0x96c3044c, 0x7d1a666d, 0xf, 0x4b618226, 0xf8620416, 0xf, 0xbb87b8aa, 0x7c31020b, 0xf, 0x5dc3dc55, 0x78f7b625, 0x12, 0xb0d69793}; // Little Endian
//    unsigned int magic_constants[0x30] = {0x958694b, 0xf000000, 0xea1d4a67, 0x249b5be3, 0x11000000, 0x4c7792ad, 0x92cdad71, 0x11000000, 0xa63bc956, 0xc9e6d638, 0x11000000, 0xd39d642b, 0x4444845a, 0xc000000, 0x5037858b, 0x2222422d, 0xc000000, 0xa89bc245, 0x1111a116, 0xc000000, 0xd44de122, 0xa8bfbfcd, 0x15000000, 0x53df478f, 0xd4dfdfe6, 0x15000000, 0xa9efa347, 0xeaef6ff3, 0x15000000, 0xd4f7d123, 0xf5f7b779, 0x15000000, 0xeafbe811, 0xdacc34fa, 0xf000000, 0x4c04c396, 0x6d661a7d, 0xf000000, 0x2682614b, 0x160462f8, 0xf000000, 0xaab887bb, 0xb02317c, 0xf000000, 0x55dcc35d, 0x25b6f778, 0x12000000, 0x9397d6b0}; // Big Endian

    // pass words of ciphertext and the magic_constants array to decryption
    for (int i = 0; i < 0x8; i += 2){
        // hardcoded input test run
        //encrypt(sample_plaintext[i],sample_plaintext[i+1], magic_constants);
        // sample input test run
        //encrypt(sample_input_plaintext[i],sample_input_plaintext[i+1], magic_constants);

        // hardcoded input test run
        //decrypt(sample_ciphertext[i],sample_ciphertext[i+1], magic_constants);
        // sample input test run
        //decrypt(sample_input_ciphertext[i],sample_input_ciphertext[i+1], magic_constants);
        // real run
        decrypt(comparison_ciphertext[i],comparison_ciphertext[i+1], magic_constants);

    }

    return 0;
}
