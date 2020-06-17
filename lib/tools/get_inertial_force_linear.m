%%%%%% Calculate
%%%%%% get_inertial_force_linear
%%%%%% 
%%%%%% Obtain total inertial forces of a robot
%%%%%% 
%%%%%% Created 2020-02-04
%%%%%% Warley Ribeiro
%%%%%% Last update: 2020-02-04
%
%
% Obtain the total inertial forces of a robor in respect to the center of gravity
%
% Function variables:
%
%     OUTPUT
%         Fa           : Inertial force [N] (3x1 vector)
%     INPUT
%         LP           : Link Parameters (SpaceDyn class)
%         SV           : State Variables (SpaceDyn class)

function Fa = get_inertial_force_linear(LP, SV)

% Center of Gravity calculation
% Inertial force
Fa = LP.m0*SV.vd0;
for i = 1:LP.num_q
    Fa = Fa + LP.m(i)*SV.vd(:,i); 
end
