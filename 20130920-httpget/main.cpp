// -*- coding: utf-8-with-signature-dos -*-
//======================================================================================================================

#include "stdafx.h"

int
http_request(const char* server_name, int port=80) {
    auto sock = socket(AF_INET, SOCK_STREAM, 0);
    if(INVALID_SOCKET == sock){
        return 10;
    }

    sockaddr_in server;
    memset(&server, 0, sizeof(server));
    server.sin_family = AF_INET;
    server.sin_port = htons((unsigned short)port);
    server.sin_addr.S_un.S_addr = inet_addr(server_name);
    if(0xffffffff == server.sin_addr.S_un.S_addr){
        auto host = gethostbyname(server_name);
        if(!host){
            return 20;
        }
        auto addrptr = (unsigned int**)host->h_addr_list;
        while(*addrptr){
            server.sin_addr.S_un.S_addr = **addrptr;
            if(!connect(sock, (sockaddr*)&server, sizeof(server))){
                break;
            }
            ++addrptr;
        }
        if(!*addrptr){
            return 30;
        }
    } else
    if(!connect(sock, (sockaddr*)&server, sizeof(server))){
        return 40;
    }

    char packet[8 << 10];
    memset(packet, 0, sizeof(packet));
    strcpy(packet, "GET / HTTP/1.0\r\n\r\n");
    cout << "---- BEGIN SEND ---- " << endl;
    cout << packet;
    cout << "---- END SEND ---- " << endl << endl;
    int len = send(sock, packet, strlen(packet), 0); assert(0 <= len);

    cout << "---- BEGIN RECV ---- " << endl;
    for(;;){
        len = recv(sock, packet, sizeof(packet) - 1, 0); assert(0 <= len);
        if(!len){
            break;
        }
        packet[len] = '\0';
        cout << packet;
    }
    cout << endl << "---- END RECV ---- " << endl << endl;

    closesocket(sock);

    return 0;
}

int
main() {
    try {
        WSADATA data;
        int err = WSAStartup(MAKEWORD(2, 2), &data); assert(!err);

        err = http_request("google.co.jp"); assert(!err);

        WSACleanup();
        return 0;
    }
    catch(const exception& ex) {
        cout << ex.what() << " : " << WSAGetLastError() << endl;
        return 1;
    }
    catch(...) {
        return 99;
    }
}

