# power_flow_test_systems
JSON-formatted versions of the MATPOWER test networks.

MATPOWER includes a bunch of [useful test networks](https://github.com/MATPOWER/matpower/tree/master/data), but they're all stored as `.m` files (basically, MATLAB functions that return the data for each test system). These files were generated from the original IEEE common data format for these test cases, but that format is pretty opaque. This project aims to convert the `.m` data from MATPOWER and make it available in the JSON format.

The JSON data files are organized as follows (based on the formatting in the [MATPOWER repo](https://github.com/MATPOWER/matpower/blob/master/lib/caseformat.m)). Fields marked `...` are lists or nested lists where the leading axis corresponds to the number of components of that type (so `bus -> type` is a list of bus types where the leading axis corresponds to the different buses).
```json
{
    "version": 2, // the MATPOWER case version
    "bus": {  // bus data
        "i": ...,  // bus indices
        "type": ...,  // bus types (1 = PQ, 2 = PV, 3 = reference, 4 = isolated)
        "PD": ...,  // real power demand (MW)
        "QD": ...,  // reactive power demand (MW)
        "GS": ...,  // shunt conductance (MW demanded at V = 1.0 p.u.)
        "BS": ...,  // shunt reactance (MVAr demanded at V = 1.0 p.u.)
        "BUS_AREA": ...,  // area number
        "VM": ...,  // voltage magnitude (p.u.)
        "VA": ...,  // voltage angle (degrees)
        "BASE_KV": ...,  // base voltage (kV)
        "ZONE": ...,  // loss zone
        "VMAX": ...,  // maximum voltage magnitude (p.u.)
        "VMIN": ...  // minimum voltage magnitude (p.u.)
    },
    "gen": {  // generator data
        "bus": ...,  // bus number
        "PG": ...,  // real power output (MW)
        "QG": ...,  // reactive power output (MVAr)
        "QMAX": ...,  // maximum reactive power output (MVAr)
        "QMIN": ...,  // minimum reactive power output (MVAr)
        "VG": ...,  // voltage magnitude setpoint (p.u.)
        "MBASE": ...,  // total MVA base of machine (defaults to baseMVA)
        "GEN_STATUS": ...,  // status (> 0 -> in service, <= 0 -> out of service)
        "PMAX": ...,  // maximum real power output (MW)
        "PMIN": ...,  // minimum real power output (MW)
        "PC1": ...,  // lower real power output of PQ capability curve (MW)
        "PC2": ...,  // upper real power output of PQ capability curve (MW)
        "QC1MIN": ...,  // minimum reactive power output at Pc1 (MVAr)
        "QC1MAX": ...,  // maximum reactive power output at Pc1 (MVAr)
        "QC2MIN": ...,  // minimum reactive power output at Pc2 (MVAr)
        "QC2MAX": ...,  // maximum reactive power output at Pc2 (MVAr)
        "RAMP_AGC": ...,  // ramp rate for load following/AGC (MW/min)
        "RAMP_10": ...,  // ramp rate for 10 minute reserves (MW)
        "RAMP_30": ...,  // ramp rate for 30 minute reserves (MW)
        "RAMP_Q": ...,  // ramp rate for reactive power (2 sec timescale) (MVAr/min)
        "APF": ...,  // area participation factor
        "cost_model": ...,  // cost model, 1 = piecewise linear, 2 = polynomial
        "STARTUP": ...,  // startup cost in US dollars
        "SHUTDOWN": ...,  // shutdown cost in US dollars
        "NCOST": ...,  // number of cost model coefficients to follow
        "coeffs": ...,  // coefficients of cost model (see [MATPOWER docs](https://github.com/MATPOWER/matpower/blob/master/lib/idx_cost.m))
    },
    "branch": {  // branch data
        "from": ...,  // from bus idx
        "to": ...,  // to bus idx
        "BR_R": ...,  // r, resistance (p.u.)
        "BR_X": ...,  // x, reactance (p.u.)
        "BR_B": ...,  // b, total line charging susceptance (p.u.)
        "RATE_A": ...,  // rateA, MVA rating A (long term rating)
        "RATE_B": ...,  // rateB, MVA rating B (short term rating)
        "RATE_C": ...,  // rateC, MVA rating C (emergency rating)
        "TAP": ...,  // ratio, transformer off nominal turns ratio
        "SHIFT": ...,  // angle, transformer phase shift angle (degrees)
        "BR_STATUS": ...,  // initial branch status, 1 - in service, 0 - out of service
        "ANGMIN": ...,  // minimum angle difference, angle(Vf) - angle(Vt) (degrees). Unconstrained if both ANGMIN and ANGMAX are 0
        "ANGMAX": ...  // maximum angle difference, angle(Vf) - angle(Vt) (degrees). Unconstrained if both ANGMIN and ANGMAX are 0
    }
}
```
