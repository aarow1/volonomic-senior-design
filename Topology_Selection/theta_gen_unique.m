function theta = A_gen_unique()
% clear all
step = pi/6;
v = [0:step:11*pi/6];
n = length(v);

rd(1) = n; % all the same         % 5
rd(2) = n*(n-1);                  % 4 1
rd(3) = n*(n-1)           *2;     % 3 2
rd(4) = n*nchoosek(n-1,2) *2;     % 3 1 1
rd(5) = n*nchoosek(n-1,2) *4;     % 2 2 1
rd(6) = n*nchoosek(n-1,3) *6;     % 2 1 1 1
rd(7)=nchoosek(n,5)*factorial(4); % 1 1 1 1 1

tot = sum(rd);

theta1(1:n,:) = v(:)*[1 1 1 1 1];  % all the same
c_2 = nchoosek([1:n],2);
c_3 = nchoosek([1:n],3);

%% choose 4 and 1
for i = 1:66
    odd = 2*i-1;
    even = 2*i;
    a = v(c_2(i,1));
    b = v(c_2(i,2));
    theta2(odd,:) = [a*[1 1 1 1], b];
    theta2(even,:) = [b*[1 1 1 1], a];
end

%% choose 3 and 2
for i = 1:66 % a a a b b
    odd = 2*i-1;
    even = 2*i;
    a = v(c_2(i,1));
    b = v(c_2(i,2));
    theta3(odd,:) = [a*[1 1 1], b*[1 1]];
    theta3(even,:) = [b*[1 1 1], a*[1 1]];
end
for i = 1:66 % a a b a b
    odd = 132 + 2*i-1;
    even = 132 + 2*i;
    a = v(c_2(i,1));
    b = v(c_2(i,2));
    theta3(odd,:) = [a, a, b, a, b];
    theta3(even,:) = [b, b, a, b, a];
end

%% choose 3 1 1
    c11_2 = nchoosek([1:n-1],2);
    num = nchoosek(n-1,2);
    theta4 = zeros([1320, 5]);
for i = 1:12
    opts = v;
    a = v(i);
    opts(opts == a) = []; % all angles except first chosen
    %     combo_2(end+1:end+num,:) = [combo_2(:,2), combo_2(:,1)];
    for j = 1:num
        b = opts(c11_2(j,1));
        c = opts(c11_2(j,2));
        
        odd = (i-1)*110 + 2*j-1;
        even = (i-1)*110 + 2*j;
        theta4(odd,:) = [a, a, a, b, c];
        theta4(even,:) = [a, a, b, a, c];
    end
end

%% choose 2 2 1
theta5 = zeros([2640 5]);
for i = 1:12
    opts = v;
    a = v(i);
    opts(opts == a) = [];
    for j = 1:num
        b = opts(c11_2(j,1));
        c = opts(c11_2(j,2));
        
        g_1 = (i-1)*220 + 4*j-3;
        g_2 = (i-1)*220 + 4*j-2;
        g_3 = (i-1)*220 + 4*j-1;
        g_4 = (i-1)*220 + 4*j;
        
        theta5(g_1,:) = [a b c c b];
        theta5(g_2,:) = [a c b b c];
        theta5(g_3,:) = [a b b c c];
        theta5(g_4,:) = [a b c b c];
    end
end
%% Total angle
theta = [theta1(:,:); theta2(:,:); theta3(:,:); theta4(:,:); theta5(:,:)];
