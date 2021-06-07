#include "idt.h"
#include "../config.h"
#include "../memory/memory.h"
#include "../kernel.h"
#include "../io/io.h"

struct IDTDescriptor idtDescriptorArray[TOTAL_INTERRUPT_COUNT];

struct IDTRDescriptor idtrDescriptor;

extern void idtLoad(struct IDTRDescriptor* ptr);
extern void invalidInterrupt();
extern void int21h();

void invalidInterruptHandler() {
    outb(0x20, 0x20);
}

void int21hHandler() {
    println("Keyboard pressed");
    outb(0x20, 0x20);
}

void idtZero() {
    println("INTERRUPT ZERO CALLED -- DIVIDE BY ZERO ERROR");
    outb(0x20, 0x20);
}

void setIDT(int interruptNumber, void* interruptAddress) {
    struct IDTDescriptor* currIDTDescriptor = &idtDescriptorArray[interruptNumber];
    currIDTDescriptor->offsetLower = (uint32_t)interruptAddress & 0x0000FFFF;
    currIDTDescriptor->selector = KERNEL_CODE_SELECTOR;
    currIDTDescriptor->zeroByte = 0;
    currIDTDescriptor->typeAttribute = 0xEE; // sets 4 bits next to it as well
    currIDTDescriptor->offsetUpper = (uint32_t)interruptAddress >> 16;
}

void idtInit() {
    memset(idtDescriptorArray, 0, sizeof(idtDescriptorArray));
    idtrDescriptor.limit = sizeof(idtDescriptorArray) - 1;
    idtrDescriptor.base = (uint32_t)idtDescriptorArray;


    for (int i = 0; i < TOTAL_INTERRUPT_COUNT; i++) {
        setIDT(i, invalidInterrupt);
    }
    setIDT(0, idtZero);
    setIDT(0x21, int21h);

    // Load IDT
    struct IDTRDescriptor* idtrDescriptorPtr = &idtrDescriptor;
    idtLoad(idtrDescriptorPtr);
}