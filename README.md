# OpenSim-Santos2017-data
The code from this repository is used to transform the data from the dos Santos dataset to trc files that can be used in OpenSim.

## Scaling and inverse kinematics
To use kinematic data you should always scale the model accordingly. See the [documentation](https://simtk-confluence.stanford.edu:8443/display/OpenSim/Tutorial+3+-+Scaling%2C+Inverse+Kinematics%2C+and+Inverse+Dynamics) for useful examples.

You must add the markers from the file `markers_all.xml` to the model `Rajagopal2015_probed.osim` when running any scaling or inverse kinematics, as otherwise a lot of markers will be ignored. Both are present in the folder `Models`.

To visualize marker trajectories after performing scaling, select the motion from the `Motions` tab, right click, and hit `Associate motion data`. This will plot the model-fixed markers in pink and the original measurement data in blue. If the pink and blue markers do not coincide, or if the model has a weird posture, you will likely have to change your scaling settings.

## Static optimization
When performing static optimization, you must add reserve actuators. The current model already has reserve actuators for each joint, but there are currently no external forces.

See [documentation](https://simtk-confluence.stanford.edu:8443/display/OpenSim/Working+with+Static+Optimization) for more information.

## Metabolic costs
The example by [Dembia and Uchida](https://simtk-confluence.stanford.edu:8443/display/OpenSim/Simulation-Based+Design+to+Reduce+Metabolic+Cost) is massively helpful to understand how to calculate metabolic costs in OpenSim. The current model already has probes for all muscles, which can be read by running the analyze tool. Their tutorial explains how to run that.  The way the probes calculate metabolic cost can be found in their [documentation page](https://simtk.org/api_docs/opensim/api_docs/classOpenSim_1_1Umberger2010MuscleMetabolicsProbe.html) if you scroll down. 

It is worth noting that OpenSim muscles are much stronger than what you should expect from a real muscle. OpenSim does not store muscle masses, so the mass will be approximated as described at the `use_provided_muscle_mass ` section. This description uses the maximum force, and as a result the predictions can be excessively large. 

You can either add muscle masses to get more accurate values, or choose a surrogate measure, such as the time integral of the force ([Rebula and Kuo (2015)](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0117384).

## Force plate data
Force plate data has been added to the `.rar` file on Brightspace. The name conventions follow the convention from the [.mot documentation page](https://simtk-confluence.stanford.edu:8443/display/OpenSim/Motion+%28.mot%29+Files), so v is for forces and p for the point of application. Apply these forces on the toes. You should probably lock the joints in the foot, or at least allow the reserve actuator to maintain equilibrium.

## Converting the Santos data to trc files (see Brightspace Project 8)
The code `loadSantos2017` loads all files from the originial dataset and combines them with the information from `PDSinfo.txt`. The trc files for the eyes open conditions are on Brightspace so you can skip this step. The file `mkr_names` is used to convert the marker names from the Santos convention to any convention you prefer. The markers on the head have been omitted, you can add these yourself if you need them.
