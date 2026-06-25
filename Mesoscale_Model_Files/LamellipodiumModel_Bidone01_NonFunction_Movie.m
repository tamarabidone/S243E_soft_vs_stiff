clc
ModelParameters = InitializeModelParameters;  % Initialize Model paramaeters

% Special Conditions (or edits to ModelParameters) ==============================================================
    ModelParameters.TimeStep = 1e-4;
    ModelParameters.TotalSimulationTime = 30; % seconds
    ModelParameters.FilamentThermalMotionOn = false; 
    ModelParameters.CytoplasmViscosity = 1e5 * 0.0001; % Pascal * seconds
    ModelParameters.StartingNumberOfFilaments = 32; %32; % This is a ballpark value based on MaximumFilamentMass
    ModelParameters.k_c = 1;
    ModelParameters.k_s_local  = 0.0084;  % pN/nm
    ModelParameters.k_s_global = 0.105;   % pN/nm
    ModelParameters.Adhesion_ActivationRate = 0.9;
    ModelParameters.k_off_pointed = 7; % s^-1
    ModelParameters.k_branch = 2.2; % s^-1
    %ModelParameters.FAL_connection_Distance = 2.75; % nm
    ModelParameters.MaximumFilamentMass = 4000; % monomers
    ModelParameters.MolecularClutch_PeakNumber = 1; % Catch bond (1 = WildType or 2 = Manganese)
    ModelParameters.MembraneWidth = 500; % 5x
    Ka = 1;
    Kl = 1;
    Nu = 1;
    % ModelParameters.ModelDepth = round(500/3); % nm
    % ModelParameters.LigandTotal = 10; %round(400/3); 
    % ModelParameters.AdhesionTotal = round(100/3);
% ===============================================================================================================
            %save ('SimData_0001pN_wt_1.mat', '-struct', 'SimData');
            Membrane       = InitializeMembrane(ModelParameters);
            Filaments      = InitializeActinFilaments(ModelParameters,Membrane); 
            Adhesions      = InitializeAdhesions(ModelParameters,Membrane);
            Ligands        = InitializeLigands(ModelParameters);
            FALconnections = InitializeFALconnections;
            ShowPlot       = true;
            MVAR = struct( ...
            'ModelParameters', ModelParameters, ...
            'Membrane', Membrane, ...
            'Filaments', Filaments, ...
            'Adhesions', Adhesions, ...
            'Ligands', Ligands, ...
            'FALconnections', FALconnections);
            TotFAL = [];
            MeanTens = [];
            SDist = [];
            
            if ShowPlot  
                [FH,AH1,AH2,AH3] = SetUpPlottingFigureAndAxes; 
            end
            set(FH,'Position',[00.0963   -0.7217    1.7975    1.3017])

            % Pre-allocate space and create parameters to be saved after model completes (variable used for recording data is: SimData)
            TimeVec = 0:MVAR.ModelParameters.TimeStep:ModelParameters.TotalSimulationTime;
            TV2 = 0:0.001:MVAR.ModelParameters.TotalSimulationTime; % This time vector is for sampling only at 1ms intervals
            nMono   = NaN(length(TV2),1);
            nAdhes  = NaN(length(TV2),1);
            nFALconn = NaN(length(TV2),1);
            MemVel  = NaN(length(TV2),1);
            SubstrateY = NaN(length(TV2),1);

            SimData.ModelParameters = MVAR.ModelParameters;
            SimData.TimeVector = TV2;
            SimData.MembranePosition = NaN(length(TV2),1);
            SimData.AdhesionData     = NaN(MVAR.ModelParameters.AdhesionTotal,5,length(TV2));

            DATA = cell(length(TV2),1);
            MVAR.MembranePrevious = MVAR.Membrane;
            
            % Initialize parameters to control the "nth" frame to plot
            index = 0;  
            count = 0;
            nth = 200; % plot every nth frame
            
            disp('Starting model....')

%% START Movie

MovieDirectory = '/uufs/chpc.utah.edu/common/home/bidone-group3/Remi/Soft_low_k_on';
v = VideoWriter(fullfile(MovieDirectory, 'Movie01.avi'), 'Motion JPEG AVI');
v.Quality = 95;
v.FrameRate = 10; %Frames per second
open(v)
MovieIdx = 0;         


