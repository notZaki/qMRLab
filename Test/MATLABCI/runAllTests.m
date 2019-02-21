entry = pwd;

lc = strfind(entry,'/Test');
rtDir = entry(1:lc-1);

cd(rtDir);
disp(['Entered ' pwd]);



bootstrapTest; % This should add them all.
res=moxunit_runtests([rtDir filesep 'Test/MoxUnitCompatible/BatchExample_test.m']);
assert(~res,'Nope.');