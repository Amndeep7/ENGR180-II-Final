Final Project - ENGR 180 II
Amndeep Singh Mann and William Bauer
Section 65 - Group 11

Instructions:

To use the program, press run or call the .m file from the command window. When 
prompted to do so, input the x and y positions of the 8 ball. The x position
should be between 0 and 9.32 since they are the dimensions of the table. The y 
position should be between 0 and 4.65 since that is the height of the table. 
Then input the x and y components of the velocity of the ball. For reference, 
the balls move well at about +-30 m/s, but can just as well with values of 
larger magnitude. After that, input the same things for the cue ball and the 
program will run the simulation. To close the program, click the x in the top 
right corner or type ctrl+c in the command window. 

Core Functionality:

Core functionality is displayed in a few different ways.  The first it that the
balls are animated using rotation, translation, and scaling.  Since the 
original sphere is of the default dimensions and at the origin, scaling is used
to change it to the appropriate size and translation is used to move it to 
where it is in respect to the simulation.  The ball is rotated in order to 
provide more believability in regards to the animation of the simulation.  
Functions, while user-defined, were made within the context of a ball class,
which was not exactly how was learned in class where they were standalone and 
in their own files.  

Advanced Functionality:

Advanced UI
This project doesn't present very much improved UI over the labs.
The original plan was to have an animated cue stick that the user could move, 
in order to more accurately mimic the billiard "atmosphere," but time ran out 
before that portion of the project could be implemented.

Advanced Algorithms
This project is centered around the physics of 2D collisions.  Based upon user
input, this project attempts to simulate the movement, and especially the 
collisions, of two balls within a constrained space (i.e. the billiard table).
Consequently, the physical characteristics of the balls and tables were made as
accurately as possible, particularly in relation to their size.  This type of
physics was not used in class previously.  

Also, this project uses a custom-designed class, namely the `ball` class, which
was functionality not covered in class.  

Advanced Visualizations
This project exhibits two major forms of advanced visualizations.  The more
trivial is that of the rotation of the balls.  While the code for explicitly
doing the rotation is considered core functionality, the code for in which
direction and by how much to rotate is a bit more advanced.  It was used so as
to provide a more realistic look to the animation.  

The more complicated advanced visualization is the use of texture maps as 
opposed to direct drawing of colors in animating the simulation.  Using texture
maps was necessary in order to not cause excessive lag in the application: 
during the testing process, drawing the balls (just plain spheres), a green 
rectangle, and six circles for the pockets was too much for a high-end laptop. 
In fact, Matlab actually often crashed, or temporarily become unresponsive, 
when the angle of (3d) view was adjusted.  The process of adding in texture 
maps is described in the comments of finalproject.m, starting at line 31.  