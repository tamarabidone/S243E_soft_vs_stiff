function [MVAR] = DeleteFALconnection(Field,Value,MVAR)


            switch Field
                    %...................................................................................
                    case 'FilamentName'  % Value = FilamentName
                            FALidx = find( MVAR.FALconnections.FilamentName == Value ); 
                            if ~isempty(FALidx) % If this filament has a connection
                                 a = MVAR.FALconnections.AdhesionIndex(FALidx,1);
                                 MVAR.Adhesions.AttachedFilamentName(a,1) = NaN;
                                 MVAR.Adhesions.AttachcedLigandIndex(a,1) = NaN;
                                 MVAR.Adhesions.ActiveStatus(a,1) = false;

                                 l = MVAR.FALconnections.LigandIndex(FALidx,1);
                                 MVAR.Ligands.AttachedFilamentName(l,1)  = NaN;
                                 MVAR.Ligands.AttachedAdhesionIndex(l,1) = NaN;

                                 MVAR.FALconnections.AdhesionIndex(FALidx,:) = [];
                                 MVAR.FALconnections.FilamentName (FALidx,:) = [];
                                 MVAR.FALconnections.MonomerIndex (FALidx,:) = [];
                                 MVAR.FALconnections.LigandIndex  (FALidx,:) = [];
                            end


                    %...................................................................................
                    case 'FilamentNameAndMonomerIndex' % Needs to inputs for value: Value = [ FilamentName, MonomerIndex ] 
                            FALidx = find( MVAR.FALconnections.FilamentName == Value(1) & ... % Find the adhesion/ligand/filamement connection with this filament name
                                           MVAR.FALconnections.MonomerIndex == Value(2) );    % and the adhesion/ligand that is connected to the current monomer being depolymerized
                                % If so, reset adhesion/ligand, and remove connection  
                                if ~isempty(FALidx) 
                                    a = MVAR.FALconnections.AdhesionIndex(FALidx,1);
                                    MVAR.Adhesions.AttachedFilamentName (a,1) = NaN;
                                    MVAR.Adhesions.AttachedLigandIndex  (a,1) = NaN;
                                    MVAR.Adhesions.ActiveStatus         (a,1) = false;

                                    l = MVAR.FALconnections.LigandIndex(FALidx);
                                    MVAR.Ligands.AttachedFilamentName (l) = NaN;
                                    MVAR.Ligands.AttachedAdhesionIndex(l) = NaN;

                                    MVAR.FALconnections.AdhesionIndex(FALidx) = [];   
                                    MVAR.FALconnections.LigandIndex  (FALidx) = [];
                                    MVAR.FALconnections.FilamentName (FALidx) = []; 
                                    MVAR.FALconnections.MonomerIndex (FALidx) = []; 
                                end


                    %...................................................................................
                    case 'AdhesionIndex'  % Value = AdhesionIndex
                                
                                for V = Value'
                                        FALidx = find( MVAR.FALconnections.AdhesionIndex == V );
                                        if ~isempty(FALidx) 
                                            a = V;
                                            MVAR.Adhesions.AttachedFilamentName(a,1) = NaN;
                                            MVAR.Adhesions.AttachedLigandIndex (a,1) = NaN;
                                            MVAR.Adhesions.ActiveStatus        (a,1) = false;

                                            l = MVAR.FALconnections.LigandIndex(FALidx);
                                            MVAR.Ligands.AttachedFilamentName (l) = NaN;
                                            MVAR.Ligands.AttachedAdhesionIndex(l) = NaN;

                                            MVAR.FALconnections.AdhesionIndex(FALidx) = [];   
                                            MVAR.FALconnections.LigandIndex  (FALidx) = [];
                                            MVAR.FALconnections.FilamentName (FALidx) = []; 
                                            MVAR.FALconnections.MonomerIndex (FALidx) = []; 
                                        end
                                end


                    %...................................................................................
                    case 'LigandIndex' % Value = LigandIndex
                            FALidx = find( MVAR.FALconnections.LigandIndex == Value );
                            if ~isempty(FALidx) 
                                a = MVAR.FALconnections.AdhesionIndex(FALidx,1);
                                MVAR.Adhesions.AttachedFilamentName(a,1) = NaN;
                                MVAR.Adhesions.AttachedLigandIndex (a,1) = NaN;
                                MVAR.Adhesions.ActiveStatus        (a,1) = false;

                                l = MVAR.FALconnections.LigandIndex(FALidx);
                                MVAR.Ligands.AttachedFilamentName (l) = NaN;
                                MVAR.Ligands.AttachedAdhesionIndex(l) = NaN;

                                MVAR.FALconnections.AdhesionIndex(FALidx) = [];   
                                MVAR.FALconnections.LigandIndex  (FALidx) = [];
                                MVAR.FALconnections.FilamentName (FALidx) = []; 
                                MVAR.FALconnections.MonomerIndex (FALidx) = []; 
                            end
                            
                            
                    %...................................................................................
            end



end
