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

    mov si, initMessage
    call print

; SET UP FOR INT 0x13 TO READ SECTOR 2 FROM DISK
    mov ah, 2
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov bx, buffer
    int 0x13
    jc error
    mov si, buffer
    call print
    jmp $           ; jump to self to prevent executing signature

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

initMessage: db 'Hello, world!', 0xD, 0
errorMessage: db "An error has occured.", 0xD, 0

times 510-($ - $$) db 0
dw 0xAA55

buffer: