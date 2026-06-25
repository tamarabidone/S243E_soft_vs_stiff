function [MVAR] = CreateFALconnections(MVAR)

    nF = size(MVAR.Filaments.XYCoords,1);
    D = MVAR.ModelParameters.FAL_connection_Distance; % nm
    MinDist = MVAR.ModelParameters.MonomerLength; % Minimum distance for connection. 
    %SO = MVAR.ModelParameters.Substrate.Ycoords; % Substrate offset
    % Test if Adhesions are within a distance D of a filament/Monomer
    if ~isempty(MVAR.Filaments.XYCoords) % Make sure there are filaments
            %-----------------------------------------------------------------------------------------------------------------------------
            for f = 1:nF
                        % Grab XY points of all monomers making up this filament
                        XY_filament = MVAR.Filaments.XYCoords{f};
                        idx1 = find( MVAR.FALconnections.FilamentName  == MVAR.Filaments.Name(f,1) );
                        if ~isempty(idx1)
                            idx2 = find( ismember( MVAR.Filaments.MonomerIndices{f},MVAR.FALconnections.MonomerIndex(idx1)) );
                            XY_filament(idx2,:) = NaN;  % Set monomer positions that are already connected to a ligand/adhesion to nan
                        end
                        
                        % Grab XY connections of all unattached (inactive) adhesions 
                        XY_adhesions = MVAR.Adhesions.XYpoints;
                        XY_adhesions(MVAR.FALconnections.AdhesionIndex,:) = NaN; % Set adhesions already connected to nan
                        
                        % Grab XY connections of all unattached ligands
                        XY_ligands = MVAR.Ligands.XYpoints;
                        XY_ligands(MVAR.FALconnections.LigandIndex,:) = NaN;
                        
                        % Calculate distance from Adhesions to filament monomers
                        Distance_AF = sqrt(   (XY_adhesions(:,1) - XY_filament(:,1)').^2 + (XY_adhesions(:,2) - XY_filament(:,2)').^2   );
                        % Calculate distance from Adhesions to Ligands
                        Distance_AL = sqrt(   (XY_adhesions(:,1) - (XY_ligands(:,1)') ).^2 + (XY_adhesions(:,2) - (XY_ligands(:,2)') ).^2   );
                        
                        % Find adesion-filament and adhesion-ligand distances less than D
                        MinInEachRow_AF = false(size(Distance_AF));
                        [~,MinIdx] = min(Distance_AF,[],2,'linear');
                        MinInEachRow_AF(MinIdx) = true;
                        
                        MinInEachRow_AL = false(size(Distance_AL));
                        [~,MinIdx] = min(Distance_AL,[],2,'linear');
                        MinInEachRow_AL(MinIdx) = true;
                        
                        [Aidx1,Midx] = find( Distance_AF <= D & MinInEachRow_AF );
                        [Aidx2,Lidx] = find( Distance_AL <= D & MinInEachRow_AL ) ;
                        
                        % Find adhesions that are close to a monomer and ligand
                        [~,idx3,idx4] = intersect(Aidx1,Aidx2);
                        
                        % Create adhesion-filament-ligand connection
                        if ~isempty(idx3)
                            for c = 1:length(idx3)
                                p_on = 1 - exp(-MVAR.ModelParameters.Adhesion_ActivationRate * MVAR.ModelParameters.TimeStep); % Calculate connection probability
                                if rand < p_on % test probability of this interaction happening
                                    a = Aidx1(idx3(c));
                                    l = Lidx (idx4(c)); 
                                    m = MVAR.Filaments.MonomerIndices{f}( Midx(idx3(c)) );
                                    n = MVAR.Filaments.Name(f);

                                    MVAR.FALconnections.FilamentName  = [ MVAR.FALconnections.FilamentName;  n ];
                                    MVAR.FALconnections.MonomerIndex  = [ MVAR.FALconnections.MonomerIndex;  m ];
                                    MVAR.FALconnections.AdhesionIndex = [ MVAR.FALconnections.AdhesionIndex; a ];
                                    MVAR.FALconnections.LigandIndex   = [ MVAR.FALconnections.LigandIndex;   l ];

                                    MVAR.Adhesions.AttachedFilamentName(a,1) = n;
                                    MVAR.Adhesions.AttachedLigandIndex(a,1) = l;
                                    MVAR.Adhesions.ActiveStatus(a,1) = true;
                                    MVAR.Adhesions.XYpoints(a,:) = MVAR.Ligands.XYpoints(l,:);

                                    MVAR.Ligands.AttachedFilamentName(l)  = n;
                                    MVAR.Ligands.AttachedAdhesionIndex(l) = a;
                                end
                            end
                        end
            end
            %-----------------------------------------------------------------------------------------------------------------------------
    end
    
    
end
