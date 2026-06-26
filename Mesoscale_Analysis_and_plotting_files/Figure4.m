figure; hold on
set(gcf,'Color','w')

% ================== COLORS ==================
colors = [
    0.1 0.1 0.1
    0.35 0.35 0.35
    0 0.6 0.8
    0.55 0.55 0.55
    0.75 0.75 0.75   % k_on = 1.1  (light grey)
    0.9 0.9 0.9
];

metric = meanFilamentCount; % replace with force_adh, force_int, etc.
E_vals_plot = [0.6 46];  % kPa
k_on_vals_plot = [ 0.9, 1.1 ];

figure; hold on
set(gcf,'Color','w')
% ================== BUILD DATA ==================
data = [];
groupID = [];
positions = [];
pos = 1;
gid = 1;
groupCenters = zeros(1,length(E_vals_plot));

for e = 1:length(E_vals_plot)
    startPos = pos;

    for k = 1:length(k_on_vals_plot)
        vals = squeeze(metric(k,e,:));  % k_on row, E column, all runs
        data    = [data; vals];
        groupID = [groupID; gid*ones(numel(vals),1)];
        positions(end+1) = pos; 
        gid = gid + 1; 
        pos = pos + 1;
    end

    groupCenters(e) = mean(startPos:(pos-1));
    pos = pos + 1; % gap between E groups
end

% ================== BOXPLOT ==================
boxplot(data, groupID, 'Positions', positions, 'Symbol','o', 'Widths',0.6);

% ================== STYLE BOXES ==================
boxes = flipud(findobj(gca,'Tag','Box'));
med   = flipud(findobj(gca,'Tag','Median'));

for i = 1:length(boxes)
    c = colors(mod(i-1,length(colors))+1,:);
    patch(get(boxes(i),'XData'), get(boxes(i),'YData'), c, 'FaceAlpha',0.9, 'EdgeColor','k');
    boxes(i).LineStyle = 'none';
    med(i).Color = 'k';
    med(i).LineWidth = 2.5;
end

% Whiskers & caps
set(findobj(gca,'Tag','Whisker'),'Color','k','LineWidth',2)
set(findobj(gca,'Tag','Cap'),'Color','k','LineWidth',2)

% Outliers
out = flipud(findobj(gca,'Tag','Outliers'));
for i = 1:length(out)
    c = colors(mod(i-1,length(colors))+1,:);
    out(i).MarkerEdgeColor = c;
    out(i).MarkerFaceColor = c;
    out(i).MarkerSize = 5;
end

% ================== AXES ==================
xticks(groupCenters)
xticklabels(arrayfun(@(x) sprintf('%.1f',x), E_vals_plot,'UniformOutput',false))
xlabel('E (kPa)','FontSize',14)
ylabel('F-actin count (#) ','FontSize',14) % change label depending on metric
ax = gca;
ax.TickLength = [0.01 0.025];
ax.LineWidth  = 1.5;
ax.FontSize   = 14;
%ylim([50 95])

% ================== LEGEND ==================
lgd = gobjects(length(k_on_vals_plot),1);
for i = 1:length(k_on_vals_plot)
    lgd(i) = plot(nan,nan,'s','MarkerFaceColor',colors(i,:), ...
        'MarkerEdgeColor','k','MarkerSize',10);
end
legend(lgd, arrayfun(@(x) sprintf('k_{on} = %.1f s^{-1}',x), k_on_vals_plot,'UniformOutput',false), ...
       'Location','best','Box','off')
%%

figure; hold on
set(gcf,'Color','w')

% ================== COLORS ==================
colors = [
    0.1 0.1 0.1
    0.35 0.35 0.35
    0 0.6 0.8
    0.55 0.55 0.55
    0.75 0.75 0.75   % k_on = 1.1  (light grey)
    0.9 0.9 0.9
];

metric = dispRuns; % replace with force_adh, force_int, etc.
E_vals_plot = [0.6 46];  % kPa
k_on_vals_plot = [ 0.9, 1.1 ];

figure; hold on
set(gcf,'Color','w')
% ================== BUILD DATA ==================
data = [];
groupID = [];
positions = [];
pos = 1;
gid = 1;
groupCenters = zeros(1,length(E_vals_plot));

for e = 1:length(E_vals_plot)
    startPos = pos;

    for k = 1:length(k_on_vals_plot)
        vals = squeeze(metric(k,e,:));  % k_on row, E column, all runs
        data    = [data; vals];
        groupID = [groupID; gid*ones(numel(vals),1)];
        positions(end+1) = pos; 
        gid = gid + 1; 
        pos = pos + 1;
    end

    groupCenters(e) = mean(startPos:(pos-1));
    pos = pos + 1; % gap between E groups
end

% ================== BOXPLOT ==================
boxplot(data, groupID, 'Positions', positions, 'Symbol','o', 'Widths',0.6);

% ================== STYLE BOXES ==================
boxes = flipud(findobj(gca,'Tag','Box'));
med   = flipud(findobj(gca,'Tag','Median'));

