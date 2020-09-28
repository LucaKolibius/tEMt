function [myStim] = loadLogs_tEMt
% specify logfile name
dir(['C:\Experiments\tEMt_041219\EMpairs_v5_2017-09-11\log\EM\','*tEMt*txt']); % shows all logfiles in current directory
logFilename = input('What is the name of the Log-File? ', 's');

%% read logfile
% Initialize variables.
raw = [];
filename = logFilename;
delimiter = '\t';
startRow = 7;

% Read columns of data as text:
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

% Open the text file.
fileID = fopen(['C:\Experiments\tEMt_041219\EMpairs_v5_2017-09-11\log\EM\', filename], 'r');
if fileID == -1
    error('Could not open file. Invalid fileID');
end

% Read columns of data according to the format.
% this does not work on matlab 2016a
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

% Close the text file.
fclose(fileID);

% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end

myStim = raw(1:end,2:3); % converts from logfile
myStim = reshape(myStim, 1,[]); % reshapes variable to be a 1xN vector
myStim = cellfun(@cellstr, myStim);
myStim = unique(myStim); % only counts unique occurences of strings in myPref

end % end of function