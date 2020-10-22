% sesh is a string ('02')
% sesh refers to the session number of the UPCOMING EM task
% patientID is a string ('sub-1013')
function prepNextEMsesh(basepath, patientID, sesh)
disp('Prepping stimulus material for upcoming session.')
sourceFolder = [basepath, '\image_data\EMtune\formatted_180-180\stimMat\']; % all 359 possible stimuli that can be used in the task minus the ones used in the practice run

myStim = loadLogs_tEMt_em(basepath, patientID, sesh); % used stimuli

% IDENTIFY UNUSED IMAGES FOR NEXT SESSION
allIm = dir([sourceFolder, '*.jpg']);
remainIm = setdiff({allIm.name}, myStim);

% create session folder for next session
newSeshFold = [basepath, '\image_data\EMtune\formatted_180-180\subjectSpecific\', patientID, filesep, 'sesh', sesh, filesep];
mkdir(newSeshFold)

for ix = 1:numel( remainIm )
    copyfile([sourceFolder, remainIm{ix}], newSeshFold);
end
end