.data
prompt_count:   .asciiz "Ingrese la cantidad de n�meros a comparar (entre 3 y 5): "
prompt_number:  .asciiz "Ingrese un n�mero: "
newline:        .asciiz "\n"
error_message:  .asciiz "Error: debe ingresar un n�mero entre 3 y 5.\n"
msg_min:        .asciiz "El n�mero menor es: "

.text
main:
    # Mostrar mensaje para ingresar cantidad de n�meros
    li $v0, 4                 # C�digo de servicio 4 para imprimir una cadena
    la $a0, prompt_count       # Cargar direcci�n del mensaje en $a0
    syscall

    # Leer cantidad de n�meros a comparar (debe estar entre 3 y 5)
    li $v0, 5                 # C�digo de servicio 5 para leer un entero
    syscall
    move $t0, $v0             # Guardamos la cantidad en $t0

    # Verificar que la cantidad est� entre 3 y 5
    li $t1, 3                 # Valor m�nimo permitido
    li $t2, 5                 # Valor m�ximo permitido
    blt $t0, $t1, error       # Si es menor que 3, ir a error
    bgt $t0, $t2, error       # Si es mayor que 5, ir a error

    # Inicializamos el menor n�mero
    li $t6, 2147483647        # El mayor valor posible para iniciar la comparaci�n de menor ($t6 ser� el menor)

    # Ciclo para pedir los n�meros
    li $t4, 0                 # Contador de n�meros ingresados

input_loop:
    # Mostrar mensaje para ingresar un n�mero
    li $v0, 4                 # C�digo de servicio 4 para imprimir una cadena
    la $a0, prompt_number      # Cargar direcci�n del mensaje en $a0
    syscall

    # Leer n�mero ingresado
    li $v0, 5                 # C�digo de servicio 5 para leer un entero
    syscall
    move $t5, $v0             # Guardamos el n�mero en $t5

    # Comparar si el n�mero ingresado es menor al actual menor
    blt $t5, $t6, update_min  # Si el n�mero ingresado es menor, actualizamos el menor
    j continue_input          # Continuar con la siguiente entrada

update_min:
    move $t6, $t5             # Actualizamos el menor con el n�mero ingresado

continue_input:
    addi $t4, $t4, 1          # Incrementamos el contador
    bne $t4, $t0, input_loop  # Si no hemos ingresado suficientes n�meros, repetir el ciclo

    # Imprimir el n�mero menor
    li $v0, 4                 # C�digo de servicio 4 para imprimir una cadena
    la $a0, msg_min           # Cargar direcci�n del mensaje del menor
    syscall
    li $v0, 1                 # C�digo de servicio 1 para imprimir un entero
    move $a0, $t6             # Cargamos el menor n�mero en $a0
    syscall

    # Imprimir una nueva l�nea
    li $v0, 4                 # C�digo de servicio 4 para imprimir una cadena
    la $a0, newline           # Cargamos la direcci�n de la cadena "newline"
    syscall

    # Terminar el programa
    li $v0, 10                # C�digo de servicio 10 para salir del programa
    syscall

error:
    # Imprimir mensaje de error
    li $v0, 4                 # C�digo de servicio 4 para imprimir una cadena
    la $a0, error_message      # Cargar direcci�n del mensaje de error en $a0
    syscall

    # Terminar el programa
    li $v0, 10                # C�digo de servicio 10 para salir del programa
    syscall
