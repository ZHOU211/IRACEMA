function BoundarySurfIndex = ExtractFacesIndex(Model)


%%%return the control points  of the surfaces of a volumetric model
PP = Model.get_point_cell;
sz = size(PP);
P = zeros(sz(1),sz(2),sz(3));

for i=1:sz(1)
    for j=1:sz(2)
        for k=1:sz(3)
            P(i,j,k) = sub2ind(size(P),i,j,k);
        end
    end
end


BoundarySurfIndex = cell(6,1);

 %%%%%%%%%%%%%%%%%%% face 1
 %%%%%%%%%%%%%%%%%%%%  ---------------
 %%%%%%%%%%%%%%%%%%%% v               |
 %%%%%%%%%%%%%%%%%%%% ^               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%%  --------->u----


BoundarySurfIndex{1}.P(:,:) = P(:,:,1);

 %%%%%%%%%%%%%%%%%%% face 6
 %%%%%%%%%%%%%%%%%%%%  ---------------
 %%%%%%%%%%%%%%%%%%%% v         w=end |
 %%%%%%%%%%%%%%%%%%%% ^               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%%  --------->u----

BoundarySurfIndex{6}.P(:,:) = P(:,:,end);


 %%%%%%%%%%%%%%%%%%% face 4
 %%%%%%%%%%%%%%%%%%%%  ---------------
 %%%%%%%%%%%%%%%%%%%% v               |
 %%%%%%%%%%%%%%%%%%%% ^               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%%  --------->w----

BoundarySurfIndex{4}.P(:,:) = P(1,:,:);
BoundarySurfIndex{4}.P = BoundarySurfIndex{4}.P';

 %%%%%%%%%%%%%%%%%%% face 3
 %%%%%%%%%%%%%%%%%%%%  ---------------
 %%%%%%%%%%%%%%%%%%%% v        u=end  |
 %%%%%%%%%%%%%%%%%%%% ^               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%%  --------->w----

 
BoundarySurfIndex{3}.P(:,:) = P(end,:,:);
BoundarySurfIndex{3}.P = BoundarySurfIndex{3}.P';

 %%%%%%%%%%%%%%%%%%% face 2
 %%%%%%%%%%%%%%%%%%%%  ---------------
 %%%%%%%%%%%%%%%%%%%% w               |
 %%%%%%%%%%%%%%%%%%%% ^               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%%  --------->u----

BoundarySurfIndex{2}.P(:,:) = P(:,1,:);

 %%%%%%%%%%%%%%%%%%% face 5
 %%%%%%%%%%%%%%%%%%%%  ---------------
 %%%%%%%%%%%%%%%%%%%% w         v=end |
 %%%%%%%%%%%%%%%%%%%% ^               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%% |               |
 %%%%%%%%%%%%%%%%%%%%  --------->u----


BoundarySurfIndex{5}.P(:,:) = P(:,end,:);


end
