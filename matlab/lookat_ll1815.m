% get grid information
pin='/nobackup/dmenemen/NA/MITgcm/grid_ll1815/';
nx=1815;
ny=532;
nz=100;
XC=readbin([pin 'XC.data'],[nx ny]);
YC=readbin([pin 'YC.data'],[nx ny]);
lon=XC(:,1)+360;
lat=YC(1,:);

% extract/plot surface speed
pin='/nobackup/dmenemen/NA/MITgcm/run/diags/';
pout=[pin 'SSpeed/'];
eval(['mkdir ' pout])
fnm=dir([pin 'interior*data']);
tmp=zeros(nx+1,ny+1);
for m=1:length(fnm)
    tmp(1:nx,1:ny)=readbin([pin fnm(m).name],[nx ny],1,'real*4',nz*2);
    tmp(end,:)=tmp(nx,:);
    U=(tmp(1:nx,1:ny)+tmp(2:end,1:ny))/2;
    tmp(1:nx,1:ny)=readbin([pin fnm(m).name],[nx ny],1,'real*4',nz*3);
    tmp(:,end)=tmp(:,ny);
    V=(tmp(1:nx,1:ny)+tmp(1:nx,2:end))/2;
    speed=sqrt(U.^2+V.^2);
    eval(['writebin(''' pout 'SurfaceSpeedMonth' myint2str(m,3) ''',speed);'])
    clf reset
    subplot(211)
    speed(find(~speed))=nan;
    pcolorcen(lon,lat,speed');
    colormap(pink)
    caxis([0 1])
    colorbar('Position',[0.91    0.5841    0.015    0.3418])
    title(['Month ' myint2str(m,3) ' mean surface speed (m/s)'])
    eval(['print -djpeg ' pout 'SurfaceSpeedMonth' myint2str(m,3)])
end

% extract/plot SST
pout=[pin 'SST/'];
eval(['mkdir ' pout])
for m=1:length(fnm)
    SST=readbin([pin fnm(m).name],[nx ny]);
    eval(['writebin(''' pout 'SST_Month' myint2str(m,3) ''',SST);'])
    clf reset
    subplot(211)
    SST(find(~SST))=nan;
    pcolorcen(lon,lat,SST');
    colormap(jet)
    caxis([0 30])
    colorbar('Position',[0.91    0.5841    0.015    0.3418])
    title(['Month ' myint2str(m,3) ' SST (^oC)'])
    eval(['print -djpeg ' pout 'SST_Month' myint2str(m,3)])
end
