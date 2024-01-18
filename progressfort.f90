!===============================================================================
! PROGRESSFORT
!===============================================================================
! AUTOR: Leandro Seabra
! DESCRIÇÃO:
!   O módulo progressfort é uma ferramenta de monitoramento de progresso em
!   aplicações Fortran. Ele fornece funcionalidades para medir e exibir o
!   progresso de iterações, juntamente com estimativas de tempo restante.
!   As subrotinas inclusas permitem iniciar um temporizador, monitorar o progresso 
!   e encerrar o temporizador.
!
! UTILIZAÇÃO:
!   Para usar o progressfort, inclua este módulo em seu projeto Fortran e
!   chame as subrotinas start_timer, monitor_progress e end_timer conforme
!   necessário para rastrear o progresso e o tempo de execução de suas
!   iterações ou tarefas.
!
! CARACTERÍSTICAS:
!   - Medição de tempo de CPU e sistema.
!   - Barra de progresso colorida para visualização em tempo real.
!   - Cálculo de tempo médio por iteração e estimativa de tempo restante.
!
! LICENÇA:
!   Este projeto está sob a Licença Apache 2.0. Consulte o arquivo LICENSE
!   para mais detalhes.
!
! NOTA:
!   Este módulo utiliza códigos de cores ANSI e é otimizado para terminais
!   que suportam esses códigos.
!
!===============================================================================
! ATENÇÃO AOS COLABORADORES:
!   Este prólogo contém informações importantes sobre este módulo. Por favor,
!   não remova ou modifique este prólogo ao fazer alterações no código.
!===============================================================================

module progressfort
    implicit none

    real :: temp_ini  ! marcador de tempo inicial
    real, allocatable :: vetor_tempo(:)  ! vetor armazena o tempo de cada iteração
    integer :: total_iteracoes  ! numero total de iterações
    character(len=1), parameter :: bloco_cheio = '|', bloco_vazio = '-'  ! Caracteres para a barra de progresso
    integer, parameter :: largura_barra = 80  ! largura da barra de progresso

    integer :: temp_ini_sistema, tempo_fim_sistema
    integer :: rate_system_clock, max_system_clock      ! ticks por segundo

! Códigos de cores ANSI
    character(len=*), parameter :: verde_claro = char(27)//'[92m'
    character(len=*), parameter :: verde_escuro = char(27)//'[32m'
    character(len=*), parameter :: azul = char(27)//'[94m'
    character(len=*), parameter :: reset_cor = char(27)//'[0m'


contains

subroutine start_timer(n_iters)

    integer, intent(in) :: n_iters  !numero de iterações

    if (allocated(vetor_tempo)) then
        deallocate(vetor_tempo)
    endif
    
    allocate(vetor_tempo(n_iters))

    total_iteracoes = n_iters

    call cpu_time(temp_ini)  ! inicia contagem do tempo cpu
    call system_clock(temp_ini_sistema, rate_system_clock, max_system_clock) ! inicia contagem do tempo sys

end subroutine start_timer

subroutine monitor_progress(iteracao_atual)

    integer, intent(in) :: iteracao_atual  ! iteração atual
    real :: tempo_atual, tempo_decorrido, tempo_medio, tempo_total_estimado, tempo_restante
    integer :: segundos_restantes, i
    real :: progresso

    call cpu_time(tempo_atual)
    tempo_decorrido = tempo_atual - temp_ini
    vetor_tempo(iteracao_atual) = tempo_decorrido

    ! calculo do tempo restante em segundos
    if (iteracao_atual > 1) then
        tempo_medio = tempo_decorrido / iteracao_atual
        tempo_total_estimado = tempo_medio * total_iteracoes
        tempo_restante = tempo_total_estimado - tempo_decorrido
        segundos_restantes = nint(tempo_restante)  
    endif

    !atualização da barra de progresso
    progresso = real(iteracao_atual) / real(total_iteracoes)
 
  write(*, '(A, F6.2, A, A, I5, A)', advance='no') 'Progresso: ', progresso * 100, '% ['
    do i = 1, largura_barra
        if (i <= int(progresso * largura_barra)) then
            write(*, '(A, A)', advance='no') verde_claro, bloco_cheio
        else
            write(*, '(A, A)', advance='no') verde_escuro, bloco_vazio
        endif
    end do
    
    write(*, '(A)', advance='no') reset_cor  ! resetar a cor após a barra


    ! exibe tempo restante ao lado da barra
    write(*, '(A, A, I5, A, A)', advance='no') '] ', azul, segundos_restantes, ' s', reset_cor
    

    if (progresso < 1.0) then
        write(*, '(A)', advance='no') char(13)  ! retorna o cursor para o início da linha
    else
        write(*, '(/)')             !move o cursos paraproxima linha do console
    endif

end subroutine monitor_progress



subroutine end_timer()
   real :: tempo_fim, tempo_total_decorrido
    integer :: tempo_fim_sistema, contagem_sistema
    real :: tempo_total_sistema

    call cpu_time(tempo_fim)
    tempo_total_decorrido = tempo_fim - temp_ini

    call system_clock(tempo_fim_sistema)
    contagem_sistema = tempo_fim_sistema - temp_ini_sistema
    tempo_total_sistema = real(contagem_sistema) / real(rate_system_clock)


    print '(A, F10.2, A)', 'Tempo (CPU): ', tempo_total_decorrido, ' segundos'
    print '(A, F10.2, A)', 'Tempo (Sistema): ', tempo_total_sistema, ' segundos'
    
    if (allocated(vetor_tempo)) then
        deallocate(vetor_tempo)
    endif

end subroutine end_timer

end module progressfort
