.data
    temperature:    .word 0   # initial temperature in Fahrenheit
    speed:          .word 0  # initial speed in mph
    fuel_level:     .word 0   # initial fuel level in percentage

    # strings for program output
    program_header:            .asciiz "----------------------------------------------------\n     MIPS Car Sensor System Simulation\n----------------------------------------------------\n\n"
    simulation_start:          .asciiz "Press Enter to Start the Simulation...\n[Simulation Started]\n\n"
    enter_initial_readings:    .asciiz "Please enter the initial sensor readings:\n"
    enter_updated_readings:    .asciiz "\nPlease enter updated sensor readings:\n"
    sensor_readings:           .asciiz "\nSensor Readings below:\n"
    temp_label:                .asciiz "\nTemperature reading: "
    speed_label:               .asciiz "\nSpeed reading: "
    fuel_label:                .asciiz "\nFuel level reading: "
    more_readings_prompt:      .asciiz "\nmore sensors reading wanted? enter 1 for yes and 0 for no: "

.text
    main:
        # print program header
        li $v0, 4
        la $a0, program_header
        syscall

        # start simulation
        li $v0, 4
        la $a0, simulation_start
        syscall

        # prompt for initial sensor readings
        li $v0, 4
        la $a0, enter_initial_readings
        syscall

        # read initial temperature
        li $v0, 4
        la $a0, prompt_temp
        syscall
        li $v0, 5
        syscall
        sw $v0, temperature

        # read initial speed
        li $v0, 4
        la $a0, prompt_speed
        syscall
        li $v0, 5
        syscall
        sw $v0, speed

        # read initial fuel level
        li $v0, 4
        la $a0, prompt_fuel
        syscall
        li $v0, 5
        syscall
        sw $v0, fuel_level

        # display initial sensor readings
        li $v0, 4
        la $a0, sensor_readings
        syscall

        # display temperature
        li $v0, 4
        la $a0, temp_label
        syscall
        lw $a0, temperature
        li $v0, 1
        syscall
        li $v0, 4
        la $a0, degree_symbol
        syscall

        # display speed
        li $v0, 4
        la $a0, speed_label
        syscall
        lw $a0, speed
        li $v0, 1
        syscall
        li $v0, 4
        la $a0, mph_symbol
        syscall

        # display fuel level
        li $v0, 4
        la $a0, fuel_label
        syscall
        lw $a0, fuel_level
        li $v0, 1
        syscall

        # process initial sensor readings
        jal process_readings

        # prompt for more sensor readings
        li $v0, 4
        la $a0, more_readings_prompt
        syscall

        # read user choice
        li $v0, 5
        syscall
        move $t0, $v0

        # check if the user wants more readings
        beq $t0, 1, update_readings
        j exit

    update_readings:
        # prompt for updated sensor readings
        li $v0, 4
        la $a0, enter_updated_readings
        syscall

        # read updated temperature
        li $v0, 4
        la $a0, prompt_temp
        syscall
        li $v0, 5
        syscall
        sw $v0, temperature

        # read updated speed
        li $v0, 4
        la $a0, prompt_speed
        syscall
        li $v0, 5
        syscall
        sw $v0, speed

        # read updated fuel level
        li $v0, 4
        la $a0, prompt_fuel
        syscall
        li $v0, 5
        syscall
        sw $v0, fuel_level

        # display updated sensor readings
        li $v0, 4
        la $a0, sensor_readings
        syscall

        # display temperature
        li $v0, 4
        la $a0, temp_label
        syscall
        lw $a0, temperature
        li $v0, 1
        syscall
        li $v0, 4
        la $a0, degree_symbol
        syscall

        # display speed
        li $v0, 4
        la $a0, speed_label
        syscall
        lw $a0, speed
        li $v0, 1
        syscall
        li $v0, 4
        la $a0, mph_symbol
        syscall

        # display fuel level
        li $v0, 4
        la $a0, fuel_label
        syscall
        lw $a0, fuel_level
        li $v0, 1
        syscall

        # process updated sensor readings
        jal process_readings

        # prompt for more sensor readings
        li $v0, 4
        la $a0, more_readings_prompt
        syscall

        # read user choice
        li $v0, 5
        syscall
        move $t0, $v0

        # check if the user wants more readings
        beq $t0, 1, update_readings
        j exit

    process_readings:
        # process temperature
        lw $t0, temperature
        li $t1, 34        # minimum temperature
        li $t2, 100       # maximum temperature
        blt $t0, $t1, temp_warn
        bgt $t0, $t2, temp_warn

        # process speed
        lw $t0, speed
        li $t1, 65        # maximum speed
        bgt $t0, $t1, speed_warn

        # process fuel level
        lw $t0, fuel_level
        li $t1, 2         # minimum fuel level
        blt $t0, $t1, fuel_warn

        j process_exit

    temp_warn:
        li $v0, 4
        la $a0, temp_warn_msg
        syscall
        j process_exit

    speed_warn:
        li $v0, 4
        la $a0, speed_warn_msg
        syscall
        j process_exit

    fuel_warn:
        li $v0, 4
        la $a0, fuel_warn_msg
        syscall

    process_exit:
        # display newline for separation
        li $v0, 4
        la $a0, newline
        syscall

        jr $ra  # return from subroutine

    exit:
        # program exit
        li $v0, 10
        syscall

    # data section
    .data
        newline:                    .asciiz "\n"
        temp_warn_msg:              .asciiz "\n[WARNING] The temperature exceeds expected range\n"
        speed_warn_msg:             .asciiz "\n[WARNING] The speed exceeds maximum limit\n"
        fuel_warn_msg:              .asciiz "\n[WARNING] The fuel level below expected level\n"
        prompt_temp:                .asciiz "Please Enter temperature (in °F): "
        prompt_speed:               .asciiz "Please Enter speed (in mph): "
        prompt_fuel:                .asciiz "Please Enter fuel level (%): "
        degree_symbol:              .asciiz "°F"
        mph_symbol:                 .asciiz " mph"
