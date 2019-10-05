; Maracine Nicoleta-Alexandra, 322CA
extern puts
extern printf
extern strlen

%define BAD_ARG_EXIT_CODE -1

section .data
filename: db "./input0.dat", 0
inputlen: dd 2263

fmtstr:            db "Key: %d",0xa, 0
usage:             db "Usage: %s <task-no> (task-no can be 1,2,3,4,5,6)", 10, 0
error_no_file:     db "Error: No input file %s", 10, 0
error_cannot_read: db "Error: Cannot read input file %s", 10, 0

section .text
global main
        
xor_strings:
	; TODO TASK 1
        push ebp
        mov ebp, esp
        
        mov eax, [ebp + 8]
        mov ebx, [ebp + 12]
xor_again:  
        xor edx, edx
        xor ecx, ecx 
        
        ; Facem XOR byte cu byte pana se termina sirurile     
        mov dl, byte[eax]
        mov cl, byte[ebx]
        xor dl, cl
        mov byte[eax], dl
        inc eax
        inc ebx
        cmp byte[eax], 0x00
        jne xor_again
   
        leave
	ret

rolling_xor:
        ; TODO TASK 2
        push ebp
        mov ebp, esp
        
        mov eax, [ebp + 8]
       
        ; Mai intai aflam lungimea sirurului 
find_len:                    
        inc ebx
        cmp byte[eax + ebx - 1], 0x00
        jne find_len
        
        ; Ne mutam la sfarsitul sirului si salvam si lungimea in ecx
        xor ecx, ecx
        mov ecx, ebx
        sub ecx, 2
        add eax, ebx   
        sub eax, 2  
       
        xor ebx, ebx
        xor edx, edx  
               
        ; Facem operatia inversa criptarii folosite in enunt
        ; Plecam de la ultimul byte si repetam pana la primul
rolling_xor_again:
        mov bl, byte[eax]
        mov dl, byte[eax - 1]
        xor bl, dl
        mov byte[eax], bl
        dec eax
        dec ecx
        cmp ecx, 0
        jne rolling_xor_again

exit2:       
        leave
	ret

xor_hex_strings:

        push ebp
        mov ebp, esp
        
        mov eax, [ebp + 8]
        mov ebx, [ebp + 12]

        ; Salvam pe stiva adresele de inceput ale stringurilor     
        push ebx
        push eax
        mov esi, eax
        
        ; Pentru fiecare byte din eax verificam daca este numar sau litera
        ; Daca este numar (adica mai mic sau egal cu 57) scadem 48 (adica 0)
        ; Daca este litera scadem 97 (a in ascii) si adunam 10 (A in hexa)
change_eax:
        mov dl, byte[eax]
        cmp dl, 57
        jle to_do_number
        sub dl, 87
        jmp find_another_for_eax
        
to_do_number:
        sub dl, 48
        
        ; Facem operatiile de mai sus si pentru urmatorul byte al lui eax
find_another_for_eax:
        mov cl, byte[eax + 1]
        cmp cl, 57
        jle to_do_number2
        sub cl, 87
        jmp modify_eax
        
to_do_number2:
        sub cl, 48
        
        ; Dupa ce avem cele doua valori gasite, pe prima o inmultim cu 16
        ; (shl 4) si o adunam pe cea de-a doua la ea 
        ; Salvam in registrul esi rezultatele
modify_eax:
        shl dl, 4
        add dl, cl
        mov byte[esi], dl
        add esi, 1
        add eax, 2
        cmp byte[eax], 0x00
        jne change_eax
        ;Facem aceasta operatie pana terminam eax si la sfarsit punem '\0' in esi
        mov byte[esi], 0x00
        mov esi, ebx
        
        ; Operatiile de mai sus se fac analog si pentru registrul ebx
change_ebx:
        mov dl, byte[ebx]
        cmp dl, 57
        jle to_do_number3
        sub dl, 87
        jmp find_another_for_ebx
        
to_do_number3:
        sub dl, 48
        
find_another_for_ebx:
        mov cl, byte[ebx + 1]
        cmp cl, 57
        jle to_do_number4
        sub cl, 87
        jmp modify_ebx
        
to_do_number4:
        sub cl, 48
        
modify_ebx:
        shl dl, 4
        add dl, cl
        mov byte[esi], dl
        add esi, 1
        add ebx, 2
        cmp byte[ebx], 0x00
        jne change_ebx
        mov byte[esi], 0x00
        
        ; Dupa ce terminam cele 2 transformari apelam functia de xor de la taskul 1
        ; pe cele doua adrese salvate la inceput pe stiva
        call xor_strings
        pop eax
        
        leave
        ret
        
