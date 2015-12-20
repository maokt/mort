#include <stdio.h>
#include <unistd.h>
#include <sys/prctl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sysexits.h>
#include <errno.h>

static void explain_exit(pid_t p, int e) {
    if (WIFEXITED(e)) {
        printf("%d exit %d\n", p, WEXITSTATUS(e));
    }
    else if (WIFSIGNALED(e)) {
        printf("%d killed by signal %d\n", p, WTERMSIG(e));
    }
}

int main(int argc, char *argv[]) {
    
    int erc = prctl(PR_SET_CHILD_SUBREAPER, 1);
    if (erc != 0) {
        perror("set child subreaper failed");
        return EX_OSERR;
    }

    pid_t first_kid = fork();
    if (first_kid == -1) {
        perror("fork failed");
        return EX_OSERR;
    }
    else if (first_kid == 0) {
        execvp(argv[1], argv+1);
        perror("exec failed");
        return EX_UNAVAILABLE;
    }

    int first_status = 0;
    int status;
    pid_t reap_kid;
    while ((reap_kid = wait(&status)) > 0) {
        explain_exit(reap_kid, status);
        if (reap_kid == first_kid) first_status = status;
    }
    if (reap_kid == -1 && errno == ECHILD) {
        // nothing to wait for; nothing left to do
        if (WIFEXITED(first_status)) return WEXITSTATUS(first_status);
        else return EX_IOERR;
    }

    return EX_SOFTWARE;
}

