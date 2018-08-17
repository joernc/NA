nx=2160; ny=540;

f1='../MITgcm/run/diags_llc2160_02/surface.0000000015.data';
f2='../MITgcm/run/diags_llc2160_03/surface.0000000015.data';
f3='../MITgcm/run/diags_llc2160_04/surface.0000000015.data';
f4='../MITgcm/run/diags_ll2160_01/surface.0000000015.data';
f5='../MITgcm/run/diags_ll2160_02/surface.0000000015.data';
f6='../MITgcm/run/diags_ll2160_03/surface.0000000015.data';
f7='../MITgcm/run/diags_ll2160_04/surface.0000000015.data';

e1=zeros(nx,ny);
e1(1:nx/4,:)=rot90(readbin(f1,[nx/4 ny],1,'real*4',2),3);
e1(nx/4+1:nx/2,:)=rot90(readbin(f1,[nx/4 ny],1,'real*4',3),3);
e1(nx/2+1:nx,:)=readbin(f1,[nx/2 ny]);
figure(1), clf, orient tall, wysiwyg
subplot(711), mypcolor(e1'); caxis([-1 1]/2), colormap(jet), colorbar
title('ETAN at hour 1 in m for llc2160.02: Joern''s set-up ported to pleiades')

e2=zeros(nx,ny);
e2(1:nx/4,:)=rot90(readbin(f2,[nx/4 ny],1,'real*4',2),3);
e2(nx/4+1:nx/2,:)=rot90(readbin(f2,[nx/4 ny],1,'real*4',3),3);
e2(nx/2+1:nx,:)=readbin(f2,[nx/2 ny]);
subplot(712), mypcolor(e2'-e1'); caxis([-1 1]/2e6), colormap(jet), colorbar
title('llc2160.03 - llc2160.02: split atmospheric pressure and tidal forcing')

e3=zeros(nx,ny);
e3(1:nx/4,:)=rot90(readbin(f3,[nx/4 ny],1,'real*4',2),3);
e3(nx/4+1:nx/2,:)=rot90(readbin(f3,[nx/4 ny],1,'real*4',3),3);
e3(nx/2+1:nx,:)=readbin(f3,[nx/2 ny]);
subplot(713), mypcolor(e3'-e2'); caxis([-1 1]/20), colormap(jet), colorbar
title(['llc2160.04 - llc2160.03: JRA55 "mean sea level pressure" vs "surface pressure"'])

e4=readbin(f4,[nx ny]);
subplot(714), mypcolor(e4'-e3'); caxis([-1 1]/80), colormap(jet), colorbar
title(['ll2160.01 - llc2160.04: lat/lon vs llc configuration'])

e5=readbin(f5,[nx ny]);
subplot(715), mypcolor(e5'-e4'); caxis([-1 1]/1e4), colormap(jet), colorbar
title(['ll2160.02 - ll2160.01: 1-degree vs JRA55 tidal forcing'])

e6=readbin(f6,[nx ny]);
subplot(716), mypcolor(e6'-e5'); caxis([-1 1]/10), colormap(jet), colorbar
title(['ll2160.03 - ll2160.02: start in 2008 vs 2003'])

e7=readbin(f7,[nx ny]);
subplot(717), mypcolor(e7'-e6'); caxis([-1 1]/100), colormap(jet), colorbar
title(['ll2160.04-ll2160.03: ERA5 vs JRA55'])

print -djpeg eta

%%%%%%%%%%%%%%%%%%%%%%%%%

f1='../../tarballs/NA_2160/jra55/tide_2003';
f2='../../tarballs/NA_2160/tides/tide_2003';
t0=readbin(f1,[640 320],1,'real*4',0)/1029;
t1=readbin(f1,[640 320],1,'real*4',1)/1029;
t2=readbin(f2,[360 181],1,'real*4',1);
lon1=0:.5625:359.9;
dy=[0 .556914, .560202, .560946, .561227, .561363, ...
      .561440, .561487, .561518, .561539, .561554, ...
      .561566, .561575, .561582, .561587, .561592, ...
      ones(1,289)*.561619268965519, ...
      .561592, .561587, .561582, .561575, .561566, ...
      .561554, .561539, .561518, .561487, .561440, ...
      .561363, .561227, .560946, .560202, .556914];
lat1=-89.57009+cumsum(dy);
lon=0:359; lat=-90:90;
t0i=interp2(lat1,lon1',t0,lat,lon');
t1i=interp2(lat1,lon1',t1,lat,lon');
td=(t1i+t0i)/2;

figure(2), clf, orient tall, wysiwyg
subplot(711), mypcolor(lon1,lat1,t0')
set(gca,'xticklabel',[]), colorbar, plotland
title('jra55/tide2003 / 1029, hour 00:30 (record 1)')
subplot(712), mypcolor(lon1,lat1,t1')
set(gca,'xticklabel',[]), colorbar, plotland
title('jra55/tide2003 / 1029, hour 01:30 (record 2)')
subplot(713), mypcolor(lon1,lat1,t1'-t0')
set(gca,'xticklabel',[]), colorbar, plotland
title('difference: panel 2 - panel 1')
subplot(714), mypcolor(lon,lat,t2')
set(gca,'xticklabel',[]), colorbar, plotland
title('tides/tide2003 / 1029, hour 01:00 (record 2)')
subplot(715), mypcolor(lon,lat,t2'-t0i')
set(gca,'xticklabel',[]), colorbar, plotland
title('difference: panel 4 - panel 1')
subplot(716), mypcolor(lon,lat,t2'-t1i')
set(gca,'xticklabel',[]), colorbar, plotland
title('difference: panel 4 - panel 2')
subplot(717), mypcolor(lon,lat,t2'-td'), colorbar, plotland
title('difference: panel 4 - ( panel 1 + panel 2 ) / 2')

%%%%%%%%%%%%%%%%%%%%%%%%%

pn='../MITgcm/run/diags_ll2160_01/';
xc=readbin([pn 'XC.data'],[nx ny]);
yc=readbin([pn 'YC.data'],[nx ny]);

ix=find(lon>=min(xc(:)+360)&lon<=max(xc(:)+360));
iy=find(lat>=min(yc(:))&lat<=max(yc(:)));

figure(3), clf
mypcolor(lon(ix),lat(iy),t2(ix,iy)'-td(ix,iy)'), colorbar
title('difference: panel 4 - ( panel 1 + panel 2 ) / 2')
