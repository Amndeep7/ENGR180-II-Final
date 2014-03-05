%final project

% [xtable, ytable, ztable] = cylinder([4 4], 4);
% 
% table(1) = surface(xtable+2, ytable+4, ztable, 'FaceColor', 'g');
% 
% set(table(1));
someAxes=axes('xlim',[0 9.32], 'ylim', [0 4.65], 'zlim', [0 2]);
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

zerovar = zeros(10);

[xsph ysph zsph] = sphere(10);

cueball = surface(2+(xsph*.2),4.65/2+(ysph*.2),.13+(zsph*.2), zerovar);

colormap(cueball, [1,1,1]);

set(cueball);




otherball = surface(6+(xsph*.2),4.65/2+(ysph*.2),.13+(zsph*.2), zerovar);

colormap(otherball, [1,0,0]);

set(otherball);










