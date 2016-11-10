%% Generate Positions
step = pi/4;
nrotors = 7;
disp('Generating Positions');
tic;
%possible positions for a rotor
w = b_gen3(step); %each position has an index

%combinations of the different rotor position indicies
%choosing nrotor placements out of the possible position indicies
v = 1:length(w);
combMat = nchoosek(v,nrotors);
[m,n] = size(combMat);
k = 1;

%using position index matrix to generate all possible rotor combinations
posMat = zeros(3,nrotors,m); %all possible rotor combinations
for i = 1:m
    for j = 1:nrotors
        posMat(:,j,k) = w(:,combMat(i,j));
    end
    k = k+1;
end
fprintf('Elapsed Time: %04.0f\n', toc);
%% Generate Forces
%generate possible force vectors
disp('Generating Forces');
step_A = pi/4;
w_A = b_gen3(step_A);
[~,n1] = size(w_A);
nForces = 1:n1;
%each force vector can be used at each rotor
v_A = [];
for i = 1:nrotors
    v_A = [v_A nForces];
end
%all possible combinations of force vector indicies
combMat_A = nchoosek(v_A,nrotors);
[m_P,n_P] = size(combMat_A);
fprintf('Elapsed Time: %04.0f\n', toc);
%% Run A matricies through w_solver
%run through w_solver
ctr = 1;
F_A = zeros(3,nrotors);

%display text setup
nCases = m*m_P;
modsplit = 20;
if ((nCases/modsplit) > modsplit)
    modsplit = (nCases/modsplit);
end
fprintf('Solving %d Cases\n',nCases);
sumT = 0;
for k = 1:m
    %recall position matrix
    p_A = posMat(:,:,k);
    for i = 1:m_P
        tic
        for j = 1:n_P
            %create force matrix using force vector indicies
            F_A(:,j) = w_A(:,combMat_A(i,j));
        end
        %M = FxP
        M_A = cross(p_A,F_A);
        A = [F_A; M_A];
        %maximize the minimum wrench
        [min_w,~,~] = w_solver(A);
        
        %store results
        params = strcat(num2str(k),'_', num2str(i),'_',num2str(j));
        data(ctr).params = params;
        data(ctr).wrench = min_w;
        data(ctr).pos = p_A;
        data(ctr).force = F_A;
        data(ctr).A = A;
        T = toc;
        sumT = sumT + T;
        if (mod(i,round(nCases/modsplit))==0)
            fprintf('%04d / %04d - %05.2f%% - %05.0f sec / %05.0f sec\n',...
                ctr, nCases, ctr/nCases*100, sumT, sumT/ctr*nCases);
        end
        ctr = ctr + 1;
    end
end


