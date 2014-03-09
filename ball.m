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
        weight=1;
        radius=1;
        friction=1;
    end
    
    methods
        function obj = ball(position, velocity)
            obj.position = position;
            obj.velocity = velocity;
        end
        
        %an intersection between two circles occurs when the distance
        %between the centers is not greater than the sum of their radii
        function intersected = ball_intersection(obj, ball)
            intersected = (obj.position(0)-ball.position(0))^2+(obj.position(1)-ball.position(1))^2 <= (obj.radius+ball.radius)^2;
        end
        
        %simulates the movement of one of the balls
        function move(obj, time_increment, minx, miny, maxx, maxy, balls)
            %update position
            obj.position = obj.position + time_increment*obj.velocity;
            
            %check if the position goes beyond a wall boundary
            if obj.position(0) < minx
                obj.position(0) = minx;
                obj.velocity(0) = -obj.velocity(0);
            elseif obj.position(0) > maxx
                obj.position(0) = maxx;
                obj.velocity(0) = -obj.velocity(0);
            end
            if obj.position(1) < miny
                obj.position(1) = miny;
                obj.velocity(1) = -obj.velocity(1);
            elseif obj.position(1) > maxy
                obj.position(1) = maxy;
                obj.velocity(1) = -obj.velocity(1);
            end
            
            %check if there's been a ball-to-ball collision, whereupon
            %apply the physics of an elastic collision
            for ball = balls
                if ball_intersection(ball)
                    new_self_velocity = (obj.velocity*(obj.mass-ball.mass)-2*ball.mass*ball.velocity)/(obj.mass+ball.mass);
                    ball.velocity = (ball.velocity*(ball.mass-obj.mass)-2*obj.mass*obj.velocity)/(obj.mass+ball.mass);
                    obj.velocity = new_self_velocity;
                end
            end
            
            %applies friction
            if obj.velocity(0) - obj.friction*time_increment >= 0
                obj.velocity(0) = obj.velocity(0) - obj.friction*time_increment;
            end
            if obj.velocity(1) - obj.friction*time_increment >= 0
                obj.velocity(1) = obj.velocity(1) - obj.friction*time_increment;
            end
        end
        
    end
    
end

