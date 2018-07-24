nx=2160; ny=540;

XC=zeros(nx,ny);
XC(1:nx/4,:)=rot90(readbin('XC.data',[nx/4 ny],1,'real*4',2),3);
XC(nx/4+1:nx/2,:)=rot90(readbin('XC.data',[nx/4 ny],1,'real*4',3),3);
XC(nx/2+1:nx,:)=readbin('XC.data',[nx/2 ny]);
XC(find(~XC))=nan;
mypcolor(XC'); colorbar

YC=zeros(nx,ny);
YC(1:nx/4,:)=rot90(readbin('YC.data',[nx/4 ny],1,'real*4',2),3);
YC(nx/4+1:nx/2,:)=rot90(readbin('YC.data',[nx/4 ny],1,'real*4',3),3);
YC(nx/2+1:nx,:)=readbin('YC.data',[nx/2 ny]);
YC(find(~YC))=nan;
mypcolor(YC'); colorbar

XG=zeros(nx,ny);
XG(1:nx/4,:)=rot90(readbin('XG.data',[nx/4 ny],1,'real*4',2),3);
XG(nx/4+1:nx/2,:)=rot90(readbin('XG.data',[nx/4 ny],1,'real*4',3),3);
XG(nx/2+1:nx,:)=readbin('XG.data',[nx/2 ny]);
XG(find(~XG))=nan;
mypcolor(XG'); colorbar

% Note that bottom row is not defined on facet 5
YG=zeros(nx,ny-1);
tmp=rot90(readbin('YG.data',[nx/4 ny],1,'real*4',2),3);
YG(1:nx/4,:)=tmp(:,1:end-1);
tmp=rot90(readbin('YG.data',[nx/4 ny],1,'real*4',3),3);
YG(nx/4+1:nx/2,:)=tmp(:,1:end-1);
tmp=readbin('YG.data',[nx/2 ny]);
YG(nx/2+1:nx,:)=tmp(:,2:end);
YG(find(~YG))=nan;
mypcolor(YG'); colorbar

Depth=zeros(nx,ny);
Depth(1:nx/4,:)=rot90(readbin('Depth.data',[nx/4 ny],1,'real*4',2),3);
Depth(nx/4+1:nx/2,:)=rot90(readbin('Depth.data',[nx/4 ny],1,'real*4',3),3);
Depth(nx/2+1:nx,:)=readbin('Depth.data',[nx/2 ny]);
mypcolor(Depth'); colorbar