for i = 1:length(boxes)
    c = colors(mod(i-1,length(colors))+1,:);
    patch(get(boxes(i),'XData'), get(boxes(i),'YData'), c, 'FaceAlpha',0.9, 'EdgeColor','k');
    boxes(i).LineStyle = 'none';
    med(i).Color = 'k';
    med(i).LineWidth = 2.5;
end

% Whiskers & caps
set(findobj(gca,'Tag','Whisker'),'Color','k','LineWidth',2)
set(findobj(gca,'Tag','Cap'),'Color','k','LineWidth',2)

% Outliers
out = flipud(findobj(gca,'Tag','Outliers'));
for i = 1:length(out)
    c = colors(mod(i-1,length(colors))+1,:);
    out(i).MarkerEdgeColor = c;
    out(i).MarkerFaceColor = c;
    out(i).MarkerSize = 5;
end

% ================== AXES ==================
xticks(groupCenters)
xticklabels(arrayfun(@(x) sprintf('%.1f',x), E_vals_plot,'UniformOutput',false))
xlabel('E (kPa)','FontSize',14)
ylabel('Turnover Rate (s^{-1}) ','FontSize',14) % change label depending on metric
ax = gca;
ax.TickLength = [0.01 0.025];
ax.LineWidth  = 1.5;
ax.FontSize   = 14;
%ylim([50 95])

% ================== LEGEND ==================
lgd = gobjects(length(k_on_vals_plot),1);
for i = 1:length(k_on_vals_plot)
    lgd(i) = plot(nan,nan,'s','MarkerFaceColor',colors(i,:), ...
        'MarkerEdgeColor','k','MarkerSize',10);
end
legend(lgd, arrayfun(@(x) sprintf('k_{on} = %.1f s^{-1}',x), k_on_vals_plot,'UniformOutput',false), ...
       'Location','best','Box','off')

%%
figure; hold on
set(gcf,'Color','w')

% ================== COLORS ==================
colors = [
    0.35 0.35 0.35   % k_on = 0.9 (dark grey)
    0.75 0.75 0.75   % k_on = 1.1 (light grey)
    0.00 0.45 0.75   % baseline (k_on=1)
];

% ================== BUILD DATA ==================
data = [];
groupID = [];
positions = [];

pos = 1;
gid = 1;
groupCenters = zeros(1,length(E_vals));

for e = 1:length(E_vals)
    startPos = pos;

    if E_vals(e) == 0.6
        % ---- k_on = 0.9 ----
        vals = squeeze(protrusionFrequency(1,:));
        data    = [data; vals];
        groupID = [groupID; gid*ones(numel(vals),1)];
        positions(end+1) = pos; gid = gid+1; pos = pos+1;

        % ---- k_on = 1.1 ----
        vals = squeeze(protrusionFrequency(2,:));
        data    = [data; vals];
        groupID = [groupID; gid*ones(numel(vals),1)];
        positions(end+1) = pos; gid = gid+1; pos = pos+1;

    elseif ismember(E_vals(e), [1.5 5])
        % ---- baseline ----
        idx = find([1.5 5] == E_vals(e));
        vals = squeeze(protrusionFrequency1(idx,:));
        data    = [data; vals];
        groupID = [groupID; gid*ones(numel(vals),1)];
        positions(end+1) = pos; gid = gid+1; pos = pos+1;
    end

    groupCenters(e) = mean(startPos:(pos-1));
    pos = pos + 1; % gap between stiffness groups
end

% ================== BOXPLOT ==================
boxplot(data, groupID, 'Positions', positions, ...
        'Symbol','o', 'Widths',0.6)

% ================== STYLE BOXES ==================
boxes = flipud(findobj(gca,'Tag','Box'));
med   = flipud(findobj(gca,'Tag','Median'));

for i = 1:length(boxes)
    c = colors(mod(i-1,length(colors))+1,:);
    patch(get(boxes(i),'XData'), get(boxes(i),'YData'), ...
          c, 'FaceAlpha',0.9, 'EdgeColor','k');
    boxes(i).LineStyle = 'none';
    med(i).Color = 'k';
    med(i).LineWidth = 3.5;
end

% Whiskers & caps
set(findobj(gca,'Tag','Whisker'),'Color','k','LineWidth',3)
set(findobj(gca,'Tag','Cap'),'Color','k','LineWidth',3)

% Outliers
out = flipud(findobj(gca,'Tag','Outliers'));
for i = 1:length(out)
    c = colors(mod(i-1,length(colors))+1,:);
    out(i).MarkerEdgeColor = c;
    out(i).MarkerFaceColor = c;
    out(i).MarkerSize = 6;
end

% ================== AXES ==================
xticks(groupCenters)
xticklabels(arrayfun(@(x) sprintf('%.1f',x), E_vals,'UniformOutput',false))
xlabel('E (kPa)','FontSize',15)
ylabel('Protrusion Frequency (events/s)','FontSize',15)

