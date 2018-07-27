fn1='../MITgcm/run/diags_llc2160_02/surface.0000000015.data';
fn2='../MITgcm/run/diags_llc2160_03/surface.0000000015.data';
fn3='../MITgcm/run/diags_llc2160_04/surface.0000000015.data';
fn4='../MITgcm/run/diags_ll2160_01/surface.0000000015.data';
fn5='../MITgcm/run/diags_ll2160_02/surface.0000000015.data';
fn6='../MITgcm/run/diags_ll2160_03/surface.0000000015.data';

nx=2160; ny=540;

e1=zeros(nx,ny);
e1(1:nx/4,:)=rot90(readbin(fn1,[nx/4 ny],1,'real*4',2),3);
e1(nx/4+1:nx/2,:)=rot90(readbin(fn1,[nx/4 ny],1,'real*4',3),3);
e1(nx/2+1:nx,:)=readbin(fn1,[nx/2 ny]);
mypcolor(e1'); colorbar
