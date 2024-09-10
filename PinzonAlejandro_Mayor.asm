.data
prompt_count:   .asciiz "Ingrese la cantidad de n�meros a comparar (entre 3 y 5): "
prompt_number:  .asciiz "Ingrese un n�mero: "
newline:        .asciiz "\n"
error_message:  .asciiz "Error: debe ingresar un n�mero entre 3 y 5.\n"

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

    # Inicializamos el mayor n�mero
    li $t3, -2147483648       # El menor valor posible para iniciar la comparaci�n ($t3 ser� el mayor)

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

    # Comparar si el n�mero ingresado es mayor al actual mayor
    bgt $t5, $t3, update_max  # Si el n�mero ingresado es mayor, actualizamos el mayor
    j continue_input          # Si no, continuamos con la siguiente entrada

update_max:
    move $t3, $t5             # Actualizamos el mayor con el n�mero ingresado

continue_input:
    addi $t4, $t4, 1          # Incrementamos el contador
    bne $t4, $t0, input_loop  # Si no hemos ingresado suficientes n�meros, repetir el ciclo

    # Imprimir el n�mero mayor
    li $v0, 1                 # C�digo de servicio 1 para imprimir un entero
    move $a0, $t3             # Cargamos el mayor n�mero en $a0
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
