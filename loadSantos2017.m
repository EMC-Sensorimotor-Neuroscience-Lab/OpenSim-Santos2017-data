% function Measurements = loadHuawei2020_Motion()
%LOADHUAWEI2020_MOTION loads pre-computed angles of ankle, knee, and hip

Data_path = "Santos_original\"
Info_path = "PDSinfo.txt"

%% Load subject data
Measurements = readtable(Info_path);
Measurements.bool_read = zeros(size(Measurements,1), 1);
Measurements.bool_transform = zeros(size(Measurements,1), 1);

Measurements.bool_read(Measurements.Subject == 2 & Measurements.Vision == "Open",:) = 1;
Measurements.bool_transform(Measurements.Subject == 2 & Measurements.Vision == "Open",:) = 1;

%% Loop through all files in the folder and fill Measurements table
for i = 1:size(Measurements,1)
    if Measurements.bool_read(i) == 1
        % Precomputed angles
        try 
            Measurements.ang(i) = {readtable(Data_path + Measurements.Trial(i) + 'ang.txt')};
        catch
            warning("Table " + Measurements.Trial(i) + " not found")
        end
    
        % Ground reaction forces
        try 
            Measurements.grf(i) = {readtable(Data_path + Measurements.Trial(i) + 'grf.txt')};
        catch
            warning("Table " + Measurements.Trial(i) + " not found")
        end
    
        % Motion capture markers
        try 
            Measurements.mkr(i) = {readtable(Data_path + Measurements.Trial(i) + 'mkr.txt', 'VariableNamingRule', 'preserve')};
        catch
            warning("Table " + Measurements.Trial(i) + " not found")
        end
    end
end

%% Marker names
mkr_names = readtable("mkr_names.xlsx", 'VariableNamingRule', 'preserve')

%% Save renamed marker data to the selected measurements
Measurements.mkr_Rajagopal = cell(size(Measurements.mkr));
for i = 1:size(Measurements,1)
    T_marker = table();
    T_marker.("Frame#") = (1:size(Measurements_selected.T_mocap{i},1))';
    T_marker.Time = Measurements_selected.T_mocap{i}.TimeStamp;
    T_marker.Time = linspace(min(T_marker.Time), max(T_marker.Time), length(T_marker.Time))'; %some measurements contain skipped measuremnts, normalize time here
    for j = 1:size(MarkerNamesHuawei2020_matched,1)
        T_mocap = Measurements_selected.T_mocap{i};
        markerHuawei = MarkerNamesHuawei2020_matched(j,1);
        markerRajagopal = MarkerNamesHuawei2020_matched(j,2);

        if markerRajagopal ~= 'false'
            X = T_mocap.(markerHuawei + "_X");
            Y = T_mocap.(markerHuawei + "_Y");
            Z = T_mocap.(markerHuawei + "_Z");

            T_marker.(markerRajagopal) = 1000*[-X,Y,-Z];
        end
    end
    Measurements_selected.T_marker{i} = T_marker;
end





