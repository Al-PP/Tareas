.data
fib_msg: .asciiz "Serie de Fibonacci:\n"      # Mensaje inicial
prompt_msg: .asciiz "Ingrese el número de términos: "  # Mensaje para solicitar número de términos
result_msg: .asciiz "Resultado: "               # Mensaje para los resultados
newline: .asciiz "\n"                           # Salto de línea

.text

main:
    # Imprimir el mensaje de la serie de Fibonacci
    li $v0, 4
    la $a0, fib_msg
    syscall

    # Solicitar el número de términos al usuario
    li $v0, 4
    la $a0, prompt_msg
    syscall

    li $v0, 5            # Código de servicio para leer un entero
    syscall
    move $t4, $v0        # Guardar el número de términos en $t4

    # Inicializar los primeros dos términos de la serie
    li $t0, 0   # F(0)
    li $t1, 1   # F(1)

    # Inicializar la suma de los términos
    li $t5, 0   # $t5 es la suma acumulada
    add $t5, $t5, $t0
    add $t5, $t5, $t1

    # Imprimir los primeros dos términos si el número de términos es >= 1
    bge $t4, 1, print_first_term
    li $v0, 10   # Salir del programa si no hay términos para mostrar
    syscall

print_first_term:
    li $v0, 1
    move $a0, $t0
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    # Si hay más de un término, imprimir el siguiente término
    bge $t4, 2, print_second_term
    li $v0, 10   # Salir del programa si solo se requiere imprimir el primer término
    syscall

print_second_term:
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    # Calcular y mostrar los términos siguientes de la serie
    move $t3, $t4       # Contador de términos restantes (ya hemos mostrado 2 términos)
    subi $t3, $t3, 2    # Inicializar con el número de términos restantes después de los primeros 2

calculate_fibonacci:
    # Calcular el siguiente término de Fibonacci: F(n) = F(n-1) + F(n-2)
    addu $t2, $t0, $t1  # Utilizar addu en lugar de add para evitar desbordamientos

    # Imprimir el término calculado
    li $v0, 1
    move $a0, $t2
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    # Actualizar la suma acumulada
    add $t5, $t5, $t2

    # Actualizar los valores para la próxima iteración
    move $t0, $t1
    move $t1, $t2

    # Decrementar el contador de términos y verificar si hemos terminado
    subi $t3, $t3, 1
    bnez $t3, calculate_fibonacci

    # Imprimir el resultado total
    li $v0, 4
    la $a0, result_msg
    syscall

    li $v0, 1
    move $a0, $t5
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    # Salir del programa
    li $v0, 10
    syscall
