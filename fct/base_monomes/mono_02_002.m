function [mono,nbmono,monod1,cmonod1,monod2,cmonod2]=mono_02_002()

derprem=false;dersecond=false;
if nargout>=4;derprem=true;end
if nargout==6;dersecond=true;end

mono=[
0 0 1 0 2 0 0 1 1 1 0 2 
];
nbmono=6;

if derprem
monod1=[
0 0 1 0 0 0 
0 0 0 1 1 2 
0 1 2 0 1 0 
0 0 0 0 0 1 
];
cmonod1=[
0 1 2 0 1 0 
0 0 0 1 1 2 
];
end

if dersecond
monod2=[
0 0 0 0 0 0 
0 0 0 1 1 2 
0 0 1 0 0 0 
0 0 0 0 0 0 
0 0 1 0 0 0 
0 0 0 0 0 1 
0 1 2 0 1 0 
0 0 0 0 0 1 
];
cmonod2=[
0 1 2 0 1 0 
0 0 0 1 1 2 
];
end

end

