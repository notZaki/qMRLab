entry = pwd;

lc = strfind(entry,'/Test');
rtDir = entry(1:lc-1);

cd(rtDir);
disp(['Entered ' pwd]);



bootstrapTest; % This should add them all.
disp('We have more space!!!!');
disp('Equation tests');
%res=moxunit_runtests([rtDir filesep 'Test/MoxUnitCompatible/equation_test'],'-recursive');
%assert(~res,'Batch example test cannot pass.');

disp('Quick Mox Tests');
%res=moxunit_runtests([rtDir filesep 'Test/MoxUnitCompatible/quickMoxTests'],'-recursive');
%assert(~res,'Batch example test cannot pass.');

lst = dir(fullfile(pwd,'*.m'));

for ii=1:length(lst)
    
    disp('====================');
    disp(lst(ii).name);
    eval(lst(ii).name(1:end-2));
    %assert(~res,'Batch example test cannot pass.');

end