ax = gca;
ax.TickLength = [0.01 0.025];
ax.LineWidth  = 1.5;
ax.FontSize   = 15;

% ================== LEGEND ==================
lgd = gobjects(3,1);
for i = 1:3
    lgd(i) = plot(nan,nan,'s','MarkerFaceColor',colors(i,:), ...
        'MarkerEdgeColor','k','MarkerSize',10);
end

legend(lgd,{
    'k_{on} = 0.9 s^{-1}'
    'k_{on} = 1.1 s^{-1}'
    'k_{on} = 1 s^{-1}, k_{int} = 1 pN/nm'
    },'Location','best','Box','off')

%%

figure; hold on
set(gcf,'Color','w')

% ===== E values =====
E_vals = [0.6 1.5 3 8 15 46];

% ===== Colors (k_on only) =====
colors = [
    0.35 0.35 0.35   % k_on = 0.9
    0.75 0.75 0.75   % k_on = 1.1
];

data = [];
groupID = [];
positions = [];

pos = 1;
gid = 1;
groupCenters = zeros(1,length(E_vals));

% ================== BUILD DATA ==================
for e = 1:length(E_vals)

    startPos = pos;

    for kon = 1:2

        vals = squeeze(frequency_force(kon,e,:));

        data    = [data; vals];
        groupID = [groupID; gid*ones(numel(vals),1)];
        positions(end+1) = pos;

        gid = gid + 1;
        pos = pos + 1;

    end

    groupCenters(e) = mean(startPos:(pos-1));
    pos = pos + 1;  % gap between stiffness groups
end

% ================== BOXPLOT ==================
boxplot(data, groupID, ...
        'Positions', positions, ...
        'Symbol','o', ...
        'Widths',0.6)

% ================== STYLE BOXES ==================
boxes = flipud(findobj(gca,'Tag','Box'));
med   = flipud(findobj(gca,'Tag','Median'));

for i = 1:length(boxes)
    c = colors(mod(i-1,2)+1,:);

    patch(get(boxes(i),'XData'), get(boxes(i),'YData'), ...
          c, 'FaceAlpha',0.9, 'EdgeColor','k');

    boxes(i).LineStyle = 'none';
    med(i).Color = 'k';
    med(i).LineWidth = 2.5;
end

% Whiskers & caps
set(findobj(gca,'Tag','Whisker'),'Color','k','LineWidth',2)
set(findobj(gca,'Tag','Cap'),'Color','k','LineWidth',2)

% ================== AXES ==================
xticks(groupCenters)
xticklabels(arrayfun(@(x) sprintf('%.1f',x), E_vals,'UniformOutput',false))
xlabel('E (kPa)','FontSize',15)
ylabel('F_{BR} > 0.257 pN (s^{-1})','FontSize',15)

ax = gca;
ax.LineWidth = 1.5;
ax.FontSize  = 14;
ax.TickLength = [0.01 0.02];

% ================== LEGEND ==================
lgd = gobjects(2,1);
for i = 1:2
    lgd(i) = plot(nan,nan,'s','MarkerFaceColor',colors(i,:), ...
        'MarkerEdgeColor','k','MarkerSize',10);
end

legend(lgd,{
    'k_{on} = 0.9 s^{-1}'
    'k_{on} = 1.1 s^{-1}'
    },'Location','best','Box','off')


%%
alpha = 0.05;

fprintf('\n===== STATISTICAL ANALYSIS: Protrusion Duration =====\n')
E_vals = [0.6 46];
for e = 1:length(E_vals)

    fprintf('\n--- E = %.2f kPa ---\n', E_vals(e))

    % Extract correct groups
    if e == 1   % 0.6 kPa
        g1 = squeeze(filamentCountDist(1,1,:)); % k_on = 0.9
        g2 = squeeze(filamentCountDist(2,1,:)); % k_on = 1.1

    elseif e == 6   % 46 kPa
        g1 = squeeze(filamentCountDist(1,2,:));
        g2 = squeeze(filamentCountDist(2,2,:));

    else   % 1.5,3,8,15
        col = e-1;
        g1 = squeeze(filamentCountDist(1,2,:));
        g2 = squeeze(filamentCountDist(1,2,:));
    end

    % Two-sample t-test (Welch)
    [h,p] = ttest2(g1, g2, 'Vartype','unequal');
    %[h, p, ks2stat] = kstest2(g1, g2);

    sig = 'ns';
    if p < 0.05, sig = '*'; end
    if p < 0.01, sig = '**'; end
    if p < 0.001, sig = '***'; end

    fprintf('k_on 0.9 vs 1.1: p = %.4g (%s)\n', p, sig)

end

%%
% --- Velocity from membrane position ---
dt = 1e-2;
V = diff(SimData.MembranePosition) / dt;   % velocity

% --- Extract 60 seconds (6000 samples) ---
Vtrace_raw = V(1000:6999);   % 6000 points exactly

% --- Time vector that MATCHES the trace length ---
t = (0:length(Vtrace_raw)-1) * dt;

