function deplist = compileModels

MethodList = list_models;
depList  = struct();

for ii = 1:length(MethodList)
    disp(['Collecting dependency list for ' MethodList{ii}]);   
    deplist(ii).fList = matlab.codetools.requiredFilesAndProducts([MethodList{ii} '.m']);
end









end