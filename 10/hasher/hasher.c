#include <stdio.h>
#include <stdlib.h>
#include "hasher.h"

void print_hex(unsigned char* data, unsigned int size){
    for (int i=0; i < size; i++){
        printf("%02x", data[i]);
    }
    printf("\n");
}

int main () {

    // define functions within the shellcode that we're interested in.
    // shellcode_base allows us to use offsets from the ghidra analysis.
    int shellcode_base = 0x8053b70;
    void (*shellcode) (unsigned int *, unsigned int *, unsigned int *) = (void *)shellcode_code;
    __attribute__ ((regparm(3))) void (*bee_bigint_mult) (unsigned char *, unsigned char *, unsigned char *) = (void*)shellcode_code + (0x80546e1 - shellcode_base);
    __attribute__ ((regparm(3))) void (*bee_bigint_sub) (unsigned char *, unsigned char *, unsigned char *) = (void*)shellcode_code + (0x8054801 - shellcode_base);
    __attribute__ ((regparm(3))) void (*bee_bigint_add) (unsigned char *, unsigned char *, unsigned char *) = (void*)shellcode_code + (0x80541b7 - shellcode_base);
    __attribute__ ((regparm(3))) void (*bee_bigint_div) (unsigned char *, unsigned char *, unsigned char *) = (void*)shellcode_code + (0x80542a3 - shellcode_base);
    __attribute__ ((regparm(3))) void (*bee_hex_to_bigint) (unsigned char *, unsigned char *, unsigned int) = (void*)shellcode_code + (0x8054447 - shellcode_base);
    __attribute__ ((regparm(3))) void (*bee_int_to_bigint) (unsigned char *, unsigned int, unsigned int) = (void*)shellcode_code + (0x805440f - shellcode_base);
    __attribute__ ((regparm(3))) void (*bee_memcpy) (unsigned char *, unsigned char *) = (void*)shellcode_code + (0x805422a - shellcode_base);
    __attribute__ ((regparm(3))) void (*bee_bigint_divmod) (unsigned char *, unsigned char *, unsigned char *, unsigned char *) = (void*)shellcode_code + (0x80543ca - shellcode_base);
    __attribute__ ((regparm(3))) void (*bee_bigint_rsa_modexp) (unsigned char *, unsigned char *, unsigned char *, unsigned char *) = (void*)shellcode_code + (0x8054533 - shellcode_base);
    int (*ret0)(void) = (void*)ret0_code;

    unsigned char local_408[0x400] = {0};
    unsigned char quotient[0x80] = {0};
    unsigned char rsa_key[0x80] = {0};
    unsigned char modulus[0x80] = {0};
    unsigned char urandom_compare_buf[0x80] = {0};
//    unsigned char input_string[0x80] = {0x1};
//    unsigned char input_string[0x80] = "AAAAAAAAAAA@flare-on.com";
//    unsigned char input_string[0x80] = "BBBBBBBBBBB@flare-on.com";
    unsigned char input_string[0x80] = "AAAAAAAAAAAAAAAAAAAAAAAA";
//    unsigned char input_string[0x80] = "BBBBBBBBBBBBBBBBBBBBBBBB";
//    unsigned char input_string[0x80] = "CCCCCCCCCCCCCCCCCCCCCCCC";
    unsigned char beecrypto_hash2[0x80] = {0};
    unsigned char f40022d8_2[0x80] = {0};
    unsigned char rsa_key_mod[0x80] = {0};
    unsigned char c10357c7[0x80] = {0};
    unsigned char d1cc3447[0x80] = {0};
    unsigned char d036c5d4[0x80] = {0};
    unsigned char f40022d8[0x80] = {0};
    
    unsigned char local_94[0x80] = {0};

    unsigned char i_buf[0x80] = {0};
    unsigned char tmp_buf1[0x80] = {0};
    unsigned char tmp_buf2[0x80] = {0};
    unsigned char tmp_buf3[0x80] = {0};
    unsigned char tmp_buf4[0x80] = {0};

    // get random data
    FILE *fdin = 0;
    fdin = fopen("/dev/urandom", "rb");
    if (fdin <= 0){
        fprintf(stderr, "Failed to open infile\n");
        return 1;
    }

    // read in input data
    size_t in_data_len = 0;
    in_data_len = fread(rsa_key, sizeof(unsigned int), 0x20, fdin);
    if (in_data_len <= 0){
        fprintf(stderr, "No data read from file\n");
        return 1;
    }
    fclose(fdin);

    bee_hex_to_bigint(f40022d8,"480022d87d1823880d9e4ef56090b54001d343720dd77cbc5bc5692be948236c", 0x40);
    bee_hex_to_bigint(f40022d8_2,"480022d87d1823880d9e4ef56090b54001d343720dd77cbc5bc5692be948236c", 0x40);
    bee_hex_to_bigint(d036c5d4, "d036c5d4e7eda23afceffbad4e087a48762840ebb18e3d51e4146f48c04697eb", 0x40); // res
    bee_hex_to_bigint(c10357c7, "c10357c7a53fa2f1ef4a5bf03a2d156039e7a57143000c8d8f45985aea41dd31", 0x40); // c
    bee_hex_to_bigint(d1cc3447, "d1cc3447d5a9e1e6adae92faaea8770db1fab16b1568ea13c3715f2aeba9d84f", 0x40); // N
    bee_int_to_bigint(tmp_buf4, 0, 0);

    // all the math's
    // modexp behaves something like a remainder rather than modexp
    bee_bigint_divmod(rsa_key, d1cc3447, quotient, rsa_key_mod);
    bee_memcpy(rsa_key,rsa_key_mod);
    bee_bigint_rsa_modexp(c10357c7, rsa_key, d1cc3447, beecrypto_hash2);
    bee_memcpy(rsa_key, rsa_key_mod);
    bee_bigint_rsa_modexp(f40022d8_2, rsa_key, d1cc3447, urandom_compare_buf);

    // this is like a single round of multiply, mod.
    // where input_string is our plantext, beecrypto_hash2 is our res, and d1cc is our N
    bee_bigint_mult(input_string, beecrypto_hash2, rsa_key);
    bee_bigint_divmod(rsa_key, d1cc3447, quotient, modulus);

/*    bee_bigint_div(rsa_key, d1cc3447, quotient);
    bee_bigint_mult(quotient, d1cc3447, local_94);
    bee_bigint_sub(rsa_key, local_94, modulus);*/


//    bee_bigint_rsa_modexp(modulus, c10357c7, d1cc3447, tmp_buf1);
//    printf("string: %s\n",tmp_buf1);
//    print_hex(tmp_buf1, 0x80);

/*    printf("modulus: %s\n",modulus);
    print_hex(modulus, 0x80);

    printf("bch: %s\n",beecrypto_hash2);
    print_hex(beecrypto_hash2, 0x80);
*/
/*    bee_bigint_mult(modulus, d1cc3447, rsa_key);
    bee_bigint_divmod(rsa_key, d1cc3447, quotient, tmp_buf1);*/

//    bee_bigint_divmod(d1cc3447, modulus, tmp_buf1, tmp_buf2);
/*    printf("divide\n");
    print_hex(tmp_buf1, 0x80);
    printf("mod\n");
    print_hex(tmp_buf2, 0x80);
*/

/*    // reverse the algorith, given all the information
    bee_bigint_mult(d1cc3447,quotient,tmp_buf1);
    bee_bigint_divmod(tmp_buf1, beecrypto_hash2, tmp_buf2, tmp_buf3);
    bee_bigint_add(tmp_buf2, tmp_buf3, tmp_buf4);
    printf("string: %s\n",tmp_buf2);
    print_hex(tmp_buf2, 0x80);
*/    


    return ret0();
}
