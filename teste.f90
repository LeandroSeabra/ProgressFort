
program test_progress
    use progressfort

    implicit none

    integer, parameter :: total_steps = 100
    real :: duration
    real, parameter :: log_base = 10.0

    duration = 10.0  

    call simulate_linear(duration, total_steps)
    call simulate_logarithmic(duration, total_steps, log_base)

end program test_progress



subroutine simulate_linear(duration, total_steps)
    use progressfort

    integer, intent(in) :: total_steps
    real, intent(in) :: duration
    integer :: i


    call start_timer(total_steps) 

    do i = 1, total_steps
        call sleep_seconds(duration / total_steps)
        call monitor_progress(i)
    end do


    call end_timer()


end subroutine simulate_linear

subroutine simulate_logarithmic(duration, total_steps, log_base)
    use progressfort

    integer, intent(in) :: total_steps
    real, intent(in) :: duration, log_base
    integer :: i

    call start_timer(total_steps) 

    do i = 1, total_steps
        call sleep_seconds(duration / total_steps)
        call monitor_progress(i)
    end do
    call end_timer()


end subroutine simulate_logarithmic

subroutine sleep_seconds(seconds)
    real, intent(in) :: seconds
    integer :: count_rate, count_start, count_end

    call system_clock(count_rate = count_rate)
    call system_clock(count_start)

    do
        call system_clock(count_end)
        if (real(count_end - count_start) / count_rate >= seconds) exit
    end do
end subroutine sleep_seconds