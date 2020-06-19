# List of examples

### Index ###

* Overview
* Examples
  * gia_function_simple_usage_example.m
  * test_example_robot.m

### Overview ###

This file describes the examples of usage of the stability polyhedron for Gravito-inertial Acceleration code. The examples are located at `\eg` directory and are presented in alphabetical order.

Please refer to the list of functions for more details.

### gia_function_simple_usage_example.m ###

This example is a simple test that uses the function `equ_gia_polyhedron_calc()` to define if a configuration is stable or not based on the stability polyhedron for GIA. 

This example sets 

* gravity
* contact positions
* maximum holding force
* CoG position and acceleration
* mass
* external force and moment 

to calculate the polyhedron and compare with the GIA vector. 

The resultant polyhedron is plotted along the GIA vector and the contact positions.

This example can be easily adapted for the user parameters, by changing the corresponding variables in the example code.

##### How to run this example #####

* Clone or download the `equ_gia` repository
* Add the folders `\eg`, `\lib\tools` and `\src` to your MATLAB path
* Run `gia_function_simple_usage_example.m`

### test_example_robot.m ###

This example is also a simple test, but based on a quadruped robot model defined by the [SpaceDyn toolbox](http://www.astro.mech.tohoku.ac.jp/spacedyn/index.html) variables and a pre-selected surface map.

The following parameters can be easily changed for this simulation:

* gravity
* surface inclination
* surface type (rough or flat)
* robot's base acceleration
* maximum holding force

This example also includes the calculation of gravito-inertial acceleration and inclination margins, which are exhibited in the MATLAB's command window. A figure with the model of the robot, stability polyhedron and GIA vector is also plotted at the end of the simulation.

##### How to run this example #####

* Clone or download the `equ_gia` repository
* Add the folders `\eg`, `\lib` (and all the sub-folders) and `\src` to your MATLAB path
* Run `test_example_robot.m`
