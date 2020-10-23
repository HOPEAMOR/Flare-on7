// Broken on recent Linux, used to work.
#include <stdio.h>

// can be non-const if you use gcc -z execstack.  static is also optional
static const char code[] = {
  0x8D, 0x04, 0x37,           //  lea eax,[rdi+rsi]       // retval = a+b;                    
  0xC3                        //  ret                                         
};

static const char ret0_code[] = "\x31\xc0\xc3";   // xor eax,eax ;  ret
                     // the compiler will append a 0 byte to terminate the C string,
                     // but that's fine.  It's after the ret.

int main () {
  // void* cast is easier to type than a cast to function pointer,
  // and in C can be assigned to any other pointer type.  (not C++)

  int (*sum) (int, int) = (void*)code;
  int (*ret0)(void) = (void*)ret0_code;

  // run code                                                                   
  int c = sum (2, 3);

  printf("digit %d\n",c);

  return ret0();
}

