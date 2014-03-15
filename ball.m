%% Final Project - ENGR 180 II
% Amndeep Singh Mann and William Bauer
% Section 65 - Group 11

%% Ball class
classdef ball < handle
    %BALL A simulated billiard ball
    %   This class, for the most part, treats a sphere as a circle to 
    %   simplify the math/code for the simple reason that these balls are 
    %   artificially restricted to a singlular z-position.  The only reason
    %   why the third dimension is retained is to keep all information 
    %   regarding the 3rd dimension in one place.  Moreover, just in case
    %   we wanted to expand into the 3rd dimension, it was not difficult at
    %   all to account for it now
    
    % These only apply to specific instances of the ball class
    properties
        position
        velocity
    end
    % Since billiard balls are standardized, these were used as constants
    properties (Constant)
        %specifications as according to american pool
        mass=170; %170 grams
        radius=2.25/12; %2 1/4 inches in feet
        friction=0.005; % friction is not a standardized constant, but this turned out to be a nice value for it
    end
    
    % Member functions
    methods
        % The only one necessary was the constructor
        function obj = ball(position, velocity)
            obj.position = position;
            obj.velocity = velocity;
        end
    end
    % Static functions
    methods (Static = true)
        function inpocket = ball_in_pocket(one, x, y, r)
            inpocket = (one.position(1)-x)^2+(one.position(2)-y)^2 <= (ball.radius+r)^2;
        end
        
        %an intersection between two circles occurs when the distance
        %between the centers is not greater than the sum of their radii
        function intersected = ball_intersection(one, two)
            intersected = (one.position(1)-two.position(1))^2+(one.position(2)-two.position(2))^2 <= (2*ball.radius)^2;
        end
        
        %a literal implementation for the equations of 2d collisions
        %between two moving objects as described here: http://en.wikipedia.org/wiki/Elastic_collision#Two-Dimensional_Collision_With_Two_Moving_Objects
        %however, they've been simplified for the case of having the same
        %mass, which means that in head-on collisions, the primary result
        %is that speeds are exchanged and direction of movement reversed,
        %and in the case of angled collisions, the balls move in right
        %angles to each other
        function ball_collision(one, two)
            one_angle = atan2(one.velocity(2), one.velocity(1));
            two_angle = atan2(two.velocity(2), two.velocity(1));
            one_speed = sum(one.velocity.*one.velocity)^0.5;
            two_speed = sum(two.velocity.*two.velocity)^0.5;
            collision_angle = atan((two.position(2)-one.position(2))/(two.position(1)-one.position(1)));
            one_new_x = two_speed*cos(two_angle-collision_angle)*cos(collision_angle)+one_speed*sin(one_angle-collision_angle)*cos(collision_angle+pi/2);
            one_new_y = two_speed*cos(two_angle-collision_angle)*sin(collision_angle)+one_speed*sin(one_angle-collision_angle)*sin(collision_angle+pi/2);
            two_new_x = one_speed*cos(one_angle-collision_angle)*cos(collision_angle)+two_speed*sin(two_angle-collision_angle)*cos(collision_angle+pi/2);
            two_new_y = one_speed*cos(one_angle-collision_angle)*sin(collision_angle)+two_speed*sin(two_angle-collision_angle)*sin(collision_angle+pi/2);
            one.velocity = [one_new_x, one_new_y, one.velocity(3)];
            two.velocity = [two_new_x, two_new_y, two.velocity(3)];
        end
        
        %simulates the movement of all of the balls
        function move(time_increment, minx, miny, maxx, maxy, balls)
            for b1 = 1:length(balls)
                %update position
                balls(b1).position = balls(b1).position + time_increment*balls(b1).velocity;

                %check if the position goes beyond a wall boundary - if so,
                %then mirror the movement of the ball (i.e. change the sign
                %of the variable that describes the impact wall, ex. if it hits
                %the left wall, then change the sign of velocity_x)
                if balls(b1).position(1)-ball.radius < minx
                    balls(b1).position(1) = minx+ball.radius;
                    balls(b1).velocity(1) = -balls(b1).velocity(1);
                elseif balls(b1).position(1)+ball.radius > maxx
                    balls(b1).position(1) = maxx-ball.radius;
                    balls(b1).velocity(1) = -balls(b1).velocity(1);
                end
                if balls(b1).position(2)-ball.radius < miny
                    balls(b1).position(2) = miny+ball.radius;
                    balls(b1).velocity(2) = -balls(b1).velocity(2);
                elseif balls(b1).position(2)+ball.radius > maxy
                    balls(b1).position(2) = maxy-ball.radius;
                    balls(b1).velocity(2) = -balls(b1).velocity(2);
                end

                %check if there's been a ball-to-ball collision, whereupon
                %apply the physics of an elastic collision
                for b2 = b1+1:length(balls)
                    if ball.ball_intersection(balls(b1), balls(b2))
                        ball.ball_collision(balls(b1), balls(b2))
                    end
                end

                %applies friction
                if balls(b1).velocity(1)^2 ~= 0
                    if balls(b1).velocity(1)^2 < 0.005
                        balls(b1).velocity(1) = 0;
                    elseif balls(b1).velocity(1) > 0
                        balls(b1).velocity(1) = balls(b1).velocity(1)-ball.friction;
                    else
                        balls(b1).velocity(1) = balls(b1).velocity(1)+ball.friction;
                    end
                end
                if balls(b1).velocity(2)^2 ~= 0
                    if balls(b1).velocity(2)^2 < 0.005
                        balls(b1).velocity(2) = 0;
                    elseif balls(b1).velocity(2) > 0
                        balls(b1).velocity(2) = balls(b1).velocity(2)-ball.friction;
                    else
                        balls(b1).velocity(2) = balls(b1).velocity(2)+ball.friction;
                    end
                end

            end
            
        end
        
    end
    
end