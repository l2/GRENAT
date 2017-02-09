function [poly,polyD,polyDD]=mono_04_002()

derprem=false;dersecond=false;
if nargout>=2;derprem=true;end
if nargout==3;dersecond=true;end

Xpow=[
0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 
0 0 0 0 0 1 1 1 1 2 2 2 3 3 4 
];
poly.Xpow=reshape(Xpow',[1,15,2]);
Xcoef=[
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
];
poly.Xcoef=reshape(Xcoef,[1,15,2]);
poly.nbMono=15;

if derprem
DXpow=[
0 0 1 2 3 0 0 1 2 0 0 1 0 0 0 
0 0 0 0 0 0 1 1 1 0 2 2 0 3 0 
0 0 0 0 0 0 1 2 3 0 1 2 0 1 0 
0 0 0 0 0 0 0 0 0 1 1 1 2 2 3 
];
polyD.Xpow=permute(reshape(DXpow',15,1,2,2),[2 1 3 4]);
DXcoef=[
0 1 2 3 4 0 1 2 3 0 1 2 0 1 0 
0 0 0 0 0 1 1 1 1 2 2 2 3 3 4 
];
polyD.Xcoef=reshape(DXcoef',[1,15,2]);
end

if dersecond
DDXpow=[
0 0 0 1 2 0 0 0 1 0 0 0 0 0 0 
0 0 0 0 0 0 0 1 1 0 0 2 0 0 0 
0 0 0 0 0 0 0 1 2 0 0 1 0 0 0 
0 0 0 0 0 0 0 0 0 0 1 1 0 2 0 
0 0 0 0 0 0 0 1 2 0 0 1 0 0 0 
0 0 0 0 0 0 0 0 0 0 1 1 0 2 0 
0 0 0 0 0 0 0 0 0 0 1 2 0 1 0 
0 0 0 0 0 0 0 0 0 0 0 0 1 1 2 
];
polyDD.Xpow=permute(reshape(DDXpow',15,1,2,4),[2 1 3 4]);
DDXcoef=[
0 0 2 6 12 0 0 2 6 0 0 2 0 0 0 
0 0 0 0 0 0 1 2 3 0 2 4 0 3 0 
0 0 0 0 0 0 1 2 3 0 2 4 0 3 0 
0 0 0 0 0 0 0 0 0 2 2 2 6 6 12 
];
polyDD.Xcoef=reshape(DDXcoef',[1,15,4]);
end

end

