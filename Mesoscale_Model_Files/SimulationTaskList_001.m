function SimulationTaskList_001(task_id)

set(0,'DefaultFigureVisible','off');

SaveDirectory = '/uufs/chpc.utah.edu/common/home/bidone-group3/Remi/ViscoElastic/Visco_3rd';
addpath(genpath('/uufs/chpc.utah.edu/common/home/bidone-group3/Remi'));

% -----------------------------
% Fixed parameters
% -----------------------------
k_l   = [0.01 0.1 1 10 100 1000];   
k_a   = [0.1 0.5 1 1.5 2 10 100]; 
nu    = [0.01 0.1 1 10 100]; 
k_c   = 1;
nRuns = 3;

% -----------------------------
% Build parameter list
% -----------------------------
values = [];

for s = 1:length(k_a)        
    for k = 1:length(k_l)   
        for n = 1:length(nu)
            for r = 1:nRuns              
            values = [values; ...
                k_a(s), ...   
                k_l(k), ...  
                nu(n), ...      
                k_c, ...       
                r];                
            end
        end
    end
end


totalSims = size(values,1);

% -----------------------------
% Array task mapping
% -----------------------------
nArrayTasks = 30;
chunkSize = ceil(totalSims / nArrayTasks);

idx_start = (task_id - 1) * chunkSize + 1;
idx_end   = min(task_id * chunkSize, totalSims);
simSubset = idx_start:idx_end;

parpool('local');

% -----------------------------
% Run simulations
% -----------------------------
parfor k = simSubset

    rng(values(k,5), 'twister');  % seed by run index

    ModelParameters = InitializeModelParameters;
    ModelParameters.TimeStep = 1e-4;
    ModelParameters.TotalSimulationTime = 30;
    ModelParameters.FilamentThermalMotionOn = false;
    ModelParameters.CytoplasmViscosity = 1e5 * 0.0001;
    ModelParameters.VerticalOffSet = -200;
    ModelParameters.StartingNumberOfFilaments = 32;

    % Substrate
    ModelParameters.k_a = values(k,1);
    ModelParameters.k_l  = values(k,2);

    % Adhesions
    ModelParameters.k_c = values(k,4);          
    ModelParameters.nu = values(k,3);  
    ModelParameters.k_off_pointed = 7;

    % Actin
    ModelParameters.k_branch = 2.2;
    ModelParameters.FAL_connection_Distance = 10 * 2.75;
    ModelParameters.MaximumFilamentMass = 4000;
    ModelParameters.MolecularClutch_PeakNumber = 1;

    % -----------------------------
    % Save name (explicit + readable)
    % -----------------------------
    SaveName = sprintf('k_a_%s__k_l_%s__nu_%s_run_%02d.mat', ...
        SimFormat(values(k,1)), ...
        SimFormat(values(k,2)), ...
        SimFormat(values(k,3)), ...
        values(k,5));

    if ~isfile(fullfile(SaveDirectory, SaveName))
        LamellipodiumModel_Bidone01(ModelParameters,SaveDirectory,SaveName);
    end
end

delete(gcp('nocreate'));
quit;

end
   