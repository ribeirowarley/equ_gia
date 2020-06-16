%%%%%% Initialize
%%%%%% ini_surf
%%%%%% 
%%%%%% Initialize surface parameters
%%%%%% 
%%%%%% Created 2019-10-30
%%%%%% Warley Ribeiro
%%%%%% Last update: 2019-12-06
%
%
% Load surface points from .mat file and set contact characteristics (stiffness and damping)
%
% Function variables:
%
%     OUTPUT
%         surface.min   : Minimum value of surface height [m] (scalar)
%         surface.K     : Floor reaction force stiffness coefficient (scalar)
%         surface.D     : Floor reaction force damping coefficient (scalar)
%     INPUT
%         surf          : Surface type (string: flat_, rough) 


function surface = ini_surf(surf)

global x ; global y ; global z;

% Flat surface
if strcmp(surf,'flat_')
    load('map_flat_HR.mat')
% Rough surface
else if strcmp(surf,'rough')
        load('map_coord_2.mat');
    else
        disp('invalid surface');
    end
end

surface.min = min(min(z));

% Contact parameters
surface.K = 1000;  % Floor reaction force stiffness coefficient
surface.D = 1;     % Floor reaction force damping coefficient

end