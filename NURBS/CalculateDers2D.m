function [dR] = CalculateDers2D(Model,u,v,P)
pu = Model.pu; pv = Model.pv;                                              % Polynomial Orders
U = Model.U; V = Model.V;                                                % Knot Vectors 
nen = (pu+1)*(pv+1);        
nu = FindSpanLinear(Model.nu,pu,u,U) +1; nv = FindSpanLinear(Model.nv,pv,v,V) +1;                                            % NURBS coordinates / span #


R = zeros(nen,1);                                                          % Bivariate NURBS basis funs
dR_duv = zeros(nen,2);                                                     % Bivariate NURBS derivaties
                                                                           % (:,1)=du; (:,2)=dv;
dR = zeros(nen,2);                          
Q = 0;                                      % Weight of NURBS Basis
dQ_du = 0;                                  % Weights of NURBS Derivatives
dQ_dv = 0;

weight = zeros(1,nen);                      % Array of weights in column
dx_du = zeros(2,2);                         % Derivatives of physical to 
du_dx = zeros(2,2);                         % parameter coordinate/inverse

%% B-Spline Basis and Derivatives to NURBS Basis and Derivatives
NU = DersBasisFun(nu-1,u,pu,1,U); % Basis and 1st derivative in U direction 
NV = DersBasisFun(nv-1,v,pv,1,V); % Basis and 1st derivative in V direction
N = NU(1,:);                      % U Knot Basis
dN = NU(2,:);                     % U Knot Derivative
M = NV(1,:);                      % V Knot Basis
dM = NV(2,:);                     % V Knot Derivative
clear NU NV

%% NURBS Rational Basis Functions

% Select the points and weights that are locally supported.
% Going descend direction (nu-uu) because that's how the book does
% And going ascend direction was giving some errors.
location = 0;
    for vv=0:pv
        for uu=0:pu
            location = location+1;
            weight(location) = P{nu-uu,nv-vv}(4);
        end
    end
    location = 0;
    for vv=0:pv
        for uu=0:pu
            location = location+1;
            % Total Weighting
            Q = Q + N(pu-uu+1)*M(pv-vv+1)*weight(location);
            % Weight derivatives in regards to parametric coordinates
            dQ_du = dQ_du + dN(pu-uu+1)*M(pv-vv+1)*weight(location);
            dQ_dv = dQ_dv + N(pu-uu+1)*dM(pv-vv+1)*weight(location);
        end
    end
% Making the rational NURBS basis
location = 0;
    for vv=0:pv
        for uu=0:pu
            location = location+1;
            ratio = weight(location)/(Q*Q); % Rational NURBS Weight
            BASIS = N(pu-uu+1)*M(pv-vv+1); % B-Spline Basis
            R(location) = BASIS*ratio*Q; % NURBS Basis
            % NURBS Basis derivatives with regards to parametric space
            dR_duv(location,1) = dN(pu-uu+1)*M(pv-vv+1) - BASIS*dQ_du;
            dR_duv(location,2) = N(pu-uu+1)*dM(pv-vv+1) - BASIS*dQ_dv;
            dR_duv(location,:) = dR_duv(location,:)*ratio;
        end
    end
%% Jacobian
% From parameter space to physical space
location = 0;
    for vv=0:pv
        for uu=0:pu
            location = location+1;
            for xx=1:2
                for yy=1:2
                    dx_du(xx,yy) = dx_du(xx,yy) +P{nu-uu,nv-vv}(xx)*dR_duv(location,yy);
                end
            end
        end
    end
% Compute inverse
du_dx = inv(dx_du);

% Compute derivatives of basis functions with respect to  physical
% coordinates
for location=1:nen
    for xx=1:2
        for yy=1:2
            dR(location,xx) = dR(location,xx)+ dR_duv(location,yy)*du_dx(yy,xx);
        end
    end
end

end