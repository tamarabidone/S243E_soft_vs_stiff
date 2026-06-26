%% Reading: varying substrate stiffnesses and k_adh

RawSaveDirectories = {'/uufs/chpc.utah.edu/common/home/bidone-group3/Remi/ViscoElastic/FinalImplement'};

% Substrate stiffnesses
k_s_global_vals = [0.105 0.263 0.525 1.4 2.62 8.05];   % pN/nm
k_s_local_vals  = [0.0084 0.0210 0.0419 0.1120 0.210 0.645]; % pN/nm
k_adh_vals      = [1];     % pN/nm
nRuns = 10;
E_vals = [0.6 1.5 3 8 15 46];
%E_vals = {'LOW_E', 'HIGH_E'};
k_on_vals = [0.9 1.1];

% Preallocate
dispRuns         = nan(length(k_on_vals), length(E_vals), nRuns);
nAdhesions       = nan(length(k_on_vals), length(E_vals), nRuns);
force_adh        = nan(length(k_on_vals), length(E_vals), nRuns);
force_int        = nan(length(k_on_vals), length(E_vals), nRuns);
membrane_f       = nan(length(k_on_vals), length(E_vals), nRuns);
protrusionFrequency = nan(length(k_on_vals), length(E_vals), nRuns);
protrusionProminence = nan(length(k_on_vals), length(E_vals), nRuns);
protrusionDuration = nan(length(k_on_vals), length(E_vals), nRuns);
meanForcePerFilament = nan(length(k_on_vals), length(E_vals), nRuns);
frequency_force = nan(length(k_on_vals), length(E_vals), nRuns);
Fil_position = cell(length(k_on_vals), length(E_vals), nRuns);
Fil_length = cell(length(k_on_vals), length(E_vals), nRuns);
fil_position_bound = cell(length(k_on_vals), length(E_vals), nRuns);
Fil_orientation = cell(length(k_on_vals), length(E_vals), nRuns);
int_position = cell(length(k_on_vals), length(E_vals), nRuns);
int_snapshots = cell(length(k_on_vals), length(E_vals), nRuns);
medianForcePerFilament = nan(length(k_on_vals), length(E_vals), nRuns);
stdForcePerFilament = nan(length(k_on_vals), length(E_vals), nRuns);
rmsVel = nan(length(k_on_vals), length(E_vals), nRuns);
dutyCycle = nan(length(k_on_vals), length(E_vals), nRuns);
meanLoadingRate   = nan(length(k_on_vals), length(E_vals), nRuns);
medianLoadingRate = nan(length(k_on_vals), length(E_vals), nRuns);
stdLoadingRate    = nan(length(k_on_vals), length(E_vals), nRuns);
loadingRateDist   = cell(length(k_on_vals), length(E_vals), nRuns);
meanLifetime   = nan(length(k_on_vals), length(E_vals), nRuns);
meanFilamentCount   = nan(length(k_on_vals), length(E_vals), nRuns);
medianLifetime = nan(length(k_on_vals), length(E_vals), nRuns);
stdLifetime    = nan(length(k_on_vals), length(E_vals), nRuns);

lifetimeDist   = cell(length(k_on_vals), length(E_vals), nRuns);
filamentCountDist   = cell(length(k_on_vals), length(E_vals), nRuns);
onRate   = nan(length(k_on_vals), length(E_vals), nRuns); % binding events / s
offRate  = nan(length(k_on_vals), length(E_vals), nRuns); % unbinding events / s
turnoverRate = nan(length(k_on_vals), length(E_vals), nRuns); % total events / s


% -------------------------------
% Loop over E values, k_on, runs
% -------------------------------
dt = 0.01;  % timestep
filterOrder = 3;
cutoffHz_freq = 2;   % for frequency detection
cutoffHz_prom = 2; % for prominence/duration
minProm = 2;         % minimum peak prominence (nm/s)
minDist_s = 0.3;     % minimum peak distance (s)
minDist_samples = round(minDist_s / dt);

