y = 0:.5:3*pi/2;
r = 0*y; 
p = sin(y);

r0 = eul2rotm([r(1),p(1),y(1)]);
rs = r0;
rs0 = r0*inv(rs);
for i = 1:length(y)
    rt0 = rs0*eul2rotm([r(i),p(i),y(i)])
    rt0*[1;0;0]
end