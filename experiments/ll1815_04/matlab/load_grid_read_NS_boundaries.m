% Loads grid from MITgcm mds (uses rdmds from MITgcm utils) files 
% and caclulates the tidal amplitude and phase at the N and S edges
% using TMD (Tidal model driver v2.5).
% Conversion/correction to  prescribed startdate using 
% tidalconversioncorrection function from 
% https://github.com/glwagner/nestedModelMaker/tree/master/src 
% depnds on tmd_extract_HC.m and tidalConversionCorrection.m
rDir = '/central/groups/oceanphysics/anirban/NA/experiments/run_ll1815_03/'
xC=rdmds([rDir 'XC']);
yC=rdmds([rDir 'YC']);
xG=rdmds([rDir 'XG']);
yG=rdmds([rDir 'YG']);

x_u_N = xG(:,531);
x_u_S = xG(:,3);
y_u_N = yC(:,531);
y_u_S = yC(:,3);

x_v_N = xC(:,531);
x_v_S = xC(:,3);
y_v_N = yG(:,531);
y_v_S = yG(:,3);

%outdir='/central/groups/oceanphysics/anirban/tideBC_tpxo7_AO/'
%[am_v_N,ph_v_N,h_v_N,cl_v_N] = tmd_extract_HC('DATA_tpxo7_AO/Model_AO_atlas',y_v_N,x_v_N,'v');
%[am_u_N,ph_u_N,h_u_N,cl_u_N] = tmd_extract_HC('DATA_tpxo7_AO/Model_AO_atlas',y_u_N,x_u_N,'v');
%[am_v_S,ph_v_S,h_v_S,cl_v_S] = tmd_extract_HC('DATA_tpxo7_AO/Model_AO_atlas',y_v_S,x_v_S,'v');
%[am_u_S,ph_u_S,h_u_S,cl_u_S] = tmd_extract_HC('DATA_tpxo7_AO/Model_AO_atlas',y_u_S,x_u_S,'v');

outdir='/central/groups/oceanphysics/anirban/tideBC_tpxo7/'
[am_v_N,ph_v_N,h_v_N,cl_v_N] = tmd_extract_HC('DATA_tpxo7/Model_tpxo7_atlas',y_v_N,x_v_N,'v');
[am_u_N,ph_u_N,h_u_N,cl_u_N] = tmd_extract_HC('DATA_tpxo7/Model_tpxo7_atlas',y_u_N,x_u_N,'v');
[am_v_S,ph_v_S,h_v_S,cl_v_S] = tmd_extract_HC('DATA_tpxo7/Model_tpxo7_atlas',y_v_S,x_v_S,'v');
[am_u_S,ph_u_S,h_u_S,cl_u_S] = tmd_extract_HC('DATA_tpxo7/Model_tpxo7_atlas',y_u_S,x_u_S,'v');

%outdir='/central/groups/oceanphysics/anirban/tideBC_tpxo8/'
%[am_v_N,ph_v_N,h_v_N,cl_v_N] = tmd_extract_HC('DATA_tpxo8_compact/Model_atlas_v1',y_v_N,x_v_N,'v');
%[am_u_N,ph_u_N,h_u_N,cl_u_N] = tmd_extract_HC('DATA_tpxo8_compact/Model_atlas_v1',y_u_N,x_u_N,'v');
%[am_v_S,ph_v_S,h_v_S,cl_v_S] = tmd_extract_HC('DATA_tpxo8_compact/Model_atlas_v1',y_v_S,x_v_S,'v');
%[am_u_S,ph_u_S,h_u_S,cl_u_S] = tmd_extract_HC('DATA_tpxo8_compact/Model_atlas_v1',y_u_S,x_u_S,'v');

%startdate = datenum(1992,1,1);
startdate = datenum(2003,1,1)
[am_v_N,ph_v_N]= tidalConversionCorrection(startdate, am_v_N, ph_v_N, cl_v_N);
[am_v_S,ph_v_S]= tidalConversionCorrection(startdate, am_v_S, ph_v_S, cl_v_S);
[am_u_N,ph_u_N]= tidalConversionCorrection(startdate, am_u_N, ph_u_N, cl_u_N);
[am_u_S,ph_u_S]= tidalConversionCorrection(startdate, am_u_S, ph_u_S, cl_u_S);

% REPLACE NaNs with zeros (at land masked regions)
am_v_N(isnan(am_v_N)) = 0;
am_u_N(isnan(am_u_N)) = 0;
am_v_S(isnan(am_v_S)) = 0;
am_u_S(isnan(am_u_S)) = 0;

ph_v_N(isnan(ph_v_N)) = 0;
ph_u_N(isnan(ph_u_N)) = 0;
ph_v_S(isnan(ph_v_S)) = 0;
ph_u_S(isnan(ph_u_S)) = 0;

nconst = size(am_v_N,1);
n = size(am_v_N,2);
% SAVE AMPLITUDES
filename = sprintf('OBNvam_%dx%d.bin', n, nconst);
file = fopen([outdir, filename], 'w', 'ieee-be');
fwrite(file, am_v_N', 'real*4');
fclose(file);

filename = sprintf('OBSvam_%dx%d.bin', n, nconst);
file = fopen([outdir, filename], 'w', 'ieee-be');
fwrite(file, am_v_S', 'real*4');
fclose(file);

filename = sprintf('OBNuam_%dx%d.bin', n, nconst);
file = fopen([outdir, filename], 'w', 'ieee-be');
fwrite(file, am_u_N', 'real*4');
fclose(file);

filename = sprintf('OBSuam_%dx%d.bin', n, nconst);
file = fopen([outdir, filename], 'w', 'ieee-be');
fwrite(file, am_u_S', 'real*4');
fclose(file);

% SAVE PHASES
filename = sprintf('OBNvph_%dx%d.bin', n, nconst);
file = fopen([outdir, filename], 'w', 'ieee-be');
fwrite(file, ph_v_N', 'real*4');
fclose(file);

filename = sprintf('OBSvph_%dx%d.bin', n, nconst);
file = fopen([outdir, filename], 'w', 'ieee-be');
fwrite(file, ph_v_S', 'real*4');
fclose(file);

filename = sprintf('OBNuph_%dx%d.bin', n, nconst);
file = fopen([outdir, filename], 'w', 'ieee-be');
fwrite(file, ph_u_N', 'real*4');
fclose(file);

filename = sprintf('OBSuph_%dx%d.bin', n, nconst);
file = fopen([outdir, filename], 'w', 'ieee-be');
fwrite(file, ph_u_S', 'real*4');
fclose(file);


