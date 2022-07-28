MATLAB Environment for Software Simulation


> Software Needed

1) Systems Tool Kit (STK)
    -Main data source and visualization
    -Provides access window and sun pointing data (as quaternions)
    -Can also provide disturbance torques
        -Currently, only magnetic disturbances are supported
        -Solar radiation pressure and aerodynamic torques are possible, but not yet implemented
    -Provides a 3D visualization environment
        -Can view the satellite and its attitude control

2) MATLAB
    -Main programming language and sciprting done here
        -Used to control and automate data extraction from STK
    -Create an object to model the satellite with components and subsystems
        -Simulate the state of this satellite with data extracted from STK
    -Visualize the various state variables with graphs
        -Shows error and deviation from ideal behavior in attitude related state variables


> How to Run
1) Navigate to configuration files
    -Open MATLAB and navigate to '/SatelliteControlStuff/satelliteControl'
    -Edit configuration files to simulate the desired time and satellite
        1) 'runthisonly.m'
            -Scenario parameters for STK (name, start time and stop time)
                -Keep the total duration less than 3 hours (2 orbits) unless the computer is high performance
            -Ground station parameters (location and sensor)
                -Can add as many ground stations as needed but 3 is more than sufficient for most cases
            -Satellite parameters (orbit and sensor)
                -Create a mock scenario to figure out the exact orbit parameters AHEAD OF TIME!
        2) 'createSatelliteModel.m'
            -Command System (safe and unsafe operation)
                -Used to define what is considered safe operation and decide on the decision tree
            -Power System (battery, solar panels, and electrical loads)
                -Used to define power consumption and generation for the satellite
            -Attitude System (reaction wheels and control torque, star tracker, magnetorquer)
                -Simulation of a simplified ADCS (with custom error)
2) Custom edits
    -The following are custom edits that CAN be made should the need arise but will require time to learn the software
        1) Custom Control Code
            -Navigate to 'SatelliteControlStuff/satelliteControl/src/objects/components/reactionWheel.m'
            -Scroll down to the method called 'controlTorque' and rewrite the control algorithm as desired
                -To add more inputs, need to add the variable here and in the main simulation loop
                    -Navigate to 'SatelliteControlStuff/satelliteControl/src/objects/satelliteModel.m'
                    -Go to the method called 'simulate' and find the area for 'Control Torque'
        2) Custom Disturbance Model
            -Can be edited directly into the method above (using an equivalent mechanical model to simulate the torque)
            -Alternative is to define a variable within the workspace with custom data
                -If the custom disturbance is computed externally, there must be as many data points as the length of the timeVector
                    -Need to make sure the index variable doesn't call for a index that is out of bounds
                -Add this data directly to the satelliteModel by running a line similar to the one below in the command window
                    - 'satelliteModel.customDisturbanceTorque = customDisturbanceTorque;'
                    - You can check the size of this variable by using 'size(customDisturbanceTorque)'
                        -Ideally, it would be equal to "3 x length(timeVector)" and occur in time steps of 'dt' with {x, y, z}
                -Then within the 'simulate' method inside of 'satelliteModel.m', add a line to add the custom disturbance torque
                    - 'Mc = Mc + obj.customDisturbanceTorque(a);'
                    - This line must be added AFTER the control torque is computed 
        3) Custom Attitude Determination and Filtering
            -Navigate to 'SatelliteControlStuff/satelliteControl/src/objects/satelliteModel.m'
                -There is currently no function for adding filtering so a custom function would need to be made!
            -Create a method called 'customFiltering' with the desired inputs and ouputs ('obj' must be the first input)
            -Add this function at the end of the section on 'Attitude Determination' with the custom inputs
                -Update the state variables for the attitude determination state variables: 'obj.stateS(a,11:14)'
3) Run everything
    -Go to command window, type in 'runthisonly', and press 'Enter'
    -Below is the expected series of events
        1) STK will open and configure a blank scenario to the parameters specified
        2) STK will add the ground stations, satellite, and the numerous sensors
        3) MATLAB will start extracting data from STK and save it to memory
        4) MATLAB will create the 'satelliteModel' object and add the data stored in memory
        5) MATLAB will simulate the system dynamics (command system, power system, and attitude system)
        6) MATLAB will upload the results to the STK object for visualization
        7) MATLAB will display the results as graphs


