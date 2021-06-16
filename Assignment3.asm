;Write a switch case driven X86/64 ALP to perform 64-bit hexadecimal arithmetic operations (+,-,*, /) using suitable macros. Define procedure for each operation.
%macro print 2
      mov rax,1         ;sys call to read
      mov rdi,1         ;assigning 1 to file descripter(stdout)
      mov rsi,%1        ;assigning address of array(buffer)
      mov rdx,%2        ;assigning length array
      syscall
%endmacro

%macro input 2
      mov rax,0         ;sys call to write
      mov rdi,0         ;assigning 0 to file descripter(stdin)
      mov rsi,%1        ;assigning address of array(buffer)
      mov rdx,%2        ;assigning length array
      syscall
%endmacro

section .data                         ;section for data
      asgn db "Write an X86/64 ALP to accept 2 64 bit hexadecimal numbers from user and do arithmetic operations and  display"                       ;variable asgn of string data type
      asgn_len:equ $-asgn             ;length of asgn
      nm db "mahima 3225"          ;variable nm of string data tyoe
      nm_len:equ $-nm                 ;length of nm
      msg1 db "Enter Number "         ;variable msg1 of string data type
      msg1_len:equ $-msg1             ;length of msg1
      msg2 db "Entered Number "       ;variable msg2 of string data type
      msg2_len:equ $-msg2             ;length of msg2
      
      menu db "1 Addition",10                   ;menu buffer consisting of 5 elements
           db "2 Subtraction",10
           db "3 Multiplication",10
           db "4 Division",10
           db "5 Exit",10
      menu_len:equ $-menu                       ;length of menu
      
      add_wc db "Addition without carry "       ;variable add_wc of string data type
      add_wc_len:equ $-add_wc                   ;length of add_wc
      add_c db "Addition with carry "           ;variable add_c of string data type
      add_c_len:equ $-add_c                     ;length of add_c
      sub_wb db "Subtraction without borrow "   ;variable sub_wb of string data type
      sub_wb_len:equ $-sub_wb                   ;length of sub_wb
      sub_b db "Subtraction with borrow "       ;variable sub_b of string data type
      sub_b_len:equ $-sub_b                     ;length of sub_b
      mult db "Multiplication "                 ;variable mult of string data type
      mult_len:equ $-mult                       ;length of mult
      quot db "Quotient "                       ;variable quot of string data type
      quot_len:equ $-quot                       ;length of quot
      remd db "Remainder "                      ;variable remd of string data type
      remd_len:equ $-remd                       ;length of remd
      
      newLine db 10                   ;variable newLine with ascii value 10 for newline
      err db "ERROR!"                 ;variable error of string data type
      err_len:equ $-err               ;length of error
       
section .bss                          ;section for uninitialised data

      choice resb 2                   ;buffer choice of 2 bytes
      num1 resb 16                    ;buffer num1 of 16 bytes
      num2 resb 16                    ;buffer num2 of 16 bytes
      temp resb 17                    ;buffer temp of 17 bytes
      temp2 resb 9                    ;buffer temp2 of 9 bytes
      num3 resb 8                     ;buffer num3 of 8 bytes
      
      
section .text                         ;section for actual code
      global _start                   ;program starts here
      _start:                    
        print asgn,asgn_len           ;displaying asgn string
        print newLine,1               ;printing newline
        print nm,nm_len               ;displaying nm string
        print newLine,1               ;printing newline
	
	while_1:                      ;loop for menu
	   print menu,menu_len        ;printing menu message
	   input choice,2             ;taking input from user as choice
	   
	   case_1:                    
	   cmp byte[choice],'1'       ;comparing choice with 31h or '1'
	   jne case_2                 ;if not equal jump to case2
	   call add_p                 ;call for add_p procedure
	   jmp while_1                ;jump to label while_1
	   
	   case_2:
	   cmp byte[choice],'2'       ;comparing choice with 32h or '2'
	   jne case_3                 ;if not equal jump to case3
	   call sub_p                 ;call for sub_p procedure
	   jmp while_1                ;jump to label while_1
	   
	   case_3:
	   cmp byte[choice],'3'       ;comparing choice with 33h or '3'
	   jne case_4                 ;if not equal jump to case4
	   call mul_p                 ;call for mul_p procedure
	   jmp while_1                ;jump to label while_1
	   
	   case_4:
	   cmp byte[choice],'4'       ;comparing choice with 34h or '4'
	   jne case_5                 ;if not equal jump to case5
	   call div_p                 ;call for div_p procedure
	   jmp while_1                ;jump to label while_1
	   
	   case_5:
	   cmp byte[choice],'5'       ;comparing choice with 35h or '5'
	   je exit                    ;if equal jump to exit
	   jmp while_1                ;jump to label while_1
	   
	exit:
           mov rax,60                    ;sys call for exit
           mov rdi,0
           syscall
        
er:
              print err,err_len       ;dispalying error string
              print newLine,1         ;printing newline
              mov rax,60              ;sys call for exit
              mov rdi,0
              syscall
                     
        
ascii_hex:                             ;  converting ascii to hex
              mov rsi,temp               ;pointning rsi to num1
              mov rcx,16                 ;intialising 16 to counter register
              mov rbx,0                  ;clearing rbx
	      
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
       
