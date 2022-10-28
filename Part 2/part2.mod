set EDGE;	
set FLOW;
set STATION;
set PEOPLE;

param cost {x in EDGE};
param station_possible {p in PEOPLE, s in STATION};
param oil_price {x in EDGE};
param bus_price {x in EDGE};
param bus_cap;
param available_buses;

var units_x {x in EDGE}, binary; 
var units_f {f in FLOW} >=0;
var units_p {p in PEOPLE, s in STATION}, binary;

minimize total_cost : sum{x in EDGE} ((cost[x]*units_x[x]*oil_price[x])+(units_x[x]*bus_price[x]));

s.t. routes_upper_limit : units_x['X01']+units_x['X02']+units_x['X03'] <= available_buses;
s.t. routes_with_start_exit : units_x['X01']+units_x['X02']+units_x['X03'] = 
				units_x['X14']+units_x['X24']+units_x['X34'];

s.t. s1_single_entrance : units_x['X01']+units_x['X21']+units_x['X31'] = 1;
s.t. s2_single_entrance : units_x['X02']+units_x['X12']+units_x['X32'] = 1;
s.t. s3_single_entrance : units_x['X03']+units_x['X13']+units_x['X23'] = 1;
s.t. s1_single_exit : units_x['X12']+units_x['X13']+units_x['X14'] = 1;
s.t. s2_single_exit : units_x['X21']+units_x['X23']+units_x['X24'] = 1;
s.t. s3_single_exit : units_x['X31']+units_x['X32']+units_x['X34'] = 1;


s.t. siblings_together_1 {s in STATION} : units_p['A4',s] = units_p['A5',s];

s.t. stations_less_than_5 {s in STATION} : sum{p in PEOPLE} units_p[p,s] <= bus_cap; 

s.t. people_only_one_station {p in PEOPLE}: sum{s in STATION} units_p[p,s] = 1; 

s.t. people_within_possible_stations {p in PEOPLE, s in STATION}: station_possible[p,s] >= units_p[p,s];

s.t. flow_s1_to_s2_less_than_bus_limit_if_route : units_f['P12'] / bus_cap <= units_x['X12'];
s.t. flow_s1_to_s3_less_than_bus_limit_if_route : units_f['P13'] / bus_cap <= units_x['X13'];
s.t. flow_s1_to_s4_less_than_bus_limit_if_route : units_f['P14'] / bus_cap <= units_x['X14'];

s.t. flow_s2_to_s1_less_than_bus_limit_if_route : units_f['P21'] / bus_cap <= units_x['X21'];
s.t. flow_s2_to_s3_less_than_bus_limit_if_route : units_f['P23'] / bus_cap <= units_x['X23'];
s.t. flow_s2_to_s4_less_than_bus_limit_if_route : units_f['P24'] / bus_cap <= units_x['X24'];

s.t. flow_s3_to_s1_less_than_bus_limit_if_route : units_f['P31'] / bus_cap <= units_x['X31'];
s.t. flow_s3_to_s2_less_than_bus_limit_if_route : units_f['P32'] / bus_cap <= units_x['X32'];
s.t. flow_s3_to_s4_less_than_bus_limit_if_route : units_f['P34'] / bus_cap <= units_x['X34'];

s.t. flow_from_s1_equal_flow_to_s1_and_s1_people : units_f['P12']+units_f['P13']+units_f['P14'] = 
						units_f['P21']+units_f['P31']+  							sum{p in PEOPLE} units_p[p,'S1'];
						
s.t. flow_from_s2_equal_flow_to_s2_and_s2_people : units_f['P21']+units_f['P23']+units_f['P24'] = 
						units_f['P12']+units_f['P32']+ 						sum{p in PEOPLE} units_p[p,'S2'];
						
s.t. flow_from_s3_equal_flow_to_s3_and_s3_people : units_f['P31']+units_f['P32']+units_f['P34'] = 
						units_f['P13']+units_f['P23']+ 						sum{p in PEOPLE} units_p[p,'S3'];


end;
