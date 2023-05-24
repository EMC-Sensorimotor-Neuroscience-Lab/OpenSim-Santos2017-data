function Measurements = loadHuawei2020_Motion()
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
            Measurements.grf(i) = readtable(Data_path + Measurements.Trial(i) + 'grf.txt');
        catch
            warning("Table " + Measurements.Trial(i) + " not found")
        end
    
        % Motion capture markers
        try 
            Measurements.mkr(i) = readtable(Data_path + Measurements.Trial(i) + 'mkr.txt');
        catch
            warning("Table " + Measurements.Trial(i) + " not found")
        end
    end
end






end

