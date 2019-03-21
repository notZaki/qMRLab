entry = pwd;

lc = strfind(entry,'/Test');
rtDir = entry(1:lc-1);

cd(rtDir);
disp(['Entered ' pwd]);



bootstrapTest; % This should add them all.
disp('We have more space!!!!');
res=moxunit_runtests([rtDir filesep 'Test/MoxUnitCompatible'],'-recursive');
assert(~res,'Batch example test cannot pass.');
