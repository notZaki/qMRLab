disp(pwd);
bootstrapTest;
res=moxunit_runtests('BatchExample_test.m','-with_coverage','-cover',pwd,'-cover_exclude','*GUI*','-cover_json_file','coverage_BatchExample.json');
assert(~res,'Nope.');