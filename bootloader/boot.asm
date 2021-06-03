ORG 0
BITS 16

biosParamBlock:
    jmp short start
    nop

times 33 db 0

jumpToStart:
    jmp 0x7c0:start

start:
    cli
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ax, 0
    mov ss, ax
    mov sp, 0x7c00
    sti
    mov si, message
    call print
    jmp $           ; jump to self to prevent executing signature

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

message: db 'Hello, world!', 0

times 510-($ - $$) db 0
dw 0xAA55