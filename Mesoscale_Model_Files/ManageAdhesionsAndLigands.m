function [MVAR] = ManageAdhesionsAndLigands(MVAR)
 
    
    SO = 0;


    %% ADHESION SECTION
    
            % Update adhesion regions 
               XY_LT = [ MVAR.Membrane.Nodes.Xcoords(1), MVAR.Membrane.Nodes.Ycoords(1) ]; %  Left-Top  xy-coordinates of current adhesion region
               XY_RT = [ MVAR.Membrane.Nodes.Xcoords(2), MVAR.Membrane.Nodes.Ycoords(2) ]; %  Right-Top xy-coordinates of current adhesion region
               XY_RB = [ MVAR.Membrane.Nodes.Xcoords(2), MVAR.Membrane.Nodes.Ycoords(2) - MVAR.ModelParameters.ModelDepth]; %  Right-Bottom xy-coordinates of current adhesion region
               XY_LB = [ MVAR.Membrane.Nodes.Xcoords(1), MVAR.Membrane.Nodes.Ycoords(1) - MVAR.ModelParameters.ModelDepth]; %  Left-Bottom  xy-coordinates of current adhesion region
               
            % Record Current Region
               MVAR.Adhesions.RegionNodes(1,:) = XY_LT;           
               MVAR.Adhesions.RegionNodes(2,:) = XY_RT;            
               MVAR.Adhesions.RegionNodes(3,:) = XY_RB; 
               MVAR.Adhesions.RegionNodes(4,:) = XY_LB; 
            
            % START Periodic boundary for Adhesions below lower adhesion region boundary ---------------------------------------------------------------------------------
                idx = find( (MVAR.Adhesions.XYpoints(:,2)) < MVAR.Adhesions.RegionNodes(4,2) ); 
                if ~isempty(idx)
                    if ~isempty(MVAR.FALconnections.AdhesionIndex)
                    idx = idx(~ismember(idx, MVAR.FALconnections.AdhesionIndex));
                    end
                        for idx2 = idx'
                                MVAR.Adhesions.XYpoints(idx2,2) = MVAR.Membrane.Nodes.Ycoords(:,2); 
                                % Find out if adhesion is connected to a filament/ligand
                                [MVAR] = DeleteFALconnection('AdhesionIndex',idx2,MVAR);
                        end
                end
            
            % START Periodic boundary for Adhesions above upper boundary ---------------------------------------------------------------------------------
                idx = find( MVAR.Adhesions.XYpoints(:,2) > MVAR.Adhesions.RegionNodes(2,2) ); 
                if ~isempty(idx) 
                    if ~isempty(MVAR.FALconnections.AdhesionIndex)
                    idx = idx(~ismember(idx, MVAR.FALconnections.AdhesionIndex));
                    end
                        for idx2 = idx'
                                MVAR.Adhesions.XYpoints(idx2,2) = MVAR.Adhesions.XYpoints(idx2,2) - MVAR.ModelParameters.ModelDepth; 
                                % Find out if adhesion is connected to a filament/ligand
                                [MVAR] = DeleteFALconnection('AdhesionIndex',idx2,MVAR);
                        end
                end
          
            % START Periodic boundary for Adhesions outside left boundary ---------------------------------------------------------------------------------
                idx = find( MVAR.Adhesions.XYpoints(:,1) < MVAR.Adhesions.RegionNodes(1,1) ); 
                if ~isempty(idx)  
                    if ~isempty(MVAR.FALconnections.AdhesionIndex)
                    idx = idx(~ismember(idx, MVAR.FALconnections.AdhesionIndex));
                    end
                        for idx2 = idx'
                                MVAR.Adhesions.XYpoints(idx2,1) = 500; 
                                % Find out if adhesion is connected to a filament/ligand
                                %[Filaments,Adhesions,Ligands,FALconnections] = DeleteFALconnection('AdhesionIndex',idx2,Filaments,Adhesions,Ligands,FALconnections);
                        end
                end
            
            
            % START Periodic boundary for Adhesions outside right boundary ---------------------------------------------------------------------------------
                idx = find( MVAR.Adhesions.XYpoints(:,1) > MVAR.Adhesions.RegionNodes(2,1) ); 
                if ~isempty(idx)  
                    if ~isempty(MVAR.FALconnections.AdhesionIndex)
                    idx = idx(~ismember(idx, MVAR.FALconnections.AdhesionIndex));
                    end
                        for idx2 = idx'
                                MVAR.Adhesions.XYpoints(idx2,1) = 0; 
                                % Find out if adhesion is connected to a filament/ligand
                                %[MVAR] = DeleteFALconnection('AdhesionIndex',idx2,Filaments,Adhesions,Ligands,FALconnections);
                        end
                end
            
           
            
    %% LIGAND SECTION
            
            % START Periodic boundary for Ligands below lower region boundary ---------------------------------------------------------------------------------
                idx = find( (MVAR.Ligands.XYpoints(:,2)) < MVAR.Adhesions.RegionNodes(4,2) ); 
                if ~isempty(idx)  
                    if ~isempty(MVAR.FALconnections.AdhesionIndex)
                    idx = idx(~ismember(idx, MVAR.FALconnections.LigandIndex));
                    end
                        for idx2 = idx'
                            % Define the bottom and top limits of the domain
                                %y_bottom = MVAR.Membrane.Nodes.Ycoords(:,2) - MVAR.ModelParameters.ModelDepth;
                                y_top = MVAR.Membrane.Nodes.Ycoords(:,2);
                                MVAR.Ligands.XYpoints(idx2,2) = y_top; 
                                % Find out if ligand is connected to a filament/adhesion. If so, delete it
                                [MVAR] = DeleteFALconnection('LigandIndex',idx2, MVAR);
                        end
                end
            
              % START Periodic boundary for ligands above upper boundary 
                 idx = find( MVAR.Ligands.XYpoints(:,2) > MVAR.Adhesions.RegionNodes(2,2) ); 
                if ~isempty(idx) 
                    if ~isempty(MVAR.FALconnections.AdhesionIndex)
                    idx = idx(~ismember(idx, MVAR.FALconnections.LigandIndex));
                    end
                        for idx2 = idx'
                                y_bottom = MVAR.Membrane.Nodes.Ycoords(:,2) - MVAR.ModelParameters.ModelDepth;
                                %y_top = MVAR.Membrane.Nodes.Ycoords(:,2);
                                MVAR.Ligands.XYpoints(idx2,2) = y_bottom; 
                                % Find out if ligand is connected to a filament/adhesion
                                [MVAR] = DeleteFALconnection('LigandIndex',idx2,MVAR);
                        end
                end

                 % START Periodic boundary for Adhesions outside left boundary ---------------------------------------------------------------------------------
                idx = find( MVAR.Ligands.XYpoints(:,1) < MVAR.Adhesions.RegionNodes(1,1) ); 
                if ~isempty(idx) 
                    if ~isempty(MVAR.FALconnections.AdhesionIndex)
                    idx = idx(~ismember(idx, MVAR.FALconnections.LigandIndex));
                    end
                        for idx2 = idx'
                                MVAR.Ligands.XYpoints(idx2,1) = MVAR.Ligands.XYpoints(idx2,1) + MVAR.ModelParameters.ModelDepth; 
                                % Find out if adhesion is connected to a filament/ligand
                                %[Filaments,Adhesions,Ligands,FALconnections] = DeleteFALconnection('LigandIndex',idx2,Filaments,Adhesions,Ligands,FALconnections);
                        end
                end
            
            
            % START Periodic boundary for Adhesions outside right boundary ---------------------------------------------------------------------------------
                idx = find( MVAR.Ligands.XYpoints(:,1) > MVAR.Adhesions.RegionNodes(2,1) ); 
                if ~isempty(idx) 
                    if ~isempty(MVAR.FALconnections.AdhesionIndex)
                    idx = idx(~ismember(idx, MVAR.FALconnections.LigandIndex));
                    end
                        for idx2 = idx'
                                MVAR.Ligands.XYpoints(idx2,1) = MVAR.Ligands.XYpoints(idx2,1) - MVAR.ModelParameters.MembraneWidth; 
                                % Find out if adhesion is connected to a filament/ligand
                                %[Filaments,Adhesions,Ligands,FALconnections] = DeleteFALconnection('LigandIndex',idx2,Filaments,Adhesions,Ligands,FALconnections);
                        end
                end
            
           
    %% F-ACTIN SECTION 

           % nF = length(Filaments.XYCoords); % number of filaments
           % 
           %  for f = 1:nF
           %      if Filaments.XYCoords{f}(end,2) < Adhesions.RegionNodes(4,2)
           %      Filaments.XYCoords{f}(:,2) = Filaments.XYCoords{f}(:,2) + ModelParameters.ModelDepth;
           %      Value = [Filaments.Name(f,1)];
           %      [Filaments,Adhesions,Ligands,FALconnections] = DeleteFALconnection('FilamentName',Value,Filaments,Adhesions,Ligands,FALconnections);
           %      end
           %  end

            
            
            
           

end
