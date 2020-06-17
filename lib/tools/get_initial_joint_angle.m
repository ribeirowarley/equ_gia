%%%%%% Calculate
%%%%%% get_initial_joint_angle
%%%%%% 
%%%%%% Calculate the initial joints angles given the initial end-effectors' positions
%%%%%% 
%%%%%% Created 2019-09-30
%%%%%% Victoria Keo, Warley Ribeiro
%%%%%% Last update: 2019-12-06
%
%
% For a given set of points xp, obtain the closest points in the map regardless of the map's resolution, including the map
% height for those points
%
% Function variables:
%
%     OUTPUT
%         q0     : Initial angular position for joints (1xn vector)
%     INPUT
%         LP     : Link Parameters (SpaceDyn class)
%         SV     : State Variables (SpaceDyn class)
%         eps    : Horizontal distance from base center until end-effector position for both x and y coordinates [m] (scalar)


function q0 = get_initial_joint_angle(LP,SV,eps)

% End-effectors initial (x,y) positions 
xe0 = [SV.R0(1)+eps SV.R0(1)-eps SV.R0(1)-eps SV.R0(1)+eps];
ye0 = [SV.R0(2)+eps SV.R0(2)+eps SV.R0(2)-eps SV.R0(2)-eps];
    
% Get the nearest points on the map and obtain height
[xe0,ye0,ze0] = get_map_pos(xe0,ye0) ;
    
POS_e0 = [xe0;ye0;ze0];
%%% 4th leg's position is above the ground
POS_e0(3,4) = POS_e0(3,4) + 0.04;


% Inverse kinematics
for i = 1:LP.num_limb
	q0(3*i-2:3*i) = ah_i_kine_3dof_minote(LP,SV,POS_e0(:,i) , i);
end
q0 = q0';

end