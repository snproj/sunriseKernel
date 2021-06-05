ORG 0x7c00
BITS 16

CodeOffset equ gdtCode - gdtStart
DataOffset equ gdtData - gdtStart

biosParamBlock:
    jmp short start
    nop

times 33 db 0

gdtStart:
gdtNull:
    dd 0
    dd 0

gdtCode:
    dw 0xffff
    dw 0
    db 0
    db 0x9a
    db 11001111b
    db 0

gdtData:
    dw 0xffff
    dw 0
    db 0
    db 0x92
    db 11001111b
    db 0

gdtEnd:

gdtDescriptor:
    dw gdtEnd - gdtStart -1
    dd gdtStart

jumpToStart:
    jmp 0:start

start:
    cli
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti

    mov si, initMessage
    call print

loadProtectedMode:
    cli
    lgdt [gdtDescriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    

    jmp CodeOffset:protectedModeStart

error:
    mov si, errorMessage
    call print
    jmp $

print:
    mov ah, 0eh     ; print
    mov bx, 0
    lodsb
    call printChar
    cmp al, 0
    jne print
    ret

printChar:
    int 0x10        ; print interrupt
    ret

[BITS 32]
protectedModeStart:
    mov ax, DataOffset
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp
    jmp $

initMessage: db 'Hello, world!\n', 0xA, 0xD, 0
errorMessage: db "An error has occured,", 0xA, 0xD, 0

times 510-($ - $$) db 0
dw 0xAA55

buffer: