function qmrFitBIDS(path)

list = dir(fullfile(path,'*.json'));
dif = struct();
first = loadjson(list(1).name);
ignoreFields = {'SeriesDescription','ProtocolName','SeriesNumber','AcquisitionTime','SAR'};

% Temporary, to be improved 

for i= 2:length(list)
        
    [~,~,dif(i-1).dif] = comp_struct(first,loadjson(list(i).name)); 
     
    dif(1).dif = rmfield(dif(1).dif,ignoreFields); 

end


remNames = fieldnames(dif(1).dif);
all = fieldnames(first);
idx = ismember(all,remNames);
first = rmfield(first,all(not(idx)));

% Here assuming that BIDS will let us understand which model it is. 

Model = vfa_t1;
FlipAngle = [first.FlipAngle; dif(1).dif.FlipAngle];
TR = [first.RepetitionTime; dif(1).dif.RepetitionTime];
Model.Prot.VFAData.Mat = [ FlipAngle TR];

tmp = load_nii_data([list(1).name(1:end-5) '.nii']);

dat = zeros([size(tmp) length(list)]);

for i=1:length(list)
    
    dat(:,:,:,i) = load_nii_data([list(i).name(1:end-5) '.nii']);
    
end


% Take a slice for demo

dat = dat(:,:,100,:);


data = struct();

data.VFAData = dat;

FitResults = FitData(data,Model,0);

FitResults.Model = Model; % qMRLab output.

% -------------------------------------------------------------------------
%%       C- SHOW FITTING RESULTS 
%           |- Output map will be displayed.
%			|- If available, a graph will be displayed to show fitting in a voxel.
% -------------------------------------------------------------------------
data.Mask = msk;
qMRshowOutput(FitResults,data,Model);

end




