function [MVAR, AdhesionTensions, Data, StretchDistance] = ...
                                  CalculatePositionAfterAppliedForces(MVAR)
                              

    % Find all the main filaments of connected filament structures (group of attached filaments)
    idxMF = find(MVAR.Filaments.Parent == 0);
    nMF = length(idxMF); % Total number of filament structures
    dt = MVAR.ModelParameters.TimeStep;
    kT = MVAR.ModelParameters.kT;
    FilamentTips = GetFilamentsTipLocations(MVAR);
    AdhesionTensions = NaN(size(MVAR.Adhesions.ActiveStatus));
    StretchDistance = NaN(size(MVAR.Adhesions.ActiveStatus));

    
    nF_1 = length(MVAR.Filaments.Name);

    Data.YSpeed    = NaN(nF_1,1, 'single');
    Data.FilamentName = NaN(nF_1,1, 'single');
    Data.XYPosition = NaN(nF_1,2, 'single');
    Data.StructName = NaN(nF_1,1, 'single');
    Data.Parent = NaN(nF_1,1, 'single');
    Data.Orientation = NaN(nF_1,2, 'single');
    Data.Main = NaN(nF_1,1, 'single');
    Data.FilamentLength = NaN(nF_1,1, 'single');
    Data.DistanceMembrane = NaN(nF_1,1, 'single');
    Data.ForceonMembrane = NaN(nF_1,1, 'single');
    Data.AdhesionForceComp = []; % [Fax,Fay,Fname]
    Data.SubstrateForce = [];
    Data.ForceonSubstrate = [];
    idxF = 0;
    
    TotalForceOnSubstrate = 0;

    %% FILAMENT MOTION SECTION 
    if ~isempty(MVAR.Filaments.Name)
                for MF = 1:nMF % Go through each filament structure and test each of its filaments to see if it is hitting the membrane and calculate the total force acting on the structure.
                        L = 0; % Total length of Filament
                        idx1 = find( MVAR.Filaments.MainIndex == MVAR.Filaments.Name(idxMF(MF)) ); % Find all filaments attached to same structure
                        nF = length(idx1); % number of filaments in this structure
                    % Calculate total length of filament structure
                        for f = idx1'  
                            L = L + length(MVAR.Filaments.MonomerIndices{f}) * MVAR.ModelParameters.MonomerLength; % L is total length of filament structure in microns
                        end 
                    % CALCULATE FORCES DUE TO FILAMENT-ADHESION CONNECTIONS and break connections where force is greater than threshold
                       [FAx,FAy,FAvalues,MVAR,AdhesionTensions, StretchDistance] = CalculateForceDueToFALconnections(idx1,MVAR,AdhesionTensions, StretchDistance);
                       TotalForceOnSubstrate = TotalForceOnSubstrate + FAy;
                       %disp(TotalForceOnSubstrate);
                       

                    % CALCULATE FORCES ACTING ON FILAMENT FROM MEMBRANE
                        % Calculate sum of the normal forces from filements pushing on membrane (all from the same structure)
                        Fm = TotalForceExertedByMembraneOnFilamentStructure(idx1,MVAR);

                    % CALCULATE NEW POSITION FOR FILAMENT STRUCTURE
                        Nu = MVAR.ModelParameters.CytoplasmViscosity*(10^-6); % pN s/nm^2
                        r  = 7/2; % nm
                        L( L < r ) = r;
                        gamma1 =  (4*pi*Nu*L) / (0.84+log(L/(2*r) )); % gamma for random fluid motion (pN*s/nm) 
                        SD = sqrt(2*kT*gamma1/dt);                    % sqrt(2*(pN*nm)*(pN*S/um)/S)
                        
                        % Add filament thermal motion if it's turned on ------
                        if MVAR.ModelParameters.FilamentThermalMotionOn
                            Fx = SD*randn;
                            Fy = SD*randn;
                        else
                            Fx = 0;
                            Fy = 0;
                        end
                        %-----------------------------------------------------
                        
                        tipXpositions = NaN(nF,1);
                        for n = 1:nF % Loop through all the filaments attached to this structure
                                idxF = idxF +1;
                                f = idx1(n);
                                yprevious = MVAR.Filaments.XYCoords{f}(end,2);

                                % START Calculate New Filament Position ------------------------------------------------------------------------------------------
                                MVAR.Filaments.XYCoords{f}(:,1) = MVAR.Filaments.XYCoords{f}(:,1)  +  (Fx + FAx     ) * dt/gamma1;   % Compute new position in X direction
                                MVAR.Filaments.XYCoords{f}(:,2) = MVAR.Filaments.XYCoords{f}(:,2)  +  (Fy + FAy + Fm) * dt/gamma1;   % Compute new position in Y direction
                                % END Calculate New Filament Position --------------------------------------------------------------------------------------------

                                % Record Filament Speed, Position, Region, etc of each tip -------------------------------------------------
                                YDist = (MVAR.Filaments.XYCoords{f}(end,2) - yprevious); % Calculate retrogade flow velocity
                                Data.YSpeed(idxF,1)       = single(YDist/MVAR.ModelParameters.TimeStep);
                                Data.FilamentName(idxF,1) = single(MVAR.Filaments.Name(f,1)) ;
                                Data.XYPosition(idxF,:)   = single(MVAR.Filaments.XYCoords{f}(end,:)) ;
                                Data.StructName(idxF,1)   = single(MVAR.Filaments.MainIndex(f,1)) ;
                                Data.Parent(idxF,1)       = single(MVAR.Filaments.Parent(f,1)) ;
                                Data.Orientation(idxF,:)  = single(MVAR.Filaments.UnitVector(f,:)) ;
                                Data.Main(idxF,1)         = single(MVAR.Filaments.MainIndex(f,:)) ;
                                Data.FilamentLength(idxF,1) = single(length(MVAR.Filaments.MonomerIndices{f})*MVAR.ModelParameters.MonomerLength);
                                Data.DistanceMembrane(idxF,1) = single(MVAR.Membrane.Nodes.Ycoords(1,1)- MVAR.Filaments.XYCoords{f}(end,2));
                                Data.AdhesionForceComp = [Data.AdhesionForceComp; single(FAvalues)];
                                % Record for mirroring -------------------------------------------------------------------------------------
                                tipXpositions(n,1) = MVAR.Filaments.XYCoords{f}(end,1); 
                        end
                        

                        % START HORIZONTAL FILAMENT PERIODIC BOUNDARY ---------------------------------------------------------------------------------------------------------------
                        BreakIdx = [];
                        Offset = 0;
                            % Check if any of the filament tips in the structure are crossing the left or right membrane edge
                            if  min(tipXpositions) < MVAR.Membrane.Nodes.Xcoords(1) 
                                Offset = MVAR.Membrane.Nodes.Xcoords(2) - max(tipXpositions); 
                            elseif max(tipXpositions) > MVAR.Membrane.Nodes.Xcoords(2) 
                                Offset = MVAR.Membrane.Nodes.Xcoords(1) - min(tipXpositions);
                            end
                            % If there are any filaments out of bounds, move the whole structure to the otherside just within the bounds
                            if ~isequal(Offset,0)
                                        % Apply offset to each filament in the structure
                                        for n = 1:nF
                                            f = idx1(n);
                                            MVAR.Filaments.XYCoords{f}(:,1) = MVAR.Filaments.XYCoords{f}(:,1) + Offset; % Apply Offset
                                            % Find adhesion connections if they exists, and delete connection
                                            [MVAR] = DeleteFALconnection('FilamentName',MVAR.Filaments.Name(f,1),MVAR);
                                        end
                            end
                        % END HORIZONTAL FILAMENT PERIODIC BOUNDARY ---------------------------------------------------------------------------------------------------------------
                end 
    end
    
    
    
    %% MEMBRANE MOTION SECTION
    
                % Calculate new positions for membrane -------------------------------
                Nu = MVAR.ModelParameters.MatrixViscosity*(10^-6); % pN s/nm^2 %
                L  = MVAR.ModelParameters.MembraneWidth;  % membrane width in nm
                r  = MVAR.ModelParameters.MembraneRadius; % nm 
                MVAR.ModelParameters.MembraneGamma = (4*pi*Nu*L) / (0.84+log(L/(2*r) )); % gamma for random fluid motion (pN*s/nm) 
                gamma3 = MVAR.ModelParameters.MembraneGamma; % gamma for random fluid motion (pN*s/nm) %
                
                if ~isempty(MVAR.Filaments.Name)
                        Ff = CalculateForceFromFilamentsHittingMembraneSegment(MVAR);
                        Data.ForceonMembrane = Ff;
                        Ff = sum(Ff,'omitnan');
                        MVAR.Membrane.Nodes.Ycoords = MVAR.Membrane.Nodes.Ycoords + Ff*dt/gamma3; % Move y-position of membrane
                end

    
    %% ADHESION MOTION SECTION (not connected)
    
                gamma4 = MVAR.ModelParameters.AdhesionGamma;
                Aidx = find( ~MVAR.Adhesions.ActiveStatus ); % Find all un-activated or unattached adhesion indices
                nA = length(Aidx);
                SD = sqrt(2*kT*gamma4/dt);     

                if ~isempty(Aidx)
                    Fx = SD*randn(nA,1); % Calculate Brownian motion forces
                    Fy = SD*randn(nA,1);
                    MVAR.Adhesions.XYpoints(Aidx,1) = MVAR.Adhesions.XYpoints(Aidx,1) + Fx*dt/gamma4;
                    MVAR.Adhesions.XYpoints(Aidx,2) = MVAR.Adhesions.XYpoints(Aidx,2) + Fy*dt/gamma4;
                end
    
                