% --- Low-pass filter ---
Fs = 1/dt;
cutoffHz = 1;
filterOrder = 3;
[b,a] = butter(filterOrder, cutoffHz/(Fs/2), 'low');
Vtrace_filt = filtfilt(b,a,Vtrace_raw);

% --- Plot ---
figure; hold on
set(gcf,'Color','w')

plot(t, Vtrace_raw, 'Color', [0.85 0.85 0.85], 'LineWidth', 0.8) % raw (light gray)
plot(t, Vtrace_filt, 'k', 'LineWidth', 2)                        % filtered (black)

xlabel('Time (s)')
ylabel('Membrane Velocity (nm/s)')
box off

%%
% Extract parameters
k_on_labels = [0.9, 1.1];          % two k_on values
substrate_index = 1;                % soft substrate: 0.6 kPa corresponds to index 1
n_reps = 20;                        % number of repetitions

% Prepare colors for the lines
colors = [0 0.4470 0.7410; 0.8500 0.3250 0.0980]; % MATLAB default blue and red

% Define bins for the histogram
bin_edges = 0:10:250; % adjust based on your filament length range
bin_centers = (bin_edges(1:end-1) + bin_edges(2:end))/2;

figure; hold on;

for k = 1:2
    all_lengths = [];
    
    % Concatenate all repetitions for this k_on and substrate
    for rep = 1:n_reps
        data = Fil_length{k, substrate_index, rep};
        all_lengths = [all_lengths; data(:)]; % make sure it's a column
    end
    
    % Compute normalized histogram (probability density)
    counts = histcounts(all_lengths, bin_edges, 'Normalization', 'probability');
    
    % Plot as a line
    plot(bin_centers, counts, 'LineWidth', 2, 'Color', colors(k,:));
end

xlabel('Filament orientation (degrees)');
ylabel('Probability');
%title('Filament Length Distributions on Soft Substrate (0.6 kPa)');
legend('k_{on} = 0.9', 'k_{on} = 1.1');
grid off;

%% Integrin Clustering Analysis  E = 0.6 kPa, k_on = 0.9 vs 1.1

E_target   = 46;
g_idx      = find(E_vals == E_target);
nRuns = 30;
k_on_labels = {'k_{on} = 0.9', 'k_{on} = 1.1'};
colors      = {[0.2 0.4 0.8], [0.8 0.2 0.2]};

% --- Pool all runs for each k_on ---
pooled = cell(1, length(k_on_vals));
for l = 1:length(k_on_vals)
    all_pts = [];
    for r = 1:nRuns
        pts = int_position{l, g_idx, r};
        if ~isempty(pts)
            all_pts = [all_pts; pts];
        end
    end
    pooled{l} = all_pts;
end
%%
% 1. 2D HEATMAPS (side by side) with consistent color scales
% ----------------------------------------------------------
xEdges = linspace(0,   500, 60);
yEdges = linspace(-500, 0,  60);
tRange = 1000:3000;
total_time = length(tRange) * dt * nRuns;  % total seconds sampled

figure('Position',[100 50 1200 450], 'Color','w');
titles = {'Low Activation (k_{on} = 0.9)', 'High Activation (k_{on} = 1.1)'};

% Compute frequency maps for both datasets
freqMaps = cell(1,2);
for l = 1:2
    pts = pooled{l};
    counts = histcounts2(pts(:,1), pts(:,2), xEdges, yEdges);
    freqMaps{l} = counts / total_time;
end

% Shared color limits
cmax = max([freqMaps{1}(:); freqMaps{2}(:)]);

