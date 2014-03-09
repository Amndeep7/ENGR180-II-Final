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

fill(x,y,[56/255 179/255 38/255]);

[xsph, ysph, zsph] = sphere(20);

cueball = ball([2, 2, ball.radius], [0, 0, 0]);
otherball = ball([4, 2, ball.radius], [-10, 0, 0]);

cueball_handle = surface(xsph,ysph,zsph);
otherball_handle = surface(xsph,ysph,zsph);

cueball_hg = hgtransform('parent', someAxes);
set(cueball_handle, 'parent', cueball_hg);
otherball_hg = hgtransform('parent', someAxes);
set(otherball_handle, 'parent', otherball_hg);
drawnow

for i = 0:0.001:1
    cueball_translation = makehgtform('translate', cueball.position);
    cueball_scaling = makehgtform('scale', cueball.radius);
    set(cueball_hg, 'matrix', cueball_translation*cueball_scaling);
    otherball_translation = makehgtform('translate', otherball.position);
    otherball_scaling = makehgtform('scale', otherball.radius);
    set(otherball_hg, 'matrix', otherball_translation*otherball_scaling);
    
    cueball.move(0.001, 0, 0, 9.32, 4.65, otherball);
    otherball.move(0.001, 0, 0, 9.32, 4.65, cueball);
    
    a = i
    
    pause(0.015);
end