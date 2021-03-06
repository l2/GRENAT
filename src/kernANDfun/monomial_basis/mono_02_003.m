function [poly,polyD,polyDD]=mono_02_003()

derprem=false;dersecond=false;
if nargout>=2;derprem=true;end
if nargout==3;dersecond=true;end

Xpow=[
0 1 2 0 1 0 0 1 0 0 
0 0 0 1 1 2 0 0 1 0 
0 0 0 0 0 0 1 1 1 2 
];
poly.Xpow=reshape(Xpow',[1,10,3]);
Xcoef=[
1 1 1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 1 1 
];
poly.Xcoef=reshape(Xcoef,[1,10,3]);
poly.nbMono=10;

if derprem
DXpow=[
0 0 1 0 0 0 0 0 0 0 
0 0 0 0 1 0 0 0 0 0 
0 0 0 0 0 0 0 1 0 0 
0 0 0 0 1 0 0 0 0 0 
0 0 0 0 0 1 0 0 0 0 
0 0 0 0 0 0 0 0 1 0 
0 0 0 0 0 0 0 1 0 0 
0 0 0 0 0 0 0 0 1 0 
0 0 0 0 0 0 0 0 0 1 
];
polyD.Xpow=permute(reshape(DXpow',10,1,3,3),[2 1 3 4]);
DXcoef=[
0 1 2 0 1 0 0 1 0 0 
0 0 0 1 1 2 0 0 1 0 
0 0 0 0 0 0 1 1 1 2 
];
polyD.Xcoef=reshape(DXcoef',[1,10,3]);
end

if dersecond
DDXpow=[
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 
];
polyDD.Xpow=permute(reshape(DDXpow',10,1,3,9),[2 1 3 4]);
DDXcoef=[
0 0 2 0 0 0 0 0 0 0 
0 0 0 0 1 0 0 0 0 0 
0 0 0 0 0 0 0 1 0 0 
0 0 0 0 1 0 0 0 0 0 
0 0 0 0 0 2 0 0 0 0 
0 0 0 0 0 0 0 0 1 0 
0 0 0 0 0 0 0 1 0 0 
0 0 0 0 0 0 0 0 1 0 
0 0 0 0 0 0 0 0 0 2 
];
polyDD.Xcoef=reshape(DDXcoef',[1,10,9]);
end

end

