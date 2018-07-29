nx=2160; ny=540;

f1='../MITgcm/run/diags_llc2160_02/surface.0000000015.data';
f2='../MITgcm/run/diags_llc2160_03/surface.0000000015.data';
f3='../MITgcm/run/diags_llc2160_04/surface.0000000015.data';
f4='../MITgcm/run/diags_ll2160_01/surface.0000000015.data';
f5='../MITgcm/run/diags_ll2160_02/surface.0000000015.data';
f6='../MITgcm/run/diags_ll2160_03/surface.0000000015.data';

e1=zeros(nx,ny);
e1(1:nx/4,:)=rot90(readbin(f1,[nx/4 ny],1,'real*4',2),3);
e1(nx/4+1:nx/2,:)=rot90(readbin(f1,[nx/4 ny],1,'real*4',3),3);
e1(nx/2+1:nx,:)=readbin(f1,[nx/2 ny]);
clf, orient tall, wysiwyg
subplot(611), mypcolor(e1'); caxis([-1 1]/2), colormap(jet), colorbar
title('ETAN at hour 1 in m for llc2160.02: Joern''s set-up ported to pleiades')

e2=zeros(nx,ny);
e2(1:nx/4,:)=rot90(readbin(f2,[nx/4 ny],1,'real*4',2),3);
e2(nx/4+1:nx/2,:)=rot90(readbin(f2,[nx/4 ny],1,'real*4',3),3);
e2(nx/2+1:nx,:)=readbin(f2,[nx/2 ny]);
subplot(612), mypcolor(e2'-e1'); caxis([-1 1]/2e6), colormap(jet), colorbar
title('llc2160.02-llc2160.01: split atmospheric pressure and tidal forcing')

e3=zeros(nx,ny);
e3(1:nx/4,:)=rot90(readbin(f3,[nx/4 ny],1,'real*4',2),3);
e3(nx/4+1:nx/2,:)=rot90(readbin(f3,[nx/4 ny],1,'real*4',3),3);
e3(nx/2+1:nx,:)=readbin(f3,[nx/2 ny]);
subplot(613), mypcolor(e3'-e2'); caxis([-1 1]/20), colormap(jet), colorbar
title(['llc2160.03-llc2160.02: jra55 "mean sea level pressure" vs "surface pressure"'])

e4=readbin(f4,[nx ny]);
subplot(614), mypcolor(e4'-e3'); caxis([-1 1]/80), colormap(jet), colorbar
title(['ll2160.01-llc2160.03: lat/lon vs llc configuration'])

e5=readbin(f5,[nx ny]);
subplot(615), mypcolor(e5'-e4'); caxis([-1 1]/1e4), colormap(jet), colorbar
title(['ll2160.02-ll2160.01: 1-degree vs jra55 tidal forcing'])

e6=readbin(f6,[nx ny]);
subplot(616), mypcolor(e6'-e5'); caxis([-1 1]/10), colormap(jet), colorbar
title(['ll2160.03-ll2160.02: January 2008 vs 2013'])
