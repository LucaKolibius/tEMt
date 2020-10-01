function findPics(basepath, patientID, sesh)
% addpath('C:\Experiments\tuning_fVSp_13022019\');
% addpath('C:\Experiments\tuning_tEMt_041219\functions\');
basepathEM = regexprep(basepath, 'tuning_tEMt_041219\\EMpairs_v5_2017-05-01', 'EMpairs_v5_2017-09-11');
myStim     = loadLogs_tEMt(basepathEM, patientID, sesh); % finds the unique stimulus labels used in the specified logfile

% session folder with all the images used for post tuning
d = datestr(now,'ddmmyyyy');
destination = [basepath, '\image_data\Tune\', patientID, filesep, 'sesh',sesh, '_postEM_',d, filesep];
mkdir(destination)

% this is where the stimuli come from
sourceFolder = [basepathEM, '\image_data\EMtune\formatted_180-180\stimMat\']; % all 359 possible stimuli that can be used in the task minus the ones used in the practice run

for i = 1:numel( myStim )
    if ~isempty(myStim{i})
        try
            copyfile([sourceFolder, myStim{i}], destination);
        catch
            disp(['Could not copy', myStim(i)]);
            continue
        end
    end
end

% how long will the tuning session last?
etf = numel(myStim)*1.2*6/60;

% for 100% / 25% / 50% / 75%
disp(sprintf('ETF: %.2f (%.2f, %.2f, %.2f) minutes.', round(etf), round(etf/4), round(etf/2), round(etf/4*3)));

end % end of function


% %% if it should be a short session
% elseif strcmp(seshpDay,'2')
% raw_second = loadLogs_tuning('second');
%
% %%
% myStim_temp = raw_second(1:end,2:4); % converts from logfile
% myStim_temp = reshape(myStim_temp, 1,[]); % reshapes variable to be a 1xN vector
%
% for i = 1:numel(myStim_temp)
%     test(1, i) = myStim_temp{1,i};
% end
% myStim_temp = unique(test); % only counts unique occurences of strings in myPref
%
% myStim2 = setdiff(myStim_temp, myStim); % this finds the cell arrays that are in myStim_temp, but not in my myStim
%
% % name folder for tuning session. this folder will be in the directory
% % "destination"
%
% cd(sourceFolder)
% for i = 1:numel( myStim2 )
%     % create the session folder
%     if i==1
%         mkdir( seshfolder );
%     end
%
%     source = myStim2{i};
%
%     try
%         copyfile( source, seshfolder);
%     catch
%         disp(['Could not copy', myStim2(i)]);
%         continue
%     end
% end
%
% % how long will the tuning session last?
% etf = numel(myStim2)*1.2*6/60;
%
% % for 100% / 25% / 50% / 75%
% disp(sprintf('ETF: %.2f (%.2f, %.2f, %.2f) minutes.', round(etf), round(etf/4), round(etf/2), round(etf/4*3)));
%
% end