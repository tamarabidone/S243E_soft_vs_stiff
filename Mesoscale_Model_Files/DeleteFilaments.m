function [MVAR] = DeleteFilaments(MVAR, DeletedFilamentNames)

 DeletedFilamentNames = unique(DeletedFilamentNames);
        
        for n = 1:length(DeletedFilamentNames)
            
                name = DeletedFilamentNames(n);
                idx = find( MVAR.Filaments.Name == name );
                
                % Delete filament
                MVAR.Filaments.Name(idx)           = [];
                MVAR.Filaments.MonomerIndices(idx) = [];
                MVAR.Filaments.XYCoords(idx)       = [];
                MVAR.Filaments.UnitVector(idx,:)   = [];
                MVAR.Filaments.IsCapped(idx)       = [];
                MVAR.Filaments.MainIndex(idx)      = [];
                MVAR.Filaments.Parent(idx)         = [];
                MVAR.Filaments.ParentIndex(idx)    = [];
                
                % Check for Adhesion/Ligand connections and delete them
                [MVAR] = DeleteFALconnection('FilamentName',name,MVAR);
        end
        
        
        
end
