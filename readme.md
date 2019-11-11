# ’Avoiding the obstacles’ game in Verilog

Wrote a program in Verilog( Hardware Description Language ) and output is shown on the seven segment 
display of **Atrix-7 FPGA board**.

The player is the leftmost display of the seven segment display. and is denoted by a bar which can become
vertical or horizontal and can move up and down on button clicks.

The player has to avoid the obstacles coming towards it using the buttons on the FPGA board.

The obstacles are the pseudo-random combinations(excluded the impossible combinations like the lighting up the whole LEDs of the display) 

Player lose when there is a head-on collision with the led which is in the same position as that of our player

With time the speed of incoming obstacle increase and at the end the score is displayed.

<img src="https://user-images.githubusercontent.com/41193564/51406560-86549f00-1b7f-11e9-8ddc-92ef63d8c926.jpeg" height="270" width = 360>


This shows our player as the leftmost display and other 3 contain the approaching obstacles.

<img src = "https://user-images.githubusercontent.com/41193564/51406803-2a3e4a80-1b80-11e9-9113-03eb00844be0.jpeg" height="270" width = 360>

This shows the player as vertical and as you can see the next obstacle contain the head on colliding led
if the player doesn't move then he will lose.


<img src = "https://user-images.githubusercontent.com/41193564/51406802-29a5b400-1b80-11e9-8302-0c20ac127414.jpeg" height="270" width = 360>

Once lost this is displayed.

<img src = "https://user-images.githubusercontent.com/41193564/51406887-68d40500-1b80-11e9-9831-83da55a3681e.jpeg" height="270" width = 360>

Score is displayed at the end.