%% START Model 
                
            MVAR.ModelParameters.SubVelForPrevTimePt = 0;

            for t = TimeVec
                SubYPrev = MVAR.ModelParameters.Substrate.Ycoords;
                for f = 1:length(Filaments.Name)
                MVAR.Filaments.PreviousLength(f) = MVAR.Filaments.XYCoords{f}(end,2) - MVAR.Filaments.XYCoords{f}(1,2);
                end
                % Main model calculations ----------------------------------------------------------------------------------
                [nMonomers, DeletedFilamentNames] = CountTotalMonomers(MVAR);
                [MVAR] = PolymerizeDepolymerizeCapDeleteFilaments(nMonomers,MVAR);
                MVAR = BranchFilamentsInBranchWindowIfSelected(MVAR);
                [MVAR] = CreateFALconnections(MVAR);
                [MVAR, AdhesionTensions, Data, StretchDistance] = CalculatePositionAfterAppliedForces(MVAR);            
                [MVAR] = ManageAdhesionsAndLigands(MVAR);    
                
                ModelParameters.SubVelForPrevTimePt = (MVAR.ModelParameters.Substrate.Ycoords-SubYPrev) / MVAR.ModelParameters.TimeStep;
                % Calculate speed, mass, and add random filament if necessarry ---------------------------------------------
                if rem( round(t, 10),0.001) == 0 % Only record in 1ms intervals
                    [MVAR] = DeleteFilaments(MVAR, DeletedFilamentNames);
                    index = index + 1;
                    Data.Timepoint  = t;
                    DATA{index,1}   = Data; % Data contains retrograde flow values for all filaments at each timepoint
                    nMono(index,1)  = nMonomers;
                    nAdhes(index,1) = length(find(MVAR.Adhesions.ActiveStatus));
                    nFALconn(index,1) = numel(MVAR.FALconnections.AdhesionIndex);
                    SubstrateY(index,1) = MVAR.ModelParameters.Substrate.Ycoords;
                    MemVel(index,1) = (MVAR.Membrane.Nodes.Ycoords(1) - MVAR.MembranePrevious.Nodes.Ycoords(1)) / MVAR.ModelParameters.TimeStep; 
                    
                    % Record membrane segment position, and Adhesion data ------------------
                    SimData.MembranePosition(index,1) = MVAR.Membrane.Nodes.Ycoords(1); 
                    SimData.AdhesionData(:,:,index)   = [MVAR.Adhesions.XYpoints, MVAR.Adhesions.ActiveStatus, AdhesionTensions, MVAR.Adhesions.AttachedFilamentName];
                    SimData.nMonomers   = nMonomers;
                    SimData.nAdhesions  = nAdhes;
                    SimData.MemVelocity = MemVel;
                    SimData.SubstrateY  = SubstrateY;
                    SimData.Data        = DATA; 
                end
                

                %[Filaments] = AddRandomFilaments(Filaments,Membrane,ModelParameters,nMono(index,1)); % If neccesary add a new filament
                             
                % Create plot ----------------------------------------------------------------------------------------------
                if ShowPlot 
                    MovieIdx = MovieIdx + 1;
                    %[FALconnections,count] = PlotFilamentsAndMembrane(nth,count,Filaments,Membrane,Adhesions,Ligands,FALconnections,FH,AH1,AH2,AH3,t,nMono,nAdhes,MemVel,index,TV2,ModelParameters);
                    if (count >= nth) || isequal(t,0)
                        count = 0;
                        [FALconnections,count] = PlotFilamentsAndMembraneMovie01(nth,count,MVAR,Filaments,Membrane,Adhesions,Ligands,FALconnections,FH,AH1,AH2,AH3,t,nMono,nAdhes,MemVel,index,TimeVec,ModelParameters, Data)
                        Fimage = getframe(FH);
                        writeVideo(v,Fimage.cdata)
                        % imwrite( Fimage.cdata, fullfile(MovieDirectory,['Frame_',sprintf('%06d',MovieIdx),'.tif']) )
                    end
                end
                
                if round(t,10) == 1
                    savefig(FH, fullfile(MovieDirectory,"Snapshot_t01.fig")) 
                elseif round(t,10) == 5
                    savefig(FH, fullfile(MovieDirectory,"Snapshot_t05.fig"))
                elseif round(t,10) == 7.5
                    savefig(FH, fullfile(MovieDirectory,"Snapshot_t075.fig"))
                elseif round(t,10) == 10
                    savefig(FH, fullfile(MovieDirectory,"Snapshot_t010.fig")) 
                elseif round(t,10) == 20
                    savefig(FH, fullfile(MovieDirectory,"Snapshot_t020.fig")) 
                elseif round(t,10) == 25
                    savefig(FH, fullfile(MovieDirectory,"Snapshot_t025.fig")) 
                elseif round(t,10) == 27.5
                    savefig(FH, fullfile(MovieDirectory,"Snapshot_t027.5.fig")) 
                elseif round(t,10) == 30
                    savefig(FH, fullfile(MovieDirectory,"Snapshot_t030.fig")) 
                end


                count = count + 1;
                MembranePrevious = Membrane;
                drawnow
            end
            
%% END Model 


% close(v)



         %%save(fullfile(SaveDir,SaveName),'SimData','-mat','-v7.3')
    %% catch
       %%  disp(['File not saved: ',SaveName])
    %% end





