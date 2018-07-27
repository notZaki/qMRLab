function qmrfit(sourceFolder,qFitJson,outFolder)

assignin('base','srcFolder',sourceFolder);

% Foo model initialization
ModelList = list_models;

for ii = 1:length(ModelList)
    try
        eval(['foo=' ModelList{ii} ';'])
    catch
        error(['Cannot initiate ' ModelList{ii}]);
    end
end



if ~exist('outFolder','var')
    warning('No output folder has been defined. Results will be saved in the same directory.');
    outFolder = sourceFolder;
end

% Future: Add BIDS control here
% Assume BIDS if multiple JSON files are present

if ~exist('qFitJson','var')
    tempJson = dir(fullfile(sourceFolder,'*.json'));
    
    if not(isempty(tempJson.name))
        
        json = [sourceFolder filesep tempJson.name];
        
    elseif not(isempty(tempJson.name)) && length(tempJson)>1
        
        % Some more things here
        
    else
        error('Json file is missing for fit params.')
    end
    
else
    
    json = qFitJson;
    
end

root = loadjson(json);
modelName = fieldnames(root);

obj = str2func(modelName{1});
Model = obj();
props = root.(modelName{1});

[Model, data] = prepFit(Model,props);

FitResults = FitData(data,Model,0);

save([outFolder filesep 'FitResults.mat'],'FitResults');

disp('--------------------')

end


function [modelOut, data] = prepFit(modelIn,props)

modelOut = modelIn;

nestedFlag = nestedCheck(props, modelIn.ModelName);

if nestedFlag
    
    % Means that input data should be parsed to get qDim
    Prot = struct();
    
    % Assuming only the first one can be multidim
    
    eval(['tmpModel = ' modelName ';']);
    
    subnames = fieldnames(props.(tmpModel.MRIinputs{1}));
    
    TIvec = zeros(length(subnames),1);
    
    for ii = 1:length(subnames)
        
        switch modelName
            
            case 'inversion_recovery'
                
                TIvec(ii,1) = props.(tmpModel.MRIinputs{1}).(subnames{ii}).InversionTime;
        end
    end
    % Complete later
    
    switch modelName
        
        case 'inversion_recovery'
            
            Prot.IRData.Mat = TIvec;
            
    end
    
    modelOut.Prot = getNestedProt(props,modelIn.ModelName);
    
elseif not(nestedFlag)
    
    % Means that input data contains qDim
    
    modelOut.Prot = getFlatProt(props,modelIn.ModelName);
    
end



data = getDataField(props,nestedFlag);


end

function data = getDataField(props, nestedFlag)

% Edit this to read and parse multi data. 

data = struct();

srcFolder = evalin('base','srcFolder');

fnames = fieldnames(props);

for ii=1:length(fnames)
    
    curName = props.(fnames{ii}).Filename;
    
    switch getInpFormat(curName)
        
        case 'nifti'
            
            curData = double(load_nii_data([srcFolder filesep curName]));
            disp([curName ' ==> ' '[' num2str(size(curData)) ']']);
            
        case 'matlab'
            
            load([srcFolder filesep curName]);
            dt = curName(1:end-4);
            curData = eval(dt);
            curData = double(curData);
            disp([curName ' ==> ' '[' num2str(size(curData)) ']']);
            
    end
    
    data.(fnames{ii}) = curData;
    
end

end

function fType = getInpFormat(fileName)

loc = max(strfind(fileName, '.'));
frm = fileName(loc+1:end);
if strcmp(frm,'gz') || strcmp(frm,'nii')
    fType = 'nifti';
elseif strcmp(frm,'mat')
    fType = 'matlab';
end

end

function bool = nestedCheck(props,modelName)


eval(['tmpModel = ' modelName ';']);

% Assuming only the first one can be multidim
fnames = fieldnames(props.(tmpModel.MRIinputs{1}));

if isstruct(props.(tmpModel.MRIinputs{1}).(fnames{1}))
    
    bool = 1;
else
    
    bool = 0;
    
end

end

function Prot = getNestedProt(props,modelName)

ME_missing = MException('qMRfit:MissingInputParam', 'Please check input parameters in JSON');
ME_wrong = MException('qMRfit:WrongInput', 'Improper input parameter is passed');

Prot = struct();

% Assuming only the first one can bfunction qmrfit(sourceFolder,qFitJson,outFolder)

assignin('base','srcFolder',sourceFolder);

% Foo model initialization
ModelList = list_models;

for ii = 1:length(ModelList)
    try
        eval(['foo=' ModelList{ii} ';'])
    catch
        error(['Cannot initiate ' ModelList{ii}]);
    end
