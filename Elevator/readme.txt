CS321
Assignment 4
Rutvik Ghughal - 170101057

PART A : Controlled Blinking 
1) Connect LCI to the 8085 using the 8255 connection
2) Load the program in the 8085 microprocessor
3) Press RESET
4) Press GO
5) Enter 9000
6) Press EXEC
7) If all the input pins on port B of LCI are HIGH then nothing happens and only the D0 of output is on
8) When D6 of input is LOW blinking starts cyclically
9) When D5 of input is LOW and D6 is HIGH blinking pauses
10) Blinking resumes when D6 is switched to LOW
11) When D6 and D5 are HIGH and D2 is LOW, the program stops execution

PART B : Elevator Program
1) Connect LCI to the 8085 using the 8255 connection
2) Load the program in the 8085 microprocessor
3) Press RESET
4) Press GO
5) Enter 9000
6) Press EXEC
7) The display shows E
8) Press EXEC again
9) The output of LCI(PORT A) shows current lift position
10) The input of LCI(PORT B) takes in the floors with buttons pressed and want to go to the ground floor
11) The elevator goes to the highest pressed floor, waits 3 seconds and comes down wating on every pressed floor

Extra feature (Boss floor)
		- WARNING - The lift only goes once to the boss floor once, in the next iteration boss floor must be switched to LOW  
8) Instead of pressing EXEC again, 
Now enter the floor the boss is in (extra feature). This floor will given priority. Enter the binary or the floor number
	floor 8 - 80
	floor 7 - 40
	floor 6 - 20
	floor 5 - 10
	floor 4 - 08
	floor 3 - 04
	floor 2 - 02
	floor 1 - 01
9) Now press EXEC
10) The output of LCI(PORT A) shows current lift position
11) The input of LCI(PORT B) takes in the floors with buttons pressed and want to go to the ground floor
12) The elevator goes to the highest pressed floor, waits 3 seconds and comes down wating on every pressed floor