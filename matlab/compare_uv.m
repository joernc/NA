nx=2160; ny=540; nz=100;

f1='../MITgcm/run/diags_llc2160_04/interior.0000000015.data';
f2='../MITgcm/run/diags_ll2160_01/interior.0000000015.data';

f1='../MITgcm/run/diags_llc2160_04/interior.0000000015.data';
f2='../MITgcm/run/diags_llc2160_04_noOBCStides/interior.0000000015.data';

u1=zeros(nx,ny);
u1(1:nx/4,:)=rot90(readbin(f1,[nx/4 ny],1,'real*4',300*4+2),3);
u1(nx/4+1:nx/2,:)=rot90(readbin(f1,[nx/4 ny],1,'real*4',300*4+3),3);
u1(nx/2+1:nx,:)=readbin(f1,[nx/2 ny],1,'real*4',200*2);
figure(1), clf, orient tall, wysiwyg
subplot(611), mypcolor(u1'); caxis([-1 1]/2), colormap(jet), colorbar
title('U at hour 1 in m/s for llc2160_04')

u2=readbin(f2,[nx ny],1,'real*4',200);
subplot(612), mypcolor(u2'); caxis([-1 1]/2), colormap(jet), colorbar
title('U at hour 1 in m/s for ll2160.01')

subplot(613), mypcolor(u2'-u1'); caxis([-1 1]/1e3), colormap(jet), colorbar
title(['U ( ll2160.01 - llc2160.04 ): lat/lon vs llc configuration'])

v1=zeros(nx,ny);
tmp=-rot90(readbin(f1,[nx/4 ny],1,'real*4',200*4+2),3);
v1(1:nx/4,2:end)=tmp(:,1:end-1);
tmp=-rot90(readbin(f1,[nx/4 ny],1,'real*4',200*4+3),3);
v1(nx/4+1:nx/2,2:end)=tmp(:,1:end-1);
v1(nx/2+1:nx,:)=readbin(f1,[nx/2 ny],1,'real*4',300*2);
subplot(614), mypcolor(v1'); caxis([-1 1]/2), colormap(jet), colorbar
title('V at hour 1 in m/s for llc2160_04')

v2=readbin(f2,[nx ny],1,'real*4',300);
subplot(615), mypcolor(v2'); caxis([-1 1]/2), colormap(jet), colorbar
title('V at hour 1 in m/s for ll2160.01')

subplot(616), mypcolor(v2'-v1'); caxis([-1 1]/1e3), colormap(jet), colorbar
title(['V ( ll2160.01 - llc2160.04 ): lat/lon vs llc configuration'])

figure(2), clf
subplot(211), plot(1:nx,v1(:,8),1:nx,v2(:,8))
title('U at hour 1 in m/s for llc2160_04')
subplot(212), plot(1:nx,v2(:,8)-v1(:,8))
title('U at hour 1 in m/s for llc2160_04')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nx=2160; ny=540; nz=100;

f1='../MITgcm/run/diags_llc2160_04/interior.0000000015.data';
f2='../MITgcm/run/diags_llc2160_04_noBalance/interior.0000000015.data';

f3='../MITgcm/run/diags_ll2160_01/interior.0000000015.data';
f4='../MITgcm/run/diags_ll2160_01_noBalance/interior.0000000015.data';

u1=zeros(nx,ny);
u1(1:nx/4,:)=rot90(readbin(f1,[nx/4 ny],1,'real*4',300*4+2),3);
u1(nx/4+1:nx/2,:)=rot90(readbin(f1,[nx/4 ny],1,'real*4',300*4+3),3);
u1(nx/2+1:nx,:)=readbin(f1,[nx/2 ny],1,'real*4',200*2);
u2=zeros(nx,ny);
u2(1:nx/4,:)=rot90(readbin(f2,[nx/4 ny],1,'real*4',300*4+2),3);
u2(nx/4+1:nx/2,:)=rot90(readbin(f2,[nx/4 ny],1,'real*4',300*4+3),3);
u2(nx/2+1:nx,:)=readbin(f2,[nx/2 ny],1,'real*4',200*2);
u3=readbin(f3,[nx ny],1,'real*4',200);
u4=readbin(f4,[nx ny],1,'real*4',200);

figure(1), clf, orient tall, wysiwyg
subplot(411), mypcolor(u1'); caxis([-1 1]/2), colormap(jet), colorbar
title('U at hour 1 in m/s for llc2160.04')
subplot(412), mypcolor(u1'-u2'); caxis([-1 1]/500), colormap(jet), colorbar
title(['llc2160.04 - llc2160.04.noBalance'])
subplot(413), mypcolor(u2'-u4'); caxis([-1 1]/1e6), colormap(jet), colorbar
title(['llc2160.04.noBalance - ll2160.01.noBalance'])
subplot(414), mypcolor(u1'-u3'); caxis([-1 1]/500), colormap(jet), colorbar
title(['llc2160.04 - ll2160.01'])

v1=zeros(nx,ny);
tmp=-rot90(readbin(f1,[nx/4 ny],1,'real*4',200*4+2),3);
v1(1:nx/4,2:end)=tmp(:,1:end-1);
tmp=-rot90(readbin(f1,[nx/4 ny],1,'real*4',200*4+3),3);
v1(nx/4+1:nx/2,2:end)=tmp(:,1:end-1);
v1(nx/2+1:nx,:)=readbin(f1,[nx/2 ny],1,'real*4',300*2);
v2=zeros(nx,ny);
tmp=-rot90(readbin(f2,[nx/4 ny],1,'real*4',200*4+2),3);
v2(1:nx/4,2:end)=tmp(:,1:end-1);
tmp=-rot90(readbin(f2,[nx/4 ny],1,'real*4',200*4+3),3);
v2(nx/4+1:nx/2,2:end)=tmp(:,1:end-1);
v2(nx/2+1:nx,:)=readbin(f2,[nx/2 ny],1,'real*4',300*2);
v3=readbin(f3,[nx ny],1,'real*4',300);
v4=readbin(f4,[nx ny],1,'real*4',300);

figure(1), clf, orient tall, wysiwyg
subplot(411), mypcolor(v1'); caxis([-1 1]/2), colormap(jet), colorbar
title('V at hour 1 in m/s for llc2160.04')
subplot(412), mypcolor(v1'-v2'); caxis([-1 1]/500), colormap(jet), colorbar
title(['llc2160.04 - llc2160.04.noBalance'])
subplot(413), mypcolor(v2'-v4'); caxis([-1 1]/1e6), colormap(jet), colorbar
title(['llc2160.04.noBalance - ll2160.01.noBalance'])
subplot(414), mypcolor(v1'-v3'); caxis([-1 1]/500), colormap(jet), colorbar
title(['llc2160.04 - ll2160.01'])

figure(2), clf, orient tall, wysiwyg
subplot(411), plot(1:nx,v1(:,8),1:nx,v2(:,8),1:nx,v3(:,8),1:nx,v4(:,8))
title('V at hour 1 in m/s')
subplot(412), plot(v1(:,8)-v2(:,8))
title(['llc2160.04 - llc2160.04.noBalance'])
subplot(413), plot(v2(:,8)-v4(:,8))
title(['llc2160.04.noBalance - ll2160.01.noBalance'])
subplot(414), plot(v1(:,8)-v3(:,8))
title(['llc2160.04 - ll2160.01'])
