# Load order of scripts

In order to get the load-demo working, load the scripts to local DB in this order:

1. room_populate.sql
2. area_populate.sql
3. furniture_type_populate.sql
4. furniture_L1.sql

(1) ROOM_POPULATE.SQL
  Contains the insert statments for room.

(2) AREA_POPULATE.SQL
  Contains the insert statements for layout, area, area_in_layout, and area_vertices for layout 1.
  
(3) FURNITURE_TYPE_POPULATE.SQL
  Contains the insert statements for furniture types.

(4) FURNITURE_L1.SQL
  Contains the insert statements for furniture in floor 1 layout 1.
