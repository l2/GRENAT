function [poly,polyD,polyDD]=mono_10_003()

derprem=false;dersecond=false;
if nargout>=2;derprem=true;end
if nargout==3;dersecond=true;end

Xpow=[
0 1 2 3 4 5 6 7 8 9 10 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 0 1 2 0 1 0 0 1 2 0 1 0 0 1 0 0 
0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 5 5 5 5 5 5 6 6 6 6 6 7 7 7 7 8 8 8 9 9 10 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 4 4 4 4 4 4 5 5 5 5 5 6 6 6 6 7 7 7 8 8 9 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 5 5 5 5 6 6 6 7 7 8 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 4 4 4 4 5 5 5 6 6 7 0 0 0 0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 3 3 3 3 4 4 4 5 5 6 0 0 0 0 0 0 1 1 1 1 1 2 2 2 2 3 3 3 4 4 5 0 0 0 0 0 1 1 1 1 2 2 2 3 3 4 0 0 0 0 1 1 1 2 2 3 0 0 0 1 1 2 0 0 1 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 7 7 7 7 7 7 7 7 7 7 8 8 8 8 8 8 9 9 9 10 
];
poly.Xpow=reshape(Xpow',[1,286,3]);
Xcoef=[
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
];
poly.Xcoef=reshape(Xcoef,[1,286,3]);
poly.nbMono=286;

if derprem
DXpow=[
0 0 1 2 3 4 5 6 7 8 9 0 0 1 2 3 4 5 6 7 8 0 0 1 2 3 4 5 6 7 0 0 1 2 3 4 5 6 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 3 4 5 6 7 8 0 0 1 2 3 4 5 6 7 0 0 1 2 3 4 5 6 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 3 4 5 6 7 0 0 1 2 3 4 5 6 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 3 4 5 6 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 0 2 2 2 2 2 2 2 2 0 3 3 3 3 3 3 3 0 4 4 4 4 4 4 0 5 5 5 5 5 0 6 6 6 6 0 7 7 7 0 8 8 0 9 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 2 2 2 2 2 2 2 0 3 3 3 3 3 3 0 4 4 4 4 4 0 5 5 5 5 0 6 6 6 0 7 7 0 8 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 2 2 2 2 2 2 0 3 3 3 3 3 0 4 4 4 4 0 5 5 5 0 6 6 0 7 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 0 2 2 2 2 2 0 3 3 3 3 0 4 4 4 0 5 5 0 6 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 2 2 2 2 0 3 3 3 0 4 4 0 5 0 0 0 0 0 0 0 0 1 1 1 1 0 2 2 2 0 3 3 0 4 0 0 0 0 0 0 0 1 1 1 0 2 2 0 3 0 0 0 0 0 0 1 1 0 2 0 0 0 0 0 1 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 1 1 0 1 1 1 0 1 1 0 1 0 0 2 2 2 2 2 2 2 2 0 2 2 2 2 2 2 2 0 2 2 2 2 2 2 0 2 2 2 2 2 0 2 2 2 2 0 2 2 2 0 2 2 0 2 0 0 3 3 3 3 3 3 3 0 3 3 3 3 3 3 0 3 3 3 3 3 0 3 3 3 3 0 3 3 3 0 3 3 0 3 0 0 4 4 4 4 4 4 0 4 4 4 4 4 0 4 4 4 4 0 4 4 4 0 4 4 0 4 0 0 5 5 5 5 5 0 5 5 5 5 0 5 5 5 0 5 5 0 5 0 0 6 6 6 6 0 6 6 6 0 6 6 0 6 0 0 7 7 7 0 7 7 0 7 0 0 8 8 0 8 0 0 9 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 1 2 0 1 0 0 0 0 0 1 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 4 4 4 4 4 4 5 5 5 5 5 6 6 6 6 7 7 7 8 8 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 5 5 5 5 6 6 6 7 7 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 4 4 4 4 5 5 5 6 6 7 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 3 3 3 3 4 4 4 5 5 6 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 2 2 2 2 3 3 3 4 4 5 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 2 2 2 3 3 4 0 0 0 0 0 0 0 0 0 1 1 1 2 2 3 0 0 0 0 0 0 0 1 1 2 0 0 0 0 0 1 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0 0 0 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 0 0 0 0 0 0 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 0 0 0 0 0 6 6 6 6 6 6 6 6 6 6 0 0 0 0 7 7 7 7 7 7 0 0 0 8 8 8 0 0 9 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 0 1 2 0 1 0 0 1 2 0 1 0 0 1 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 4 4 4 4 4 4 5 5 5 5 5 6 6 6 6 7 7 7 8 8 9 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 5 5 5 5 6 6 6 7 7 8 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 4 4 4 4 5 5 5 6 6 7 0 0 0 0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 3 3 3 3 4 4 4 5 5 6 0 0 0 0 0 0 1 1 1 1 1 2 2 2 2 3 3 3 4 4 5 0 0 0 0 0 1 1 1 1 2 2 2 3 3 4 0 0 0 0 1 1 1 2 2 3 0 0 0 1 1 2 0 0 1 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 6 6 6 6 6 6 6 6 6 6 7 7 7 7 7 7 8 8 8 9 
];
polyD.Xpow=permute(reshape(DXpow',286,1,3,3),[2 1 3 4]);
DXcoef=[
0 1 2 3 4 5 6 7 8 9 10 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 0 1 2 0 1 0 0 1 2 0 1 0 0 1 0 0 
0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 5 5 5 5 5 5 6 6 6 6 6 7 7 7 7 8 8 8 9 9 10 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 4 4 4 4 4 4 5 5 5 5 5 6 6 6 6 7 7 7 8 8 9 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 5 5 5 5 6 6 6 7 7 8 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 4 4 4 4 5 5 5 6 6 7 0 0 0 0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 3 3 3 3 4 4 4 5 5 6 0 0 0 0 0 0 1 1 1 1 1 2 2 2 2 3 3 3 4 4 5 0 0 0 0 0 1 1 1 1 2 2 2 3 3 4 0 0 0 0 1 1 1 2 2 3 0 0 0 1 1 2 0 0 1 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 7 7 7 7 7 7 7 7 7 7 8 8 8 8 8 8 9 9 9 10 
];
polyD.Xcoef=reshape(DXcoef',[1,286,3]);
end

if dersecond
DDXpow=[
0 0 0 1 2 3 4 5 6 7 8 0 0 0 1 2 3 4 5 6 7 0 0 0 1 2 3 4 5 6 0 0 0 1 2 3 4 5 0 0 0 1 2 3 4 0 0 0 1 2 3 0 0 0 1 2 0 0 0 1 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 0 0 0 1 2 3 4 5 6 0 0 0 1 2 3 4 5 0 0 0 1 2 3 4 0 0 0 1 2 3 0 0 0 1 2 0 0 0 1 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 0 0 0 1 2 3 4 5 0 0 0 1 2 3 4 0 0 0 1 2 3 0 0 0 1 2 0 0 0 1 0 0 0 0 0 0 0 0 0 1 2 3 4 5 0 0 0 1 2 3 4 0 0 0 1 2 3 0 0 0 1 2 0 0 0 1 0 0 0 0 0 0 0 0 0 1 2 3 4 0 0 0 1 2 3 0 0 0 1 2 0 0 0 1 0 0 0 0 0 0 0 0 0 1 2 3 0 0 0 1 2 0 0 0 1 0 0 0 0 0 0 0 0 0 1 2 0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 2 2 2 2 2 2 2 0 0 3 3 3 3 3 3 0 0 4 4 4 4 4 0 0 5 5 5 5 0 0 6 6 6 0 0 7 7 0 0 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0 2 2 2 2 2 2 0 0 3 3 3 3 3 0 0 4 4 4 4 0 0 5 5 5 0 0 6 6 0 0 7 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 2 2 2 2 2 0 0 3 3 3 3 0 0 4 4 4 0 0 5 5 0 0 6 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 0 2 2 2 2 0 0 3 3 3 0 0 4 4 0 0 5 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 2 2 2 0 0 3 3 0 0 4 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 2 2 0 0 3 0 0 0 0 0 0 0 0 0 0 1 1 0 0 2 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 0 0 1 1 1 1 1 0 0 1 1 1 1 0 0 1 1 1 0 0 1 1 0 0 1 0 0 0 0 0 2 2 2 2 2 2 2 0 0 2 2 2 2 2 2 0 0 2 2 2 2 2 0 0 2 2 2 2 0 0 2 2 2 0 0 2 2 0 0 2 0 0 0 0 0 3 3 3 3 3 3 0 0 3 3 3 3 3 0 0 3 3 3 3 0 0 3 3 3 0 0 3 3 0 0 3 0 0 0 0 0 4 4 4 4 4 0 0 4 4 4 4 0 0 4 4 4 0 0 4 4 0 0 4 0 0 0 0 0 5 5 5 5 0 0 5 5 5 0 0 5 5 0 0 5 0 0 0 0 0 6 6 6 0 0 6 6 0 0 6 0 0 0 0 0 7 7 0 0 7 0 0 0 0 0 8 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 0 0 1 2 3 4 5 6 7 0 0 1 2 3 4 5 6 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 0 0 1 2 3 4 5 6 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 0 0 0 0 0 1 2 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 2 2 2 2 2 2 2 0 3 3 3 3 3 3 0 4 4 4 4 4 0 5 5 5 5 0 6 6 6 0 7 7 0 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 2 2 2 2 2 2 0 3 3 3 3 3 0 4 4 4 4 0 5 5 5 0 6 6 0 7 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 0 2 2 2 2 2 0 3 3 3 3 0 4 4 4 0 5 5 0 6 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 2 2 2 2 0 3 3 3 0 4 4 0 5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 2 2 2 0 3 3 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 2 2 0 3 0 0 0 0 0 0 0 0 0 0 0 1 1 0 2 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 1 1 0 1 1 1 0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 2 2 2 2 2 2 0 2 2 2 2 2 0 2 2 2 2 0 2 2 2 0 2 2 0 2 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 0 3 3 3 3 3 0 3 3 3 3 0 3 3 3 0 3 3 0 3 0 0 0 0 0 0 0 0 0 4 4 4 4 4 0 4 4 4 4 0 4 4 4 0 4 4 0 4 0 0 0 0 0 0 0 0 5 5 5 5 0 5 5 5 0 5 5 0 5 0 0 0 0 0 0 0 6 6 6 0 6 6 0 6 0 0 0 0 0 0 7 7 0 7 0 0 0 0 0 8 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 0 0 1 2 3 4 5 6 7 0 0 1 2 3 4 5 6 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 3 4 5 6 7 0 0 1 2 3 4 5 6 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 3 4 5 6 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 2 2 2 2 2 2 2 0 3 3 3 3 3 3 0 4 4 4 4 4 0 5 5 5 5 0 6 6 6 0 7 7 0 8 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 2 2 2 2 2 2 0 3 3 3 3 3 0 4 4 4 4 0 5 5 5 0 6 6 0 7 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 0 2 2 2 2 2 0 3 3 3 3 0 4 4 4 0 5 5 0 6 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 2 2 2 2 0 3 3 3 0 4 4 0 5 0 0 0 0 0 0 0 0 1 1 1 1 0 2 2 2 0 3 3 0 4 0 0 0 0 0 0 0 1 1 1 0 2 2 0 3 0 0 0 0 0 0 1 1 0 2 0 0 0 0 0 1 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 1 1 0 1 1 1 0 1 1 0 1 0 0 2 2 2 2 2 2 2 0 2 2 2 2 2 2 0 2 2 2 2 2 0 2 2 2 2 0 2 2 2 0 2 2 0 2 0 0 3 3 3 3 3 3 0 3 3 3 3 3 0 3 3 3 3 0 3 3 3 0 3 3 0 3 0 0 4 4 4 4 4 0 4 4 4 4 0 4 4 4 0 4 4 0 4 0 0 5 5 5 5 0 5 5 5 0 5 5 0 5 0 0 6 6 6 0 6 6 0 6 0 0 7 7 0 7 0 0 8 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 0 0 1 2 3 4 5 6 7 0 0 1 2 3 4 5 6 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 0 0 1 2 3 4 5 6 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 0 0 0 0 0 1 2 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 2 2 2 2 2 2 2 0 3 3 3 3 3 3 0 4 4 4 4 4 0 5 5 5 5 0 6 6 6 0 7 7 0 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 2 2 2 2 2 2 0 3 3 3 3 3 0 4 4 4 4 0 5 5 5 0 6 6 0 7 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 0 2 2 2 2 2 0 3 3 3 3 0 4 4 4 0 5 5 0 6 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 2 2 2 2 0 3 3 3 0 4 4 0 5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 2 2 2 0 3 3 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 2 2 0 3 0 0 0 0 0 0 0 0 0 0 0 1 1 0 2 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 1 1 0 1 1 1 0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 2 2 2 2 2 2 0 2 2 2 2 2 0 2 2 2 2 0 2 2 2 0 2 2 0 2 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 0 3 3 3 3 3 0 3 3 3 3 0 3 3 3 0 3 3 0 3 0 0 0 0 0 0 0 0 0 4 4 4 4 4 0 4 4 4 4 0 4 4 4 0 4 4 0 4 0 0 0 0 0 0 0 0 5 5 5 5 0 5 5 5 0 5 5 0 5 0 0 0 0 0 0 0 6 6 6 0 6 6 0 6 0 0 0 0 0 0 7 7 0 7 0 0 0 0 0 8 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 0 0 0 1 2 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 5 5 5 5 6 6 6 7 7 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 4 4 4 4 5 5 5 6 6 7 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 3 3 3 3 4 4 4 5 5 6 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 2 2 2 2 3 3 3 4 4 5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 2 2 2 3 3 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 2 2 3 0 0 0 0 0 0 0 0 0 0 0 0 1 1 2 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0 0 0 0 0 0 0 0 0 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 0 0 0 0 0 0 0 0 0 0 0 5 5 5 5 5 5 5 5 5 5 0 0 0 0 0 0 0 0 0 6 6 6 6 6 6 0 0 0 0 0 0 0 7 7 7 0 0 0 0 0 8 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 1 2 0 1 0 0 0 0 0 1 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 5 5 5 5 6 6 6 7 7 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 4 4 4 4 5 5 5 6 6 7 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 3 3 3 3 4 4 4 5 5 6 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 2 2 2 2 3 3 3 4 4 5 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 2 2 2 3 3 4 0 0 0 0 0 0 0 0 0 1 1 1 2 2 3 0 0 0 0 0 0 0 1 1 2 0 0 0 0 0 1 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0 0 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 0 0 0 0 0 5 5 5 5 5 5 5 5 5 5 0 0 0 0 6 6 6 6 6 6 0 0 0 7 7 7 0 0 8 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 0 0 1 2 3 4 5 6 7 0 0 1 2 3 4 5 6 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 3 4 5 6 7 0 0 1 2 3 4 5 6 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 3 4 5 6 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 3 4 5 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 3 4 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 0 0 1 2 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 2 2 2 2 2 2 2 0 3 3 3 3 3 3 0 4 4 4 4 4 0 5 5 5 5 0 6 6 6 0 7 7 0 8 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 2 2 2 2 2 2 0 3 3 3 3 3 0 4 4 4 4 0 5 5 5 0 6 6 0 7 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 0 2 2 2 2 2 0 3 3 3 3 0 4 4 4 0 5 5 0 6 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 2 2 2 2 0 3 3 3 0 4 4 0 5 0 0 0 0 0 0 0 0 1 1 1 1 0 2 2 2 0 3 3 0 4 0 0 0 0 0 0 0 1 1 1 0 2 2 0 3 0 0 0 0 0 0 1 1 0 2 0 0 0 0 0 1 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 1 1 0 1 1 1 0 1 1 0 1 0 0 2 2 2 2 2 2 2 0 2 2 2 2 2 2 0 2 2 2 2 2 0 2 2 2 2 0 2 2 2 0 2 2 0 2 0 0 3 3 3 3 3 3 0 3 3 3 3 3 0 3 3 3 3 0 3 3 3 0 3 3 0 3 0 0 4 4 4 4 4 0 4 4 4 4 0 4 4 4 0 4 4 0 4 0 0 5 5 5 5 0 5 5 5 0 5 5 0 5 0 0 6 6 6 0 6 6 0 6 0 0 7 7 0 7 0 0 8 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 0 1 2 3 0 1 2 0 1 0 0 0 0 0 0 1 2 0 1 0 0 0 0 0 1 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 5 5 5 5 6 6 6 7 7 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 4 4 4 4 5 5 5 6 6 7 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 3 3 3 3 4 4 4 5 5 6 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 2 2 2 2 3 3 3 4 4 5 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 2 2 2 3 3 4 0 0 0 0 0 0 0 0 0 1 1 1 2 2 3 0 0 0 0 0 0 0 1 1 2 0 0 0 0 0 1 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0 0 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 0 0 0 0 0 5 5 5 5 5 5 5 5 5 5 0 0 0 0 6 6 6 6 6 6 0 0 0 7 7 7 0 0 8 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 1 2 3 0 1 2 0 1 0 0 1 2 0 1 0 0 1 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 5 5 5 5 6 6 6 7 7 8 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 4 4 4 4 5 5 5 6 6 7 0 0 0 0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 3 3 3 3 4 4 4 5 5 6 0 0 0 0 0 0 1 1 1 1 1 2 2 2 2 3 3 3 4 4 5 0 0 0 0 0 1 1 1 1 2 2 2 3 3 4 0 0 0 0 1 1 1 2 2 3 0 0 0 1 1 2 0 0 1 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 6 6 6 6 6 6 7 7 7 8 
];
polyDD.Xpow=permute(reshape(DDXpow',286,1,3,9),[2 1 3 4]);
DDXcoef=[
0 0 2 6 12 20 30 42 56 72 90 0 0 2 6 12 20 30 42 56 72 0 0 2 6 12 20 30 42 56 0 0 2 6 12 20 30 42 0 0 2 6 12 20 30 0 0 2 6 12 20 0 0 2 6 12 0 0 2 6 0 0 2 0 0 0 0 0 2 6 12 20 30 42 56 72 0 0 2 6 12 20 30 42 56 0 0 2 6 12 20 30 42 0 0 2 6 12 20 30 0 0 2 6 12 20 0 0 2 6 12 0 0 2 6 0 0 2 0 0 0 0 0 2 6 12 20 30 42 56 0 0 2 6 12 20 30 42 0 0 2 6 12 20 30 0 0 2 6 12 20 0 0 2 6 12 0 0 2 6 0 0 2 0 0 0 0 0 2 6 12 20 30 42 0 0 2 6 12 20 30 0 0 2 6 12 20 0 0 2 6 12 0 0 2 6 0 0 2 0 0 0 0 0 2 6 12 20 30 0 0 2 6 12 20 0 0 2 6 12 0 0 2 6 0 0 2 0 0 0 0 0 2 6 12 20 0 0 2 6 12 0 0 2 6 0 0 2 0 0 0 0 0 2 6 12 0 0 2 6 0 0 2 0 0 0 0 0 2 6 0 0 2 0 0 0 0 0 2 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 9 0 2 4 6 8 10 12 14 16 0 3 6 9 12 15 18 21 0 4 8 12 16 20 24 0 5 10 15 20 25 0 6 12 18 24 0 7 14 21 0 8 16 0 9 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 0 2 4 6 8 10 12 14 0 3 6 9 12 15 18 0 4 8 12 16 20 0 5 10 15 20 0 6 12 18 0 7 14 0 8 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 0 2 4 6 8 10 12 0 3 6 9 12 15 0 4 8 12 16 0 5 10 15 0 6 12 0 7 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 0 2 4 6 8 10 0 3 6 9 12 0 4 8 12 0 5 10 0 6 0 0 0 0 0 0 0 0 0 1 2 3 4 5 0 2 4 6 8 0 3 6 9 0 4 8 0 5 0 0 0 0 0 0 0 0 1 2 3 4 0 2 4 6 0 3 6 0 4 0 0 0 0 0 0 0 1 2 3 0 2 4 0 3 0 0 0 0 0 0 1 2 0 2 0 0 0 0 0 1 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 2 4 6 8 10 12 14 16 0 2 4 6 8 10 12 14 0 2 4 6 8 10 12 0 2 4 6 8 10 0 2 4 6 8 0 2 4 6 0 2 4 0 2 0 0 3 6 9 12 15 18 21 0 3 6 9 12 15 18 0 3 6 9 12 15 0 3 6 9 12 0 3 6 9 0 3 6 0 3 0 0 4 8 12 16 20 24 0 4 8 12 16 20 0 4 8 12 16 0 4 8 12 0 4 8 0 4 0 0 5 10 15 20 25 0 5 10 15 20 0 5 10 15 0 5 10 0 5 0 0 6 12 18 24 0 6 12 18 0 6 12 0 6 0 0 7 14 21 0 7 14 0 7 0 0 8 16 0 8 0 0 9 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 9 0 2 4 6 8 10 12 14 16 0 3 6 9 12 15 18 21 0 4 8 12 16 20 24 0 5 10 15 20 25 0 6 12 18 24 0 7 14 21 0 8 16 0 9 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 0 2 4 6 8 10 12 14 0 3 6 9 12 15 18 0 4 8 12 16 20 0 5 10 15 20 0 6 12 18 0 7 14 0 8 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 0 2 4 6 8 10 12 0 3 6 9 12 15 0 4 8 12 16 0 5 10 15 0 6 12 0 7 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 0 2 4 6 8 10 0 3 6 9 12 0 4 8 12 0 5 10 0 6 0 0 0 0 0 0 0 0 0 1 2 3 4 5 0 2 4 6 8 0 3 6 9 0 4 8 0 5 0 0 0 0 0 0 0 0 1 2 3 4 0 2 4 6 0 3 6 0 4 0 0 0 0 0 0 0 1 2 3 0 2 4 0 3 0 0 0 0 0 0 1 2 0 2 0 0 0 0 0 1 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2 2 6 6 6 6 6 6 6 6 12 12 12 12 12 12 12 20 20 20 20 20 20 30 30 30 30 30 42 42 42 42 56 56 56 72 72 90 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2 6 6 6 6 6 6 6 12 12 12 12 12 12 20 20 20 20 20 30 30 30 30 42 42 42 56 56 72 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 6 6 6 6 6 6 12 12 12 12 12 20 20 20 20 30 30 30 42 42 56 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 6 6 6 6 6 12 12 12 12 20 20 20 30 30 42 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 6 6 6 6 12 12 12 20 20 30 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 6 6 6 12 12 20 0 0 0 0 0 0 0 0 0 2 2 2 6 6 12 0 0 0 0 0 0 0 2 2 6 0 0 0 0 0 2 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 4 4 4 4 4 4 5 5 5 5 5 6 6 6 6 7 7 7 8 8 9 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2 4 4 4 4 4 4 4 6 6 6 6 6 6 8 8 8 8 8 10 10 10 10 12 12 12 14 14 16 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 6 6 6 6 6 6 9 9 9 9 9 12 12 12 12 15 15 15 18 18 21 0 0 0 0 0 0 0 4 4 4 4 4 4 8 8 8 8 8 12 12 12 12 16 16 16 20 20 24 0 0 0 0 0 0 5 5 5 5 5 10 10 10 10 15 15 15 20 20 25 0 0 0 0 0 6 6 6 6 12 12 12 18 18 24 0 0 0 0 7 7 7 14 14 21 0 0 0 8 8 16 0 0 9 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 0 1 2 3 4 5 0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 0 2 4 6 8 10 12 14 16 0 2 4 6 8 10 12 14 0 2 4 6 8 10 12 0 2 4 6 8 10 0 2 4 6 8 0 2 4 6 0 2 4 0 2 0 0 3 6 9 12 15 18 21 0 3 6 9 12 15 18 0 3 6 9 12 15 0 3 6 9 12 0 3 6 9 0 3 6 0 3 0 0 4 8 12 16 20 24 0 4 8 12 16 20 0 4 8 12 16 0 4 8 12 0 4 8 0 4 0 0 5 10 15 20 25 0 5 10 15 20 0 5 10 15 0 5 10 0 5 0 0 6 12 18 24 0 6 12 18 0 6 12 0 6 0 0 7 14 21 0 7 14 0 7 0 0 8 16 0 8 0 0 9 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 4 4 4 4 4 4 5 5 5 5 5 6 6 6 6 7 7 7 8 8 9 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2 4 4 4 4 4 4 4 6 6 6 6 6 6 8 8 8 8 8 10 10 10 10 12 12 12 14 14 16 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 6 6 6 6 6 6 9 9 9 9 9 12 12 12 12 15 15 15 18 18 21 0 0 0 0 0 0 0 4 4 4 4 4 4 8 8 8 8 8 12 12 12 12 16 16 16 20 20 24 0 0 0 0 0 0 5 5 5 5 5 10 10 10 10 15 15 15 20 20 25 0 0 0 0 0 6 6 6 6 12 12 12 18 18 24 0 0 0 0 7 7 7 14 14 21 0 0 0 8 8 16 0 0 9 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 42 42 42 42 42 42 42 42 42 42 56 56 56 56 56 56 72 72 72 90 
];
polyDD.Xcoef=reshape(DDXcoef',[1,286,9]);
end

end