end



if ~exist('outFolder','var')
    warning('No output folder has been defined. Results will be saved in the same directory.');
    outFolder = sourceFolder;
end

% Future: Add BIDS control here
% Assume BIDS if multiple JSON files are present

if ~exist('qFitJson','var')
    tempJson = dir(fullfile(sourceFolder,'*.json'));
    
    if not(isempty(tempJson.name))
        
        json = [sourceFolder filesep tempJson.name];
        
    elseif not(isempty(tempJson.name)) && length(tempJson)>1
        
        % Some more things here
        
    else
        error('Json file is missing for fit params.')
    end
    
else
    
    json = qFitJson;
    
end

root = loadjson(json);
modelName = fieldnames(root);

obj = str2func(modelName{1});
Model = obj();
props = root.(modelName{1});

[Model, data] = prepFit(Model,props);

FitResults = FitData(data,Model,0);

save([outFolder filesep 'FitResults.mat'],'FitResults');

disp('--------------------')

end


function [modelOut, data] = prepFit(modelIn,props)

modelOut = modelIn;

nestedFlag = nestedCheck(props, modelIn.ModelName);

if nestedFlag
    
    % Means that input data should be parsed to get qDim
    Prot = struct();
    
    % Assuming only the first one can be multidim
    
    eval(['tmpModel = ' modelName ';']);
    
    subnames = fieldnames(props.(tmpModel.MRIinputs{1}));
    
    TIvec = zeros(length(subnames),1);
    
    for ii = 1:length(subnames)
        
        switch modelName
            
            case 'inversion_recovery'
                
                TIvec(ii,1) = props.(tmpModel.MRIinputs{1}).(subnames{ii}).InversionTime;
        end
    end
    % Complete later
    
    switch modelName
        
        case 'inversion_recovery'
            
            Prot.IRData.Mat = TIvec;
            
    end
    
    modelOut.Prot = getNestedProt(props,modelIn.ModelName);
    
elseif not(nestedFlag)
    
    % Means that input data contains qDim
    
    modelOut.Prot = getFlatProt(props,modelIn.ModelName);
    
end



data = getDataField(props,nestedFlag);


end

function data = getDataField(props, nestedFlag)

data = struct();

srcFolder = evalin('base','srcFolder');

fnames = fieldnames(props);

for ii=1:length(fnames)
    
    curName = props.(fnames{ii}).Filename;
    
    switch getInpFormat(curName)
        
        case 'nifti'
            
            curData = double(load_nii_data([srcFolder filesep curName]));
            disp([curName ' ==> ' '[' num2str(size(curData)) ']']);
            
        case 'matlab'
            
            load([srcFolder filesep curName]);
            dt = curName(1:end-4);
            curData = eval(dt);
            curData = double(curData);
            disp([curName ' ==> ' '[' num2str(size(curData)) ']']);
            
    end
    
    data.(fnames{ii}) = curData;
    
end

end

function fType = getInpFormat(fileName)

loc = max(strfind(fileName, '.'));
frm = fileName(loc+1:end);
if strcmp(frm,'gz') || strcmp(frm,'nii')
    fType = 'nifti';
elseif strcmp(frm,'mat')
    fType = 'matlab';
end

end

function bool = nestedCheck(props,modelName)


eval(['tmpModel = ' modelName ';']);

% Assuming only the first one can be multidim
fnames = fieldnames(props.(tmpModel.MRIinputs{1}));

if isstruct(props.(tmpModel.MRIinputs{1}).(fnames{1}))
    
    bool = 1;
else
    
    bool = 0;
    
end

end

function Prot = getNestedProt(props,modelName)

ME_missing = MException('qMRfit:MissingInputParam', 'Please check input parameters in JSON');
ME_wrong = MException('qMRfit:WrongInput', 'Improper input parameter is passed');

Prot = struct();

% Assuming only the first one can be multidim

eval(['tmpModel = ' modelName ';']);

subnames = fieldnames(props.(tmpModel.MRIinputs{1}));

TIvec = zeros(length(subnames),1);

for ii = 1:length(subnames)
    
    switch modelName
        
        case 'inversion_recovery'
            try
                if isempty(props.(tmpModel.MRIinputs{1}).(subnames{ii}).InversionTime); ME_missing.throw(); end
                if length(props.(tmpModel.MRIinputs{1}).(subnames{ii}).InversionTime)>1; ME_wrong.throw(); end
                TIvec(ii,1) = props.(tmpModel.MRIinputs{1}).(subnames{ii}).InversionTime;
            catch
                error('Please check subfields of IRData in JSON.')
            end
    end