% Plot
for l = 1:2
    subplot(1,2,l)
    imagesc(xEdges(1:end-1), yEdges(1:end-1), freqMaps{l}')
    axis xy
    colormap(hot)
    cb = colorbar;
    cb.Label.String = 'Frequency (s^{-1})';
    cb.Label.FontSize = 12;
    clim([0 cmax])
    xlabel('X position (nm)')
    ylabel('Distance from membrane (nm)')
    title(titles{l})
    set(gca, 'FontSize', 13)
end

%sgtitle('Bound Integrin Position Distributions  E = 0.6 kPa', 'FontSize', 15)
%%
% -----------------------------------------------
% NND within 90th percentile density region
% -----------------------------------------------
% -----------------------------------------------
% NND within 90th percentile density region
% -----------------------------------------------
figure('Position',[100 30 700 450], 'Color','w');
hold on
colors = [0.2 0.4 0.8;   % k_on = 0.9, blue
          0.8 0.2 0.2];  % k_on = 1.1, red
hArr = gobjects(1,2);  % store histogram handles

for l = 1:2
    pts = pooled{l};

    % Subsample if too large
    maxPts = 500000;
    if size(pts,1) > maxPts
        idx = randperm(size(pts,1), maxPts);
        pts = pts(idx,:);
    end

    % --- Bin the points ---
    [counts, ~, ~, binX, binY] = histcounts2(pts(:,1), pts(:,2), xEdges, yEdges);

    % --- 90th percentile threshold ---
    thresh = prctile(counts(counts > 0), 50);

    % --- Vectorized bin lookup ---
    valid_bins = binX > 0 & binY > 0 & ...
                 binX <= size(counts,1) & binY <= size(counts,2);
    in_high_density = false(size(pts,1), 1);
    in_high_density(valid_bins) = counts(sub2ind(size(counts), ...
                                  binX(valid_bins), binY(valid_bins))) >= thresh;

    pts_cluster = pts(in_high_density, :);

    fprintf('k_on = %.1f | Points in 90th pct region: %d / %d (%.1f%%)\n', ...
        k_on_vals(l), sum(in_high_density), size(pts,1), ...
        100*sum(in_high_density)/size(pts,1))

    % --- NND ---
    if size(pts_cluster,1) < 2, continue; end
    D = pdist2(pts_cluster, pts_cluster, 'euclidean', 'Smallest', 2);
    nnd_cluster = D(2,:)';

    fprintf('k_on = %.1f | Median NND (90th pct) = %.2f nm\n', ...
        k_on_vals(l), median(nnd_cluster))

    hArr(l) = histogram(nnd_cluster, 60, 'Normalization', 'probability', ...
        'FaceColor', colors(l,:), 'FaceAlpha', 0.5, 'EdgeColor', 'none');
end

xlabel('Nearest-Neighbor Distance (nm)')
ylabel('Probability')
legend(hArr, k_on_labels, 'FontSize', 13, 'Location', 'best')
set(gca, 'FontSize', 13, 'Box', 'off')
set(gcf, 'Position', [100 50 700 450])
%sgtitle('90th Percentile Density Region Overlay  E = 0.6 kPa','FontSize',15)

%%

% -----------------------------------------------
% 3. CLUSTER DENSITY METRIC
% -----------------------------------------------
R = 1;  % nm  tune to your system
figure('Position',[100 50 600 450]);
density_metric = nan(1,2);

for l = 1:2
    pts = pooled{l};

    % Subsample first
    maxPts = 5000;
    if size(pts,1) > maxPts
        idx = randperm(size(pts,1), maxPts);
        pts = pts(idx,:);
    end

    if size(pts,1) < 2, continue; end

    % Find nearest neighbor distance only  no full matrix
    D = pdist2(pts, pts, 'euclidean', 'Smallest', 2);
    nnd = D(2,:)';  % nearest neighbor distance per point

    % Fraction of points with a neighbor within R
    hasNeighbor = nnd < R;
    density_metric(l) = sum(hasNeighbor) / size(pts,1);

    fprintf('k_on = %.1f | Cluster density (R=%gnm) = %.3f\n', ...
        k_on_vals(l), R, density_metric(l))
end

bar(density_metric, 'FaceColor', 'flat', 'CData', [0.2 0.4 0.8; 0.8 0.2 0.2])
xticklabels(k_on_labels)
ylabel(sprintf('Fraction of integrins within %g nm of a neighbor', R))
title('Cluster Density Metric  E = 0.6 kPa')
set(gca, 'FontSize', 13, 'Box', 'off')
%%
% -----------------------------------------------
% 4. RIPLEY'S K / L FUNCTION
% -----------------------------------------------
% -----------------------------------------------
% Ripley's L  per run, then averaged
% -----------------------------------------------
r_vals = linspace(0, 150, 40);
x_min = 0; x_max = 500;
y_min = -500; y_max = 0;
area = (x_max - x_min) * (y_max - y_min);

L_allRuns = nan(length(k_on_vals), nRuns, length(r_vals));

for l = 1:2
    for r = 1:nRuns
        pts = int_position{l, g_idx, r};
        if size(pts,1) < 10, continue; end

        n = size(pts,1);
        D = pdist2(pts, pts);

        K = zeros(1, length(r_vals));
        for ri = 1:length(r_vals)
            rv = r_vals(ri);

            % Ripley's edge correction weight per pair (Ripley's isotropic)
            withinR = D < rv & D > 0;

            % Edge correction: weight each point by fraction of circle inside domain
            w = zeros(n, n);
            for i = 1:n
                for j = 1:n
                    if withinR(i,j)
                        % Proportion of circle of radius D(i,j) inside domain
                        cx = pts(i,1); cy = pts(i,2);
                        d  = D(i,j);
                        % Distances to each edge
                        dx_left  = cx - x_min;
                        dx_right = x_max - cx;
                        dy_bot   = cy - y_min;
                        dy_top   = y_max - cy;
                        % Fraction of circumference inside (approx)
                        prop = min([dx_left, dx_right, dy_bot, dy_top, d]) / d;
                        prop = max(min(prop, 1), 0.25);
                        w(i,j) = 1/prop;
                    end
                end
            end

            K(ri) = (area / n^2) * sum(w(:));
        end

        L_allRuns(l, r, :) = sqrt(K/pi) - r_vals;
    end
end

% --- Plot mean +/- SEM across runs ---
figure('Position',[100 300 700 450]);
hold on

