classdef ball < handle
    %BALL Summary of this class goes here
    %   Treating a sphere as a circle to simplify the math/code for the
    %   simple reason that these balls are artificially restricted to a
    %   singlular z-position.  The only reason why the third dimension is
    %   retained is to keep all information regarding the 3rd dimension in
    %   one place.
    
    properties
        position
        velocity
    end
    properties (Constant)
        %specifications as according to american pool
        mass=170; %170 grams
        radius=2.25/12; %2 1/4 inches in feet
        friction=0.005;
    end
    
    methods
        function obj = ball(position, velocity)
            obj.position = position;
            obj.velocity = velocity;
        end
    end
    
    methods (Static = true)
        function inpocket = ball_in_pocket(one, x, y, r)
            inpocket = (one.position(1)-x)^2+(one.position(2)-y)^2 <= (ball.radius+r)^2;
        end
        
        
        %an intersection between two circles occurs when the distance
        %between the centers is not greater than the sum of their radii
        function intersected = ball_intersection(one, two)
            intersected = (one.position(1)-two.position(1))^2+(one.position(2)-two.position(2))^2 <= (2*ball.radius)^2;
        end
        
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
        
        %simulates the movement of one of the balls
        function move(time_increment, minx, miny, maxx, maxy, balls)
            for b1 = 1:length(balls)
                %update position
                balls(b1).position = balls(b1).position + time_increment*balls(b1).velocity;

                %check if the position goes beyond a wall boundary
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
                %apply the physics of an elastic collision - simplified to the
                %case where masses are equivalent
                for b2 = b1+1:length(balls)
                    if ball.ball_intersection(balls(b1), balls(b2))
%                         new_self_velocity = balls(b2).velocity;
%                         balls(b2).velocity = balls(b1).velocity;
%                         balls(b1).velocity = new_self_velocity;
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