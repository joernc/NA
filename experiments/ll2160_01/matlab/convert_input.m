% MATLAB commands used on July 23, 2018 to create input files for
% lat/lon configuration in /nobackup/dmenemen/tarballs/NA_2160/input_ll
% based on llc input files in /nobackup/dmenemen/tarballs/NA_2160/input
% It also uses output files from experiments/llc2160_04, which at the
% time were in /nobackup/dmenemen/NA/MITgcm/run/diags_llc2160_04

cd /nobackup/dmenemen/tarballs/NA_2160/input_ll
nx=2160;
ny=540;
nz=100;
pin='../input/';

fnm='/nobackup/dmenemen/NA/MITgcm/run/diags_llc2160_04/YG.data';
tmp=readbin(fnm,[nx/2 ny]);
delY=zeros(ny,1);
delY(1:ny-1)=diff(tmp(1,:));
delY(ny)=2*delY(ny-1)-delY(ny-2);
writebin('delYFile',delY);

fnm='bathy.bin';
tmp=zeros(nx,ny);
tmp(1:nx/4,:)=rot90(readbin([pin fnm],[nx/4 ny],1,'real*4',2),3);
tmp(nx/4+1:nx/2,:)=rot90(readbin([pin fnm],[nx/4 ny],1,'real*4',3),3);
tmp(nx/2+1:nx,:)=readbin([pin fnm],[nx/2 ny]);
mypcolor(tmp'); colorbar
writebin(fnm,tmp);

fnm='S0_2160x540x100.bin';
tmp=zeros(nx,ny);
for k=1:nz
    tmp(1:nx/4,:)=rot90(readbin([pin fnm],[nx/4 ny],1,'real*4',2+(k-1)*4),3);
    tmp(nx/4+1:nx/2,:)=rot90(readbin([pin fnm],[nx/4 ny],1,'real*4',3+(k-1)*4),3);
    tmp(nx/2+1:nx,:)=readbin([pin fnm],[nx/2 ny],1,'real*4',(k-1)*2);
    mypcolor(tmp'); title(k), colorbar
    pause(.01)
    writebin(fnm,tmp,1,'real*4',k-1);
end

fnm='T0_2160x540x100.bin';
tmp=zeros(nx,ny);
for k=1:nz
    tmp(1:nx/4,:)=rot90(readbin([pin fnm],[nx/4 ny],1,'real*4',2+(k-1)*4),3);
    tmp(nx/4+1:nx/2,:)=rot90(readbin([pin fnm],[nx/4 ny],1,'real*4',3+(k-1)*4),3);
    tmp(nx/2+1:nx,:)=readbin([pin fnm],[nx/2 ny],1,'real*4',(k-1)*2);
    mypcolor(tmp'); title(k), colorbar
    pause(.01)
    writebin(fnm,tmp,1,'real*4',k-1);
end

fnu='U0_2160x540x100.bin';
fnv='V0_2160x540x100.bin';
tmu=zeros(nx,ny);
tmv=zeros(nx,ny);
for k=1:nz
    tmp=-rot90(readbin([pin fnu],[nx/4 ny],1,'real*4',2+(k-1)*4),3);
    tmv(1:nx/4,2:end)=tmp(:,1:end-1);
    tmp=-rot90(readbin([pin fnu],[nx/4 ny],1,'real*4',3+(k-1)*4),3);
    tmv(nx/4+1:nx/2,2:end)=tmp(:,1:end-1);
    tmu(nx/2+1:nx,:)=readbin([pin fnu],[nx/2 ny],1,'real*4',(k-1)*2);
    tmu(1:nx/4,:)=rot90(readbin([pin fnv],[nx/4 ny],1,'real*4',2+(k-1)*4),3);
    tmu(nx/4+1:nx/2,:)=rot90(readbin([pin fnv],[nx/4 ny],1,'real*4',3+(k-1)*4),3);
    tmv(nx/2+1:nx,:)=readbin([pin fnv],[nx/2 ny],1,'real*4',(k-1)*2);
    figure(1), mypcolor(tmu'); title(['u ' int2str(k)]), caxis([-1 1]/5), colorbar
    figure(2), mypcolor(tmv'); title(['v ' int2str(k)]), caxis([-1 1]/5), colorbar
    writebin(fnu,tmu,1,'real*4',k-1);
    writebin(fnv,tmv,1,'real*4',k-1);
end

% evaluate discontinuity in v
tmp1=-rot90(readbin([pin fnu],[nx/4 ny],1,'real*4',3+(k-1)*4),3);
tmp2=readbin([pin fnv],[nx/2 ny],1,'real*4',(k-1)*2);
for i=1:12
    ssd1(i)=sum((tmp2(1,i:end+i-13)-tmp2(1,1:end-12)).^2);
    ssd2(i)=sum((tmp2(i,1:end-12)-tmp2(1,1:end-12)).^2);
    ssd3(i)=sum((tmp1(end,i:end+i-13)-tmp2(1,1:end-12)).^2);
end
clf, plot(0:11,ssd1,'k-*',0:11,ssd2,'b-o',0:11,ssd3,'r-o')
axis([0 11 0 .2])
legend

suf='_1620x13.bin'; sfo='_2160x13.bin';
fne='OBEph'; fnw='OBWph'; fnn='OBNph'; fns='OBSph';
for k=1:13
    tme=readbin([pin fne suf],1620,1,'real*4',k-1);
    tmw=readbin([pin fnw suf],1620,1,'real*4',k-1);
    tmn=readbin([pin fnn suf],1620,1,'real*4',k-1);
    tms=readbin([pin fns suf],1620,1,'real*4',k-1);
    tmp=zeros(nx,1);
    tmp(1:nx/2)=tmw(541:end);
    tmp(nx/2+1:end)=tmn(1:nx/2);
    writebin([fnn sfo],tmp,1,'real*4',k-1)
    tmp(find(~tmp))=nan; plot(tmp), title([fnn ' ' int2str(k)]), pause(1)
    tmp=zeros(nx,1);
    tmp(1:nx/2)=tme(541:end);
    tmp(nx/2+1:end)=tms(1:nx/2);
    writebin([fns sfo],tmp,1,'real*4',k-1)
    tmp(find(~tmp))=nan; plot(tmp), title([fns ' ' int2str(k)]), pause(1)
end

suf='_1620x13.bin'; sfo='_2160x13.bin';
fne='OBEam'; fnw='OBWam'; fnn='OBNam'; fns='OBSam';
for k=1:13
    tme=readbin([pin fne suf],1620,1,'real*4',k-1);
    tmw=readbin([pin fnw suf],1620,1,'real*4',k-1);
    tmn=readbin([pin fnn suf],1620,1,'real*4',k-1);
    tms=readbin([pin fns suf],1620,1,'real*4',k-1);
    tmp=zeros(nx,1);
    tmp(1:nx/2)=-tmw(541:end);
    tmp(nx/2+1:end)=tmn(1:nx/2);
    writebin([fnn sfo],tmp,1,'real*4',k-1)
    tmp(find(~tmp))=nan; plot(tmp), title([fnn ' ' int2str(k)]), pause(1)
    tmp=zeros(nx,1);
    tmp(1:nx/2)=-tme(541:end);
    tmp(nx/2+1:end)=tms(1:nx/2);
    writebin([fns sfo],tmp,1,'real*4',k-1)
    tmp(find(~tmp))=nan; plot(tmp), title([fns ' ' int2str(k)]), pause(1)
end

% fnm='/nobackup/dmenemen/NA/MITgcm/run/diags_llc2160_04/interior.0000000015.data';
% t=zeros(nx,ny); k=1;
% t(1:nx/4,:)=rot90(readbin(fnm,[nx/4 ny],1,'real*4',2+(k-1)*4),3);
% t(nx/4+1:nx/2,:)=rot90(readbin(fnm,[nx/4 ny],1,'real*4',3+(k-1)*4),3);
% t(nx/2+1:nx,:)=readbin(fnm,[nx/2 ny],1,'real*4',(k-1)*2);
% mypcolor(t'); colorbar
% 
% s=zeros(nx,ny); k=101;
% s(1:nx/4,:)=rot90(readbin(fnm,[nx/4 ny],1,'real*4',2+(k-1)*4),3);
% s(nx/4+1:nx/2,:)=rot90(readbin(fnm,[nx/4 ny],1,'real*4',3+(k-1)*4),3);
% s(nx/2+1:nx,:)=readbin(fnm,[nx/2 ny],1,'real*4',(k-1)*2);
% mypcolor(s'); colorbar
% 
% u=zeros(nx,ny); ku=201;
% v=zeros(nx,ny); kv=301;
% tmp=-rot90(readbin(fnm,[nx/4 ny],1,'real*4',2+(ku-1)*4),3);
% v(1:nx/4,2:end)=tmp(:,1:end-1);
% tmp=-rot90(readbin(fnm,[nx/4 ny],1,'real*4',3+(ku-1)*4),3);
% v(nx/4+1:nx/2,2:end)=tmp(:,1:end-1);
% u(nx/2+1:nx,:)=readbin(fnm,[nx/2 ny],1,'real*4',(ku-1)*2);
% u(1:nx/4,:)=rot90(readbin(fnm,[nx/4 ny],1,'real*4',2+(kv-1)*4),3);
% u(nx/4+1:nx/2,:)=rot90(readbin(fnm,[nx/4 ny],1,'real*4',3+(kv-1)*4),3);
% v(nx/2+1:nx,:)=readbin(fnm,[nx/2 ny],1,'real*4',(kv-1)*2);
% subplot(211), mypcolor(u'); colorbar
% subplot(212), mypcolor(v'); colorbar

suf='_1620x100x26.bin'; sfo='_2160x100x26.bin';
for fld={'s','t'}
    fne=['OBE' fld{1}]; fnw=['OBW' fld{1}];
    fnn=['OBN' fld{1}]; fns=['OBS' fld{1}];
    for k=1:2600, disp(k)
        tme=readbin([pin fne suf],1620,1,'real*4',k-1);
        tmw=readbin([pin fnw suf],1620,1,'real*4',k-1);
        tmn=readbin([pin fnn suf],1620,1,'real*4',k-1);
        tms=readbin([pin fns suf],1620,1,'real*4',k-1);
        tmp=zeros(nx,1);
        tmp(1:nx/2)=tmw(541:end);
        tmp(nx/2+1:end)=tmn(1:nx/2);
        writebin([fnn sfo],tmp,1,'real*4',k-1)
        % clf, eval(['plot(' fld{1} '(:,537))']), hold on
        % tmp(find(~tmp))=nan; plot(tmp,'r')
        % axis([0 nx min([-1e-9;tmp]) max([1e-9;tmp])])
        % title([fnn ' ' int2str(k)]), grid, pause
        tmp=zeros(nx,1);
        tmp(1:nx/2)=tme(541:end);
        tmp(nx/2+1:end)=tms(1:nx/2);
        writebin([fns sfo],tmp,1,'real*4',k-1)
        % clf, eval(['plot(' fld{1} '(:,8))']), hold on
        % tmp(find(~tmp))=nan; plot(tmp)
        % axis([0 nx min([-1e-9;tmp]) max([1e-9;tmp])])
        % title([fns ' ' int2str(k)]), grid, pause
    end
end

suf='_1620x100x26.bin'; sfo='_2160x100x26.bin';
feu='OBEu'; fwu='OBWu'; fnu='OBNu'; fsu='OBSu';
fev='OBEv'; fwv='OBWv'; fnv='OBNv'; fsv='OBSv';
for k=1:2600, disp(k)
    teu=readbin([pin feu suf],1620,1,'real*4',k-1);
    twu=readbin([pin fwu suf],1620,1,'real*4',k-1);
    tnu=readbin([pin fnu suf],1620,1,'real*4',k-1);
    tsu=readbin([pin fsu suf],1620,1,'real*4',k-1);
    tev=readbin([pin fev suf],1620,1,'real*4',k-1);
    twv=readbin([pin fwv suf],1620,1,'real*4',k-1);
    tnv=readbin([pin fnv suf],1620,1,'real*4',k-1);
    tsv=readbin([pin fsv suf],1620,1,'real*4',k-1);
    tmu=zeros(nx,1); tmv=zeros(nx,1);
    tmu(1:nx/2)=twv(541:end);
    tmu(nx/2+1:end)=tnu(1:nx/2);
    tmv(1:nx/2)=-twu(541:end);
    tmv(nx/2+1:end)=tnv(1:nx/2);
    % clf, subplot(211), plot(u(:,537)), hold on, plot(tmu,'r')
    % subplot(212), plot(v(:,537)), hold on, plot(tmv,'r')
    writebin([fnu sfo],tmu,1,'real*4',k-1)
    writebin([fnv sfo],tmv,1,'real*4',k-1)
    tmu=zeros(nx,1); tmv=zeros(nx,1);
    tmu(1:nx/2)=tev(541:end);
    tmu(nx/2+1:end)=tsu(1:nx/2);
    tmv(1:nx/2)=-teu(541:end);
    tmv(nx/2+1:end)=tsv(1:nx/2);
    % clf, subplot(211), plot(u(:,8)), hold on, plot(tmu,'r')
    % subplot(212), plot(v(:,8)), hold on, plot(tmv,'r')
    writebin([fsu sfo],tmu,1,'real*4',k-1)
    writebin([fsv sfo],tmv,1,'real*4',k-1)
end
