#define _BSD_SOURCE
#include <unistd.h>

int main(void) {
    daemon(0,0);
    return 64;
}
