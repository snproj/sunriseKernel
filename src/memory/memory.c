#include "memory.h"

void* memset(void* ptr, int c, size_t size){
    char* charPtr = (char*)ptr;
    for (int i = 0; i < size; i++) {
        charPtr[i] = (char)c;
    }
    return ptr;
}