for g = 1:length(E_vals)
    for l = 1:length(k_on_vals)
        for r = 1:nRuns

            SaveName = [sprintf('%g',E_vals(g)), ' kPa','_k_on_',SimFormat(k_on_vals(l)),  ...
                        '_k_adh_',SimFormat(1), '_run_',sprintf('%02d',r), '.mat']; 
            % 
            % SaveName = [(E_vals{g}), '_k_on_',SimFormat(k_on_vals(l)),  '_k_adh_',SimFormat(1), ...
            %             '_run_',sprintfe('%02d',r), '.mat'];
            
             % SaveName = sprintf('k_s_global_%s__k_s_local_%s_k_adh_%s_run_%02d.mat', ... 
             %                   SimFormat(k_s_global_vals(g)), SimFormat(k_s_local_vals(g)), ... 
             %                    SimFormat(k_adh_vals(l)),r);
            fileFound = false;
            for d = 1:length(RawSaveDirectories)
                filePath = fullfile(RawSaveDirectories{d}, SaveName);
                if exist(filePath,'file')
                    load(filePath,'SimData');
                    fileFound = true;
                    break
                end
            end
            %disp(fileFound)
            if ~fileFound, continue; end

            tRange = 1000:3000;

            % -------------------------------
            % Adhesion lifetimes and counts
            % -------------------------------
            adhState = SimData.AdhesionData(:,3,tRange);
            lifetimes = [];
            nAdh = size(adhState,1);
            for i = 1:nAdh
                trace = squeeze(adhState(i,:));
                dTrace = diff([0 trace 0]);
                startIdx = find(dTrace == 1);
                endIdx   = find(dTrace == -1) - 1;
                lifetimes = [lifetimes, (endIdx-startIdx+1)*dt];
            end
            nAdhesions(l,g,r) = nnz(adhState == 1)/1000;

            % -------------------------------
            % Membrane displacement
            % -------------------------------
            V = SimData.MembranePosition;
            dispRuns(l,g,r) = mean(V(tRange));

            % -------------------------------
            % Forces per filament
            % -------------------------------
            allFilamentForces = [];
            frequency= [];
            Fil_pos = [];
            Fil_len = [];
            Fil_orien = [];
            
            bound_xy_all = [];
            bound_xy_integrin_snapshots = [];
            bound_fil_all = [];
            
            for t = tRange
                
                f = SimData.Data{t,1}.ForceonMembrane;
                allFilamentForces = [allFilamentForces; sum(f)];
                frequency = [frequency; length(find(f > 0.257))];

                fil_position   = SimData.Data{t,1}.XYPosition;
                nFilaments_t = size(fil_position,1);
                if t == tRange(1)
                    filamentCounts = [];
                end
                filamentCounts = [filamentCounts;nFilaments_t];
                mem_y_pos     = SimData.MembranePosition(t);
                xy_fil_rel_total = [fil_position(:,1), fil_position(:,2) - mem_y_pos];
                Fil_pos = [Fil_pos; xy_fil_rel_total];
                
                length_fil = SimData.Data{t,1}.FilamentLength;
                Fil_len = [Fil_len; length_fil];
                
                o = atan2d(SimData.Data{t,1}.Orientation(:,2), SimData.Data{t,1}.Orientation(:,1));
                Fil_orien = [Fil_orien; o];

                bound_idx = find(SimData.AdhesionData(:,3,t) == 1);
                if ~isempty(bound_idx)
                    xy     = SimData.AdhesionData(bound_idx, 1:2, t);
                    mem_y  = SimData.MembranePosition(t);
                    xy_rel = [xy(:,1), xy(:,2) - mem_y];
            
                    % Heatmap point cloud
                    bound_xy_all = [bound_xy_all; xy_rel];
            
                    % Snapshot with timestep tag  only when 2+ integrins bound
                    if length(bound_idx) >= 2
                        bound_xy_integrin_snapshots = [bound_xy_integrin_snapshots; xy_rel, repmat(t, length(bound_idx), 1)];
                    end
                end

               % Get bound integrin indices
                    bound_mask = SimData.AdhesionData(:,3,t) == 1;
                    if ~any(bound_mask), continue; end
                
                    % Get filament names for bound integrins
                    bound_fil_names = SimData.AdhesionData(bound_mask, 5, t);
                
                    fil_names = SimData.Data{t,1}.FilamentName;
                    fil_pos   = SimData.Data{t,1}.XYPosition;
                    mem_y     = SimData.MembranePosition(t);
                
                    % Vectorized match  find indices of all bound filament names at once
                    [~, fil_idx] = ismember(bound_fil_names, fil_names);
                
                    % Remove any unmatched (idx == 0)
                    valid = fil_idx > 0;
                    fil_idx = fil_idx(valid);
                
                    if isempty(fil_idx), continue; end
                
                    % Extract positions all at once
                    xy_fil     = fil_pos(fil_idx, :);
                    xy_fil_rel = [xy_fil(:,1), xy_fil(:,2) - mem_y];
                
                    bound_fil_all = [bound_fil_all; xy_fil_rel];
                end
            %Fil_position{l,g,r} = Fil_pos;
            int_position{l,g,r}  = bound_xy_all;
            int_snapshots{l,g,r} = bound_xy_integrin_snapshots;  % [x, y_rel, t]
            fil_position_bound{l,g,r} = bound_fil_all;
            meanFilamentCount(l,g,r) = mean(filamentCounts, "omitnan");
            filamentCountDist{l,g,r} = filamentCounts;
            
            meanForcePerFilament(l,g,r)   = mean(allFilamentForces,'omitnan');
            frequency_force(l,g,r) = mean(frequency, 'omitnan');
            medianForcePerFilament(l,g,r) = median(allFilamentForces,'omitnan');
            stdForcePerFilament(l,g,r)    = std(allFilamentForces,'omitnan');
            Fil_position{l,g,r} = Fil_pos;
            Fil_length{l,g,r} = Fil_len;
            Fil_orientation{l,g,r} = Fil_orien;
            %int_position{l,g,r} = bound_xy_all;

            % Adhesion / integrin forces
            forcesPerTimestep = sum(SimData.AdhesionData(:,4,tRange),1,'omitnan');
            meanForceRun = mean(forcesPerTimestep);
            MeanforcesPerTimestep = mean(SimData.AdhesionData(:,4,tRange),1,'omitnan');
            meanForceperRun = mean(MeanforcesPerTimestep);
            MeanposPerTimestep = mean(SimData.AdhesionData(:,4,tRange),1,'omitnan');

            force_int(l,g,r) = meanForceperRun;
            force_adh(l,g,r) = (meanForceRun*1e-12)/(2.5e-13);
            % -------------------------------
            % Integrin loading rates (dF/dt)
            % -------------------------------
            F = SimData.AdhesionData(:,4,tRange);     % force (pN)
            state = SimData.AdhesionData(:,3,tRange); % bound state (1 = bound)
            
            dFdt_all = [];
            
            for i = 1:size(F,1)  % loop over integrins
                
                f_trace = squeeze(F(i,:));
                s_trace = squeeze(state(i,:));
                
                % Bound mask
                bound_mask = (s_trace == 1);
                
                % Need at least 2 consecutive bound points
                if sum(bound_mask) < 2
                    continue
                end
                
                % Compute force difference
                df = diff(f_trace);
                
                % Keep only continuous bound segments
                valid_steps = bound_mask(1:end-1) & bound_mask(2:end);
                
                % Compute loading rate (pN/s)
                dFdt = df(valid_steps) / dt;
                
                % OPTIONAL: only keep positive loading (force buildup)
                 dFdt = dFdt(dFdt > 0);
                
                dFdt_all = [dFdt_all; dFdt(:)];
            end
            
            % Store results
            if ~isempty(dFdt_all)
                meanLoadingRate(l,g,r)   = mean(dFdt_all,'omitnan');
                medianLoadingRate(l,g,r) = median(dFdt_all,'omitnan');
                stdLoadingRate(l,g,r)    = std(dFdt_all,'omitnan');
                loadingRateDist{l,g,r}   = dFdt_all;
            else
                meanLoadingRate(l,g,r)   = NaN;
                medianLoadingRate(l,g,r) = NaN;
                stdLoadingRate(l,g,r)    = NaN;
                loadingRateDist{l,g,r}   = [];
            end

            % -------------------------------
            % Adhesion lifetimes
            % -------------------------------
            adhState = SimData.AdhesionData(:,3,tRange);
            
            lifetimes = [];
            nAdh = size(adhState,1);
            
            for i = 1:nAdh
                
                trace = squeeze(adhState(i,:));
                
                % Detect binding/unbinding transitions
                dTrace = diff([0 trace 0]);
                startIdx = find(dTrace == 1);
                endIdx   = find(dTrace == -1) - 1;
                
                if isempty(startIdx)
                    continue
                end
                
                % Convert to time (seconds)
                lt = (endIdx - startIdx + 1) * dt;
                
                lifetimes = [lifetimes; lt(:)];
            end
            
            % Store metrics
            if ~isempty(lifetimes)
                meanLifetime(l,g,r)   = mean(lifetimes,'omitnan');
                medianLifetime(l,g,r) = median(lifetimes,'omitnan');
                stdLifetime(l,g,r)    = std(lifetimes,'omitnan');
                lifetimeDist{l,g,r}   = lifetimes;
            else
                meanLifetime(l,g,r)   = NaN;
                medianLifetime(l,g,r) = NaN;
                stdLifetime(l,g,r)    = NaN;
                lifetimeDist{l,g,r}   = [];
            end
            % -------------------------------
            % Integrin turnover rates
            % -------------------------------
            adhState = SimData.AdhesionData(:,3,tRange); % 1 = bound, 0 = unbound
            
            nAdh = size(adhState,1);
            Ttotal = length(tRange) * dt;  % total time (s)
            
            total_on_events  = 0;
            total_off_events = 0;
            
            for i = 1:nAdh
                
                trace = squeeze(adhState(i,:));
                
                % Detect transitions
                dTrace = diff([0 trace 0]);
                
                % Binding events: 0 -> 1
                n_on  = sum(dTrace == 1);
                
                % Unbinding events: 1 -> 0
                n_off = sum(dTrace == -1);
                
                total_on_events  = total_on_events  + n_on;
                total_off_events = total_off_events + n_off;
            end
            
            % Normalize per integrin and per time
            onRate(l,g,r)  = total_on_events  / (nAdh * Ttotal); % s^-1
            offRate(l,g,r) = total_off_events / (nAdh * Ttotal); % s^-1
            
            % Total turnover (both processes)
            turnoverRate(l,g,r) = (total_on_events + total_off_events) / (nAdh * Ttotal);
            % -------------------------------
            % Protrusion dynamics
            % -------------------------------
            Vdiff = diff(V)/dt;
            Vtrace_raw = Vdiff(1000:3000);

            % --- Filter for frequency ---
            [b_freq,a_freq] = butter(filterOrder, cutoffHz_freq/(1/(2*dt)),'low');
            Vtrace_freq = filtfilt(b_freq,a_freq,Vtrace_raw);

            % --- Filter for prominence/duration ---
            [b_prom,a_prom] = butter(filterOrder, cutoffHz_prom/(1/(2*dt)),'low');
            Vtrace_prom = filtfilt(b_prom,a_prom,Vtrace_raw);

            % RMS velocity
            rmsVel(l,g,r) = sqrt(mean(Vtrace_prom.^2));

            % Peak frequency
            [~, pkLocsF] = findpeaks(Vtrace_freq,'MinPeakDistance',minDist_samples);
            protrusionFrequency(l,g,r) = numel(pkLocsF)/(length(Vtrace_raw)*dt);

            % Prominence and duration
            [~, pkLocsP, pkWidthsP, pkPromP] = findpeaks(Vtrace_prom,...
                'MinPeakProminence', minProm, ...
                'MinPeakDistance', minDist_samples);
            if ~isempty(pkLocsP)
                protrusionProminence(l,g,r) = mean(pkPromP);
                protrusionDuration(l,g,r) = mean(pkWidthsP*dt);
            else
                protrusionProminence(l,g,r) = NaN;
                protrusionDuration(l,g,r) = NaN;
            end

            % Duty cycle
            threshold = 10;  % nm/s
            dutyCycle(l,g,r) = sum(Vtrace_prom > threshold)*dt / (length(Vtrace_prom)*dt);

        end
    end
end
