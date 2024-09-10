.data
prompt_count:   .asciiz "Ingrese la cantidad de números a comparar (entre 3 y 5): "
prompt_number:  .asciiz "Ingrese un número: "
newline:        .asciiz "\n"
error_message:  .asciiz "Error: debe ingresar un número entre 3 y 5.\n"

.text
main:
    # Mostrar mensaje para ingresar cantidad de números
    li $v0, 4                 # Código de servicio 4 para imprimir una cadena
    la $a0, prompt_count       # Cargar dirección del mensaje en $a0
    syscall

    # Leer cantidad de números a comparar (debe estar entre 3 y 5)
    li $v0, 5                 # Código de servicio 5 para leer un entero
    syscall
    move $t0, $v0             # Guardamos la cantidad en $t0

    # Verificar que la cantidad esté entre 3 y 5
    li $t1, 3                 # Valor mínimo permitido
    li $t2, 5                 # Valor máximo permitido
    blt $t0, $t1, error       # Si es menor que 3, ir a error
    bgt $t0, $t2, error       # Si es mayor que 5, ir a error

    # Inicializamos el mayor número
    li $t3, -2147483648       # El menor valor posible para iniciar la comparación ($t3 será el mayor)

    # Ciclo para pedir los números
    li $t4, 0                 # Contador de números ingresados

input_loop:
    # Mostrar mensaje para ingresar un número
    li $v0, 4                 # Código de servicio 4 para imprimir una cadena
    la $a0, prompt_number      # Cargar dirección del mensaje en $a0
    syscall

    # Leer número ingresado
    li $v0, 5                 # Código de servicio 5 para leer un entero
    syscall
    move $t5, $v0             # Guardamos el número en $t5

    # Comparar si el número ingresado es mayor al actual mayor
    bgt $t5, $t3, update_max  # Si el número ingresado es mayor, actualizamos el mayor
    j continue_input          # Si no, continuamos con la siguiente entrada

update_max:
    move $t3, $t5             # Actualizamos el mayor con el número ingresado

continue_input:
    addi $t4, $t4, 1          # Incrementamos el contador
    bne $t4, $t0, input_loop  # Si no hemos ingresado suficientes números, repetir el ciclo

    # Imprimir el número mayor
    li $v0, 1                 # Código de servicio 1 para imprimir un entero
    move $a0, $t3             # Cargamos el mayor número en $a0
    syscall

    # Imprimir una nueva línea
    li $v0, 4                 # Código de servicio 4 para imprimir una cadena
    la $a0, newline           # Cargamos la dirección de la cadena "newline"
    syscall

    # Terminar el programa
    li $v0, 10                # Código de servicio 10 para salir del programa
    syscall

error:
    # Imprimir mensaje de error
    li $v0, 4                 # Código de servicio 4 para imprimir una cadena
    la $a0, error_message      # Cargar dirección del mensaje de error en $a0
    syscall

    # Terminar el programa
    li $v0, 10                # Código de servicio 10 para salir del programa
    syscall
