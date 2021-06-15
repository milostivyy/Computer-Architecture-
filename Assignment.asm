%macro print 2
      mov rax,1                                                 ;sys call to read
      mov rdi,1                                                 ;assigning 1 to file descripter(stdout)
      mov rsi,%1                                                ;assigning address of array(buffer)
      mov rdx,%2                                                ;assigning length array
      syscall
%endmacro

%macro input 2
      mov rax,0                                                 ;sys call to write
      mov rdi,0                                                 ;assigning 0 to file descripter(stdin)
      mov rsi,%1                                                ;assigning address of array(buffer)
      mov rdx,%2                                                ;assigning length array
      syscall
%endmacro

section .data
      asgn db "Write an X86/64 ALP to accept string from user and store it and dispaly it's length"                                                          ;problem statement
      asgn_len:equ $-asgn                                        ;length of asgn
      nm db "Mahima 3225 "                                     ;name variable
      nm_len:equ $-nm                                            ;length of nm
      msg1 db "enter string "                                    ;msg1 variable
      msg1_len:equ $-msg1                                        ;length of msg1
      msg2 db "entered string's length is "                      ;msg2 variable
      msg2_len:equ $-msg2                                        ;length of msg2
      newLine db 10                                              ;newLine variable
  
section .bss 
      string resb 37                                             ;string buffer with 37 bytes
      len resb 2                                                 ;len buffer with 2 bytes
       
section .text
      global _start
      _start:
      print asgn,asgn_len                                        ;printing asgn
      print newLine,1                                            ;printing newline
      print nm,nm_len                                            ;printing name
      print newLine,1                                            ;printing newline
      print msg1,msg1_len                                        ;printing msg1
      input string,37                                            ;intaking of string from user
      dec rax                                                    ;dec rax to get exact length of stirng without enter
      mov rbx,rax                                                ;storing rbx to rax as after print macro rax changes
      print msg2,msg2_len                                        ;printing msg2
      call display_8                                             ;call to dispaly_8 procedure
      
      mov rax,60                                                 ;sys call for exit
      mov rdi,0
      syscall
      
display_8:                            ;displaying hex
             mov rcx,2
             mov rsi,len              ;pointning rsi to len
            
             next:
                 rol bl,4             ;rotating left 4 bits of bl
                 mov al,bl            ;moving bl to al
                 and al ,0Fh          ;reseting all bits except lower nibble
                 cmp al,9h            ;comparing value in al with 9h
                 jbe addition30h      ;if value is less than or equal then addition30h will be called
                 add al,7h            ;adding 7h to al
                 addition30h:
                       add al ,30h    ;adding 30h to al
                 mov [rsi],al         ;moving value in al to rsi
                 inc rsi              ;pointing rsi to next index
              loop next
              print len,2             ;displaying length of the string
              print newLine,1         ;printing newline
              ret                     ;returning from procedure
       
            
                   
      
