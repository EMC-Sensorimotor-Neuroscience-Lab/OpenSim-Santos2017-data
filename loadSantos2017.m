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
mkr_names = readtable("mkr_names.xlsx", 'VariableNamingRule', 'preserve');

%% Save renamed marker data to the selected measurements
Measurements.mkr_Rajagopal = cell(size(Measurements.mkr));
for i = 1:size(Measurements,1)
    if Measurements.bool_read(i) == 1 && Measurements.bool_transform(i) == 1
        T_marker = table();
        T_marker.("Frame#") = (1:size(Measurements.mkr{i},1))';
        T_marker.Time = Measurements.mkr{i}.Time;
        T_marker.Time = linspace(min(T_marker.Time), max(T_marker.Time), length(T_marker.Time))'; %some measurements contain skipped measuremnts, normalize time here
        for j = 1:size(mkr_names,1)
            mkr_transformed = Measurements.mkr{i};
            markerSantos = string(mkr_names{j,2});
            markerRajagopal = string(mkr_names{j,1});
    
            if (markerRajagopal ~= "") && (markerSantos ~= "")
                X = mkr_transformed.(markerSantos + "_X");
                Y = mkr_transformed.(markerSantos + "_Y");
                Z = mkr_transformed.(markerSantos + "_Z");
    
                T_marker.(markerRajagopal) = 1000*[-X,Y,-Z];
            end
        end
        Measurements.mkr_Rajagopal{i} = T_marker;
    end
end





