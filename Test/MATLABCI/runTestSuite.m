
function [testsResults] = runTestSuite(suiteTag)
%runtests: Run tagged tests from all subdirectories
%   suiteTag: String matching tags from test classes in subdirectories
%   
    entry = pwd;

    lc = strfind(entry,'/Test');
    rtDir = entry(1:lc-1);
    tstDir = [entry filesep 'MoxUnitCompatible'];
    
    cd(rtDir);
    bootstrapTest;

    import matlab.unittest.TestSuite;
    fullSuite = TestSuite.fromFolder(tstDir, 'IncludingSubfolders', true);
    
    persistenceSuite = fullSuite.selectIf('Tag',suiteTag);
    testsResults = run(persistenceSuite)

end
