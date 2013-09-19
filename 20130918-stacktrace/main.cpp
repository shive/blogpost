// -*- coding: utf-8-with-signature-dos -*-
//======================================================================================================================

// 参考 : この例外を投げたのは誰だー　スタックトレースで遊ぼう : http://d.hatena.ne.jp/rti7743/20110109/1294605380

#include <stdio.h>
#include <array>
#include <iostream>
#include <iomanip>
#include <windows.h>
#include <dbghelp.h>

using namespace std;

namespace mycode {
#ifdef _M_IX86
    typedef DWORD DWORDx;
#else
    typedef DWORD64 DWORDx;
#endif

    string
    getline(const char* filename, int linenumber) {
        if(FILE* fp = fopen(filename, "rt")){
            char linebuffer[1024] = "";
            for(int Li = 0; Li < linenumber - 1; ++Li){
                fgets(linebuffer, sizeof(linebuffer), fp);
            }
            char* p = strchr(linebuffer, '\n');
            if(p){
                *p = '\0';
            }
            fclose(fp);
            return string(linebuffer);
        }
        return "?";
    }

    void
    backtrace() {
        static struct sym_t {
            HANDLE proc;
            sym_t() {
                proc = GetCurrentProcess();
                SymSetOptions(
                    SYMOPT_DEFERRED_LOADS | // シンボルを参照する必要があるときまで読み込まない
                    SYMOPT_LOAD_LINES |     // 行番号情報を読み込む
                    SYMOPT_UNDNAME          // すべてのシンボルを装飾されていない形式で表します
                    );
                if(!SymInitialize(proc, 0, true)){
                    throw exception("error : SymInitialize");
                }
                // cout << "<SymInitialize>" << endl;
            }
            ~sym_t() {
                SymCleanup(proc);
                // cout << "<SymCleanup>" << endl;
            }
        } s_sym;

        array<void*,8> addr;
        int count = RtlCaptureStackBackTrace(0, addr.size(), &addr[0], 0);
        cout << "---- BEGIN BACKTRACE ----" << endl;
        for(int Li = 1; Li < count; ++Li){
            auto p = reinterpret_cast<uintptr_t>(addr[Li]);

            IMAGEHLP_MODULE module;
            ::memset(&module, 0, sizeof(module));
            module.SizeOfStruct = sizeof(module);
            if(!SymGetModuleInfo(s_sym.proc, p, &module)){
                throw exception("error : SymGetModuleInfo");
            }

            char buffer[MAX_PATH + sizeof(IMAGEHLP_SYMBOL)];
            ::memset(buffer, 0, sizeof(buffer));
            auto symbol = reinterpret_cast<IMAGEHLP_SYMBOL*>(buffer);
            symbol->SizeOfStruct = sizeof(*symbol);
            symbol->MaxNameLength = MAX_PATH;

            DWORDx disp = 0;
            if(!SymGetSymFromAddr(s_sym.proc, p, &disp, symbol)){
                throw exception("error : SymGetSymFromAddr");
            }

            string text = "?";
            IMAGEHLP_LINE line;
            ::memset(&line, 0, sizeof(line));
            line.SizeOfStruct = sizeof(line);
            DWORD disp2 = 0;
            if(!SymGetLineFromAddr(s_sym.proc, p, &disp2, &line)){
                line.FileName = "?";
                line.LineNumber = 0;
                text = "?";
            } else {
                text = getline(line.FileName, line.LineNumber);
            }

            cout << Li
                 << " : 0x" << hex << setw(sizeof(uintptr_t) * 2) << setfill('0') << p
                 << " : " << module.ModuleName
                 << " : " << symbol->Name
                 << " : " << line.FileName << "(" << dec << line.LineNumber << ")"
                 << " : " << text.c_str()
                 << endl;
        }
        cout << "---- END BACKTRACE ----" << endl << endl;
    }

    void
    foo() {
        backtrace();
    }
    void
    bar() {
        foo();
    }
    void
    baz() {
        bar();
    }
    void
    hoge() {
        baz();
    }
}

int
main() {
    try {
        mycode::hoge();
    }
    catch(const exception& ex) {
        cout << ex.what() << endl;
        return 1;
    }
    return 0;
}

