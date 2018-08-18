% MATLAB commands used on August 18, 2018 to
% extract 1815x532 lat/lon input files in
% /nobackup/dmenemen/tarballs/NA_2160/input_ll1815
% based on 2160x540lat/lon input files in
% /nobackup/dmenemen/tarballs/NA_2160/input_ll
%
% It also uses output files from experiments/ll2160_04,
% which at the time were in
% /nobackup/dmenemen/NA/MITgcm/run/diags_llc2160_04
%
% 532 factors: 1 2 4 7 14 19 28 38 76 133 266
% 1815 factors: 1 3 5 11 15 33 55 121 165 363 605

cd /nobackup/dmenemen/tarballs/NA_2160/input_ll1815
nx=2160; ix=35:1849;
ny= 540; iy= 7: 538;
nz= 100;
pin='../input_ll/';

fnm='delYFile';
tmp=readbin([pin fnm],[ny]);
writebin(fnm,tmp(iy));

fnm='bathy.bin';
tmp=readbin([pin fnm],[nx ny]);
writebin(fnm,tmp(ix,iy));

for fld={'S0','T0','U0','V0'}
    tmp=readbin([pin fld{1} '_2160x540x100.bin'],[nx ny nz]);
    writebin([fld{1} '_1815x532x100.bin'],tmp(ix,iy,:));
end

for fld={'OBNam','OBNph','OBSam','OBSph'}
    tmp=readbin([pin fld{1} '_2160x13.bin'],[nx 13]);
    writebin([fld{1} '_1815x13.bin'],tmp(ix,:));
end

for fld={'OBNs','OBNt','OBNu','OBNv','OBSs','OBSt','OBSu','OBSv'}
    tmp=readbin([pin fld{1} '_2160x100x26.bin'],[nx nz 26]);
    writebin([fld{1} '_1815x100x26.bin'],tmp(ix,:,:));
end
