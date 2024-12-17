#YunZhan_Zhou_zhouy407_1009948933
#Alex_Mamoukarys_mamoukar_1010125703

# Define sets
set PM_product_num; # Shoe type index
set RM_num; # Raw material type index
set MM_machine_num; # Machine number index
set WM_warehouse_num; # Warehouse number index
set machine_numbers := 1..165;

# Define parameters
param PM_sales_price{PM_product_num}; # Sales price of each shoe type
param BOM_quantity{PM_product_num, RM_num} default 0; # Quantity of raw material type needed for each shoe type
param RM_cost{RM_num}; # Raw material costs
param demand = 440; # Estimated demand for every shoe type - computed in Excel
param MM_operating_cost_per_min{MM_machine_num} default 0; # Operating cost for each machine
param MA_avg_duration{PM_product_num, MM_machine_num} default 0; # Average duration of each machine for each shoe type
param WM_capacity{WM_warehouse_num}; # Capacity of each warehouse
param RM_s_quantity{RM_num}; # Available quantity of each raw material for purchase

# Decision variables
var x{PM_product_num} >= 0; # Number of shoes of type i sold

# Objective function components
var sale_profit = sum{i in PM_product_num} x[i] * PM_sales_price[i];
var raw_material_cost = sum{i in PM_product_num} x[i] * sum{j in RM_num} RM_cost[j] * BOM_quantity[i, j];
var demand_cost = 10 * sum{i in PM_product_num} max(0, demand - x[i]);
var machine_operation_cost = sum{i in PM_product_num} x[i] * sum{j in MM_machine_num} MM_operating_cost_per_min[j] * MA_avg_duration[i, j];
var labour_cost = 25 * sum{i in PM_product_num} x[i] * sum{j in MM_machine_num} MA_avg_duration[i, j] / 3600;

# Objective function
maximize profit: sale_profit - raw_material_cost - demand_cost - machine_operation_cost - labour_cost;

# Constraints
subject to raw_materials: sum{i in PM_product_num} x[i] * sum{j in RM_num} RM_cost[j] * BOM_quantity[i, j] <= 10000000;
subject to warehouse_capacity: sum{i in PM_product_num} x[i] <= sum{j in WM_warehouse_num} WM_capacity[j];
subject to available_quantity{j in RM_num}: sum{i in PM_product_num} x[i] * BOM_quantity[i, j] <= RM_s_quantity[j];
subject to available_operating_time{j in MM_machine_num}: sum{i in PM_product_num} x[i] * MA_avg_duration[i, j] <= 336*60*60;