line_colors = [0.2 0.4 0.8; 0.8 0.2 0.2];
for l = 1:2
    L_runs = squeeze(L_allRuns(l,:,:));           % [nRuns x nR]
    L_mean = mean(L_runs, 1, 'omitnan');
    L_sem  = std(L_runs, 0, 1, 'omitnan') / sqrt(sum(~isnan(L_runs(:,1))));

    fill([r_vals fliplr(r_vals)], ...
         [L_mean+L_sem fliplr(L_mean-L_sem)], ...
         line_colors(l,:), 'FaceAlpha', 0.15, 'EdgeColor', 'none')
    plot(r_vals, L_mean, 'Color', line_colors(l,:), 'LineWidth', 2.5)
end

yline(0, 'k--', 'LineWidth', 1.5)
xlabel('r (nm)')
ylabel('L(r) - r')
legend(k_on_labels, 'FontSize', 13, 'Location', 'best')
title("Ripley's L Function  E = 0.6 kPa")
set(gca, 'FontSize', 13, 'Box', 'off')

%%
% -----------------------------------------------
% Local Integrin Density  E = 3 & 46 kPa, both k_on
% -----------------------------------------------
xEdges = linspace(0,   500, 60);
yEdges = linspace(-500, 0,  60);
E_targets = [3, 46];
g_idxs    = arrayfun(@(e) find(E_vals == e), E_targets);
dx = mean(diff(xEdges));
dy = mean(diff(yEdges));
bin_area = dx * dy;
 
% density_per_run: [nE x nKon x nRuns]
density_per_run_all = nan(length(E_targets), length(k_on_vals), nRuns);

for gi = 1:length(E_targets)
    g_idx_i = g_idxs(gi);
    for l = 1:length(k_on_vals)
        pts_all = [];
        for r = 1:nRuns
            pts_all = [pts_all; int_position{l, g_idx_i, r}];
        end
        if isempty(pts_all), continue; end
        counts_all  = histcounts2(pts_all(:,1), pts_all(:,2), xEdges, yEdges);
        thresh      = prctile(counts_all(counts_all > 0), 90);
        high_bins   = counts_all >= thresh;
        region_area = sum(high_bins(:)) * bin_area;
        fprintf('E = %g kPa | k_on = %.1f | Region area = %.1f nm^2 (%.4f um^2)\n', ...
            E_targets(gi), k_on_vals(l), region_area, region_area/1e6)

        for r = 1:nRuns
            data = int_snapshots{l, g_idx_i, r};
            if isempty(data), continue; end
            t_vals       = unique(data(:,3));
            counts_per_t = zeros(length(t_vals), 1);

            for ti = 1:length(t_vals)
                pts_t = data(data(:,3) == t_vals(ti), 1:2);
                if isempty(pts_t), continue; end
                [~,~,~, bX, bY] = histcounts2(pts_t(:,1), pts_t(:,2), xEdges, yEdges);
                valid     = bX > 0 & bY > 0 & ...
                            bX <= size(high_bins,1) & bY <= size(high_bins,2);
                in_region = false(size(pts_t,1),1);
                in_region(valid) = high_bins(sub2ind(size(high_bins), ...
                                             bX(valid), bY(valid)));
                counts_per_t(ti) = sum(in_region);
            end
            density_per_run_all(gi, l, r) = mean(counts_per_t) / region_area;
        end
    end
end

% --- Collect stats and convert to integrins/um^2 ---
mean_d    = nan(4,1);
sem_d     = nan(4,1);
data_runs = nan(4, nRuns);

idx = 1;
for gi = 1:length(E_targets)
    for l = 1:length(k_on_vals)
        d = squeeze(density_per_run_all(gi, l, :))' * 1e6;  % convert to /um^2
        mean_d(idx)       = mean(d, 'omitnan');
        sem_d(idx)        = std(d, 'omitnan') / sqrt(sum(~isnan(d)));
        data_runs(idx,:)  = d;
        idx = idx + 1;
    end
end

% --- Plot ---
figure('Position',[100 50 700 450], 'Color','w');
hold on

group_labels = {'k_{on}=0.9', 'k_{on}=1.1', 'k_{on}=0.9', 'k_{on}=1.1'};
group_colors = [0.2 0.4 0.8;
                0.8 0.2 0.2;
                0.1 0.6 0.3;
                0.9 0.6 0.1];
bar_x = [1 2 4 5];

for i = 1:4
    bar(bar_x(i), mean_d(i), 0.6, 'FaceColor', group_colors(i,:), ...
        'FaceAlpha', 0.7, 'EdgeColor', 'none')
    errorbar(bar_x(i), mean_d(i), sem_d(i), 'k', 'LineWidth', 1.5, 'CapSize', 8)
    scatter(bar_x(i) + 0.15*(rand(nRuns,1)-0.5), data_runs(i,:)', ...
        20, 'k', 'filled', 'MarkerFaceAlpha', 0.3)
    fprintf('%s | Mean = %.2f integrins/um^2\n', group_labels{i}, mean_d(i))
