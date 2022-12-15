#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <linux/reboot.h>
#include <string.h>


int main(int argc, char *argv[]) {
    if (argc == 2 && strcmp(argv[1], "-reboot") == 0) {
        // reboot
        ::syscall(SYS_reboot, LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2, LINUX_REBOOT_CMD_RESTART2, "/dev/mmcblk0p1");
        return 0;
    }
    return 0;
}