%% SUBSTRATE MOTION SECTION 
% gamma5 = 6*pi*100*10^-6*(500/sqrt(2)); 
% ks_global = MVAR.ModelParameters.k_s_global; 
% Ymem = MVAR.Membrane.Nodes.Ycoords(end); 
% Sub_F = -(MVAR.ModelParameters.YPrev - Ymem)*ks_global; 
% MVAR.ModelParameters.Substrate.Ycoords = MVAR.ModelParameters.YPrev + (-TotalForceOnSubstrate + Sub_F)*dt/gamma5; 
% Sub_M = MVAR.ModelParameters.Substrate.Ycoords - MVAR.ModelParameters.YPrev; 
% alpha = 0.01; % Tune this: smaller alpha means ligands lag substrate more 
% ligand_shift = alpha * Sub_M; MVAR.Ligands.XYpoints(:,2) = MVAR.Ligands.XYpoints(:,2) + ligand_shift; 
%MVAR.ModelParameters.YPrev = MVAR.ModelParameters.Substrate.Ycoords; 
%Data.SubstrateForce = Sub_F; 
%Data.SubPosition = MVAR.ModelParameters.Substrate.Ycoords;

k_a = MVAR.ModelParameters.k_a;
k_l = MVAR.ModelParameters.k_l;
nu =  MVAR.ModelParameters.nu;

