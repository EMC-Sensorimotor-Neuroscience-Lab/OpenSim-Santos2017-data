% Save data from Huawei2020 dataset as trc file.
% For trc documentation, see
% - https://simtk-confluence.stanford.edu:8443/display/OpenSim/Marker+%28.trc%29+Files

% Add utilities
addpath("Utilities Matlab\Preprocessing\")

%% Load data
Measurements = loadHuawei2020_Motion()
Measurements_selected = Measurements((string(Measurements.trialName) == "0001") & (string(Measurements.subjectName) ~= "Subj08"), :)

%% Marker names
MarkerNamesRajagopal2015 = [
    "RACR"
    "LACR"
    "C7"
    "CLAV"
    "RASH"
    "RPSH"
    "LASH"
    "LPSH"
    "RSJC"
    "RUA1"
    "RUA2"
    "RUA3"
    "RLEL"
    "RMEL"
    "RFAsuperior"
    "RFAradius"
    "RFAulna"
    "LSJC"
    "LUA1"
    "LUA2"
    "LUA3"
    "LLEL"
    "LMEL"
    "LFAsuperior"
    "LFAradius"
    "LFAulna"
    "RASI"
    "LASI"
    "RPSI"
    "LPSI"
    "LHJC"
    "RHJC"
    "RTH1"
    "RTH2"
    "RTH3"
    "RLFC"
    "RMFC"
    "RKJC"
    "RTB1"
    "RTB2"
    "RTB3"
    "RLMAL"
    "RMMAL"
    "RAJC"
    "RCAL"
    "RTOE"
    "RMT5"
    "LTH1"
    "LTH2"
    "LTH3"
    "LLFC"
    "LMFC"
    "LKCJ"
    "LTB1"
    "LTB2"
    "LTB3"
    "LLMAL"
    "LMMAL"
    "LAJC"
    "LCAL"
    "LTOE"
    "LMT5"
    "REJC"
    "LEJC"
    "R_tibial_plateau"
    "L_tibial_plateau"
]

MarkerNamesHuawei2020_matched = [
    "T10" "T10"
    "SACR" "SACR"
    "NAVE" "NAVE"
    "XYPH" "XYPH"
    "STRN" "CLAV"
    "LASIS" "LASI"
    "RASIS" "RASI"
    "LPSIS" "LPSI"
    "RPSIS" "RPSI"
    "LGTRO" "LGTRO"
    "FLTHI" "LTH1"
    "LLEK" "LLFC"
    "LATI" "LTB2"
    "LLM" "LLMAL"
    "LHEE" "LCAL"
    "LTOE" "LTOE"
    "LMT5" "LMT5"
    "RGTRO" "RGTRO"
    "FRTHI" "RTH1"
    "RLEK" "RLFC"
    "RATI" "RTB2"
    "RLM" "RLMAL"
    "RHEE" "RCAL"
    "RTOE" "RTOE"
    "RMT5" "RMT5"
    "RACR" "RACR"
    "LACR" "LACR"
    "T1" false
    "T2" false
    "T3" false
    "T4" false
    "T5" false
]

%% Save renamed marker data to the selected measurements
Measurements_selected.T_marker = cell(size(Measurements_selected.T_mocap));
for i = 1:size(Measurements_selected,1)
    T_marker = table();
    T_marker.("Frame#") = (1:size(Measurements_selected.T_mocap{i},1))';
    T_marker.Time = Measurements_selected.T_mocap{i}.TimeStamp;
    T_marker.Time = linspace(min(T_marker.Time), max(T_marker.Time), length(T_marker.Time))'; %some measurements contain skipped measuremnts, normalize time here
    for j = 1:size(MarkerNamesHuawei2020_matched,1)
        T_mocap = Measurements_selected.T_mocap{i};
        markerHuawei = MarkerNamesHuawei2020_matched(j,1);
        markerRajagopal = MarkerNamesHuawei2020_matched(j,2);

        if markerRajagopal ~= 'false'
            X = T_mocap.(markerHuawei + "_PosX");
            Y = T_mocap.(markerHuawei + "_PosY");
            Z = T_mocap.(markerHuawei + "_PosZ");

            T_marker.(markerRajagopal) = 1000*[-X,Y,-Z];
        end
    end
    Measurements_selected.T_marker{i} = T_marker;
end

%% Plot markers
figure; hold on; axis equal
xlabel('X'); ylabel('Y'); zlabel('Z')
T_marker_plot = Measurements_selected.T_marker{3};
for i = 3:size(T_marker_plot,2)
    marker = T_marker_plot{:,i};
    plot3(marker(:,1), marker(:,2), marker(:,3))
end
plot3(Measurements_selected.T_mocap{1}.T1_PosX*1000, Measurements_selected.T_mocap{1}.T1_PosY*1000, Measurements_selected.T_mocap{1}.T1_PosZ*1000, 'x')
plot3(Measurements_selected.T_mocap{1}.T2_PosX*1000, Measurements_selected.T_mocap{1}.T2_PosY*1000, Measurements_selected.T_mocap{1}.T2_PosZ*1000, 'x')
plot3(Measurements_selected.T_mocap{1}.T3_PosX*1000, Measurements_selected.T_mocap{1}.T3_PosY*1000, Measurements_selected.T_mocap{1}.T3_PosZ*1000, 'x')
plot3(Measurements_selected.T_mocap{1}.T4_PosX*1000, Measurements_selected.T_mocap{1}.T4_PosY*1000, Measurements_selected.T_mocap{1}.T4_PosZ*1000, 'x')
plot3(Measurements_selected.T_mocap{1}.T5_PosX*1000, Measurements_selected.T_mocap{1}.T5_PosY*1000, Measurements_selected.T_mocap{1}.T5_PosZ*1000, 'x')

%% Plot markers 2D
figure; hold on; axis equal
xlabel('X'); ylabel('Y')
T_marker_plot = Measurements_selected.T_marker{2};
for i = 3:size(T_marker_plot,2)
    marker = T_marker_plot{:,i};
    plot(marker(:,1), marker(:,2))
end

%% Save data to an array
filename = ['Huawei_Subj06_T0001.trc'];

for i = 1:size(Measurements_selected, 1)  
    measurement = Measurements_selected(i,:);
    T_marker = measurement.T_marker{1};
    filename = ['Huawei_', measurement.subjectName, '_T', measurement.trialName '.trc'];
    width = 2 + 3*(size(T_marker,2)-2);
    
    autoheader1 = ["PathFileType" "4" "(X/Y/Z)" "filename.trc"];
    autoheader2 = [
        "DataRate" 100
        "CameraRate" 100
        "NumFrames" size(T_marker,1)
        "NumMarkers" size(T_marker,2)-2
        "Units" "mm"
        "OrigDataRate" 100
        "OrigDataStartFrame" 1
        "OrigNumFrames" size(T_marker,1)
        ]';
    
    mainlabels = string(T_marker.Properties.VariableNames);
    mainlabelsWithWhitespace = mainlabels(1:2);
    for i = 3:size(mainlabels,2)
        mainlabelsWithWhitespace = [mainlabelsWithWhitespace, mainlabels(i), nan, nan];
    %     mainlabelsWithWhitespace = [mainlabelsWithWhitespace, mainlabels(i)]
    end
    
    sublabelmatrix = ["X","Y","Z"]' + string(1:(size(T_marker,2)-2));
    sublabels = [nan, nan, sublabelmatrix(:)'];
    emptyrow = nan(1,size(sublabels,2));
    
    out = [
        autoheader1, nan(size(autoheader1,1), (width - size(autoheader1,2)));
        autoheader2, nan(size(autoheader2,1), (width - size(autoheader2,2)));
        mainlabelsWithWhitespace, nan(size(mainlabelsWithWhitespace,1), (width - size(mainlabelsWithWhitespace,2)));
        sublabels
        emptyrow
        T_marker.Variables
        ];
    
    emptycolumn = nan(size(out,1),1);
    out = [out, emptycolumn];
    
    writematrix(out, filename, 'Delimiter', 'tab', 'FileType','text')
end





