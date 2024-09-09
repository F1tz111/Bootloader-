bits  16    ;setting size to be  only 16 bits
org 0x7c00  ;setting origin of mem address to load bootloader (we choose 0c7c00 cuz its convention )
 
boot:
     mov si,Name ;moving the label to the register
     mov ah ,0x0e   ;BIOS intrrrupt func to print on screen 
     
.loop:
     lodsb          ;loads the byte from address pointed by (si) into al reg and increment si by 1
     or al,al       ;OR al with al 
     jz halt        ;if true jump to halt
     int 0x10       ;BIOS interrupt to handle printing (it checks if there is smth in ah)
     jmp .loop 

halt :
    cli             ;clear interrupt flag
    hlt             ;halt program 


Name: db "Mustafa Malik",0   ;defining String to print  
times 510 - ($-$$) db 0       ;padding reamaining 510 bytes with zeroes
dw 0xaa55                     ;marking last 2-byte for boot sector signature    
             