if ~isfield(MVAR.ModelParameters,'PrevForce')
    MVAR.ModelParameters.PrevForce = TotalForceOnSubstrate;
end
PrevForce = MVAR.ModelParameters.PrevForce;
dFs = (TotalForceOnSubstrate - PrevForce)/dt;
MVAR.ModelParameters.YPrev = MVAR.ModelParameters.Substrate.Ycoords; 
MVAR.ModelParameters.Substrate.Ycoords = MVAR.ModelParameters.YPrev + (k_a*TotalForceOnSubstrate + nu*(dFs) - k_a*k_l*MVAR.ModelParameters.YPrev)*(dt/((k_a + k_l)*nu));                
Sub_M = MVAR.ModelParameters.Substrate.Ycoords - MVAR.ModelParameters.YPrev; 
alpha = 0.01; % Tune this: smaller alpha means ligands lag substrate more 
ligand_shift = alpha * Sub_M; 
MVAR.Ligands.XYpoints(:,2) = MVAR.Ligands.XYpoints(:,2) + ligand_shift; 

Data.SubPosition = MVAR.ModelParameters.Substrate.Ycoords;
MVAR.ModelParameters.PrevForce = TotalForceOnSubstrate;


end
%% START of Sub-functions ============================================================================================================================================================================================================

function Fm = TotalForceExertedByMembraneOnFilamentStructure(FilInd,MVAR)
            
            Fm = 0;
            for f = FilInd' % Calculate the force of the membrane is exerting on all the filaments in this structure
                    y = MVAR.Membrane.Nodes.Ycoords(1) - MVAR.Filaments.XYCoords{f}(end,2); % Distance of filament tip from membrane
                    %|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                    % Evaluate normal force of filament against membrane velocity eq.5 (Mogliner and Oser 1996);
                    theta = abs(atand( MVAR.Filaments.UnitVector(f,1)/MVAR.Filaments.UnitVector(f,2) ));
                    theta(theta < 1 ) = 1; % For model stability, keep theta greater than 1 degree
                    lambda = MVAR.ModelParameters.PersistenceLength;
                    kT = MVAR.ModelParameters.kT;
                    L = length(MVAR.Filaments.MonomerIndices{f})*MVAR.ModelParameters.MonomerLength;
                    L( L<30  ) = 30;
                    L( L>150 ) = 150;
                    delta = MVAR.ModelParameters.MonomerLength*cosd(theta);
                    K = 4*lambda*kT/(L.^3*sind(theta).^2); % eq. B.1
                    if y >= 0
                        Fn = -sqrt(2*kT*K/pi).*exp(-K*y.^2/(2*kT))./( erf(y*sqrt(K/(2*kT))) + 1 ); % Normal force calculation (force is in -y direction)
                    else
                        Fn = -sqrt(2*kT*K/pi).*exp(-K*y.^2/(2*kT))./( erfc( abs( y*sqrt(K/(2*kT)) ) ) );
                    end
                    %|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                    Fn( isnan(Fn) | isinf(Fn) ) = -100;
                    Fm = Fm + Fn;
            end

end


%======================================================================================================
%======================================================================================================

