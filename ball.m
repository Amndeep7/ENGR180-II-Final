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
        friction=0.001;
    end
    
    methods
        function obj = ball(position, velocity)
            obj.position = position;
            obj.velocity = velocity;
        end
        
        %an intersection between two circles occurs when the distance
        %between the centers is not greater than the sum of their radii
        function intersected = ball_intersection(obj, other)
            intersected = (obj.position(1)-other.position(1))^2+(obj.position(2)-other.position(2))^2 <= (2*ball.radius)^2;
        end
        
        %simulates the movement of one of the balls
        function move(obj, time_increment, minx, miny, maxx, maxy, balls)
            %update position
            obj.position = obj.position + time_increment*obj.velocity;
            
            %check if the position goes beyond a wall boundary
            if obj.position(1)-ball.radius < minx
                obj.position(1) = minx+ball.radius;
                obj.velocity(1) = -obj.velocity(1);
            elseif obj.position(1)+ball.radius > maxx
                obj.position(1) = maxx-ball.radius;
                obj.velocity(1) = -obj.velocity(1);
            end
            if obj.position(2)-ball.radius < miny
                obj.position(2) = miny+ball.radius;
                obj.velocity(2) = -obj.velocity(2);
            elseif obj.position(2)+ball.radius > maxy
                obj.position(2) = maxy-ball.radius;
                obj.velocity(2) = -obj.velocity(2);
            end
            
            %check if there's been a ball-to-ball collision, whereupon
            %apply the physics of an elastic collision - simplified to the
            %case where masses are equivalent
            for other = balls
                if obj.ball_intersection(other)
                    new_self_velocity = other.velocity;
                    other.velocity = obj.velocity;
                    obj.velocity = new_self_velocity;
                end
            end
            
            %applies friction
            if obj.velocity(1)^2 ~= 0
                if obj.velocity(1)^2 < 0.005
                    obj.velocity(1) = 0;
                elseif obj.velocity(1) > 0
                    obj.velocity(1) = obj.velocity(1)-ball.friction;
                else
                    obj.velocity(1) = obj.velocity(1)+ball.friction;
                end
            end
            if obj.velocity(2)^2 ~= 0
                if obj.velocity(2)^2 < 0.005
                    obj.velocity(2) = 0;
                elseif obj.velocity(2) > 0
                    obj.velocity(2) = obj.velocity(2)-ball.friction;
                else
                    obj.velocity(2) = obj.velocity(2)+ball.friction;
                end
            end
            
        end
        
    end
    
end