function Measurements = loadHuawei2020_Motion()
%LOADHUAWEI2020_MOTION loads pre-computed angles of ankle, knee, and hip

Data_path = "Data/Huawei2020/Processed_Data"

%% Load subject data


%% Create table with all measurements
% Each measurement has its own row with all information regarding this
% measurement.
% One participant could contribute multiple valid trials if desired.
% Each measurement row stores
%     - Table T with time series measurements
%     - Subject information
%     - Values that are constant during the trial, such as distance between origins of force plates

Measurements = table();

%% Loop through all files in the folder and fill Measurements table
% Get list of all files in the desired data folder (subfolders are not
%  used)
files = dir(Data_path +  ("/Subj*/Motion*.txt"));

for file = files'
    out = table(); %initialize output structure
    out.file = file;

    % Get measurement information from file name
    name_split = string(split(file.name, ".")); %remove file extension
    subjectName = file.folder(end-5:end); %eg. Subj03
    fileName = char(name_split(1)); 
    
    % Store subject and trial names
    out.subjectName = subjectName;
    out.trialName = fileName(end-3:end);
    
    % Read data as table
    out.T_motion = {readtable(file.folder + "\" + fileName)};
    out.T_mocap = {readtable(file.folder + "\" + "Mocap" + out.trialName)};

    out.Properties.RowNames = string(out.subjectName) + string(out.trialName); %set row name

    % Store output struct to Measurements table
    Measurements = [Measurements;out];
end



end

