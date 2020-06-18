# List of functions

### Index ###

* Overview
* Main functions
  * equ_gia_acceleration_margin()
  * equ_gia_inclination_margin()
  * equ_gia_polyhedron_calc()
  * equ_tumbling_axes_ab()
  * gia_limit()
  * 
* Libraries
  * SpaceDyn
  * Tools

### Overview ###

This file describes the functions for Gravito-inertial Acceleration (GIA) stability polyhedron code. The functions are located at `\src` directory. The functions are presented in alphabetical order.

Please refer to the original work for details on the equations:

Warley F. R. Ribeiro, Kentaro Uno, Kenji Nagaoka, and Kazuya Yoshida, "Dynamic Equilibrium of Climbing Robots Based on Stability Polyhedron for Gravito-Inertial Acceleration", *The 23rd International Conference on Climbing and Walking Robots and the Support Technologies for Mobile Machines*, Moscow, Russia, 2020 (accepted).

### equ_gia_acceleration_margin() ###

This function calculates the gravito-inertial acceleration margin based on the stability polyhedron. GIA margin is the
acceleration magnitude increment for GIA along the direction normal to the tumbling axis necessary to reach the limiting plane.

                                                    a_gi.{(pg-pa)x(pg-pb)}
                    acc_marg =  ||a_gi_lim||  -  ----------------------------
                                                      ||(pg-pa)x(pg-pb)||

where:

`acc_marg` : Gravito-inertial acceleration margin
`a_gi_lim` : Maximum gravito-inertial acceleration towards the direction normal to the tumbling axis
`a_gi` : Gravito-inertial acceleration
`pa`  : Position of the first point of the tumbling axis
`pb`  : Position of the second point of the tumbling axis
`pg`  : Position of the center of gravity

*Function variables:*

OUTPUT:

* `acc_margin`       : Acceleration margin considering the stability polyhedron [m/s^2] (scalar)
* `acc_margin_ab`    : Acceleration margin for each tumbling axis [m/s^2] (1xn vector)

INPUT:

* `polyhedron`       : Variables to define the shape of the polyhedron (struct)
* `gia`              : Gravito-Inertial Acceleration [m/s^2] (3x1 vector)
* `equ_flag`         : Flag of equilibrium condition (1: equilibrium, 0: not in equilibrium) (scalar)

*Note:* All the inputs for this function can be obtained from `equ_gia_polyhedron_calc()`

### equ_gia_inclination_margin() ###

