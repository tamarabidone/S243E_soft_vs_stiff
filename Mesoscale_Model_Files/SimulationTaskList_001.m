function SimulationTaskList_001(task_id)

set(0,'DefaultFigureVisible','off');

SaveDirectory = '/uufs/chpc.utah.edu/common/home/bidone-group3/Remi/Elastic/Final_implement';
addpath(genpath('/uufs/chpc.utah.edu/common/home/bidone-group3/Remi'));

% -----------------------------
% Fixed parameters
% -----------------------------
k_sub_global = [0.105 0.263 0.525 1.4 2.62 8.05];   % pN/nm
k_sub_local  = [0.0084 0.0210 0.0419 0.1120 0.210 0.645]; % pN/nm
k_adh_vals      = [1];     % pN/nm
nRuns = 10;
E_vals = [0.6 1.5 3 8 15 46];
%E_vals = {'LOW_E', 'HIGH_E'};
k_on_vals = [0.9 1.1];


% -----------------------------
% Build parameter list
% -----------------------------
values = [];

for s = 1:length(k_sub_local)        
    for k = 1:length(k_sub_global)   
        for n = 1:length(k_on_vals)
            for r = 1:nRuns              
            values = [values; ...
                k_sub_local(s), ...   
                k_sub_global(k), ...  
                k_on_vals(n), ...      
                k_adh, ...       
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
    ModelParameters.k_sub_local = values(k,1);
    ModelParameters.k_sub_global  = values(k,2);

    % Adhesions
    ModelParameters.k_on = values(k,3);          
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
   
