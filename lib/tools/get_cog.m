%%%%%% Calculate
%%%%%% get_cog
%%%%%% 
%%%%%% Obtain center of gravity position
%%%%%% 
%%%%%% Created 2019-10-31
%%%%%% Warley Ribeiro
%%%%%% Last update: 2019-12-06
%
%
% Obtain center of gravity position from links positions and inertia parameters
%
% Function variables:
%
%     OUTPUT
%         OG           : Center of Gravity position [m] (3x1 vector)
%     INPUT
%         LP           : Link Parameters (SpaceDyn class)
%         SV           : State Variables (SpaceDyn class)

function OG = get_cog(LP, SV)

% Center of Gravity calculation
OG = LP.m0*SV.R0;
for i=1:LP.num_q
    OG = OG + LP.m(i)*SV.RR(:,i);
end
OG = OG/LP.mass;