base32decode:
	; TODO TASK 4
	ret

bruteforce_singlebyte_xor:
	; TODO TASK 5
        push ebp
        mov ebp, esp
        
        mov ecx, [ebp + 8]
        xor eax, eax
        ; Incepem sa verificam facand xor de la 1 pe sir
        mov al, 1
        xor ebx, ebx
        xor edx, edx
        
        ; Verificam pentru fiecare byte din ecx daca facand xor daca 
        ; am putea obtine cuvantul dorit
xor_bytes_from_ecx:
        mov dl, byte[ecx + ebx]
        xor dl, al
        cmp dl, 'f'
        jne to_inc5
        mov dl, byte[ecx + ebx + 1]
        xor dl, al
        cmp dl, 'o'
        jne to_inc5
        mov dl, byte[ecx + ebx + 2]
        xor dl, al
        cmp dl, 'r'
        jne to_inc5
        mov dl, byte[ecx + ebx + 3]
        xor dl, al
        cmp dl, 'c'
        jne to_inc5
        mov dl, byte[ecx + ebx + 4]
        xor dl, al
        cmp dl, 'e'
        jne to_inc5
        jmp modify_ecx
        
        ; Incrementam ebx de fiecare data cand nu avem potrivire
        ; Facem aceasta operatie pana ajungem cu 4 inainte de 
        ; sfarsitul stringului ca sa nu iesim din din string daca
        ; exista potrivire
to_inc5:
        inc ebx
        cmp byte[ecx + ebx + 4], 0x00
        jne xor_bytes_from_ecx
        
        ; Daca nu am gasit potrivire pentru cheia pe care am folosit-o
        ; crestem cheia cu 1 si incercam din nou
change_key:
        inc al
        xor ebx, ebx    
        jmp xor_bytes_from_ecx
        
        ; Daca am gasit force ajungem aici unde modificam ecx prin xor pe 
        ; string cu cheia gasita
modify_ecx:
        xor byte[ecx], al
        inc ecx
        cmp byte[ecx], 0x00
        jne modify_ecx
      
exit5:       
        leave
	ret

decode_vigenere:
	; TODO TASK 6
        push ebp
        mov ebp, esp
        
        mov eax, [ebp + 8]
        mov ebx, [ebp + 12]
        xor esi, esi
        
        ; Daca este litera shiftam cu numarul de pozitii date de cheie
        ; Scadem din cl pe 'a' pentru a gasi numarul de pozitii cu care trebuie 
        ; sa shiftam
        ; Luam fiecare byte din string si verificam mai intai daca este litera
        ; Daca nu este incrementam doar stringul
        ; Daca este litera scadem numarul de pozitii care fusesera adaugate
        ; la criptare
        ; In caz ca am iesit din intervalul literelor adunam 26 pentru a avea
        ; litera
decode_again:
        xor edx, edx
        xor ecx, ecx
        mov dl, byte[eax]
        mov cl, byte[ebx + esi]
        sub cl, 'a'
        cmp dl, 'a'
        jl to_inc_string_only
        cmp dl, 'z'
        jg to_inc_string_only
        sub dl, cl
        cmp dl, 'a'
        jge modify_string
        add dl, 26
        
        ; Modificam si in stringul initial
modify_string:
        mov byte[eax], dl  
        jmp to_inc_both 
        
to_inc_string_only:
        inc eax
        jmp decode_again  
        
        ; Dupa fiecare decriptare crestem stringul si cheia
to_inc_both:
        inc eax
        inc esi
        cmp byte[eax], 0x00
        je end6
        cmp byte[ebx + esi], 0x00
        je start_key_again
        jmp decode_again
        
        ; Folosim acest label deoarece cheia fiind mai mica decat stringul
        ; va trebui de mai multe ori sa o luam de la capat cu el
start_key_again:
        xor esi, esi
        jmp decode_again

end6:     
        leave
	ret

