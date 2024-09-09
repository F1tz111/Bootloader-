bits  16                   ;starting real mode bits
org  0x7c00                ;origin for bootloader

boot:
    mov ax, 0x2401         ;setting ax reg to use extended memory 
    int 0x15               ;interrupt for querying for extended memory              

    mov ax, 0x3
    int 0x10               ; set vga text mode 3
    cli
    lgdt [gdt_pointer]     ;loading the gdt table
    mov eax, cr0           ;using special reg to enable protected mode
    or eax,0x1             ;moving 1 to eax
    mov cr0,eax            ;cr0(enabled)
    jmp CODE_SEG:start_pm   ;jumping to codeseg

gdt_start:
    null_descriptor:
         dd  0             ;setting null descriptor 
         dd  0             
    code_descriptor:
         dw 0xffff         ;setting first 16 bits of limit
         dw 0              ;setting first 24 bits of base
         db 0              ;16+8=24
         db 10011010b       ;present(1),privilage(00),type(1).flags(1010) 
         db 11001111b       ;other flags(1100) + last 4 bits of limit
         db 0              ;last 8 bits of base

    ;to learn more about which bit corresponds to which field of the table visit: wiki.osdev.org/Global_Descriptor_Table
    
    data_descriptor:
         dw 0xffff
         dw 0
         db 0
         db 10010010b
         db 11001111b 
         db 0
gdt_end: 
        
gdt_pointer:
         dw gdt_end - gdt_start  ;size
         dd gdt_start       
         
CODE_SEG equ code_descriptor - gdt_start
DATA_SEG equ data_descriptor - gdt_start


bits  32
start_pm:
        mov ax,DATA_SEG
        mov ds,ax
        mov es,ax
        mov fs,ax
        mov ss,ax
        mov gs,ax
        mov esi,name
        mov ebx,0xb8000   

.loop
       lodsb
       or al,al
       jz halt
       or eax,0x0100
       mov word [ebx],ax
       add ebx,2
       jmp .loop

halt:
    cli
    hlt

name: db "Mustafa Malik", 0
      
times 510 -  ($-$$) db  0
dw 0xaa55   
