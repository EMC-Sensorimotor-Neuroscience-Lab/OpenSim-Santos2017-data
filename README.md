# OpenSim-Santos2017-data
The code from this repository is used to transform the data from the dos Santos dataset to trc files that can be used in OpenSim.

## Scaling and inverse kinematics
To use kinematic data you should always scale the model accordingly. See the documentation for useful examples:
https://simtk-confluence.stanford.edu:8443/display/OpenSim/Tutorial+3+-+Scaling%2C+Inverse+Kinematics%2C+and+Inverse+Dynamics

You must add the markers from the file `markers_all.xml` to the model `Rajagopal2015_probed.osim` when running any scaling or inverse kinematics, as otherwise a lot of markers will be ignored. Both are present in the folder `Models`.

To visualize marker trajectories after performing scaling, select the motion from the `Motions` tab, right click, and hit `Associate motion data`. This will plot the model-fixed markers in pink and the original measurement data in blue. If the pink and blue markers do not coincide, or if the model has a weird posture, you will likely have to change your scaling settings.

## Static optimization
When performing static optimization, you must add reserve actuators. The current model already has reserve actuators for each joint, but there are currently no external forces.

## Force plate data
I am currently working on the force plate data. This paragraph will be updated once they have been converted.

## Converting the Santos data to trc files (see Brightspace Project 8)
The code `loadSantos2017` loads all files from the originial dataset and combines them with the information from `PDSinfo.txt`. The trc files for the eyes open conditions are on Brightspace so you can skip this step. The file `mkr_names` is used to convert the marker names from the Santos convention to any convention you prefer. The markers on the head have been omitted, you can add these yourself if you need them.
