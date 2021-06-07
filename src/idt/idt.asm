section .asm

extern int21hHandler
extern invalidInterruptHandler

global invalidInterrupt
global idtLoad
global int21h

idtLoad:
    push ebp
    mov ebp, esp

    mov ebx, [ebp+8]
    lidt [ebx]

    pop ebp
    ret

int21h:
    cli
    pushad

    call int21hHandler

    popad
    sti
    iret

invalidInterrupt:
    cli
    pushad

    call invalidInterruptHandler

    popad
    sti
    iret