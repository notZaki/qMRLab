
function [testsResults] = runTestSuite(suiteTag)
%runtests: Run tagged tests from all subdirectories
%   suiteTag: String matching tags from test classes in subdirectories
%   
    entry = pwd;

    lc = strfind(entry,'/Test');
    rtDir = entry(1:lc-1);

    lc2 = strfind(entry,'/MATLABCI');
    tstDir = entry(1:lc2-1);;
    
    cd(rtDir);
    bootstrapTest;

    %import matlab.unittest.TestSuite;
    %fullSuite = TestSuite.fromFolder([tstDir filesep 'MoxUnitCompatible'], 'IncludingSubfolders', true);
    
    %persistenceSuite = fullSuite.selectIf('Tag',suiteTag);
    %testsResults = run(persistenceSuite)

    res=moxunit_runtests([rtDir filesep 'Test/MoxUnitCompatible/equation_test'],'-recursive');
    assert(logical(res),'Equation test test cannot pass.');

    res=moxunit_runtests([rtDir filesep 'Test/MoxUnitCompatible/quickMoxTests'],'-recursive');
    assert(logical(res),'Quickmox test test cannot pass.');

    



end
