%% Final Project - ENGR 180 II
% Amndeep Singh Mann and William Bauer
% Section 65 - Group 11

%% Preparing the workspace
hold off; clear all; close all; clc;

%% Preparing the display
someAxes=axes('xlim',[0 9.32], 'ylim', [0 4.65], 'zlim', [0 2]);
rotate3d on;
grid on;
view(3);
axis equal;
hold on;
xlabel('x');
ylabel('y');
zlabel('z');

%% Preparing the billiard table
table = imread('board.png');
surf([0, 9.32; 0, 9.32], [0, 0; 4.65, 4.65], [0, 0; 0, 0], 'CData', table, 'FaceColor', 'texturemap');

%% Receiving user input
disp('You will be asked to provide certain input, please make sure to keep everything in the appropriate bounds.');
disp('The table has the dimensions of 9.32''x4.65'', so please make sure the balls are well within them.');
disp('Try not to stretch reality too far with the velocities of the balls.');
ball8 = ball([input('x-pos of the 8 ball: '), input('y-pos of the 8 ball: '), ball.radius], [input('vx of the 8 ball: '), input('vy of the 8 ball: '), 0]);
ballc = ball([input('x-pos of the cue ball: '), input('y-pos of the cue ball: '), ball.radius], [input('vx of the cue ball: '), input('vy of the cue ball: '), 0]);
balls = [ball8, ballc];

%% Preparing ball graphics
% rgb2ind takes each color in the image and assigns it to a value in a
% list called the map.  The image's color for each pixel is then an index
% into the map.
ball8_graphics_rgb = imread('magic 8 ball 2.png');
[ball8_ind, ball8_map] = rgb2ind(ball8_graphics_rgb, 256);
ballc_graphics_rgb = imread('drexel logo.jpg');
[ballc_ind, ballc_map] = rgb2ind(ballc_graphics_rgb, 256);

% The colormap is just a list of all of those colors
colormap([ball8_map; ballc_map]);

% The sphere object that is used to describe both of the balls in the
% simulation
[xsph, ysph, zsph] = sphere(100);

% Creates handles for the surfaces of the balls.  They both use the
% texturemap as described by the colormap to "color" themselves.  However,
% the cue ball will not be colored correctly as it will index values that
% are in the colormap of the 8ball.
ball8_handle = surface(xsph, ysph, zsph, flipud(ball8_ind), 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'CDataMapping', 'direct');
ballc_handle = surface(xsph, ysph, zsph, flipud(ballc_ind), 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'CDataMapping', 'direct');

% To counteract this problem, the cdata (i.e. the indexed color values used
% in the graphic) for the cueball will be incremented so that they will 
% point to values in the range of colormap data describing the cueball.  
set(ballc_handle, 'CData', get(ballc_handle, 'CData')+length(ball8_map));

ball8_hg = hgtransform('parent', someAxes);
set(ball8_handle, 'parent', ball8_hg);
ballc_hg = hgtransform('parent', someAxes);
set(ballc_handle, 'parent', ballc_hg);
drawnow

%% Simulation code
ball8_angle_change = 0;
ballc_angle_change = 0;
% while the balls exist (as we delete them once they fall in a pocket) and
% as long as the balls are actually moving, keep on running the simulation
while (ball8.isvalid() || ballc.isvalid()) && sum([balls.velocity].^2) ~= 0
    % as the simulation can go on without having both balls, you only want
    % to simulate the balls that exist
    balls_in_simulation = {};
    
    % since the balls are the default spheres, this takes them to where
    % they need to be, scales them, and rotates them perpendicular to the
    % direction of their velocity in order to simulate the rotating effect
    % (however, whenever the velocity has a change due to a collision, then
    % the rotation has a jump since it does not keep track of the previous
    % direction of movement)
    if ball8.isvalid()
        ball8_translation = makehgtform('translate', ball8.position);
        ball8_scaling = makehgtform('scale', ball8.radius);
        ball8_rotating = makehgtform('axisrotate', [-ball8.velocity(2), ball8.velocity(1), ball8.velocity(3)], ball8_angle_change);
        % if the ball isn't moving, then makehgtform returns a matrix that
        % contains NaNs
        if(sum(ball8.velocity) == 0)
            ball8_rotating = [1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];
        end
        set(ball8_hg, 'matrix', ball8_translation*ball8_scaling*ball8_rotating);
        balls_in_simulation{length(balls_in_simulation)+1} = ball8;
    end
    
    if ballc.isvalid()
        ballc_translation = makehgtform('translate', ballc.position);
        ballc_scaling = makehgtform('scale', ballc.radius);
        ballc_rotating = makehgtform('axisrotate', [-ballc.velocity(2), ballc.velocity(1), ballc.velocity(3)], ballc_angle_change);
        if(sum(ballc.velocity) == 0)
            ballc_rotating = [1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];
        end
        set(ballc_hg, 'matrix', ballc_translation*ballc_scaling*ballc_rotating);
        balls_in_simulation{length(balls_in_simulation)+1} = ballc;
    end
    
    % 0.001 was a timelapse that had pretty good results - small enough
    % that there were no major physics distortions, large enough that
    % calculation time was not a factor in slowing it down
    ball.move(0.001, 0, 0, 9.32, 4.65, [balls_in_simulation{:}]);
    
    % if a ball falls in a pocket, then it is deleted from the simulation
    for xpocket = [0, 9.32/2, 9.32]
        for ypocket = [0, 4.65]
            if ball8.isvalid() && ball.ball_in_pocket(ball8, xpocket, ypocket, 0.1)
                delete(ball8)
                set(ball8_handle, 'visible', 'off');
                if ballc.isvalid()
                    balls = ballc;
                else
                    balls = [];
                end
            end
            if ballc.isvalid() && ball.ball_in_pocket(ballc, xpocket, ypocket, 0.1)
                delete(ballc)
                set(ballc_handle, 'visible', 'off');
                if ball8.isvalid()
                    balls = ball8;
                else
                    balls = [];
                end
            end
        end
    end
    
    % updating the angle appearance for the rotation code above
    if ball8.isvalid()
        ball8_angle_change = ball8_angle_change+0.003*sum(ball8.velocity.*ball8.velocity)^0.5;
    end
    if ballc.isvalid()
        ballc_angle_change = ballc_angle_change+0.003*sum(ballc.velocity.*ballc.velocity)^0.5;
    end
    
    % like with the time lapse, this value just worked out to be really
    % good at not being too skippy or too fast to understand
    pause(0.015);
end