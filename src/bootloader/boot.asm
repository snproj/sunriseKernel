ORG 0x7c00
BITS 16

global start

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
    mov eax, 1
    mov ecx, 100
    mov edi, 0x0100000      ; 1 megabyte
    call ATA_LBA_Read
    jmp CodeOffset:0x0100000

ATA_LBA_Read:
    mov ebx, eax            ; backup LBA

    ; Send highest 8 bits of LBA to HD controller
    shr eax, 24
    or eax, 0xE0            ; Select master drive
    mov dx, 0x1F6
    out dx, al

    ; Send total no. of sectors to read
    mov eax, ecx,
    mov dx, 0x1F2
    out dx, al

    mov eax, ebx            ; restore backup LBA

    ; Send more bits of LBA
    mov dx, 0x1F3
    out dx, al

    mov dx, 0x1F4
    mov eax, ebx            ; restore backup LBA again
    shr eax, 8
    out dx, al

    mov dx, 0x1F5
    mov eax, ebx
    shr eax, 16
    out dx, al

    mov dx, 0x1F7
    mov al, 0x20
    out dx, al

    ; read all sectors into memory
.nextSector:
    push ecx

    ; check if we need to read
.tryAgain:
    mov dx, 0x1F7
    in al, dx
    test al, 8
    jz .tryAgain
    

    mov ecx, 256            ; read 256 bytes at a time
    mov dx, 0x1F0
    rep insw
    pop ecx
    loop .nextSector

    ret

initMessage: db 'Headasd, world!', 0xA, 0xD, 0
errorMessage: db "An error has occured,", 0xA, 0xD, 0

times 510-($ - $$) db 0
dw 0xAA55

buffer: