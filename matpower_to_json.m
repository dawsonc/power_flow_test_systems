%% Load all of the matpower network test cases (which are specified as .m files) and
%% re-export as a json. Note that running this will take a bunch of memory.
clear all;

% Add matpower to the path
addpath("../matpower")
addpath("../matpower/data")
addpath("../matpower/lib")

% Get a list of all matpower networks to export
network_files = dir("../matpower/data");

% Go through each file
for i = 1:numel(network_files)
    network_file_name = network_files(i).name;
    if length(network_file_name) > 2 && network_file_name(end-1:end) == ".m"
        % Load the case
        case_name = network_file_name(1:end-2);
        fprintf("Loading case: %s\n", case_name)

        % Run the case function to get the data
        clear network network_original
        network_original = eval(case_name);

        % Extract the relevant data (skip the case if it doesn't have all the fields
        % we want)
        [PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
            VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;
        [F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, RATE_C, ...
            TAP, SHIFT, BR_STATUS, PF, QF, PT, QT, MU_SF, MU_ST, ...
            ANGMIN, ANGMAX, MU_ANGMIN, MU_ANGMAX] = idx_brch;
        [GEN_BUS, PG, QG, QMAX, QMIN, VG, MBASE, GEN_STATUS, PMAX, PMIN, ...
            MU_PMAX, MU_PMIN, MU_QMAX, MU_QMIN, PC1, PC2, QC1MIN, QC1MAX, ...
            QC2MIN, QC2MAX, RAMP_AGC, RAMP_10, RAMP_30, RAMP_Q, APF] = idx_gen;
        [PW_LINEAR, POLYNOMIAL, MODEL, STARTUP, SHUTDOWN, NCOST, COST] = idx_cost;

        try
            % Logistics
            network.version = network_original.version;
            network.baseMVA = network_original.baseMVA;
            
            % Bus info
            network.bus.i = network_original.bus(:, BUS_I);
            network.bus.type = network_original.bus(:, BUS_TYPE);
            network.bus.PD = network_original.bus(:, PD);
            network.bus.QD = network_original.bus(:, QD);
            network.bus.GS = network_original.bus(:, GS);
            network.bus.BS = network_original.bus(:, BS);
            network.bus.BUS_AREA = network_original.bus(:, BUS_AREA);
            network.bus.VM = network_original.bus(:, VM);
            network.bus.VA = network_original.bus(:, VA);
            network.bus.BASE_KV = network_original.bus(:, BASE_KV);
            network.bus.ZONE = network_original.bus(:, ZONE);
            network.bus.VMAX = network_original.bus(:, VMAX);
            network.bus.VMIN = network_original.bus(:, VMIN);
            
            % Generator info
            network.gen.bus = network_original.gen(:, GEN_BUS);
            network.gen.PG = network_original.gen(:, PG);
            network.gen.QG = network_original.gen(:, QG);
            network.gen.QMAX = network_original.gen(:, QMAX);
            network.gen.QMIN = network_original.gen(:, QMIN);
            network.gen.VG = network_original.gen(:, VG);
            network.gen.MBASE = network_original.gen(:, MBASE);
            network.gen.GEN_STATUS = network_original.gen(:, GEN_STATUS);
            network.gen.PMAX = network_original.gen(:, PMAX);
            network.gen.PMIN = network_original.gen(:, PMIN);
            network.gen.PC1 = network_original.gen(:, PC1);
            network.gen.PC2 = network_original.gen(:, PC2);
            network.gen.QC1MIN = network_original.gen(:, QC1MIN);
            network.gen.QC1MAX = network_original.gen(:, QC1MAX);
            network.gen.QC2MIN = network_original.gen(:, QC2MIN);
            network.gen.QC2MAX = network_original.gen(:, QC2MAX);
            network.gen.RAMP_AGC = network_original.gen(:, RAMP_AGC);
            network.gen.RAMP_10 = network_original.gen(:, RAMP_10);
            network.gen.RAMP_30 = network_original.gen(:, RAMP_30);
            network.gen.RAMP_Q = network_original.gen(:, RAMP_Q);
            network.gen.APF = network_original.gen(:, APF);
            network.gen.cost_model = network_original.gencost(:, MODEL);
            network.gen.STARTUP = network_original.gencost(:, STARTUP);
            network.gen.SHUTDOWN = network_original.gencost(:, SHUTDOWN);
            network.gen.NCOST = network_original.gencost(:, NCOST);
            network.gen.coeffs = network_original.gencost(:, NCOST+1:end);

            % Branch info
            network.branch.from = network_original.branch(:, F_BUS);
            network.branch.to = network_original.branch(:, T_BUS);
            network.branch.BR_R = network_original.branch(:, BR_R);
            network.branch.BR_X = network_original.branch(:, BR_X);
            network.branch.BR_B = network_original.branch(:, BR_B);
            network.branch.RATE_A = network_original.branch(:, RATE_A);
            network.branch.RATE_B = network_original.branch(:, RATE_B);
            network.branch.RATE_C = network_original.branch(:, RATE_C);
            network.branch.TAP = network_original.branch(:, TAP);
            network.branch.SHIFT = network_original.branch(:, SHIFT);
            network.branch.BR_STATUS = network_original.branch(:, BR_STATUS);
            network.branch.ANGMIN = network_original.branch(:, ANGMIN);
            network.branch.ANGMAX = network_original.branch(:, ANGMAX);

            % Save the case to a json
            fileID = fopen(cat(2, 'test_cases/', case_name, '.json'),'w');
            fprintf(fileID, jsonencode(network), PrettyPrint=true);
        catch err
            fprintf("[ERROR]: Unable to load case %s, err %s\n", case_name, err.message)
        end
    end
end
