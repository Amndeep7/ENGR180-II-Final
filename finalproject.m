%final project

hold off; clear all; close all; clc;

someAxes=axes('xlim',[0 9.32], 'ylim', [0 4.65], 'zlim', [0 2]);
rotate3d on;
grid on;
view(3);
axis equal;
hold on;
xlabel('x');
ylabel('y');
zlabel('z');

x = [0, 9.32, 9.32, 0, 0];
y = [0, 0, 4.65, 4.65, 0];

table = imread('board.png');
surf([0, 9.32; 0, 9.32], [0, 0; 4.65, 4.65], [0, 0; 0, 0], 'CData', table, 'FaceColor', 'texturemap');

disp('You will be asked to provide certain input, please make sure to keep everything in the appropriate bounds.');
disp('The table has the dimensions of 9.32''x4.65'', so please make sure the balls are well within them.');
disp('Try not to stretch reality too far with the velocities of the balls.');
ball8 = ball([input('x-pos of the 8 ball: '), input('y-pos of the 8 ball: '), ball.radius], [input('vx of the 8 ball: '), input('vy of the 8 ball: '), 0]);
ballc = ball([input('x-pos of the cue ball: '), input('y-pos of the cue ball: '), ball.radius], [input('vx of the cue ball: '), input('vy of the cue ball: '), 0]);
balls = [ball8, ballc];

ball8_graphics_rgb = imread('magic 8 ball 2.png');
[ball8_ind, ball8_map] = rgb2ind(ball8_graphics_rgb, 256);
ballc_graphics_rgb = imread('drexel logo.jpg');
[ballc_ind, ballc_map] = rgb2ind(ballc_graphics_rgb, 256);

colormap([ball8_map; ballc_map]);

[xsph, ysph, zsph] = sphere(20);

ball8_handle = surface(xsph, ysph, zsph, flipud(ball8_ind), 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'CDataMapping', 'direct');
ballc_handle = surface(xsph, ysph, zsph, flipud(ballc_ind), 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'CDataMapping', 'direct');

set(ballc_handle, 'CData', get(ballc_handle, 'CData')+length(ball8_map));

ball8_hg = hgtransform('parent', someAxes);
set(ball8_handle, 'parent', ball8_hg);
ballc_hg = hgtransform('parent', someAxes);
set(ballc_handle, 'parent', ballc_hg);
drawnow
ball8_angle_change = 0;
ballc_angle_change = 0;
while (ball8.isvalid() || ballc.isvalid()) && sum([balls.velocity].^2) ~= 0
    balls_in_simulation = {};
    
    if ball8.isvalid()
        ball8_translation = makehgtform('translate', ball8.position);
        ball8_scaling = makehgtform('scale', ball8.radius);
        ball8_rotating = makehgtform('axisrotate', [-ball8.velocity(2), ball8.velocity(1), ball8.velocity(3)], ball8_angle_change);
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
    
    ball.move(0.001, 0, 0, 9.32, 4.65, [balls_in_simulation{:}]);
    
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
    
    if ball8.isvalid()
        ball8_angle_change = ball8_angle_change+0.003*sum(ball8.velocity.*ball8.velocity)^0.5;
    end
    if ballc.isvalid()
        ballc_angle_change = ballc_angle_change+0.003*sum(ballc.velocity.*ballc.velocity)^0.5;
    end
    
    pause(0.015);
end