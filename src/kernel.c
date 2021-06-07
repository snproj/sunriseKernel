#include "kernel.h"
#include <stdint.h>
#include "idt/idt.h"
#include "io/io.h"

#define VGA_COLS 80
#define VGA_ROWS 25

void infiniteLoop () {
    loop:
        int x = 0xDEADBEEF;
        x--;
        goto loop;
}

uint16_t* videoMemoryStart = (uint16_t*)(0xB8000);

uint16_t makePrintableChar(char newChar, char colour) {
    return (colour << 8) | newChar;
}

void initTerminal() {
    for (int i = 0; i < VGA_ROWS; i++) {
        for (int j = 0; j < VGA_COLS; j++) {
            videoMemoryStart[(i * VGA_COLS) + j] = makePrintableChar(' ', 0);
        }
    }
}

void printCharToXY(int x, int y, char newChar, char colour) {
    videoMemoryStart[(y * VGA_COLS) + x] = makePrintableChar(newChar, colour);
}

void printCharSerial(char newChar, char colour) {
    static int x = 0;
    static int y = 0;
    if (newChar == '\n') {
        x = 0;
        y++;
        return;
    }
    printCharToXY(x, y, newChar, colour);
    x++;
    if (x > VGA_COLS) {
        x = 0;
        y++;
    }
}

int strlen(const char* str) {
    int len = 0;
    while (str[len]) {
        len++;
    }
    return len;
}

char* strcat(char* str, const char* appendee) {
    char* ptr = str + strlen(str);
    while(*appendee) {
        *ptr++ = *appendee++;
    }
    *ptr = '\0';

    return str;
}

void print(const char* str) {
    int len = strlen(str);
    for (int i = 0; i < len; i++) {
        printCharSerial(str[i], 15);
    }
}

void println(const char* str) {
    print(str);
    const char* newLine = "\n";
    print(newLine);
}

void marker(){}

void kernelMain() {
    initTerminal();
    //videoMemoryStart[80] = makePrintableChar('A', 4);
    print("Hello world\n\nSuck a cheetah's dick");

    println("hi fuck");

    println("fuck there");

    marker();

    //outb(0x60, 0xff);

    idtInit();

    println("hoyo");

    infiniteLoop();
}