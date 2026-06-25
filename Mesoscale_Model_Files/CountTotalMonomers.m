function [nMonomers, DeletedFilamentNames]  = CountTotalMonomers(MVAR)

    %nF = length(MVAR.Filaments.MonomerIndices);
    DeletedFilamentNames = [];
    nMonomers = 0;
    idxMF = find(MVAR.Filaments.Parent == 0);
    nMF = length(idxMF); % Total number of filament structures
    BoundaryEdge = MVAR.Membrane.Nodes.Ycoords(end) - MVAR.ModelParameters.ModelDepth;
    for MF = 1:nMF
        Structmonomers = 0;
        Outsidemonomers = 0;
        idx1 = find( MVAR.Filaments.MainIndex == MVAR.Filaments.Name(idxMF(MF)) ); 
        nF = length(idx1);
    for f = 1:nF
        Structmonomers = Structmonomers + length(MVAR.Filaments.XYCoords{f}(:,2));
        outRange = sum( (MVAR.Membrane.Nodes.Ycoords(end) - MVAR.Filaments.XYCoords{f}(:,2)) < BoundaryEdge );
        Outsidemonomers = Outsidemonomers + outRange;
        inRange =  sum( (MVAR.Membrane.Nodes.Ycoords(end) - MVAR.Filaments.XYCoords{f}(:,2)) > BoundaryEdge );
        nMonomers = nMonomers + inRange;
    end
        if Outsidemonomers == Structmonomers
            names = MVAR.Filaments.Name(idx1,1);
            DeletedFilamentNames = [DeletedFilamentNames; names];
        end

    end
