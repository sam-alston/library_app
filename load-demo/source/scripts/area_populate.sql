-- These scripts are intended to insert area, areas_in_layout and area_vertices entities into hsu_library schema
-- This is the Main lobby (Area 1, Floor 1)
INSERT INTO LAYOUT
(AUTHOR, FLOOR, DATE_CREATED)
VALUES
('SRA', 1, NOW());

insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Main Lobby", "LIB 102");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(1, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values 
(1, 75, 257, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(1, 75, 322, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(1, 189, 322, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(1, 189, 257, 4);


-- This is the Cafe (Area 2, Floor 1)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Cafe", "LIB 101A");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(2, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(2, 200, 258, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(2, 200, 291, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(2, 189, 297, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(2, 189, 315, 4);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(2, 200, 323, 5);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(2, 200, 356, 6);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(2, 240, 356, 7);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(2, 240, 258, 8);


-- This is the Learning Center and Tutoring Area (Area 3, Floor 1)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Learning Center and Tutoring Area", "LIB 101");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(3, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(3, 269, 191, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(3, 338, 191, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(3, 338, 56, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(3, 269, 56, 4);


-- This is the Computer Lab (Area 4, Floor 1)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Computer Lab", "LIB 101");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(4, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 170, 126, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 140, 126, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 140, 192, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 205, 192, 4);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 205, 258, 5);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 235, 258, 6);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 235, 224, 7);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 269, 224, 8);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 269, 56, 9);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 170, 56, 10);


-- This is the Quiet Study Area (Area 5, Floor 2)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Quiet Study", "LIB 201");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(5, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 101, 61, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 101, 94, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 105.5, 94, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 105.5, 126.5, 4);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 101, 126.5, 5);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 101, 159.2, 6);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 105.5, 159.2, 7);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 105.5, 191, 8);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 115, 191, 9);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 115, 75, 10);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 319, 75, 11);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 319, 191, 12);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 334, 191, 13);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 334, 159.2, 14);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 339, 159.2, 15);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 339, 126.6, 16);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 334, 126.6, 17);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 334, 57, 18);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 301.5, 57, 19);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 301.5, 61.3, 20);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 268.9, 61.3, 21);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 268.9, 57, 22);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 236.2, 57, 23);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 236.2, 61.3, 24);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 203.4, 61.3, 25);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 203.4, 57, 26);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 170.7, 57, 27);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 170.7, 61, 28);


-- This is the SW Group Study (Area 6, Floor 2)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("SW Group Study", "LIB 201");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(6, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(6, 206, 191, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(6, 206, 223, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(6, 302, 223, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(6, 302, 229, 4);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(6, 333, 229, 5);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(6, 333, 224, 6);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(6, 338, 224, 7);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(6, 338, 191, 8);


-- This is the West Window Group Study Area (Area 7, Floor 2)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("West Window Group Study", "LIB 201");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(7, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(7, 205, 349, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(7, 240, 349, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(7, 240, 257, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(7, 205, 257, 4);


-- This is the Collaboration Lab(Area 8, Floor 2)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Collaboration Lab", "LIB 201");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(8, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(8, 205, 257, 5);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(8, 191, 257, 6);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(8, 191, 354, 7);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(8, 205, 354, 8);


-- This is the Whiteboard Group Study Area(Area 9, Floor 2)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Whiteboard Group Study", "LIB 201");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(9, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(9, 191, 265, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(9, 152, 265, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(9, 152, 440, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(9, 191, 440, 4);


-- This is the Children's Literature Group Study(Area 10, Floor 2)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Children's Literature Group Study", "LIB 201");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(10, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 281, 454, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 281, 484, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 286, 484, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 286, 497, 4);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 280, 497, 5);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 280, 502, 6);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 268, 502, 7);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 268, 497, 8);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 236, 497, 9);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 236, 502, 10);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 203, 502, 11);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 203, 454, 12);


-- This is the Helen Everett Reading Room Group Study Area (Area 11, Floor 2)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Helen Everett Reading Room Group Study", "LIB 201");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(11, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(11, 60, 497, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(11, 60, 502, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(11, 203, 502, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(11, 203, 461, 4);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(11, 96, 461, 5);


-- This is the HSU Authors Hall Group Study(Area 12, Floor 2)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("HSU Authors Hall Group Study", "LIB 201");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(12, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(12, 60, 497, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(12, 55, 497, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(12, 55, 258, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(12, 104, 258, 4);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(12, 104, 443, 5);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(12, 96, 443, 6);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(12, 96, 461, 7);


-- This is the Quiet Area (Area 13, Floor 3)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Quiet Study", "LIB 301");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(13, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(13, 61, 61, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(13, 61, 204, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(13, 75, 204, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(13, 75, 75, 4);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(13, 298, 75, 5);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(13, 298, 170, 6);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(13, 312, 170, 7);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(13, 312, 61, 8);


-- This is the Scholars Runway (Area 14, Floor 3)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Scholars Runway", "LIB 307");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(14, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(14, 167, 227, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(14, 60, 276, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(14, 60, 298, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(14, 141, 298, 4);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(14, 141, 468, 5);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(14, 97, 468, 6);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(14, 97, 494, 7);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(14, 167, 494, 8);


-- This is the Special Collections (Area 15, Floor 3)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Special Collections", "LIB 307");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(15, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(15, 60, 298, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(15, 141, 298, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(15, 141, 421, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(15, 60, 421, 4);


-- This is the Scholars Lab (Area 16, Floor 3)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Scholars Lab", "LIB 301");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(16, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(16, 167, 277, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(16, 167, 400, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(16, 194, 400, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(16, 194, 385, 4);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(16, 209, 385, 5);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(16, 209, 277, 6);


-- This is the Social Group Study (Area 17, Floor 3)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Social Group Study", "LIB 301");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(17, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(17, 171, 240, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(17, 171, 75, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(17, 197, 75, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(17, 197, 215, 4);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(17, 250, 215, 5);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(17, 250, 170, 6);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(17, 276, 170, 7);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(17, 276, 240, 8);
