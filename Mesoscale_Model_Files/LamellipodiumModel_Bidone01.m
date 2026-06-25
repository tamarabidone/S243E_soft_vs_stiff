function LamellipodiumModel_Bidone01(ModelParameters,SaveDir,SaveName)

%% Initialize model variables
Membrane       = InitializeMembrane(ModelParameters);
Filaments      = InitializeActinFilaments(ModelParameters,Membrane); 
Adhesions      = InitializeAdhesions(ModelParameters,Membrane);
Ligands        = InitializeLigands(ModelParameters);
FALconnections = InitializeFALconnections;

MVAR = struct( ...
    'ModelParameters', ModelParameters, ...
    'Membrane', Membrane, ...
    'Filaments', Filaments, ...
    'Adhesions', Adhesions, ...
    'Ligands', Ligands, ...
    'FALconnections', FALconnections);

%% Time vectors
TimeVec = 0:MVAR.ModelParameters.TimeStep:ModelParameters.TotalSimulationTime;
TV2     = 0:0.001:MVAR.ModelParameters.TotalSimulationTime; % 1 ms sampling

%% Preallocate tracking variables
nMono      = NaN(length(TV2),1);
nAdhes     = NaN(length(TV2),1);
MemVel     = NaN(length(TV2),1);

ModelParameters.SampleTimeStep = 1E-2;
ModelParameters.SaveTimeStep   = 1;

%% Preallocate SimData
SimData.ModelParameters   = MVAR.ModelParameters;
SimData.TimeVector        = TV2;
SimData.MembranePosition  = NaN(length(TV2),1);
SimData.AdhesionData      = NaN(MVAR.ModelParameters.AdhesionTotal,5,length(TV2));
SimData.Data              = cell(length(TV2),1);

MVAR.MembranePrevious = MVAR.Membrane;

%% Indices
index = 0;
count = 0;

MVAR.ModelParameters.SubVelForPrevTimePt = 0;

%% ===================== START MODEL =====================
for t = TimeVec
    SubYPrev = MVAR.ModelParameters.Substrate.Ycoords;

    % Core model steps -----------------------------------------------------
    [nMonomers, DeletedFilamentNames] = CountTotalMonomers(MVAR); %#ok<ASGLU>
    MVAR = PolymerizeDepolymerizeCapDeleteFilaments(nMonomers,MVAR);
    MVAR = BranchFilamentsInBranchWindowIfSelected(MVAR);
    MVAR = CreateFALconnections(MVAR);
    [MVAR, AdhesionTensions, Data, StretchDistance] = ...
        CalculatePositionAfterAppliedForces(MVAR); %#ok<ASGLU>
    MVAR = ManageAdhesionsAndLigands(MVAR);

    % Substrate velocity
    MVAR.ModelParameters.SubVelForPrevTimePt = ...
        (MVAR.ModelParameters.Substrate.Ycoords - SubYPrev) ...
        / MVAR.ModelParameters.TimeStep;

    if rem(round(t,10), ModelParameters.SampleTimeStep) == 0
        index = index + 1;

        % Store Data struct
        Data.Timepoint = t;
        SimData.Data{index,1} = Data;

        % Scalars
        nMono(index,1)  = CountTotalMonomers(MVAR);
        nAdhes(index,1) = nnz(Adhesions.ActiveStatus);
        MemVel(index,1) = ...
            (MVAR.Membrane.Nodes.Ycoords(1) - ...
             MVAR.MembranePrevious.Nodes.Ycoords(1)) ...
             / ModelParameters.TimeStep;

        SimData.MembranePosition(index,1) = ...
            MVAR.Membrane.Nodes.Ycoords(1);

        SimData.AdhesionData(:,:,index) = ...
            [ MVAR.Adhesions.XYpoints, ...
              MVAR.Adhesions.ActiveStatus, ...
              AdhesionTensions, ...
              MVAR.Adhesions.AttachedFilamentName ];

        SimData.nMonomers   = nMono;
        SimData.nAdhesions  = nAdhes;
        SimData.MemVelocity = MemVel;
    end
    % ---------------------------------------------------------------------

    count = count + 1;
    MVAR.MembranePrevious = MVAR.Membrane;
end

try
    save(fullfile(SaveDir,SaveName),'SimData','-mat','-v7.3')
catch
    disp(['File not saved: ',SaveName])
end

end