end

xticks(bar_x)
xticklabels(group_labels)
xtickangle(15)
ylabel('Mean Integrin Density (integrins /\mum^{-2})')
ylim([400 1000])
set(gca, 'FontSize', 13, 'Box', 'off')

% E group separators and labels
xline(3, 'k--', 'LineWidth', 1)
text(1.5, max(mean_d)*1.08, 'E = 3 kPa',  'HorizontalAlignment','center','FontSize',13)
text(4.5, max(mean_d)*1.08, 'E = 46 kPa', 'HorizontalAlignment','center','FontSize',13)

% t-tests within each E group
Y = [];
E_factor = [];
kon_factor = [];

for gi = 1:length(E_targets)

    for l = 1:length(k_on_vals)

        d = squeeze(density_per_run_all(gi,l,:)) * 1e6;

        for r = 1:nRuns

            if ~isnan(d(r))
                Y(end+1,1) = d(r);
                E_factor(end+1,1) = gi;   % stiffness level
                kon_factor(end+1,1) = l;  % k_on condition
            end

        end
    end
end

[p,tbl,stats] = anovan(Y,{E_factor, kon_factor}, ...
    'model','interaction', ...
    'varnames',{'Stiffness','k_on'});

disp(tbl)
%%
% Pool across runs for E = 0.6 kPa

E_target   = 46;
g_idx      = find(E_vals == E_target);
nRuns = 25;
k_on_labels = {'k_{on} = 0.9', 'k_{on} = 1.1'};
colors      = {[0.2 0.4 0.8], [0.8 0.2 0.2]};

% --- Pool all runs for each k_on ---
pooled_fil = cell(1,2);
for l = 1:2
    all_pts = [];
    for r = 1:nRuns
        pts =  fil_position_bound{l, g_idx, r};
        if ~isempty(pts)
            all_pts = [all_pts; pts];
        end
    end
    pooled_fil{l} = all_pts;
end

% Compute shared color limits
counts_fil1 = histcounts2(pooled_fil{1}(:,1), pooled_fil{1}(:,2), xEdges, yEdges);
counts_fil2 = histcounts2(pooled_fil{2}(:,1), pooled_fil{2}(:,2), xEdges, yEdges);
shared_clim_fil = [0, max([counts_fil1(:); counts_fil2(:)])];

titles_fil = {'Bound Filaments k_{on} = 0.9', 'Bound Filaments k_{on} = 1.1'};

figure('Position',[100 50 1200 450], 'Color','w');
for l = 1:2
    subplot(1,2,l)
    histogram2(pooled_fil{l}(:,1), pooled_fil{l}(:,2), xEdges, yEdges, ...
        'DisplayStyle','tile', 'ShowEmptyBins','on', 'Normalization','probability')
    colormap(hot), colorbar;
    xlabel('X position (nm)')
    ylabel('Distance from membrane (nm)')
    title(titles_fil{l})
    set(gca, 'FontSize', 13)
end
%sgtitle('Bound Filament Position Distributions  E = 0.6 kPa', 'FontSize', 15)

%%

% -----------------------------------------------
% Bound Filament Position Distribution  y_rel to membrane
% -----------------------------------------------
figure('Position',[100 50 700 450], 'Color','w');
hold on

hArr_fil = gobjects(1,2);

for l = 1:2
    pts = pooled_fil{l};
    if isempty(pts), continue; end

    if l == 1, fc = [0.2 0.4 0.8]; else, fc = [0.8 0.2 0.2]; end

    hArr_fil(l) = histogram(abs(pts(:,2)), 80, ...
        'Normalization', 'probability', ...
        'FaceColor', fc, 'FaceAlpha', 0.5, 'EdgeColor', 'none');

    fprintf('k_on = %.1f | Median y_rel = %.2f nm\n', k_on_vals(l), median(pts(:,2)))
end

xlabel('F-actin distance from membrane (nm)')
ylabel('Probability')
legend(hArr_fil, k_on_labels, 'FontSize', 13, 'Location', 'best')
%title('Bound Filament Distance from Membrane  E = 0.6 kPa')
set(gca, 'FontSize', 13, 'Box', 'off')

%%
% -----------------------------------------------
% Distribution of Integrin Position Relative to Membrane
% E = 3 & 46 kPa, both k_on
% -----------------------------------------------

figure('Position',[100 30 700 500], 'Color','w');
hold on

group_colors = [0.2 0.4 0.8;
                0.8 0.2 0.2;
                0.1 0.6 0.3;
                0.9 0.6 0.1];

bar_x        = [1 2 4 5];
group_labels = {'k_{on}=0.9', 'k_{on}=1.1', 'k_{on}=0.9', 'k_{on}=1.1'};

% Bin edges for y_rel distribution
yBins = linspace(-520, 20, 80);
yCenters = yBins(1:end-1) + mean(diff(yBins))/2;

mean_y   = nan(4,1);
sem_y    = nan(4,1);
median_y = nan(4,1);

