A = 2;
tauN = 0.2;
tauW = 0.2;
num = A*[1 1/tauN]/tauW;
den = [1 0 0];
rlocus(num,den); rlocfind(num,den)
numd = [-0.05 1]
dend = [0.05 1]
G=tf(conv(numd,num),conv(dend,den))
rlocus(G); rlocfind(G)
numd = [-0.02 1]
dend = [0.02 1]
G=tf(conv(numd,num),conv(dend,den))
rlocus(G); rlocfind(G)
numI = [1 1]
denI = [1 0]
G=tf(conv(numI,conv(numd,num)),conv(denI,conv(dend,den)))
rlocus(G); rlocfind(G)