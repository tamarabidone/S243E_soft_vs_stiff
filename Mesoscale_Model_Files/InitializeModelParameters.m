function ModelParameters = InitializeModelParameters

%% Time Properties
  
        ModelParameters.TotalSimulationTime = 30; %30; % seconds
        ModelParameters.TimeStep = 1e-4; % seconds 

%% General Properties
        
        ModelParameters.kT = 4.11; % k_B * T = 4.28 pN*nm (for T = 310 K)
        ModelParameters.CytoplasmViscosity = 1e4 * 0.001; % (Pa*s) https://summerschool.tugraz.at/images/phocadownload/Wirtz-Annu_Rev_Biophys-2009.pdf
        ModelParameters.MatrixViscosity = 100; %(PaS) REF: The interaction of plasma fibronectin
        %with fibroblastic cells in suspension (Yamada 1985)
        % REF 2: Oscillatory behaviour of simple kinetic model for
        % proteolysis during cell invasion (Laretta-Garde)
        %Ref 3: Computational model for cell migration in 3D matrices
        %(Lauffenburger 2005)
%% Ligand Properties        

        ModelParameters.LigandTotal = 400; 
        
%% Adhesion Properties

        ModelParameters.AdhesionTotal = 100; % 800 MC = on, 400 MC = off; (for LeadingEdgeLength = 2000 nm and RegionsDepth = 200 nm)
        ModelParameters.FAL_connection_Distance = 10*2.75; % nm
        ModelParameters.Adhesion_ActivationRate = 1; % events/sec
        ModelParameters.Adhesion_DeActivationRate = 0.1; % events/sec
        ModelParameters.Adhesion_MolecularClutchOn = true;
        ModelParameters.MolecularClutch_PeakNumber = 1;
        ModelParameters.AdhesionSpringConstant = 0.5; % 10 (picoNewtons/nanometer)
        ModelParameters.AdhesionSpringEqLength = 2; % (nm) Adhesion spring equilibrium length
        ModelParameters.AdhesionGamma = 2.16e-5; % pN s/nm    gamma = k_B T/D  where D = 1.9e5 nm^2 /s

        
%% Membrane properties
      
        ModelParameters.BrownianRatchetOn = true;
        ModelParameters.MembraneWidth = 500; % nm
        ModelParameters.ModelDepth = 500; % nm
        ModelParameters.MembraneRadius = 50; % nm
        
        
        % Membrane velocity is calculated in "CalculatePositionAfterAppliedForces"
%             Nu = ModelParameters.CytoplasmViscosity*(10^-6); % pN s/nm^2
%             L  = ModelParameters.MembraneWidth; % membrane width in nm
%             r  = 2.7; % nm
%         ModelParameters.MembraneGamma = (4*pi*Nu*L) / (0.84+log(L/(2*r) )); % gamma for random fluid motion (pN*s/nm) 
        

%% Filament properties
 
        ModelParameters.StartingNumberOfFilaments = 100;
        ModelParameters.FilamentThermalMotionOn = false;
        ModelParameters.FilamentsInitialLength = round(300/2.75); %round(0.5*(15/2.7)*15); % Ave Number of monomers in an initialized filament
        ModelParameters.VerticalOffSet = -200; % (nm) % the tips of new filaments are randomly initiated between the membrane and the vertical offset
        ModelParameters.MonomerLength = 2.75; % 2.7; (nm)       
        ModelParameters.MaximumFilamentMass = 4000; % total monomers; % (units of nMonomers) Threshold for adding new filaments to model
        ModelParameters.k_off_pointed = 7; % 12; %6.5; %13; (s^-1)
        ModelParameters.k_on_barbed = 11; % s^(-1) uM^(-1)  http://cytomorpholab.com/wp-content/uploads/2021/11/publication_1-23.pdf (table 2)
        ModelParameters.FreeMonomerMolarity = 15; % uM
        ModelParameters.k_cap = 3;     % (s^-1)
        ModelParameters.k_uncap = 1.5; % (s^-1)
        ModelParameters.k_branch = 2.2;% 0.5; % (s^-1)
        ModelParameters.branchWindowSize = 15; % (nm)
        ModelParameters.branchAngle = 70;
        ModelParameters.branchAngleSTD = 10;      % Standard deviation of branching angle in degrees
        ModelParameters.MinimumBranchSeparation = 50; % nm
        ModelParameters.PersistenceLength = 1000; % (nm) Persistence length of actin filament (17.7 um)

        
%% Substrate properties
        
        ModelParameters.SubstrateTypeElastic = true;
        ModelParameters.SubstrateSpringConstant = 0.01; %0.01; % pN/nm 
        ModelParameters.Substrate.Ycoords = 0;
        ModelParameters.YPrev = 0;
        ModelParameters.ForceonSubstrate = 0;
        ModelParameters.Ka = 1;
        ModelParameters.Kl = 1;
        ModelParameters.Nu = 1e2;
        ModelParameters.k_c = 0.5;

        ModelParameters.k_s_local  = 1;  % pN/nm
        ModelParameters.k_s_global = 1;   % pN/nm
        ModelParameters.SubstrateSpringConstant = ModelParameters.k_s_global;
        ModelParameters.Substrate.Ycoords = 0;
        ModelParameters.YPrev = 0;
        ModelParameters.SubstrateGamma = 0.1;   % pN·s/nm (your dashpot ³)

        ModelParameters.Ka = ModelParameters.k_c;        
        ModelParameters.Kl = ModelParameters.k_s_local;  
        ModelParameters.Nu = 1e2;                      
        
        
           