function Ff = CalculateForceFromFilamentsHittingMembraneSegment(MVAR)
        
        
        % Add up all the filament forces on the membrane
        Ff = []; %0;
        nF = length(MVAR.Filaments.Name);
        for f = 1:nF
            y = MVAR.Membrane.Nodes.Ycoords(1) - MVAR.Filaments.XYCoords{f}(end,2); % Distance of filament tip from membrane
            %|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
            % Evaluate force of filament against membrane  eq.5 (Mogliner and Oser 1996);
            theta = abs( atand( MVAR.Filaments.UnitVector(f,1) / MVAR.Filaments.UnitVector(f,2) ) );
            theta(theta < 1 ) = 1; % For model stability, keep theta greater than 1 degree 
            lambda = MVAR.ModelParameters.PersistenceLength;
            kT = MVAR.ModelParameters.kT;
            L = length(MVAR.Filaments.MonomerIndices{f}) * MVAR.ModelParameters.MonomerLength;
            L( L<30  ) = 30;
            L( L>150 ) = 150;
            delta = MVAR.ModelParameters.MonomerLength * cosd(theta);
            K = 4*lambda*kT / (L.^3 * sind(theta).^2) ; % eq. B.1
            
            if y >= 0
                Fm = sqrt(2*kT*K/pi).*exp(-K*(y.^2)/(2*kT))./( erf(y*sqrt(K/(2*kT))) + 1 ); % Normal force calculation (force is in +y direction)
            else
                Fm = sqrt(2*kT*K/pi).*exp(-K*(y.^2)/(2*kT))./( erfc( abs( y*sqrt(K/(2*kT)) ) ) ); % Variation of same equation do to bad precision of erf function near 0
            end

            Fm( isnan(Fm) | isinf(Fm) ) = 100;
            %|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
            Ff = [Ff;Fm]; %Ff + Fm;
        end   
       
end

%======================================================================================================
%======================================================================================================
        
function [FAx,FAy,FAvalues,MVAR,AdhesionTensions,StretchDistance] = ...
         CalculateForceDueToFALconnections(idx,MVAR,AdhesionTensions,StretchDistance)

    [A,B,C,D] = MolecularClutchPeakParameters(MVAR.ModelParameters.MolecularClutch_PeakNumber);

    % outputs
    FAx = 0;
    FAy = 0;
    FAvalues = [];
    Aidx = [];

    k_c        = MVAR.ModelParameters.k_c;        
    % ks_local  = MVAR.ModelParameters.k_s_local;  
    % ks_global = MVAR.ModelParameters.k_s_global; 

    %k_cl = (kc * ks_local) / (kc + ks_local);

    if ~isempty(MVAR.FALconnections.AdhesionIndex)

        for f = idx'
            % find all adhesions connected to this filament
            con = find(MVAR.FALconnections.FilamentName == MVAR.Filaments.Name(f,1));
            if isempty(con), continue; end

            for c = con'
                aidx = MVAR.FALconnections.AdhesionIndex(c);
                lidx = MVAR.FALconnections.LigandIndex(c);
                midx = find(MVAR.Filaments.MonomerIndices{f} == MVAR.FALconnections.MonomerIndex(c));

                % adhesion is at the ligand position
                MVAR.Adhesions.XYpoints(aidx,:) = MVAR.Ligands.XYpoints(lidx,:);

                % geometry
                xDist = MVAR.Adhesions.XYpoints(aidx,1) - MVAR.Filaments.XYCoords{f}(midx,1);
                yDist = MVAR.Adhesions.XYpoints(aidx,2) - MVAR.Filaments.XYCoords{f}(midx,2);
                Sep   = sqrt(xDist^2 + yDist^2);
                Stretch = Sep - MVAR.ModelParameters.AdhesionSpringEqLength;
                F = k_c * Stretch;

                if Sep > 0
                    Fx = F * (xDist / Sep);
                    Fy = F * (yDist / Sep);
                else
                    Fx = 0; Fy = F;
                end

                AdhesionTensions(aidx) = F;
                StretchDistance(aidx) = Stretch;

                k_off = A*exp(B*F) + C*exp(D*F);
                p_unbind = 1 - exp(-k_off * MVAR.ModelParameters.TimeStep);

                if rand < p_unbind && MVAR.ModelParameters.Adhesion_MolecularClutchOn
                    Aidx = [Aidx; aidx];
                else
                    FAx = FAx + Fx;
                    FAy = FAy + Fy;
                    FAvalues = [FAvalues; [Fx, Fy, MVAR.Filaments.Name(f,1)]];
                end
            end
        end

        % delete broken adhesions
        if MVAR.ModelParameters.Adhesion_MolecularClutchOn && ~isempty(Aidx)
            MVAR = DeleteFALconnection('AdhesionIndex', Aidx, MVAR);
        end
    end
end