main:
    mov ebp, esp; for correct debugging
	push ebp
	mov ebp, esp
	sub esp, 2300

	; test argc
	mov eax, [ebp + 8]
	cmp eax, 2
	jne exit_bad_arg

	; get task no
	mov ebx, [ebp + 12]
	mov eax, [ebx + 4]
	xor ebx, ebx
	mov bl, [eax]
	sub ebx, '0'
	push ebx

	; verify if task no is in range
	cmp ebx, 1
	jb exit_bad_arg
	cmp ebx, 6
	ja exit_bad_arg

	; create the filename
	lea ecx, [filename + 7]
	add bl, '0'
	mov byte [ecx], bl

	; fd = open("./input{i}.dat", O_RDONLY):
	mov eax, 5
	mov ebx, filename
	xor ecx, ecx
	xor edx, edx
	int 0x80
	cmp eax, 0
	jl exit_no_input

	; read(fd, ebp - 2300, inputlen):
	mov ebx, eax
	mov eax, 3
	lea ecx, [ebp-2300]
	mov edx, [inputlen]
	int 0x80
	cmp eax, 0
	jl exit_cannot_read

	; close(fd):
	mov eax, 6
	int 0x80

	; all input{i}.dat contents are now in ecx (address on stack)
	pop eax
	cmp eax, 1
	je task1
	cmp eax, 2
	je task2
	cmp eax, 3
	je task3
	cmp eax, 4
	je task4
	cmp eax, 5
	je task5
	cmp eax, 6
	je task6
	jmp task_done

task1:
	; TASK 1: Simple XOR between two byte streams

	; TODO TASK 1: find the address for the string and the key
	; TODO TASK 1: call the xor_strings function

        xor eax, eax
        xor ebx, ebx
        xor edx, edx

        mov eax, ecx
        mov ebx, ecx
        
        ; Cautam adresa de la care incepe cheia
to_inc_task1:       
        inc ecx
        inc edx
        cmp byte[ecx], 0x00
        jne to_inc_task1
        inc edx
        
        add ebx, edx
        
        push ebx
        push eax
        call xor_strings
        
        pop ecx
        add esp, 4
        
	push ecx
	call puts                   ;print resulting string
	add esp, 4

	jmp task_done

task2:
	; TASK 2: Rolling XOR

	; TODO TASK 2: call the rolling_xor function
        
        
        push ecx
        call rolling_xor
        
        pop ecx
        
        push ecx
        call puts
        add esp, 4

        jmp task_done

task3:
	; TASK 3: XORing strings represented as hex strings

	; TODO TASK 1: find the addresses of both strings
	; TODO TASK 1: call the xor_hex_strings function
        
	xor eax, eax
        xor ebx, ebx
        xor edx, edx

        mov eax, ecx
        mov ebx, ecx
        
        ; Cautam adresa de la care incepe cheia
to_inc_task3:       
        inc ecx
        inc edx
        cmp byte[ecx], 0x00
        jne to_inc_task3
        inc edx
        
        add ebx, edx
        
        push ebx
        push eax
        call xor_hex_strings
        
        pop ecx
        add esp, 4
        
	push ecx
	call puts                   ;print resulting string
	add esp, 4

	jmp task_done

task4:
	; TASK 4: decoding a base32-encoded string

	; TODO TASK 4: call the base32decode function
	
	push ecx
	call puts                    ;print resulting string
	pop ecx
	
	jmp task_done

task5:
	; TASK 5: Find the single-byte key used in a XOR encoding

	; TODO TASK 5: call the bruteforce_singlebyte_xor function
        
        push ecx
        call bruteforce_singlebyte_xor
        pop ecx

        ; push eax si pop eax pentru a nu fi stricat de functia puts     
        push eax
	
        push ecx                    ;print resulting string
        call puts
        pop ecx

        pop eax

        push eax                    ;eax = key value
        push fmtstr
        call printf                 ;print key value
        add esp, 8

        jmp task_done

task6:
	; TASK 6: decode Vignere cipher

	; TODO TASK 6: find the addresses for the input string and key
	; TODO TASK 6: call the decode_vigenere function

	push ecx
	call strlen
	pop ecx

	add eax, ecx
	inc eax

	push eax
	push ecx                   ;ecx = address of input string 
	call decode_vigenere
	pop ecx
	add esp, 4

	push ecx
	call puts
	add esp, 4

task_done:
	xor eax, eax
	jmp exit

exit_bad_arg:
	mov ebx, [ebp + 12]
	mov ecx , [ebx]
	push ecx
	push usage
	call printf
	add esp, 8
	jmp exit

exit_no_input:
	push filename
	push error_no_file
	call printf
	add esp, 8
	jmp exit

exit_cannot_read:
	push filename
	push error_cannot_read
	call printf
	add esp, 8
	jmp exit

exit:
	mov esp, ebp
	pop ebp
	ret
