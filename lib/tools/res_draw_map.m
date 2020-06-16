%%%%%% Results
%%%%%% res_draw_map
%%%%%% 
%%%%%% Draw map
%%%%%% 
%%%%%% Created 2019-10-31
%%%%%% Warley Ribeiro
%%%%%% Last update: 2019-12-06
%
%
% Draw map from .mat file
%
% Function variables:
%
%     OUTPUT
%         -
%     INPUT 
%         inc       : Surface inclination [deg] (scalar)

function res_draw_map(inc)

% Global variables for map positions
global x; global y; global z
% Total number of points
n = size(z,1)*size(z,2); 
[X,Y] = meshgrid(x,y);

if inc ~= 0
    % Creat vectors array
    MAP(1,:) = reshape(X,1,size(X,1)*size(X,2)); 
    MAP(2,:) = reshape(Y,1,size(Y,1)*size(Y,2)); 
    MAP(3,:) = reshape(z , 1 , n ); 
    % Rotate map to match the surface inclination
    rot = rpy2dc([0;pi*inc/180;0])'; 
    map = rot' * MAP; 
    % Change back from array to individual variables
    X = reshape(map(1,:),size(x,2),size(y,2)); 
    Y = reshape(map(2,:),size(x,2),size(y,2)); 
    Z = reshape(map(3,:),size(X,1),size(X,2)); 
else
    Z = z;
end
% Plot map
mesh(X,Y,Z);

c = gray;
c_a = c(3*end/4:end,:);
colormap(gray);
colormap(c_a);
end