% get grid information
pin='/nobackup/dmenemen/NA/MITgcm/grid_ll1815/';
nx=1815;
ny=532;
nz=100;
XC=readbin([pin 'XC.data'],[nx ny]);
YC=readbin([pin 'YC.data'],[nx ny]);
lon=XC(:,1)+360;
lat=YC(1,:);

% plot surface speed
pin='/nobackup/dmenemen/NA/MITgcm/run/diags/';
fnm=dir([pin 'interior*data']);
for m=1:length(fnm)
    U=readbin([pin fnm(m).name],[nx ny],1,'real*4',nz*2);
    V=readbin([pin fnm(m).name],[nx ny],1,'real*4',nz*3);
    speed=sqrt(U.^2+V.^2);
    speed(find(~speed))=nan;
    %    speed=log10(speed);
    clf
    subplot(211)
    pcolorcen(lon,lat,speed');
    colormap(pink)
    caxis([0 1])
    colorbar('Position',[0.91    0.5841    0.015    0.3418])
    title(['Month ' int2str(m) ' mean surface speed (m/s)'])
    eval(['print -djpeg SurfaceSpeedMonth' myint2str(m)])
end
