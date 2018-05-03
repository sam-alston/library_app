-- These scripts are intended to insert area, areas_in_layout and area_vertices entities into hsu_library schema
-- This is the Main lobby (Area 1, Floor 1)
INSERT INTO `hsu_library`.`layout`
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

INSERT INTO `hsu_library`.`layout`
(AUTHOR, FLOOR, DATE_CREATED)
VALUES
('SRA', 2, NOW());

-- This is the Quiet Study Area (Area 5, Floor 2)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Quiet Study", "LIB 201");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(5, 2);

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
(6, 2);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (6, 191.25, 340, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (6, 230, 340.25, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (6, 229.75, 302, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (6, 223.5, 301.75, 3);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (6, 223, 234.25, 4);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (6, 257.5, 234.75, 5);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (6, 256.25, 190.5, 6);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (6, 191.125, 190.25, 7);


-- This is the West Window Group Study Area (Area 7, Floor 2)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("West Window Group Study", "LIB 201");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(7, 2);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (7, 257.125, 213.625, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (7, 257.125, 240.625, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (7, 349.125, 240.625, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (7, 349.125, 213.625, 3);


-- This is the Collaboration Lab(Area 8, Floor 2)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Collaboration Lab", "LIB 201");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(8, 2);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (8, 257, 190.875, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (8, 257, 213.875, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (8, 349.25, 213.875, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (8, 349.25, 190.875, 3);


-- This is the Whiteboard Group Study Area(Area 9, Floor 2)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Whiteboard Group Study", "LIB 201");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(9, 2);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (9, 256.25, 105.25, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (9, 256.25, 191, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (9, 442.75, 191, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (9, 442.75, 105.25, 3);


-- This is the Children's Literature Group Study(Area 10, Floor 2)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Children's Literature Group Study", "LIB 201");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(10, 2);

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
(11, 2);

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
(12, 2);

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

INSERT INTO `hsu_library`.`layout`
(AUTHOR, FLOOR, DATE_CREATED)
VALUES
('SRA', 3, NOW());


-- This is the Quiet Area (Area 13, Floor 3)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Quiet Study", "LIB 301");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(13, 3);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (13, 172, 327, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (13, 173, 298, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (13, 75, 299, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (13, 75, 74.5, 3);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (13, 204, 75, 4);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (13, 204, 55.25, 5);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (13, 47.75, 54.75, 6);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (13, 48, 325, 7);


-- This is the Scholars Runway (Area 14, Floor 3)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Scholars Runway", "LIB 303");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(14, 3);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (14, 312.5, 59, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (14, 312, 132.5, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (14, 470, 131.5, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (14, 468.75, 60.25, 3);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (14, 494, 60.25, 4);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (14, 494.5, 167, 5);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (14, 278, 166.5, 6);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (14, 277.5, 60.5, 7);


-- This is the Special Collections (Area 15, Floor 3)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Special Collections", "LIB 303");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(15, 3);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (15, 312.25, 59.5, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (15, 312.25, 132, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (15, 420.25, 132, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (15, 420.25, 59.5, 3);


-- This is the Scholars Lab (Area 16, Floor 3)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Scholars Lab", "LIB 301");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(16, 3);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (16, 275.75, 166.75, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (16, 275.75, 209.25, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (16, 400, 209.25, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (16, 400, 166.75, 3);


-- This is the Social Group Study (Area 17, Floor 3)
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Social Group Study", "LIB 301");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(17, 3);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (17, 170.25, 278, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (17, 240.25, 278.25, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (17, 239.75, 184.25, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (17, 275.5, 184.5, 3);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (17, 276.5, 167.25, 4);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (17, 74.75, 167, 5);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (17, 75.5, 203.25, 6);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (17, 206.5, 202.75, 7);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (17, 206, 252.75, 8);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (17, 170, 252.75, 9);

-- This is the Digital Media Lab
INSERT INTO `hsu_library`.`area`
(`name`, `facilities_id`)
values("Digital Media Lab", "LIB 120");

INSERT INTO `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(18, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(18, 119, 191.75, 1);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(18, 119, 242.25, 2);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(18, 139.6, 242.25, 3);

insert into `hsu_library`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(18, 139.6, 191.75, 4);

-- areas for rooms
INSERT INTO `hsu_library`.`area`
(`name`, `facilities_id`)
values("Lecture Room", "LIB 114");

INSERT INTO `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(19, 1);

INSERT INTO `hsu_library`.`area`
(`name`, `facilities_id`)
values("Group Study", "LIB 115");

INSERT INTO `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(20, 1);

INSERT INTO `hsu_library`.`area`
(`name`, `facilities_id`)
values("Group Study", "LIB 116");

INSERT INTO `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(21, 1);

INSERT INTO `hsu_library`.`area`
(`name`, `facilities_id`)
values("Group Study", "LIB 117");

INSERT INTO `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(22, 1);

INSERT INTO `hsu_library`.`area`
(`name`, `facilities_id`)
values("Computer Lab", "LIB 121");

INSERT INTO `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(23, 1);

INSERT INTO `hsu_library`.`area`
(`name`, `facilities_id`)
values("Computer Lab", "LIB 122");

INSERT INTO `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(24, 1);

INSERT INTO `hsu_library`.`area`
(`name`, `facilities_id`)
values("Library Conference and Training", "LIB 118");

INSERT INTO `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(25, 1);

-- Room 205
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Collaboration Lab", "LIB 205");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(26, 2);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (26, 355.5, 202, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (26, 355.5, 227.75, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (26, 387.5, 227.75, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (26, 387.5, 202, 3);

-- MF Area
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Micro-Film Area", "LIB 201");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(27, 2);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (27, 387.25, 191.25, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (27, 387.25, 242.75, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (27, 453.75, 242.75, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (27, 453.75, 191.25, 3);

-- CTL Classroom
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("CTL Classroom", "LIB 301");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(28, 3);

insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Room 309", "LIB 309");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(29, 3);

insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Room 306", "LIB 306");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(30, 3);

-- Math Lab 2nd floor
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Math Tutorial Lab", "LIB 208");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(31, 2);

-- Fishbowl
insert into `hsu_library`.`area`
(`name`, `facilities_id`)
values
("Fishbowl", "LIB 209");

insert into `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
values
(32, 2);