[BITS 32]
global start
extern kernelMain

CodeOffset equ 0x08
DataOffset equ 0x10

start:
    ; jmp $
    mov ax, DataOffset
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp

    ; Enable A20 line
    in al, 0x92
    or al, 2
    out 0x92, al
    ; End enable A20 line

    ; Remap master PIC
    mov al, 00010001b
    out 0x20, al

    mov al, 0x20
    out 0x21, al

    mov al, 00000001b
    out 0x21, al
    ;End remap of master PIC

    sti                         ; reenable interrupts

    call kernelMain

    jmp $
    mov eax, 69

times 512 - ($ - $$) db 0