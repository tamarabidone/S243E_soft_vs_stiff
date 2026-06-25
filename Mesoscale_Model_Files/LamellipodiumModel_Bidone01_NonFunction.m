clc
ModelParameters = InitializeModelParameters;  % Initialize Model paramaeters

% Special Conditions (or edits to ModelParameters) ==============================================================
    ModelParameters.TimeStep = 1e-4;
    ModelParameters.TotalSimulationTime = 50; % seconds
    ModelParameters.FilamentThermalMotionOn = false; 
    ModelParameters.CytoplasmViscosity = 1e5 * 0.0001; % Pascal * seconds
    ModelParameters.VerticalOffSet = -200;
    ModelParameters.StartingNumberOfFilaments = 32; % This is a ballpark value based on MaximumFilamentMass
    ModelParameters.AdhesionSpringConstant = 0.5; % Change (substrate rigidity)
    ModelParameters.k_c = 1; %Clutch Stiffness
    ModelParameters.k_a = 1; %Additional Stiffness
    ModelParameters.k_l = 1; %Long-Term Stiffness
    ModelParameters.nu = 1; %Dashpot Viscosity
    ModelParameters.k_off_pointed = 7; % s^-1
    ModelParameters.k_branch = 2.2; % s^-1
    ModelParameters.FAL_connection_Distance = 10*2.75; % nm
    ModelParameters.MaximumFilamentMass = 4000; % monomers
    ModelParameters.MolecularClutch_PeakNumber = 1; % Catch bond (1 = WildType or 2 = Manganese)
% ===============================================================================================================
            %save ('SimData_0001pN_wt_1.mat', '-struct', 'SimData');
            % Initialize model variables for Filaments, Adhesions, Ligands, and Filament/Adhesion/Ligand connections
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
            ShowPlot       = true;
            
            if ShowPlot  
                [FH,AH1,AH2,AH3] = SetUpPlottingFigureAndAxes; 
            end
            
            % Pre-allocate space and create parameters to be saved after model completes (variable used for recording data is: SimData)
            TimeVec = 0:MVAR.ModelParameters.TimeStep:MVAR.ModelParameters.TotalSimulationTime;
            TV2 = 0:0.001:MVAR.ModelParameters.TotalSimulationTime; % This time vector is for sampling only at 1ms intervals
            nMono   = NaN(length(TV2),1);
            nAdhes  = NaN(length(TV2),1);
            MemVel  = NaN(length(TV2),1);
            
            SimData.ModelParameters = MVAR.ModelParameters;
            SimData.TimeVector = TV2;
            SimData.MembranePosition = NaN(length(TV2),1);
            SimData.AdhesionData     = NaN(MVAR.ModelParameters.AdhesionTotal,5,length(TV2));
            
            DATA = cell(length(TV2),1);
            MembranePrevious = MVAR.Membrane;
            
            % Initialize parameters to control the "nth" frame to plot
            index = 0;  
            count = 0;
            nth = 1000; % plot every nth frame
            
            disp('Starting model....')

%% START Movie

MovieDirectory = '/Users/remisondaz/Desktop/MATLAB/Viscoelastic New';
v = VideoWriter(fullfile(MovieDirectory, 'Movie01.avi'), 'Motion JPEG AVI');
v.Quality = 95;
v.FrameRate = 10; %Frames per second
open(v)
MovieIdx = 0;   


%% START Model 

            for t = TimeVec
                SubYPrev = MVAR.ModelParameters.Substrate.Ycoords;
                % Main model calculations ----------------------------------------------------------------------------------
                [nMonomers, DeletedFilamentNames] = CountTotalMonomers(MVAR);
                [MVAR] = PolymerizeDepolymerizeCapDeleteFilaments(nMonomers,MVAR);
                MVAR = BranchFilamentsInBranchWindowIfSelected(MVAR);
                [MVAR] = CreateFALconnections(MVAR);
                [MVAR, AdhesionTensions, Data, StretchDistance] = CalculatePositionAfterAppliedForces(MVAR);            
                [MVAR] = ManageAdhesionsAndLigands(MVAR);    
                
                ModelParameters.SubVelForPrevTimePt = (MVAR.ModelParameters.Substrate.Ycoords-SubYPrev) / MVAR.ModelParameters.TimeStep;

                % Calculate speed, mass, and add random filament if necessarry ---------------------------------------------
                if rem( round(t,10),0.1) == 0 % Only record in 1ms intervals
                    disp(t)
                    index = index + 1;
                    Data.Timepoint  = t;
                    DATA{index,1}   = Data; % Data contains retrograde flow values for all filaments at each timepoint
                    nMono(index,1)  = CountTotalMonomers(MVAR);
                    nAdhes(index,1) = length(find(MVAR.Adhesions.ActiveStatus));
                    MemVel(index,1) = (MVAR.Membrane.Nodes.Ycoords(1) - MembranePrevious.Nodes.Ycoords(1)) / MVAR.ModelParameters.TimeStep; 
                    
                    % Record membrane segment position, and Adhesion data ------------------
                    SimData.MembranePosition(index,1) = MVAR.Membrane.Nodes.Ycoords(1); 
                    SimData.AdhesionData(:,:,index)   = [MVAR.Adhesions.XYpoints, MVAR.Adhesions.ActiveStatus, AdhesionTensions, MVAR.Adhesions.AttachedFilamentName];
                    SimData.nMonomers   = nMono;
                    SimData.nAdhesions  = nAdhes;
                    SimData.MemVelocity = MemVel;
                    SimData.Data        = DATA; 
                end
                
                %[Filaments] = AddRandomFilaments(Filaments,Membrane,ModelParameters,nMono(index,1)); % If neccesary add a new filament
                
                % Create plot ----------------------------------------------------------------------------------------------
                if ShowPlot
                    MovieIdx = MovieIdx + 1;
                    [count] = PlotFilamentsAndMembrane(nth,count,MVAR,AdhesionTensions,FH,AH1,AH2,AH3,t, TimeVec,nMono,nAdhes,SubYPrev,MemVel,index,TV2, Data);
                    %[FALconnections,count] = PlotFilamentsAndMembraneMovie01(nth,count,Filaments,Membrane,Adhesions,Ligands,FALconnections,FH,AH1,AH2,AH3,t,nMono,nAdhes,MemVel,index,TV2,ModelParameters);
                    Fimage = getframe(FH);
                    writeVideo(v,Fimage.cdata)
                    %imwrite( Fimage.cdata, fullfile(MovieDirectory,['Frame_',sprintf('%06d',MovieIdx),'.tif']) )
                end
                
                if round(t,10) == 0.5
                    disp('pause')
                elseif round(t,10) == 10
                    disp('pause')
                elseif round(t,10) == 20
                    disp('pause')
                end

                count = count + 1;
                MembranePrevious = MVAR.Membrane;
                drawnow
            end
            
%% END Model 


% close(v)



         %%save(fullfile(SaveDir,SaveName),'SimData','-mat','-v7.3')
    %% catch
       %%  disp(['File not saved: ',SaveName])
    %% end


