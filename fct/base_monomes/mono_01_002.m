function [mono,nbmono,monod1,cmonod1,monod2,cmonod2]=mono_01_002()

derprem=false;dersecond=false;
if nargout>=4;derprem=true;end
if nargout==6;dersecond=true;end

mono=[
0 0 1 0 0 1 
];
nbmono=3;

if derprem
monod1=[
0 0 0 
0 0 1 
0 1 0 
0 0 0 
];
cmonod1=[
0 1 0 
0 0 1 
];
end

if dersecond
monod2=[
0 0 0 
0 0 1 
0 0 0 
0 0 0 
0 0 0 
0 0 0 
0 1 0 
0 0 0 
];
cmonod2=[
0 1 0 
0 0 1 
];
end

end

