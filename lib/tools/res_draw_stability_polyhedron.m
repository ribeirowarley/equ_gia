%%%%%% Results
%%%%%% res_draw_stability_polyhedron
%%%%%% 
%%%%%% Draw stability polyhedron 
%%%%%% 
%%%%%% Created 2020-02-05
%%%%%% Warley Ribeiro
%%%%%% Last update: 2020-06-16
%
%
% Draw support polyhedron for acceleration from intersection points with ground surface
%
% Function variables:
%
%     OUTPUT
%         -
%     INPUT
%         LP           : Link Parameters (SpaceDyn class)
%         SV           : State Variables (SpaceDyn class)
%         POS_e        : End-effector positions (3xnum_limb matrix) 
%         inc          : Surface inclination [deg] (scalar)

function res_draw_stability_polyhedron(inc, polyhedron,Edge_color,Edge_width,Face_color,Face_alpha)

% Rotation matrix
rot = rpy2dc([0;pi*inc/180;0])';
% Rotate polyhedron to match surface inclination
polyhedron.vertex = rot'* polyhedron.vertex;

for i = 1:size(polyhedron.vertex,2)-1
    patch('Vertices',[polyhedron.vertex(:,i) polyhedron.vertex(:,i+1) polyhedron.vertex(:,end)]',...
        'Faces',[1 2 3],'FaceAlpha',Face_alpha ,'Edgecolor',Edge_color ,'Facecolor',Face_color,'LineWidth',Edge_width)
end
patch('Vertices',[polyhedron.vertex(:,end-1) polyhedron.vertex(:,1) polyhedron.vertex(:,end)]',...
    'Faces',[1 2 3],'FaceAlpha',Face_alpha ,'Edgecolor',Edge_color ,'Facecolor',Face_color,'LineWidth',Edge_width)

end