ascii_hex32:                          ;converting ascii to hex
              mov rcx,8               ;intialising 8 to counter register
              mov ebx,0               ;clearing ebx
  
              next2:
                 rol ebx,4            ;rotating left 4 bits of ebx
                 mov al,[rsi]         ;moving value in rsi to al register
                 cmp al,29h           ;comparing value in al with 29h
                 jbe er               ;if value is less than or equal then er will be called
                 cmp al,47h           ;comparing value in al with 47h
                 jge er               ;if value is greater than or equal then er will be called
                 cmp al,30h           ;comparing value in al with 30h
                 jge op1              ;if value is greater than or equal then op will be called
                 cmp al, 40h          ;comparing value in al with 40h
                 je er                ;if value is equal then er will be called
                 op1: 
                 cmp al,39h           ;comparing value in al with 39h
                 jbe minus30h1        ;if value is less than or equal then minus30h will be called
                 sub al, 7h           ;subtracting 7h from al
                 minus30h1:            
                     sub al, 30h      ;subtracting 30h from al
                 ADD bl,al            ;adding al to bl
                 inc rsi              ;pointing rsi to next index
              loop next2
              ret                     ;returning from procedure
              
add_p:          
              print msg1, msg1_len       ;displaying msg1 string
              input temp, 17             ;taking input
              call ascii_hex             ;converting input to hexadecimal 64 bit
	      mov [num1],rbx             ;moving value in rbx to num1
	      print msg1, msg1_len       ;displaying msg1 string
              input temp, 17             ;taking input
              call ascii_hex             ;converting input to hexadecimal 64 bit
              mov [num2],rbx             ;moving value in rbx to num2
	      
              mov rbx,[num1]             ;moving value in num1 to rbx
              add rbx,[num2]             ;adding value in rbx and num2
              print add_wc,add_wc_len    ;printing add_wc message
              call display_64            ;displaying result
              
              mov rbx,[num1]             ;moving value in num1 to rbx
              adc rbx,[num2]             ;adding value in rbx and num2
	      print add_c,add_c_len      ;printing add_c message
              call display_64            ;displaying result
              ret
             
sub_p:          

              print msg1, msg1_len       ;displaying msg1 string
              input temp, 17             ;taking input
              call ascii_hex             ;converting input to hexadecimal 64 bit
	      mov [num1],rbx             ;moving value in rbx to num1
	      print msg1, msg1_len       ;displaying msg1 string
              input temp, 17             ;taking input
              call ascii_hex             ;converting input to hexadecimal 64 bit
              mov [num2],rbx             ;moving value in rbx to num2
	      
              mov rbx,[num1]             ;moving value in num1 to rbx
              sub rbx,[num2]             ;subtracting value in num2 from rbx
              print sub_wb,sub_wb_len    ;printing sub_wc message
              call display_64            ;displaying result
              
              mov rbx,[num1]             ;moving value in num1 to rbx
              sbb rbx,[num2]             ;subtracting value in num2 from rbx
	      print sub_b,sub_b_len      ;printing sub_wc message
              call display_64            ;displaying result
              ret
          
mul_p:          
              print msg1, msg1_len       ;displaying msg1 string
              input temp, 17             ;taking input
              call ascii_hex             ;converting input to hexadecimal 64 bit
	      mov [num1],rbx             ;moving value in rbx to num1
	      print msg1, msg1_len       ;displaying msg1 string
              input temp, 17             ;taking input
              call ascii_hex             ;converting input to hexadecimal 64 bit
              mov [num2],rbx             ;moving value in rbx to num2
	      
              mov rax,[num1]             ;moving value in num1 to rax
              mov rbx,[num2]             ;moving value in num2 to rbx
              mul rbx                    ;multiplying value in rax with rbx
              mov rbx,rdx                ;moving value in rbx to rbx
              push rax
              print mult,mult_len        ;printing mult message
              cmp rbx,0h                 ;comparing value in rbx with 0
              je skip                    ;if equal to 0 jump to skip
              call display_64            ;displaying rdx value
              skip:
              
              pop rax
              mov rbx,rax                ;moving the vakue in rax to rbx
              call display_64            ;displaying rax value
              ret
              
div_p:
         
	print msg1, msg1_len             ;displaying msg1 string
	input temp, 17                   ;taking input
	print msg1, msg1_len             ;displaying msg1 string
	input temp2, 9                   ;taking input
	call ascii_hex32		; converting divisor to hexadecimal
	mov [num3], ebx		        ; Storing rbx in num3 buffer
	
	mov rdi, temp2			; Destination is temp2
	mov rsi, temp			; Source is num1
	cld				; Clearing direction flag and rsi and rdi will be incremented
	mov rcx, 8			; cx=8
	rep movsb			; mov bytes from source to destination until cx != 0
	
	mov rsi, temp2			; Destination is temp2
	call ascii_hex32		; convert to hexadecimal
	mov edx, ebx			; Mov ebx register to edx
		
	mov rdi, temp2			; Destination is temp2
	mov rsi, temp+8		        ; Source is num1
	cld				; clearing direction flag and rsi and rdi will be decremented
	mov rcx, 8			; Last 8 bytes
	rep movsb			; Move bytes from source to destination until cx != 0
	
	mov rsi, temp2			; Moving temp2 to rdi
	push rdx
	call ascii_hex32		; converting to hexadecimal
	pop rdx
	mov eax, ebx			; Move ebx to eax
		
	mov ebx, [num3]		         ; Move divisor-num3 to ebx
	div ebx			         ; DIV instruction to divide dividend(edx eax) by divisor
	                                 ; Quotient is stored in EAX and remainder is stored in EDX
	
	push rax
	push rdx
	print quot, quot_len	         ; Printing Quotient message
	pop rdx
	pop rax
	
	mov ebx, eax			  ; Moving eax to ebx for procedure
	push rdx
	call display_64		          ; printing Quotient
	pop rdx
	
	push rdx
	print remd, remd_len	         ; Printing remainder message
	pop rdx
	
	mov ebx, edx			 ; Moving edx register to ebx
	call display_64		         ;  displaying remainder
	ret
          
      
