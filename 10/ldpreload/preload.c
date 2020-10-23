#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <signal.h>
#include <stdlib.h>
#include <stddef.h>
#include <stdarg.h>
#include <errno.h>
#include <sys/resource.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/syscall.h>
#include <math.h>

/* Change the protections of FILE to MODE.  */
/*int
chmod (const char *file, mode_t mode)
{
  printf("\nDATA - chmod input: %s, %x\n", file, (int)mode);

  // get magic constants
  unsigned int d1 = 0;
  unsigned int d2 = 0;
  unsigned int d3 = 0;
  unsigned int dtemp = 0;
  for (unsigned char i = 0; i < 4; i++){
    dtemp = (unsigned char)*(file+0x1c+i);
    d1 += dtemp << (8*i);
    dtemp = (unsigned char)*(file+0xa4+i);
    d2 += dtemp << (8*i);
    dtemp = (unsigned char)*(file+0x4c+i);
    d3 += dtemp << (8*i);
  }

//  printf("%x, %x, %x\n", d1, d2, d3);


  //if (d1 == 37){
  //  printf("\nDATA - chmod printable mode: %x\n", (unsigned int)mode);
  //}

  fflush(stdout);
  // waste some time so that i can see stuff
  int big_number = 10000000000;
  int a;
  for (int i = 0; i < big_number; i++){
    a = i;
  }

  unsigned int uvar = syscall(SYS_chmod, file, mode);
  printf("\nDATA - chmod uvar: %x\n", uvar);

  return uvar;
}*/

/* Truncate PATH to LENGTH bytes.  */
int
truncate (const char *path, off_t length)
{

//  char *new_path = path;
    //printf("STATUS - truncate: %.*s\n",(int)length,path);
    printf("STATUS - truncate\n");

//  printf("\nDATA - truncate input: %.*s, %ld\n", (int)length+40050, path, length);
//  printf("\n");
// fflush(stdout);
  
//  unsigned char cancel_flag = 0; // 0 for dont cancel, 1 for do
  unsigned char cancel_flag = 1; // 0 for dont cancel, 1 for do
  if (cancel_flag == 0){
    printf("STATUS - truncate: overwriting decrypted text\n");
/*    unsigned char comparison_ciphertext[0x20] = {0x64,0xa0,0x60,0x02,0xea,0x8a,0x87,0x7d,0x6c,0xe9,0x7c,0xe4,0x82,0x3f,0x2d,0x0c,0x8c,0xb7,0xb5,0xeb,0xcf,0x35,0x4f,0x42,0x4f,0xad,0x2b,0x49,0x20,0x28,0x7c,0xe0};
    for (int i = 0; i < length; i++){
      new_path[i] = comparison_ciphertext[i];
    }*/
  }

  int ret, save;
  if (length == 0) {
    printf("STATUS - truncate: failing with length == 0\n");
    fflush(stdout);
    ret = 0;
  }
  else {
//    printf("\nSTATUS - truncate: calling truncate\n");
//    ret = ftruncate (fd, length);
    ret = syscall(SYS_truncate, path, length); // lets try syscalling ourselves
//    printf("\nDATA - truncate ret: %d\n", ret);
//    fflush(stdout);
  }
  save = errno;
//  (void) close (fd);
//  if (ret < 0)
//    __set_errno (save);
  return ret;
}

int
nice (int incr)
{

  printf("DATA - nice index: %d\n", incr ^ 0xaa);
  fflush(stdout);

  int save;
  int prio;
  int result;
  int a;
  /* -1 is a valid priority, so we use errno to check for an error.  */
  save = errno;
  //set_errno (0);
  prio = getpriority (PRIO_PROCESS, 0);
  if (prio == -1)
    {
      if (errno != 0)
        return -1;
    }
  result = setpriority (PRIO_PROCESS, 0, prio + incr);
  if (result == -1)
    {
      if (errno == EACCES)
        a = 5;
        //set_errno (EPERM);
      return -1;
    }
  //set_errno (save);
  return getpriority (PRIO_PROCESS, 0);
}

