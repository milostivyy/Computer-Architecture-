;Write an X86/64 ALP to accept five 64 bit Hexadecimal numbers from user and store them in an array and display the accepted numbers.
%macro print 2
      mov rax,1         ;sys call to write
      mov rdi,1         ;assigning 1 to file descripter(stdout)
      mov rsi,%1        ;assigning address of array(buffer)
      mov rdx,%2        ;assigning length array
      syscall
%endmacro

%macro input 2
      mov rax,0         ;sys call to write
      mov rdi,0         ;assigning 1 to file descripter(stdout)
      mov rsi,%1        ;assigning address of array(buffer)
      mov rdx,%2        ;assigning length array
      syscall
%endmacro

section .data                         ;section for data
      asgn db "Write an X86/64 ALP to accept 5 64 bit hexadecimal numbers from user and store them in an array and dispaly"                              ;variable asgn of string data type
      asgn_len:equ $-asgn             ;length of asgn
      nm db "Mahima 3225 "          ;variable nm of string data tyoe
      nm_len:equ $-nm                 ;length of nm
      msg1 db "enter Number "         ;variable msg1 of string data type
      msg1_len:equ $-msg1             ;length of msg1
      msg2 db "entered number "       ;variable msg2 of string data type
      msg2_len:equ $-msg2             ;length of msg2
      newLine db 10                   ;variable newLine with ascii value 10 for newline
      err db "ERROR!"                 ;variable error of string data type
      err_len:equ $-err               ;length of error
       
section .bss                          ;section for uninitialised data
      num1 resb 17                    ;array num1 of 17 bytes
      temp resb  16                   ;array temp of 16 bytes
      rs resq  5                      ;array rs of 5 quad 
     
section .text                         ;section for actual code
      global _start                   ;program starts here
      _start:                    
        print asgn,asgn_len           ;displaying asgn string
        print newLine,1               ;printing newline
        print nm,nm_len               ;displaying nm string
        print newLine,1               ;printing newline
        mov rsi,rs                    ;pointing rsi to 0th index of rs
        mov rcx, 5                    ;intialising 5 to counter register
        fl:                           
           push rsi                   ;for retaining old value
           push rcx                   ;for retaining old value
           print msg1, msg1_len       ;displaying msg1 string
           input num1, 17             ;taking input
	   call ascii_hex             ;converting input to hexadecimal 64 bit
	   pop rcx     
	   pop rsi
	   mov [rsi], rbx             ;storing rbx value in rsi nth index
	   add rsi, 8                 ;pointing rsi to next index
	loop fl
	
         
        mov rsi, rs                   ;pointing rsi to 0th index of rs
        mov rcx, 5                    ;intialising 5 to counter register
        sl:
           mov rbx,[rsi]              ;storing rsi value in rbx
           push rsi                   ;for retaining old value
           push rcx                   ;for retaining old value
           print msg2, msg2_len       ;displaying msg2 string
           call display_64            ;converting hexadecimal 64 bit to input
           pop rcx
           pop rsi
           add rsi, 8                 ;pointing rsi to next index
        loop sl
        mov rax,60                    ;sys call for exit
        mov rdi,0
        syscall
er:
              print err,err_len       ;dispalying error string
              print newLine,1         ;printing newline
              mov rax,60              ;sys call for exit
              mov rdi,0
              syscall
              
ascii_hex:                            ;converting ascii to hex
              mov rcx,16              ;intialising 16 to counter register
              mov rsi,num1            ;pointning rsi to num1
              mov rbx,0               ;clearing rbx
  
              next1:
                 rol rbx,4            ;rotating left 4 bits of rbx
                 mov al, [rsi]        ;moving value in rsi to al register
                 cmp al,29h           ;comparing value in al with 29h
                 jbe er               ;if value is less than or equal then er will be called
                 cmp al,47h           ;comparing value in al with 47h
                 jge er               ;if value is greater than or equal then er will be called
                 cmp al,30h           ;comparing value in al with 30h
                 jge op               ;if value is greater than or equal then op will be called
                 cmp al, 40h          ;comparing value in al with 40h
                 je er                ;if value is equal then er will be called
                 op: 
                 cmp al,39h           ;comparing value in al with 39h
                 jbe minus30h         ;if value is less than or equal then minus30h will be called
                 sub al, 7h           ;subtracting 7h from al
                 minus30h:            
                     sub al, 30h      ;subtracting 30h from al
                 ADD bl,al            ;adding al to bl
                 inc rsi              ;pointing rsi to next index
              loop next1
              ret                     ;returning from procedure
              
display_64:                           ;displaying hex
              mov rcx,16              ;intialising 16 to counter register
              mov rsi,temp            ;pointning rsi to temp
              next:
                 rol rbx,4            ;rotating left 4 bits of rbx
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
              print temp,16           ;displaying temp
              print newLine,1         ;printing newline
              ret                     ;returning
       
        
