.data
fib_msg: .asciiz "Serie de Fibonacci:\n"      # Mensaje inicial
prompt_msg: .asciiz "Ingrese el n�mero de t�rminos: "  # Mensaje para solicitar n�mero de t�rminos
result_msg: .asciiz "Resultado: "               # Mensaje para los resultados
newline: .asciiz "\n"                           # Salto de l�nea

.text

main:
    # Imprimir el mensaje de la serie de Fibonacci
    li $v0, 4
    la $a0, fib_msg
    syscall

    # Solicitar el n�mero de t�rminos al usuario
    li $v0, 4
    la $a0, prompt_msg
    syscall

    li $v0, 5            # C�digo de servicio para leer un entero
    syscall
    move $t4, $v0        # Guardar el n�mero de t�rminos en $t4

    # Inicializar los primeros dos t�rminos de la serie
    li $t0, 0   # F(0)
    li $t1, 1   # F(1)

    # Inicializar la suma de los t�rminos
    li $t5, 0   # $t5 es la suma acumulada
    add $t5, $t5, $t0
    add $t5, $t5, $t1

    # Imprimir los primeros dos t�rminos si el n�mero de t�rminos es >= 1
    bge $t4, 1, print_first_term
    li $v0, 10   # Salir del programa si no hay t�rminos para mostrar
    syscall

print_first_term:
    li $v0, 1
    move $a0, $t0
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    # Si hay m�s de un t�rmino, imprimir el siguiente t�rmino
    bge $t4, 2, print_second_term
    li $v0, 10   # Salir del programa si solo se requiere imprimir el primer t�rmino
    syscall

print_second_term:
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    # Calcular y mostrar los t�rminos siguientes de la serie
    move $t3, $t4       # Contador de t�rminos restantes (ya hemos mostrado 2 t�rminos)
    subi $t3, $t3, 2    # Inicializar con el n�mero de t�rminos restantes despu�s de los primeros 2

calculate_fibonacci:
    # Calcular el siguiente t�rmino de Fibonacci: F(n) = F(n-1) + F(n-2)
    addu $t2, $t0, $t1  # Utilizar addu en lugar de add para evitar desbordamientos

    # Imprimir el t�rmino calculado
    li $v0, 1
    move $a0, $t2
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    # Actualizar la suma acumulada
    add $t5, $t5, $t2

    # Actualizar los valores para la pr�xima iteraci�n
    move $t0, $t1
    move $t1, $t2

    # Decrementar el contador de t�rminos y verificar si hemos terminado
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
