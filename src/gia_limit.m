%%%%%% Equilibrium
%%%%%% equ_acc_limit
%%%%%% 
%%%%%% Obtain maximum GIA acceleration for normal directions of tumbling axes
%%%%%% 
%%%%%% Created 2020-02-04
%%%%%% Warley Ribeiro
%%%%%% Last update: 2020-06-15
%
% Calculate maximum acceleration for the normal direction n_ab
%
%                            sum{Fj.{(pb-pj)x(pa-pj)}} + M0.(pa-pb) + F0.(pbxpa)
%                gia_lim = -------------------------------------------------------
%                                           m ||(pg-pa)x(pg-pb)|| 
%
% 
% Function variables:
%
%     OUTPUT
%         a_lim        : Acceleration limit for all possible tumbling axis faces of the equilibrium polyhedron 
%                       (3xab_num matrix)
%     INPUT
%         LP           : Link Parameters (SpaceDyn class)
%         SV           : State Variables (SpaceDyn class)
%         ab           : Matrix with the number legs for tumbling axes (ab_num x 2 matrix). Each row represents one tumbling
%                        axis, while the columns represent the number of the leg for that specific axis
%         ab_num       : Total number of possible tumbling axis (scalar)
%         POS_e        : End-effector positions (3xnum_limb matrix)
%         M0           : External moment in the center of gravity [Nm] (3x1 vector)
%         F0           : External Force in the center of gravity [N] (3x1 vector)
%         F_grip       : Maximum gripping force [N] (scalar)
%         n_ab         : Normal vector for all possible tumbling axis faces of the equilibrium polyhedron 
%                        (3xab_num matrix)
%         n_ab_u       : Unit normal vector for all possible tumbling axis faces of the equilibrium polyhedron 
%                        (3xab_num matrix)
%         pg           : Center of Gravity position [m] (3x1 vector)

function gia_limit_nab = gia_limit(n, mass, grasp_flag, tumbling_axes, tumbling_axes_number, POS_e, M0, F0, F_hold, n_ab, n_ab_u)

% Initialize variables
gia_limit_nab = zeros(3,tumbling_axes_number);

for i = 1:tumbling_axes_number
    a = tumbling_axes(i,1); b = tumbling_axes(i,2);
    % Tumbling axis initial and final points
    pa = POS_e(:,a);
    pb = POS_e(:,b);
    
    % Moment due to external force/moment
    Mab = M0'*(pa-pb) + F0'*cross(pb,pa);
	% Moment due to holding force
    for j = 1:n
        if j ~= a && j ~= b && grasp_flag(j) == 1
            pj = POS_e(:,j);
            Mab = Mab + F_hold*[0 0 -1]*cross((pb-pj),(pa-pj));
        end
    end
    % Maximum GIA
    gia_limit_nab(:,i) = Mab/(mass*norm(n_ab(:,i)))*n_ab_u(:,i);
    
end