void *
memset (void *dest, int val, size_t len)
{
  unsigned char *ptr = dest;

  printf("DATA - memset input: %s, %d, %d\n", ptr, val, len);
  fflush(stdout);

  while (len-- > 0)
    *ptr++ = val;
  return dest;
}

int 
sprintf (char *buf, const char *fmt, ...)
{

    printf("DATA - sprintf input: %s, %s\n", buf, fmt);
    fflush(stdout);

    int n;
    va_list ap;
    va_start(ap, fmt);
    n = vsprintf (buf, fmt, ap);
    va_end(ap);
    return (n);
}

void *
memcpy (void *dest, const void *src, size_t len)
{

  //unsigned char ciphertext[0x20] = {0x64,0xa0,0x60,0x02,0xea,0x8a,0x87,0x7d,0x6c,0xe9,0x7c,0xe4,0x82,0x3f,0x2d,0x0c,0x8c,0xb7,0xb5,0xeb,0xcf,0x35,0x4f,0x42,0x4f,0xad,0x2b,0x49,0x20,0x28,0x7c,0xe0};
//  unsigned char ciphertext[0x20] = {0xea,0x8a,0x87,0x7d,0x64,0xa0,0x60,0x02,0x82,0x3f,0x2d,0x0c,0x6c,0xe9,0x7c,0xe4,0xcf,0x35,0x4f,0x42,0x8c,0xb7,0xb5,0xeb,0x20,0x28,0x7c,0xe0,0x4f,0xad,0x2b,0x49};

  unsigned char *d = dest; // converted to unsigned
  const unsigned char *s = src; // converted to unsigned

  printf("DATA - memcpy input: %.*s, %.*s, %d\n",len, d, len, s, len); // this breaks our attempts to view the hash values rather than the string.
//  printf("\nDATA - memcpy hex data: %x\n", (unsigned int)src);
/*  for (int i = 0; i < len; i++){
    printf(" %x ", (unsigned int)s[i]);
  }*/
//  printf("\nDATA - memcpy 2 bytes: %x, %x\n", d[0], d[1]); // debugging for the xxtea partial flag condition

//  unsigned char partial_flag_cancel_flag = 0; // 0 for dont cancel, 1 for do
  unsigned char partial_flag_cancel_flag = 1; // 0 for dont cancel, 1 for do

  // dont memcpy overwrite our 2nd partial flag data location if we correctly identify it.
  if (d[0] == 0xd6 && d[1] == 0x3f && partial_flag_cancel_flag == 0){
    printf("STATUS - memcpy: identified xxtea related partial flag location, refusing to copy data\n");
    fflush(stdout);
  /*  int local_len = 0x20;
    for (int i = 0; i < local_len; i++){
      d[i] = ciphertext[i];
    }*/
    return dest;
  }
  else {
    printf("STATUS - memcpy: copying as usual\n");
    fflush(stdout);
    while (len--){
      *d++ = *s++;
    }
    return dest;
  }
  fflush(stdout);
  return 0; // this shouldn't happen
}

int memcmp(const void* s1, const void* s2,size_t n)
{
    const unsigned char *p1 = s1, *p2 = s2;
    
    printf("DATA - memcmp input: %s, %s, %d\n", p1, p2, n);
    fflush(stdout);

    while(n--)
        if( *p1 != *p2 )
            return *p1 - *p2;
        else
            p1++,p2++;
    return 0;
}

int
strcmp (const char *p1, const char *p2)
{
  const unsigned char *s1 = (const unsigned char *) p1;
  const unsigned char *s2 = (const unsigned char *) p2;

  printf("DATA - strcmp input: %s, %s\n", p1, p2);
  fflush(stdout);

  unsigned char c1, c2;
  do
    {
      c1 = (unsigned char) *s1++;
      c2 = (unsigned char) *s2++;
      if (c1 == '\0')
        return c1 - c2;
    }
  while (c1 == c2);
  return c1 - c2;
}

