%%%%%% Tools
%%%%%% ah_i_kine_3dof_minote
%%%%%% 
%%%%%% Inverse kinematics solver for a 3 DOF manipulator
%%%%%% 
%%%%%% 2018-02-23
%%%%%% Warley Ribeiro (Original from Hayato Minote)

function q_sol = ah_i_kine_3dof_minote( LP, SV, POS_e, num_e )
%i_kine_ori2 3ƒŠƒ“ƒNƒ}ƒjƒsƒ…ƒŒ?[ƒ^‚Ì‹t‰^“®Šw
%   ‹t‰^“®Šw‚ð‰ð?Í“I‚É‰ð‚­ŠÖ?”

%%
q_sol = zeros(3,1);
POS_eE = zeros(3,1);
joints = j_num( LP, num_e );

POS_eE = POS_e - SV.R0;

POS_eE = (rot_x(SV.Q0(1,1))*rot_y(SV.Q0(2,1))*rot_z(SV.Q0(3,1))*POS_eE);

joint1_POS_e_num(1,1) = POS_eE(1,1) - LP.c0(1,joints(1));
joint1_POS_e_num(2,1) = POS_eE(2,1) - LP.c0(2,joints(1));
joint1_POS_e_num(3,1) = POS_eE(3,1) - LP.c0(3,joints(1));

joint1_POS_e_num = rot_z(-LP.Qi(3,joints(1))) * joint1_POS_e_num;

xt = joint1_POS_e_num(1,1);
yt = joint1_POS_e_num(2,1);
zt = joint1_POS_e_num(3,1);

q_sol(1,1) = atan(yt/xt);

Lxy = rot_2xy(-q_sol(1,1)) * joint1_POS_e_num(1:2,1);

xt = Lxy(1);
yt = Lxy(2);
zt = joint1_POS_e_num(3,1);

l1 = LP.cc(1,joints(1)  ,joints(1)+1) - LP.cc(1,joints(1)  ,joints(1)  );
l2 = LP.cc(1,joints(1)+1,joints(1)+2) - LP.cc(1,joints(1)+1,joints(1)+1);
l3 = LP.ce(1,joints(1)+2) - LP.cc(1,joints(1)+2,joints(1)+2);

L_d = sqrt((xt - l1)^2 + yt^2 + zt^2);
the2_d = acos((L_d^2 + l2^2 - l3^2)/(2 * l2 * L_d));
the2_dd = atan(-zt/(xt -l1));
q_sol(2,1) = the2_d - the2_dd;

the3_d = acos((l2^2 + l3^2 -L_d^2)/(2 * l2 * l3));
the3 = -pi + the3_d;
q_sol(3,1) = the3;
end

