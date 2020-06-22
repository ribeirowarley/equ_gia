%%%%%% equ_gia_polyhedron_calc() USAGE EXAMPLE
%%%%%% 
%%%%%% Created 2020-06-18
%%%%%% Warley Ribeiro
%%%%%% Last update: 2020-06-18

global Gravity

% Gravity vector [m/s^2]
Gravity = [0 0 -9.81]';

% Contact points positions [m]
p1 = [ 1  1 0]';
p2 = [-1  1 0]';
p3 = [-1 -1 0]';
p4 = [ 1 -1 0]';
POS_e = [p1 p2 p3 p4];

% Center of gravity position [m]
pg = [0 0 1]';

% CoG acceleration [m/s^2]
a_g = [0 0 0]';

% Total mass [kg]
mass = 2;

% Grasping flag
grasp_flag = [1 1 1 1];

% Holding force [N]
F_hold = 5;

% External force and moment [N] [Nm]
F0 = [0 0 0]';
M0 = [0 0 0]';

% Variable to plot polyhedron 
plot_on = 1;

% z-coordinate for base of polyhedron
floor_base = 0;

% Expansion factor for the acceleration vector compared to the position vectors
expansion_factor = 0.02;

[polyhedron, gia, equ_flag] = equ_gia_polyhedron_calc(POS_e, pg, a_g, mass, grasp_flag, F_hold, F0, M0, plot_on, ...
                                                      floor_base, expansion_factor);
                                                  
% Visualize (requires functions in the directory \lib\tools)

plot3(POS_e(1,:),POS_e(2,:),POS_e(3,:),'*r')
hold on
res_draw_stability_polyhedron(0,polyhedron,[0 0 0], 2, [0 0 1], 0.3)
res_draw_vector(pg,expansion_factor*gia,0,[1 0 0])
