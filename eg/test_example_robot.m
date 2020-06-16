%%%%%% Equilibrium
%%%%%% test_example_robot
%%%%%% 
%%%%%% Test if a robot is in equilibrium or not, considering stability polyhedron for Gravito-Inertial Acceleration
%%%%%% 
%%%%%% Created 2019-10-30
%%%%%% Warley Ribeiro
%%%%%% Last update: 2020-06-16
%

clc; clear; close all; tic;

%%%%%%%%%%%%%% Simulation parameters

g = 1/6; % Gravity [G]]
inc = 0; % Inclination [deg]
surf_t = 'rough'; % Surface type (flat_, rough)
acc = [0 7 0]'; % Base acceleration [m/s^2]
robot = 'grip'; % Type of robot (leg_, grip)
F_hold = 3.2;  % Holding Force [N]
grasp_flag = [1 1 1 0]; % Grasping flag
plot_on = 1; % Plot figure

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Definition of global variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Gravity
global Ez
global x ; global y ; global z

Ez = [0 0 1]';  % Unit vector for joints rotation axis
Gravity = rpy2dc([0;pi*inc/180;0])'*g*[0 0 -9.81]'; % Gravity vector [m/s^2]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialize surface %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
surface = ini_surf(surf_t);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialize robot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[LP, SV] = ini_robot(robot, 0.12, 0.14);
shape_robot = ini_draw_create_robot(LP, 0.005, robot);
SV.vd0 = acc;

SV = calc_aa( LP, SV );
SV = calc_pos( LP, SV );
[POS_e, Qe_deg, Q0_deg] = get_fwd_kin(LP, SV);

% Center of Gravity calculation
pg = get_cog(LP, SV);

% Calculate total acceleration
% Center of Gravity Inertial force
Fa = get_inertial_force_linear(LP, SV);
% Center of Gravity acceleration
a_g = Fa/LP.mass;

% Robot mass
mass = LP.mass;

% External Force and Moment
F0 = [0 0 0]';
M0 = [0 0 0]';

floor_base = surface.min;

% To show stability polyhedron in cartesian space shrinked by a factor of "expansion_factor"
expansion_factor = 0.02;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Equilibrium check %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[polyhedron, gia, equ_flag] = equ_gia_polyhedron_calc(POS_e, pg, a_g, mass, grasp_flag, F_hold, F0, M0, plot_on, ...
                                                      floor_base, expansion_factor);
[acc_margin, acc_margin_ab] = equ_gia_acceleration_margin(polyhedron, gia, equ_flag);
[inclination_margin, inclination_margin_ab] = equ_gia_inclination_margin(polyhedron, gia, equ_flag);
if equ_flag                                                                 % ACC 3DP OK
	disp('Equilibrium: OK'); disp('Acceleration vector is inside the support polyhedron')
    disp(['Acceleration margin:   ' num2str(acc_margin) ' m/s^2'])
    disp(['Angular margin:        ' num2str(inclination_margin) ' deg'  ])
else                                                                                % ACC 3DP NO
	disp('Equilibrium: NO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
    disp('Acceleration vector is OUTSIDE the support polyhedron')
    disp('Acceleration margin:    ZERO'); disp('Angular margin:         ZERO')
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot Robot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_on
    figure(100)
    hold on;
    set_fig_3D('\it{x} \rm{[m]}', '\it{y} \rm{[m]}', '\itz \rm[m]', 'Times New Roman', 25, 1280, 720, ...
               [-0.27, 0.25], [-0.4, .35], [-0.3 , .35], -160, 12);

    res_draw_map(inc);                                                                             % Plot surface
    res_draw_robot(LP, SV, robot, POS_e, shape_robot, inc, [0.1, 0.1, 0]);                         % Plot robot
    res_draw_vector(pg,expansion_factor*Gravity,inc,[0 0.7 0]);                                    % Plot Gravity vector

    res_draw_stability_polyhedron(inc, polyhedron,[0 0 1],2,[0 0 1],0.25);                         % Plot support polyhedron
    res_draw_vector(pg,expansion_factor*gia,inc,'red');                                            % Plot GIA vector
end

toc
