%%%%%% Setting
%%%%%% set_fig_3D
%%%%%% Set figure parameters for 3D graphs
%%%%%% 
%%%%%% Created 2019-11-12
%%%%%% Warley Ribeiro
%%%%%% Last update: 2019-12-06
%
%
% Modify three-dimensional figure parameters
%
% Function variables:
%
%     OUTPUT
%         -
%     INPUT 
%         X_label     : Label for x-axis (string)
%         Y_label     : Label for y-axis (string)
%         Z_label     : Label for z-axis (string)
%         FontName    : Name of the font (string)
%         FontSize    : Size of the font (scalar)
%         res_x       : Pixel resolution for x direction (scalar)
%         res_y       : Pixel resolution for y direction (scalar)
%         X_lim       : Limitis for the x-axis (1x2 vector)
%         Y_lim       : Limitis for the y-axis (1x2 vector)
%         Z_lim       : Limitis for the z-axis (1x2 vector)
%         az          : Azimute angle for view [deg] (scalar)
%         el          : Elevation angle for view [deg] (scalar)


function set_fig_3D(X_label, Y_label, Z_label, FontName, FontSize, res_x, res_y, X_lim, Y_lim, Z_lim, az, el)

%%% Definition of files for writing simulation results %%%
% Labels
xlabel(X_label,'FontName',FontName,'FontSize',FontSize);
ylabel(Y_label,'FontName',FontName,'FontSize',FontSize);
zlabel(Z_label,'FontName',FontName,'FontSize',FontSize);
% Define fonts
set(gca,'FontName',FontName,'FontSize',FontSize,'LineWidth',2);
% Define background color and window size (resolution)
set(gcf,'color','w','Position', [1 1 res_x res_y]);
set(gcf,'Renderer','zbuffer')
% Axis, grid and camera angle
axis equal; grid on; view(az,el);
% Limits for axes
xlim(X_lim); ylim(Y_lim); zlim(Z_lim);
% Lighting paramenters
lighting gouraud; material shiny; lightangle(-45,30)