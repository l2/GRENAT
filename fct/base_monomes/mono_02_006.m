function [MatX,nbmono,MatDX,CoefDX,MatDDX,CoefDDX]=mono_02_006(X)

derprem=false;dersecond=false;
if nargout>=4;derprem=true;end
if nargout==6;dersecond=true;end

MatX=[
 ones(size(X,1),1) ...
X(:,1) ...
X(:,1).^2 ...
X(:,2) ...
X(:,1).*X(:,2) ...
X(:,2).^2 ...
X(:,3) ...
X(:,1).*X(:,3) ...
X(:,2).*X(:,3) ...
X(:,3).^2 ...
X(:,4) ...
X(:,1).*X(:,4) ...
X(:,2).*X(:,4) ...
X(:,3).*X(:,4) ...
X(:,4).^2 ...
X(:,5) ...
X(:,1).*X(:,5) ...
X(:,2).*X(:,5) ...
X(:,3).*X(:,5) ...
X(:,4).*X(:,5) ...
X(:,5).^2 ...
X(:,6) ...
X(:,1).*X(:,6) ...
X(:,2).*X(:,6) ...
X(:,3).*X(:,6) ...
X(:,4).*X(:,6) ...
X(:,5).*X(:,6) ...
X(:,6).^2
];
nbmono=28;

if derprem
MatDX=cell(1,size(X,2));

MatDX{1}=[
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
2.*X(:,1) ...
zeros(size(X,1),1) ...
X(:,2) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
X(:,3) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
X(:,4) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
X(:,5) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
X(:,6) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDX{2}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
X(:,1) ...
2.*X(:,2) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
X(:,3) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
X(:,4) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
X(:,5) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
X(:,6) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDX{3}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
X(:,1) ...
X(:,2) ...
2.*X(:,3) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
X(:,4) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
X(:,5) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
X(:,6) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDX{4}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
X(:,1) ...
X(:,2) ...
X(:,3) ...
2.*X(:,4) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
X(:,5) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
X(:,6) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDX{5}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
X(:,1) ...
X(:,2) ...
X(:,3) ...
X(:,4) ...
2.*X(:,5) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
X(:,6) ...
zeros(size(X,1),1) ...
];

MatDX{6}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
X(:,1) ...
X(:,2) ...
X(:,3) ...
X(:,4) ...
X(:,5) ...
2.*X(:,6)
];

CoefDX=[
0 1 2 0 1 0 0 1 0 0 0 1 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 
0 0 0 1 1 2 0 0 1 0 0 0 1 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 
0 0 0 0 0 0 1 1 1 2 0 0 0 1 0 0 0 0 1 0 0 0 0 0 1 0 0 0 
0 0 0 0 0 0 0 0 0 0 1 1 1 1 2 0 0 0 0 1 0 0 0 0 0 1 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 2 0 0 0 0 0 1 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 2 
];
end

if dersecond
MatDDX=cell(size(X,2),size(X,2));

MatDDX{1}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
2.*ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{2}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{3}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{4}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{5}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{6}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{7}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{8}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
2.*ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{9}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{10}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{11}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{12}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{13}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{14}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{15}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
2.*ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{16}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{17}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{18}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{19}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{20}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{21}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{22}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
2.*ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{23}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{24}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{25}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{26}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{27}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{28}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{29}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
2.*ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{30}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{31}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{32}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{33}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{34}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{35}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
ones(size(X,1),1) ...
zeros(size(X,1),1) ...
];

MatDDX{36}=[
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
zeros(size(X,1),1) ...
2.*ones(size(X,1),1) ...
];

CoefDDX=[
0 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 
0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 
0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 
];
end

end

