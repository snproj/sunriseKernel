ORG 0x7c00
BITS 16

start:
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