idx = 1;
for gi = 1:length(E_targets)
    g_idx_i = g_idxs(gi);
    for l = 1:length(k_on_vals)

        % Pool y_rel across all runs
        y_all = [];
        for r = 1:nRuns
            pts = int_position{l, g_idx_i, r};
            if ~isempty(pts)
                y_all = [y_all; pts(:,2)];
            end
        end

        if isempty(y_all)
            idx = idx + 1;
            continue
        end

        % Compute normalized distribution
        counts_y  = histcounts(y_all, yBins, 'Normalization', 'probability');

        % Scale for violin width
        scale     = 0.35;
        counts_scaled = counts_y / max(counts_y) * scale;

        % Draw filled violin
        xc = bar_x(idx);
        fill([xc + counts_scaled, fliplr(xc - counts_scaled)], ...
             [yCenters,           fliplr(yCenters)], ...
             group_colors(idx,:), 'FaceAlpha', 0.4, 'EdgeColor', 'none')
        plot(xc + counts_scaled, yCenters, 'Color', group_colors(idx,:), 'LineWidth', 1)
        plot(xc - counts_scaled, yCenters, 'Color', group_colors(idx,:), 'LineWidth', 1)

        % Median line
        med_y = median(y_all);
        plot([xc - scale, xc + scale], [med_y med_y], ...
            'Color', group_colors(idx,:), 'LineWidth', 2.5)

        % Mean +/- SEM across runs
        run_means = nan(nRuns,1);
        for r = 1:nRuns
            pts = int_position{l, g_idx_i, r};
            if ~isempty(pts)
                run_means(r) = mean(pts(:,2));
            end
        end
        mean_y(idx) = mean(run_means, 'omitnan');
        sem_y(idx)  = std(run_means, 'omitnan') / sqrt(sum(~isnan(run_means)));
        median_y(idx) = med_y;

        % Mean dot with error bar
        errorbar(xc, mean_y(idx), sem_y(idx), 'ko', ...
            'MarkerFaceColor', 'k', 'MarkerSize', 5, 'LineWidth', 1.5, 'CapSize', 6)

        fprintf('E = %g kPa | k_on = %.1f | Mean y_rel = %.1f nm | Median = %.1f nm\n', ...
            E_targets(gi), k_on_vals(l), mean_y(idx), median_y(idx))

        idx = idx + 1;
    end
end

% Formatting
xticks(bar_x)
xticklabels(group_labels)
xtickangle(15)
ylabel('Distance from Membrane (nm)')
set(gca, 'FontSize', 13, 'Box', 'off')
ylim([-520 20])

% E group separators and labels
xline(3, 'k--', 'LineWidth', 1)
text(1.5,  -480, 'E = 3 kPa',  'HorizontalAlignment', 'center', 'FontSize', 13)
text(4.5,  -480, 'E = 46 kPa', 'HorizontalAlignment', 'center', 'FontSize', 13)
% Collect all observations
Y = [];
E_factor = [];
kon_factor = [];

for gi = 1:length(E_targets)
    g_idx_i = g_idxs(gi);

    for l = 1:length(k_on_vals)
        for r = 1:nRuns

            pts = int_position{l, g_idx_i, r};

            if ~isempty(pts)
                mean_val = mean(pts(:,2));

                Y(end+1,1) = mean_val;
                E_factor(end+1,1) = gi;      % stiffness group
                kon_factor(end+1,1) = l;     % k_on condition
            end

        end
    end
end

% Two-way ANOVA
[p,tbl,stats] = anovan(Y,{E_factor, kon_factor}, ...
    'model','interaction', ...
    'varnames',{'Stiffness','k_on'});

disp(tbl)

%%
%% ===== ALL PAIRWISE COMPARISONS =====
% RMSVel: 2 x 6 x 30

nStiff = size(dutyCycle, 2);

pvals = zeros(nStiff,1);
tstats = zeros(nStiff,1);

for s = 1:nStiff
    group1 = squeeze(dutyCycle(1, s, :)); % k_on = low
    group2 = squeeze(dutyCycle(2, s, :)); % k_on = high
    
    [~, p, ~, stats] = ttest2(group1, group2);
    
    pvals(s) = p;
    tstats(s) = stats.tstat;
end

[p_sorted, sort_idx] = sort(pvals);
m = length(pvals);
q = 0.05;

thresholds = (1:m)'/m * q;
significant_sorted = p_sorted <= thresholds;

max_idx = find(significant_sorted, 1, 'last');

significant_fdr = false(size(pvals));
if ~isempty(max_idx)
    significant_fdr(sort_idx(1:max_idx)) = true;
end

stiffness_idx = (1:nStiff)';

results_table = table(stiffness_idx, tstats, pvals, significant_fdr, ...
    'VariableNames', {'StiffnessIndex', 't_stat', 'p_value', 'Significant_FDR'});

disp('--- k_on COMPARISON WITHIN EACH STIFFNESS ---');
disp(results_table);