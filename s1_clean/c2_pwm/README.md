
## Exercise ##
Change the PWM interface, so i_en signal is not longer needed, and PWM scales from 0% to 100%
with the range of the i_duty unsigned value, i.e. o_pwm i constantly low when i_duty = 0, 
constantly high when i_duty = TBD, and for a i_duty step of 1, 1/256 duty cycle is added.   
