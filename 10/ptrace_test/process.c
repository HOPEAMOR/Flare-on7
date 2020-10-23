#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <sys/user.h>   /* For user_regs_struct */
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <sys/reg.h>


int main()
{   pid_t child;
    long orig_eax;
    int status;
    child = fork();
    if(child == 0) {
        char *buf = malloc(0x100);
        ptrace(PTRACE_TRACEME, 0, NULL, NULL);
        read(0x0, buf, 0xff);
        printf("stuff\n");
        execl("/bin/ls", "ls", NULL);
    }
    else {
       while(1) {
          wait(&status);
          if(WIFEXITED(status))
              break;
          orig_eax = ptrace(PTRACE_PEEKUSER,
                     child, 4 * ORIG_EAX, NULL);
            
          printf("orig_eax: %ld\n",orig_eax);

          ptrace(PTRACE_SYSCALL,
                   child, NULL, NULL);
        }
    }
    return 0;
}