int
strncmp (const char *s1, const char *s2, size_t n)
{
  unsigned char c1 = '\0';
  unsigned char c2 = '\0';

  printf("DATA - strncmp input: %s, %s\n", s1, s2);
  fflush(stdout);

  if (n >= 4)
    {
      size_t n4 = n >> 2;
      do
        {
          c1 = (unsigned char) *s1++;
          c2 = (unsigned char) *s2++;
          if (c1 == '\0' || c1 != c2)
            return c1 - c2;
          c1 = (unsigned char) *s1++;
          c2 = (unsigned char) *s2++;
          if (c1 == '\0' || c1 != c2)
            return c1 - c2;
          c1 = (unsigned char) *s1++;
          c2 = (unsigned char) *s2++;
          if (c1 == '\0' || c1 != c2)
            return c1 - c2;
          c1 = (unsigned char) *s1++;
          c2 = (unsigned char) *s2++;
          if (c1 == '\0' || c1 != c2)
            return c1 - c2;
        } while (--n4 > 0);
      n &= 3;
    }
  while (n > 0)
    {
      c1 = (unsigned char) *s1++;
      c2 = (unsigned char) *s2++;
      if (c1 == '\0' || c1 != c2)
        return c1 - c2;
      n--;
    }
  return c1 - c2;
}


/* Return the length of the null-terminated string STR.  Scan for
   the null terminator quickly by testing four bytes at a time.  */
size_t
strlen (const char *str)
{

  printf("DATA - strlen input: %s\n",str);
  fflush(stdout);

  const char *char_ptr;
  const unsigned long int *longword_ptr;
  unsigned long int longword, himagic, lomagic;
  /* Handle the first few characters by reading one character at a time.
     Do this until CHAR_PTR is aligned on a longword boundary.  */
  for (char_ptr = str; ((unsigned long int) char_ptr
                        & (sizeof (longword) - 1)) != 0;
       ++char_ptr)
    if (*char_ptr == '\0')
      return char_ptr - str;
  /* All these elucidatory comments refer to 4-byte longwords,
     but the theory applies equally well to 8-byte longwords.  */
  longword_ptr = (unsigned long int *) char_ptr;
  /* Bits 31, 24, 16, and 8 of this number are zero.  Call these bits
     the "holes."  Note that there is a hole just to the left of
     each byte, with an extra at the end:
     bits:  01111110 11111110 11111110 11111111
     bytes: AAAAAAAA BBBBBBBB CCCCCCCC DDDDDDDD
     The 1-bits make sure that carries propagate to the next 0-bit.
     The 0-bits provide holes for carries to fall into.  */
  himagic = 0x80808080L;
  lomagic = 0x01010101L;
  if (sizeof (longword) > 4)
    {
      /* 64-bit version of the magic.  */
      /* Do the shift in two steps to avoid a warning if long has 32 bits.  */
      himagic = ((himagic << 16) << 16) | himagic;
      lomagic = ((lomagic << 16) << 16) | lomagic;
    }
  if (sizeof (longword) > 8)
    abort ();
  /* Instead of the traditional loop which tests each character,
     we will test a longword at a time.  The tricky part is testing
     if *any of the four* bytes in the longword in question are zero.  */
  for (;;)
    {
      longword = *longword_ptr++;
      if (((longword - lomagic) & ~longword & himagic) != 0)
        {
          /* Which of the bytes was the zero?  If none of them were, it was
             a misfire; continue the search.  */
          const char *cp = (const char *) (longword_ptr - 1);
          if (cp[0] == 0)
            return cp - str;
          if (cp[1] == 0)
            return cp - str + 1;
          if (cp[2] == 0)
            return cp - str + 2;
          if (cp[3] == 0)
            return cp - str + 3;
          if (sizeof (longword) > 4)
            {
              if (cp[4] == 0)
                return cp - str + 4;
              if (cp[5] == 0)
                return cp - str + 5;
              if (cp[6] == 0)
                return cp - str + 6;
              if (cp[7] == 0)
                return cp - str + 7;
            }
        }
    }
}
