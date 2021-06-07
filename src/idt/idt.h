#ifndef IDT_H
#include <stdint.h>
#define IDT_H

struct IDTDescriptor {
    uint16_t offsetLower;
    uint16_t selector;
    uint8_t zeroByte;
    uint8_t typeAttribute;
    uint16_t offsetUpper;
} __attribute__((packed));

struct IDTRDescriptor {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

void idtInit();

#endif