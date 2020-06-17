%%%%%% Initialize
%%%%%% ini_robot
%%%%%% 
%%%%%% Initialize robot parameters
%%%%%% 
%%%%%% Created 2019-10-30
%%%%%% Warley Ribeiro
%%%%%% Last update: 2019-12-26
%
%
% Initialize robot's links parameters and state variables, including gripping force and end-effector positions and
% orientations
%
% Function variables:
%
%     OUTPUT
%         LP           : Link Parameters (SpaceDyn class)
%         SV           : State Variables (SpaceDyn class)
%         F_grip       : Maximum gripping force [N] (scalar)
%         POS_e        : Position of the end-effector [m] (3xnum_limb matrix)
%         ORI_e        : Orientation of the end-effector [DC] (3x3*num_limb matrix)
%         cont_POS     : Initial point of contact which is used as equilibrium position [m] (3xnum_limb matrix)
%     INPUT
%         robot        : Robot type (string: leg_, grip) 
%         foot_dist    : Distance from projection of robot center to end-point in both x and y directions [m] (scalar)
%         base_height  : Height of base from mean surface of the ground [m] (scalar)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% New variables for LP and SV, other than what is explained by SpaceDyn documents
%
%         LP.num_limb  : number of limbs (scalar)
%         SV.sup       : vector to indicate if the i-th limb is a supporting limb (SV.sup(i) = 1) or a swinging limb 
%                        (SV.sup(i) = 0) (1xn vector)
%         SV.slip      : vector to indicate if the i-th limb is slipping (SV.slip(i) = 1) or not (SV.slip(i) = 0)(1xn vector)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [LP, SV, F_grip, POS_e, ORI_e, cont_POS] = ini_robot(robot, foot_dist, base_height)

global contact_f
global x ; global y ; global z

%%% Link parameters %%%
LP = HubRobo_grip_LP(); 
LP.num_limb = sum(LP.SE); % Total number of limbs
contact_f = zeros(1,LP.num_limb); % Limb end-effector contact flag

%%% State variables initialization %%%
SV = ah1_SV( LP );                                                         
% Initial Base position
SV.R0 = [x(length(x)/2) ;  y(length(y)/2) ; base_height - 0.08 ] ; % center of the map 
% Supporting limb
SV.sup = zeros(1,LP.num_limb); % Supporting limb flag
SV.slip = zeros(1,LP.num_limb);% Supporting limb slip flag 
% Initialize supporting limbs
SV.sup = [0 1 1 1];

% Set initial joint angle [rad] 
SV.q = get_initial_joint_angle(LP,SV,foot_dist);    


%%% Links positions %%%
SV = calc_aa( LP, SV );
SV = calc_pos( LP, SV );

joints = zeros(LP.num_limb,3);
POS_e = zeros(3,LP.num_limb);
ORI_e = zeros(3,3*LP.num_limb);
for i = 1:LP.num_limb
    % Joints/links connecting the base to each limb end-effector
    joints(i,:) = j_num(LP, i);
    % Each limb end-effector pos/ori  [m] [DCM]
    [POS_e(:,i), ORI_e(:,3*i-2 : 3*i)] = f_kin_e(LP, SV, joints(i,:));
end
% Initialize contact position
cont_POS = POS_e;

% Gripping force, if applicable
if strcmp(robot,'leg_')
    F_grip = 0;
else if strcmp(robot,'grip')
        F_grip = 6.8; % average
%         F_grip = 3.2; % minimum
    else
        disp('invalid robot type');
    end
end

end