end
% Complete later

switch modelName
    
    case 'inversion_recovery'
        
        Prot.IRData.Mat = TIvec;
        
end




end

function Prot = getFlatProt(props,modelName)

Prot = struct();

fnames = fieldnames(props);
inLen = length(fnames);

eval(['curModel = ' modelName ';']);

reqFields = curModel.MRIinputs(logical(not(curModel.get_MRIinputs_optional)));
reqLen = length(reqFields);

if not(all(ismember(reqFields,fnames))); error('Missing non-optional field'); end

if inLen - reqLen > 0; disp(['Detected ' num2str(inLen-reqLen) ' optional input(s).']); end

ME_missing = MException('qMRfit:MissingInputParam', 'Please check input parameters in JSON');
ME_wrong = MException('qMRfit:WrongInput', 'Improper input parameter is passed');

switch modelName
    
    case 'mt_sat'
        
        try
            
            % Field names are used explicitly to catch if there is a
            % mismatch in JSON file.
            
            Prot.MTw.Mat = [props.MTw.FlipAngle props.MTw.RepetitionTime];
            Prot.PDw.Mat = [props.PDw.FlipAngle props.PDw.RepetitionTime];
            Prot.T1w.Mat = [props.T1w.FlipAngle props.T1w.RepetitionTime];
            
            
            for ii=1:reqLen
                
                if any(structfun(@isempty, props.(reqFields{ii})));  ME_missing.throw(); end
                
            end
            
            
        catch
            
            
            error('Expected: (i) FlipAngle (ii) RepetitionTime');
            
        end
        
    case 'inversion_recovery'
        
        
        try
            
            Prot.IRData.Mat = transpose(props.IRData.InversionTime);
            
            if length(props.IRData.InversionTime)==1; ME_wrong.throw(); end
            
        catch
            
            error('Expected: (i) InversionTime in vector form');
            
        end
end

ende multidim

eval(['tmpModel = ' modelName ';']);

subnames = fieldnames(props.(tmpModel.MRIinputs{1}));

TIvec = zeros(length(subnames),1);

for ii = 1:length(subnames)
    
    switch modelName
        
        case 'inversion_recovery'
            try
                if isempty(props.(tmpModel.MRIinputs{1}).(subnames{ii}).InversionTime); ME_missing.throw(); end
                if length(props.(tmpModel.MRIinputs{1}).(subnames{ii}).InversionTime)>1; ME_wrong.throw(); end
                TIvec(ii,1) = props.(tmpModel.MRIinputs{1}).(subnames{ii}).InversionTime;
            catch
                error('Please check subfields of IRData in JSON.')
            end
    end
end
% Complete later

switch modelName
    
    case 'inversion_recovery'
        
        Prot.IRData.Mat = TIvec;
        
end




end

function Prot = getFlatProt(props,modelName)

Prot = struct();

fnames = fieldnames(props);
inLen = length(fnames);

eval(['curModel = ' modelName ';']);

reqFields = curModel.MRIinputs(logical(not(curModel.get_MRIinputs_optional)));
reqLen = length(reqFields);

if not(all(ismember(reqFields,fnames))); error('Missing non-optional field'); end

if inLen - reqLen > 0; disp(['Detected ' num2str(inLen-reqLen) ' optional input(s).']); end

ME_missing = MException('qMRfit:MissingInputParam', 'Please check input parameters in JSON');
ME_wrong = MException('qMRfit:WrongInput', 'Improper input parameter is passed');

switch modelName
    
    case 'mt_sat'
        
        try
            
            % Field names are used explicitly to catch if there is a
            % mismatch in JSON file.
            
            Prot.MTw.Mat = [props.MTw.FlipAngle props.MTw.RepetitionTime];
            Prot.PDw.Mat = [props.PDw.FlipAngle props.PDw.RepetitionTime];
            Prot.T1w.Mat = [props.T1w.FlipAngle props.T1w.RepetitionTime];
            
            
            for ii=1:reqLen
                
                if any(structfun(@isempty, props.(reqFields{ii})));  ME_missing.throw(); end
                
            end
            
            
        catch
            
            
            error('Expected: (i) FlipAngle (ii) RepetitionTime');
            
        end
        
    case 'inversion_recovery'
        
        
        try
            
            Prot.IRData.Mat = transpose(props.IRData.InversionTime);
            
            if length(props.IRData.InversionTime)==1; ME_wrong.throw(); end
            
        catch
            
            error('Expected: (i) InversionTime in vector form');
            
        end
end

end