This function calculates the inclination margin based on the stability polyhedron. GIA margin is the
angle between the GIA vector and the limit plane for a tumbling axis.

                                       (pg-pa)x(pg-pb).a_gi               ||(a_gi_lim||
              inc_marg = min(acos(-------------------------------) - acos(-------------))
                                    ||(pg-pa)x(pg-pb)|| ||a_gi||            ||a_gi||


where:

`inc_marg` : Inclination margin
`a_gi_lim` : Maximum gravito-inertial acceleration towards the direction normal to the tumbling axis
`a_gi` : Gravito-inertial acceleration
`pa`  : Position of the first point of the tumbling axis
`pb`  : Position of the second point of the tumbling axis
`pg`  : Position of the center of gravity

*Function variables:*

OUTPUT:

* `inclination_margin`    : Inclination margin for total acceleration considering the support polyhedron [deg] (scalar)
* `inclination_margin_ab` : Inclination margin for each tumbling axis [rad] (1xn vector)

INPUT:

* `polyhedron`       : Variables to define the shape of the polyhedron (struct)
* `gia`              : Gravito-Inertial Acceleration [m/s^2] (3x1 vector)
* `equ_flag`         : Flag of equilibrium condition (1: equilibrium, 0: not in equilibrium) (scalar)

*Note:* All the inputs for this function can be obtained from `equ_gia_polyhedron_calc()`

### equ_gia_polyhedron_calc() ###

This function calculates the stability polyhedron for Gravito-Inertial Acceleration vector.

             m.a_gi.{(pg-pa)x(pg-pb)} = sum{Fj.{(pb-pj)x(pa-pj)}} + M0.(pa-pb) + F0.(pbxpa)


where:

`m`   : Total mass of the robot
`a_gi` : Gravito-inertial acceleration
`pa`  : Position of the first point of the tumbling axis
`pb`  : Position of the second point of the tumbling axis
`pg`  : Position of the center of gravity
`pj`  : Position of the other grasping points
`Fj`  : Maximum holding force for the position j
`M0`  : External moment applied to the center of gravity
`F0`  : External force applied to the center of gravity

*Function variables:*

OUTPUT:

* `polyhedron`       : Variables to define the shape of the polyhedron (struct)
  * `polyhedron.plane_point`     : Maximum accelerations in a normal direction of tumbling axis [m/s^2] (3xn matrix)
  * `polyhedron.plane_vector`    : Normal vector to tumbling axis from center of gravity (3xn matrix)
  * `polyhedron.plane_point_exp` : Point in the limit plane based on robot position and the expansion factor (3xn matrix)
  * `polyhedron.edge_vec`        : Direction vector for the edges of the polyhedron [m] (3xn matrix)
  * `polyhedron.edge_point`      : Position of a point in the line of the edge where the z position is null (3xn matrix)
  * `polyhedron.vertex`          : Position of the corners of the polyhedron (3x(n+1) matrix)
* `gia`              : Gravito-Inertial Acceleration [m/s^2] (3x1 vector)
* `equ_flag`         : Flag of equilibrium condition (1: equilibrium, 0: not in equilibrium) (scalar)

INPUT:

* `POS_e`            : End-effector (legs' contact) positions POS_e = [p1 p2 ... pn] [m] (3xn matrix) 
* `pg`               : Center of Gravity position [m] (3x1 vector)
* `a_g`              : Acceleration of the center of gravity [m/s^2] (3x1 vector)
* `mass`             : Total mass of the robot [kg] (scalar)
* `grasp_flag`       : Flag of grasping condition of each leg (1: grasping, 0: not grasping) (1xn vector)
* `F_hold`           : Maximum holding force [N] (scalar)
* `F0`               : External force acting at the center of gravity [N] (3x1 vector)
* `M0`               : External moment acting at the center of gravity [Nm] (3x1 vector)
* `plot_on`          : Variable to plot polyhedron (1: plot, 2: do not plot) (logic)
* `floor_base`       : Vertical (z-axis) coordinate of floor for polyhedron base [m] (scalar, only applicable if `plot_on = 1`)
* `expansion_factor` : Expansion factor for the acceleration vector compared to the position vectors (scalar, only applicable if `plot_on = 1`)


USAGE EXAMPLE:
```
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

[polyhedron, gia, equ_flag] = equ_gia_polyhedron_calc(POS_e, pg, a_g, mass, grasp_flag, F_hold, F0, M0, plot_on, floor_base, expansion_factor);


```

*Note:* The example above can be found in the directory `\eg`, including some visualization features. Please add `\eg`, `\lib\tools` and `\src` to your MATLAB path before running. 


### equ_tumbling_axes_ab() ###

This function calculates all possible tumbling axes numbering, accordingly to the number of the supporting legs. This function requires that the numbering order of legs follows either a clockwise or counter-clockwise sequence.


*Function variables:*

OUTPUT:

* `tumbling_axes`           : Matrix with the number legs for tumbling axes (matrix: tumbling_axes_number x 2). Each row represents one tumbling axis, while the columns represent the number of the leg for that specific axis
* `tumbling_axes_number`    : Total number of possible tumbling axis (scalar)

INPUT:

* `n`                       : Total number of legs (scalar)
* `grasp_flag`       : Flag of grasping condition of each leg (1: grasping, 0: not grasping) (1xn vector)

*Note:* This function is required for `equ_gia_polyhedron_calc()`

### gia_limit() ###

This function calculates maximum GIA acceleration for direction normal to the tumbling axis

*Function variables:*

OUTPUT:

* `gia_limit_nab`       : Acceleration limit for all possible tumbling axis faces of the equilibrium polyhedron (3xab_num matrix)

INPUT:

* `n`                       : Total number of legs (scalar)
* `grasp_flag`       : Flag of grasping condition of each leg (1: grasping, 0: not grasping) (1xn vector)
* `mass`             : Total mass of the robot [kg] (scalar)
* `tumbling_axes`           : Matrix with the number legs for tumbling axes (matrix: tumbling_axes_number x 2). Each row represents one tumbling axis, while the columns represent the number of the leg for that specific axis
* `tumbling_axes_number`    : Total number of possible tumbling axis (scalar)
* `POS_e`            : End-effector (legs' contact) positions POS_e = [p1 p2 ... pn] [m] (3xn matrix) 
* `F0`               : External force acting at the center of gravity [N] (3x1 vector)
* `M0`               : External moment acting at the center of gravity [Nm] (3x1 vector)
* `F_hold`           : Maximum holding force [N] (scalar)


%        n_ab                 : Normal vector for all possible tumbling axis faces of the equilibrium polyhedron (3xab_num matrix)
%        n_ab_u               : Unit normal vector for all possible tumbling axis faces of the equilibrium polyhedron 
%                              (3xab_num matrix)

*Note:* This function is required for `equ_gia_polyhedron_calc()`


