n=4;
allCombos=dec2bin(0:2^n-1) -'0';

b1=allCombos(:,1);
b2=allCombos(:,2);
b3=allCombos(:,3);
ba=allCombos(:,4);
c=ones(2^n,1);

coeffs=[1 1 1 1 1 1 -1 -1 -1  -1 1];
[b1.*b2 b1.*b3 b1.*ba b2.*b3 b2.*ba b3.*ba b1 b2 b3 ba c]*coeffs'


%%

b=[0 0 0 0 0 0 0 1]';
A=[...
0  0  0  0  0  0  1
0  0  0  0  0  1  1
0  0  0  0  1  0  1
0  0  1  0  1  1  1
0  0  0  1  0  0  1
0  1  0  1  0  1  1
1  0  0  1  1  0  1
1  1  1  1  1  1  1];

alpha=A\b
alpha=mldivide(A,b)
%%
A=[...
0  0  0  0  0  0  1
0  0  0  0  0  1  1
0  0  0  0  1  0  1
0  0  0  1  1  1  1
0  0  1  0  0  0  1
0  1  1  0  0  1  1
1  0  1  0  1  0  1
1  1  1  1  1  1  1];

alpha=A\b
alpha=mldivide(A,b)

%%
b=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 ]'; % this is maybe an error, because it should be 1 1 at the end, but it actually doesn't really matter
A=[...
0  0  0  0  0  0  0  0  0  0  1
0  0  0  0  0  0  0  0  0  1  1
0  0  0  0  0  0  0  0  1  0  1
0  0  0  0  0  1  0  0  1  1  1
0  0  0  0  0  0  0  1  0  0  1
0  0  0  0  1  0  0  1  0  1  1
0  0  0  1  0  0  0  1  1  0  1
0  0  0  1  1  1  0  1  1  1  1
0  0  0  0  0  0  1  0  0  0  1
0  0  1  0  0  0  1  0  0  1  1
0  1  0  0  0  0  1  0  1  0  1
0  1  1  0  0  1  1  0  1  1  1
1  0  0  0  0  0  1  1  0  0  1
1  0  1  0  1  0  1  1  0  1  1
1  1  0  1  0  0  1  1  1  0  1
1  1  1  1  1  1  1  1  1  1  1];

alpha=A\b
alpha=mldivide(A,b)

%% b1b2b3 with no triangles
b=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 ]'; % this is maybe an error, because it should be 1 1 at the end, but it actually doesn't really matter

A=[...
0 0 0 0 0 0 0 0 1
0 0 0 0 0 0 0 1 1
0 0 0 0 0 0 1 0 1
0 0 0 1 0 0 1 1 1
0 0 0 0 0 1 0 0 1
0 0 1 0 0 1 0 1 1
0 0 0 0 0 1 1 0 1
0 0 1 1 0 1 1 1 1
0 0 0 0 1 0 0 0 1
0 0 0 0 1 0 0 1 1
0 1 0 0 1 0 1 0 1
0 1 0 1 1 0 1 1 1
1 0 0 0 1 1 0 0 1
1 0 1 0 1 1 0 1 1
1 1 0 0 1 1 1 0 1
1 1 1 1 1 1 1 1 1];


alpha=A\b
alpha=mldivide(A,b)
%%
clear('res')
n=5;
allCombos=dec2bin(0:2^n-1) -'0';
b=mat2cell(allCombos,2^n,ones(1,n));
c=ones(2^n,1);

%% generate the array: A= [b1b2 b1b3 b1b4 b1ba b2b3 b2b4 b2ba b3b4 ... b1 b2 b3 b4 ba 1]:
A=c;
for i=1:n
    for j=i+1:n
        A=[A b{i}.*b{j}];
    end
end
for i = 1 : n
    A=[A b{i}];
end

A=[A c];
A(:,1)=[];

N=4;
res = zeros(2*N+1,2*N+1, 2*N+1);
res(1+N,:,:)=10;res(:,1+N,:)=10;res(:,:,1+N)=10;
for alpha123=[-N:-1 1:N]
    for alpha234=[-N:-1 1:N]
        for alpha341=[-N:-1 1:N]
LHS=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 alpha234 alpha234 0 0 0 0 0 0 alpha341 alpha341 0 0 0 0 alpha123 alpha123 alpha123+alpha234+alpha341 alpha123+alpha234+alpha341]';
    
alpha=A\LHS;
alpha=mldivide(A,LHS);
RHS = A*alpha;
%RHS = min(RHS(1:2:2^n -1), RHS(2:2:2^n));
res(1+N+alpha123,1+N+alpha234,1+N+alpha341)=norm(RHS-LHS); % LHS(1:2:2^n-1) if we minimise over b_a
        end
    end
end
[minRes minIndex]=min(min(min(res)));

[i, j, k] = ind2sub(size(res),find(res==0)); 

%%
alpha123=1;alpha234=-3;alpha341=-4;
LHS=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 alpha234 alpha234 0 0 0 0 0 0 alpha341 alpha341 0 0 0 0 alpha123 alpha123 alpha123+alpha234+alpha341 alpha123+alpha234+alpha341]';
alpha=A\LHS;
alpha=mldivide(A,LHS);
A*alpha;
