function MVAR = BranchFilamentsInBranchWindowIfSelected(MVAR)


    nF = length(MVAR.Filaments.XYCoords); % number of filaments
   
    for f = 1:nF
        % Use x-coordinate of filament end-point to locate Membrane segment this end-point is under.
        % Then test if the y-coordinate of each filament's end point is within the branch window.
        Xtip = MVAR.Filaments.XYCoords{f}(end,1);
        Ytip = MVAR.Filaments.XYCoords{f}(end,2);
        % Answer = IsFilamentWithinTheBranchingWindowOfAMembraneSegment(Xtip,Ytip,Membrane,ModelParameters);
        Answer = Ytip >= (MVAR.Membrane.Nodes.Ycoords(1) - MVAR.ModelParameters.branchWindowSize);
        
        if Answer % Check if filaments is in branching region
                       % if ~Filaments.IsCapped(f,1) % && (Filaments.UnitVector(f,2) > 0)
                            % Also check if this location has a branch already
                            
                            idxDaughter = find( MVAR.Filaments.Parent == MVAR.Filaments.Name(f,1) );
                            MonomerAlreadyTaken = false; % only one branch allowed at each monomer
                            if ~isempty(idxDaughter)
                                for k = 1:length(idxDaughter)
                                    if MVAR.Filaments.ParentIndex(idxDaughter(k),1) == MVAR.Filaments.MonomerIndices{f}(end,1)
                                        MonomerAlreadyTaken = true;
                                        break
                                    end
                                end
                            end
                            
                            % Calculate Branching Coefficient based on spacingc -----------------------------------------
                            MonMinDist = floor(MVAR.ModelParameters.MinimumBranchSeparation/MVAR.ModelParameters.MonomerLength);
                            nMonomers = length(MVAR.Filaments.MonomerIndices{f}); % Measure monomer length of current filament
                            idx = find( MVAR.Filaments.Parent == MVAR.Filaments.Name(f,1) ); % Find any filaments that branched off of this filament
                            % Find the index search range for a length MinimumBranchSeparation from the barbed end of the filament
                            MonSearchRange = (nMonomers - MonMinDist):nMonomers;
                            MonSearchRange = MonSearchRange( MonSearchRange > 0 ); % Make sure the indices don't go below 1
                            % Of the filaments that branched off of this filament, did any occur within a distance of ~50 nm from the tip?
                            C = intersect( MVAR.Filaments.ParentIndex(idx), MVAR.Filaments.MonomerIndices{f}(MonSearchRange) );
                            if isempty(C) && nMonomers > MonMinDist 
                                BranchingCoefficient = 1;
                            else
                                BranchingCoefficient = 0;
                            end
                            %--------------------------------------------------------------------------------------------
                            if ~MonomerAlreadyTaken && (  rand(1) <= MVAR.ModelParameters.k_branch * MVAR.ModelParameters.TimeStep * BranchingCoefficient   )
                                    % Randomly select which side of the filament the brance is created
                                        %  Sign = randi([0,1],1,1);   Sign(Sign==0) = -1; 
                                        
                                    % Select side of filament to brance off of that is in direction of membrane
                                        Sign = sign(MVAR.Filaments.UnitVector(f,1));

                                    % Randomly select angle from distribution
                                    BranchAngle = Sign*(randn(1)*MVAR.ModelParameters.branchAngleSTD + MVAR.ModelParameters.branchAngle);
                                    % create rotation matrix
                                    R = [ [cosd(BranchAngle), -sind(BranchAngle)];... 
                                          [sind(BranchAngle),  cosd(BranchAngle)] ];
                                    % rotate unit vector of parent filament
                                    xi = MVAR.Filaments.UnitVector(f,1);
                                    yj = MVAR.Filaments.UnitVector(f,2);
                                    M = R*[xi;yj]; 
                                    xr = M(1); 
                                    yr = M(2);
                                    % Calculate first point of new filament
                                    D = MVAR.ModelParameters.MonomerLength; %(nm)
                                    X = MVAR.Filaments.XYCoords{f}(end,1) + D*xr;
                                    Y = MVAR.Filaments.XYCoords{f}(end,2) + D*yr;   
                                    % Now create new filament branch ---------------------------------------
                                        MVAR.Filaments.Name           = [ MVAR.Filaments.Name; max(MVAR.Filaments.Name) + 1 ];
                                        MVAR.Filaments.MonomerIndices = [ MVAR.Filaments.MonomerIndices; {1} ];
                                        MVAR.Filaments.XYCoords       = [ MVAR.Filaments.XYCoords; {[X,Y]}];
                                        MVAR.Filaments.UnitVector     = [ MVAR.Filaments.UnitVector; [xr,yr] ];
                                        MVAR.Filaments.IsCapped       = [ MVAR.Filaments.IsCapped; false ];
                                        MVAR.Filaments.MainIndex      = [ MVAR.Filaments.MainIndex; MVAR.Filaments.MainIndex(f,1) ];
                                        MVAR.Filaments.Parent         = [ MVAR.Filaments.Parent; MVAR.Filaments.Name(f,1) ];
                                        MVAR.Filaments.ParentIndex    = [ MVAR.Filaments.ParentIndex; MVAR.Filaments.MonomerIndices{f}(end,1) ];
                                    %----------------------------------------------------------------
                            end
                        %end
        end
    end


end

%======================================================================================================
%======================================================================================================

function Answer = IsFilamentWithinTheBranchingWindowOfAMembraneSegment(Xtip,Ytip,MVAR)

            Answer = false; % assign default Answer value
            nS = size(MVAR.Membrane.Segments,1);
            SpringWidth = MVAR.ModelParameters.SpringWidth;
            % Xend and Yend are X and Y coordinates of filament tip
            for m = 1:nS % For each membrane segment
               Yseg = MVAR.Membrane.Nodes(MVAR.Membrane.Segments(m,1),2); %  y-coordinate current Membrane segment
               % Test if filament tip is between membrane segment endpoints
               % and within branching window
               if Xtip >= (MVAR.Membrane.Nodes(MVAR.Membrane.Segments(m,1),1)-SpringWidth/2) &&... % Filament X-end >= Left segment endpoint
                  Xtip <= (MVAR.Membrane.Nodes(MVAR.Membrane.Segments(m,2),1)+SpringWidth/2) &&... % Filament X-end <= Right segment endpoint
                  Ytip >= (Yseg-MVAR.ModelParameters.branchWindowSize) &&...                  % Filament tip > Lower Branch Window   
                  Ytip <= (Yseg)                                                         % Filament tip > Upper Branch Window   
                      Answer = true;
                      break
               end   
            end
           
            
end
