desiredAttitude

Goal
-Simulate a satellite in orbit (sensors and orbit specific)
-Obtain access windows over a time period
-Interpolate in access window to obtain finer resolution
-Obtain a desired attitude profile in interpolated values
-Upload desired attitude file to satellite (confirm it works)

List of Relevant Code
	- openSTK.m (run)
		- Opens STK and creates a scenario (start and stop time speified)
		- Adds a facility with a sensor
			- Semi-sphere with a range of 1500 km
		- Adds a satellite with a sensor
			- Very narrow view with similar range (1501 km)
			- Sensor points along the Body X direction
		- Computes access windows (satellite and ground station sensor)
		- Resets animation period
	- afECF.m
		- Get access window information
			- Other functions get the relevant data
		- Create the attitude file (.a)
		- Load the file onto the satellite
	- getPointingVector.m
		- Gets access window times to interpolate over
			- Other function get this data
		- Use satellite and facility data providers (position)
			- Both are in Earth Centered Fixed Frame
			- List of pointing data for interpolated times
	- interpolateXs.m
		- Given a list of access windows
		- Interpolates the times using a fixed time step
	- countTime.m (run afECF.m here)
		- Counts the number of points (interpolated times)

How to run
1) openSTK.m
2) afECF(scenario, satellite, facility, access, scenarioStartTime, interval) [1]
3) CHECK
	-Open scenario in STK and reset animation
	-Go to a time before first access window (few seconds before)
	-Decrease time step and play animation (slower is better)
	-Satellite sensor should completely cover the access line
	-As the satellites moves, the attitude profile should change accordingly
	-The access line should ALWAYS remain inside the sensor cone!
		If this condition is not met, reduce the interval 
		-Satellite was in a circular orbit with 350 km altitude
		-Satellite sensor had a half cone angle of 1 deg
		-Ground station range was set to 1500 km
		-For me, an interval of 0.1 seconds was very smooth and accurate


[1] Change satellite sensor settings (persistence)
1) Go to object browser in STK
2) Right click 'sSensor' under Satellite object
3) Go into Properties and make the following changes
	-

