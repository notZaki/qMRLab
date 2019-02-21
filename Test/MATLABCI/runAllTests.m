entry = pwd;

lc = strfind(entry,'/Test');
rtDir = entry(1:lc-1);

% /users/mss.system.Ax1P4l/build/Test/MATLABCI is the startup
% when you pass -sd "Test/MATLABCI". 

cd(rtDir);
disp(['Entered ' pwd]);
list(ls);
bootstrapTest; % This should add them all.
res=moxunit_runtests('BatchExample_test.m','-with_coverage','-cover',pwd,'-cover_exclude','*GUI*','-cover_json_file','coverage_BatchExample.json');
assert(~res,'Nope.');