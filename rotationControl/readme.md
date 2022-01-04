Overview of code

FILES TO RUN
1) rotationTest.m
-File to run
-Will create block, simulate, and play animation

2) seeData.m
-View data from rotationTest.m
-Shows quaternion data (desired and simulated for both)

NECESARY FILES
1) block.m
-Class that lets you create an object and simulate it
-Read the file if you want details (I'm not putting all of it here)

2) dynRotCon.m
-Dynamics for Rotational Control based on quaternions and angular velocity (entirely)

MISCELLANEOUS FILES
1) unitStep.m
-Unit step function that is easy for me to use

2) cpm.m
-Cross product matrix

3) q2a.m
-Converts 4 quaternions to an attitude profile

4) e2q.m
-Converts 3 euler angles to 4 quaternions

5) qp.m
-Quaternion multiplication

6) quatCM.m
-Quaternion error based control moment (torque)


That's everything
