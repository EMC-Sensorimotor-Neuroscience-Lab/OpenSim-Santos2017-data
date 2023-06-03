% function Measurements = loadHuawei2020_Motion()
%LOADHUAWEI2020_MOTION loads pre-computed angles of ankle, knee, and hip

Data_path = "Santos_original\"
Output_path = "Santos_transformed\"
Info_path = "PDSinfo.txt"

%% Load subject data
Measurements = readtable(Info_path);
Measurements.bool_read = zeros(size(Measurements,1), 1);
Measurements.bool_transform = zeros(size(Measurements,1), 1);

Measurements.bool_read(Measurements.Vision == "Open" & Measurements.Subject == 1,:) = 1;
Measurements.bool_transform(Measurements.Vision == "Open" & Measurements.Subject == 1,:) = 1;

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
grf_names = readtable("grf_names.xlsx", 'VariableNamingRule', 'preserve');

%% Save renamed marker data to the selected measurements
Measurements.mkr_Rajagopal = cell(size(Measurements.mkr));
Measurements.grf_Rajagopal = cell(size(Measurements.grf));
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
    
            % Store marker data and transform axes to enforce X forward
            if (markerRajagopal ~= "") && (markerSantos ~= "")
                X = mkr_transformed.(markerSantos + "_X");
                Y = mkr_transformed.(markerSantos + "_Y");
                Z = mkr_transformed.(markerSantos + "_Z");
    
                T_marker.(markerRajagopal) = 1000*[X,Y,Z];
            end
        end

        T_grf = table();
        T_grf.time = Measurements.mkr{i}.Time;
        T_grf.time = linspace(min(T_grf.time), max(T_grf.time), length(T_grf.time))'; %some measurements contain skipped measuremnts, normalize time here
        
        for j = 1:size(grf_names,1)
            grf_transformed = Measurements.grf{i};
            grfSantos = string(grf_names{j,2});
            grfRajagopal = string(grf_names{j,1});
    
            % Store forces and transform axes to enforce X forward
            if (grfRajagopal ~= "") && (grfSantos ~= "")
                T_grf.(grfRajagopal) = grf_transformed.(grfSantos);
            end
        end
        Measurements.mkr_Rajagopal{i} = T_marker;
        Measurements.grf_Rajagopal{i} = T_grf;
    end
end

%% Save kinematic data to trc
for i = 1:size(Measurements, 1)  
    if Measurements.bool_transform(i) == 1
        filename = [Measurements.Trial{i} + "mkr_Rajagopal.trc"];
        measurement = Measurements(i,:);

        T_marker = measurement.mkr_Rajagopal{1};
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
        for j = 3:size(mainlabels,2)
            mainlabelsWithWhitespace = [mainlabelsWithWhitespace, mainlabels(j), nan, nan];
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
        
        writematrix(out, Output_path + filename, 'Delimiter', 'tab', 'FileType','text')
    end
end

%% Save force data to mot file
for i = 1:size(Measurements, 1)  
    if Measurements.bool_transform(i) == 1
        filename = [Measurements.Trial{i} + "grf_Rajagopal.mot"];
        measurement = Measurements(i,:);

        T_grf = measurement.grf_Rajagopal{1};
        width = size(T_grf,2);
        
        header = [
            filename;
            "version=1";
            "datarows "+string(size(T_grf,1));
            "datacolumns " + string(size(T_grf,2));
            "range " + string(min(T_grf.time)) + " " + string(max(T_grf.time))
            "endheader"
            ];

        A = T_grf.Variables;
        colNames1 = string(T_grf.Properties.VariableNames);
        
        emptyNextToHeader = nan(size(header,1), (size(A,2)-1));

        out = [
            header, emptyNextToHeader;
            colNames1;
            A
            ];
        
        writematrix(out, Output_path + filename, 'Delimiter', 'tab', 'FileType','text')
    end
end





