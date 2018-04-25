-- These scripts implement the tables for hsu_library schema
-- Last modified: 4/9/18
DROP SCHEMA `hsulibra_space_app` ;
CREATE SCHEMA `hsulibra_space_app` ;

CREATE TABLE `hsulibra_space_app`.`furniture_type` (
  `furniture_type_id` INT NOT NULL AUTO_INCREMENT,
  `furniture_name` VARCHAR(45) NOT NULL,
  `number_of_seats` INT NULL,
  PRIMARY KEY (`furniture_type_id`),
  UNIQUE INDEX `furniture_name_UNIQUE` (`furniture_name` ASC))
COMMENT = 'Contains the types of furniture such as tables and chairs, also stores their max number of seats.';

CREATE TABLE `hsulibra_space_app`.`room` (
  `facilities_id` VARCHAR(10) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`facilities_id`))
COMMENT = 'Rooms are identified by a facilities id which is unique to the campus, and the also have a human readable name.';

CREATE TABLE `hsulibra_space_app`.`layout` (
  `layout_id` INT NOT NULL AUTO_INCREMENT,
  `author` VARCHAR(45) NOT NULL,
  `floor` INT NOT NULL,
  `date_created` DATETIME NULL,
  PRIMARY KEY (`layout_id`))
COMMENT = 'Layouts are the entities that unify which objects are on a certain floor, they also record the author and date of creation.';

CREATE TABLE `hsulibra_space_app`.`area` (
  `area_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `facilities_id` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`area_id`),
  INDEX `room_id_idx` (`facilities_id` ASC),
  CONSTRAINT `room_id_fk`
    FOREIGN KEY (`facilities_id`)
    REFERENCES `hsulibra_space_app`.`room` (`facilities_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'All the spaces on a layout are made up of areas. They have an ID, a human name that defaults to a room name if there is no sub area, the room id, and a layout.';

CREATE TABLE `hsulibra_space_app`.`area_in_layout` (
  `area_id` INT NOT NULL,
  `layout_id` INT NULL,
  PRIMARY KEY (`area_id`),
  INDEX `layout_AL_fk_idx` (`layout_id` ASC),
  CONSTRAINT `area_AL_fk`
    FOREIGN KEY (`area_id`)
    REFERENCES `hsulibra_space_app`.`area` (`area_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `layout_AL_fk`
    FOREIGN KEY (`layout_id`)
    REFERENCES `hsulibra_space_app`.`layout` (`layout_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Areas might not change with each new layout, so areas and layouts are a many-to-many relationship.';

CREATE TABLE `hsulibra_space_app`.`furniture` (
  `furniture_id` INT NOT NULL AUTO_INCREMENT,
  `x_location` FLOAT NOT NULL,
  `y_location` FLOAT NOT NULL,
  `degree_offset` INT NOT NULL,
  `layout_id` INT NOT NULL,
  `furniture_type` INT NOT NULL,
  `default_seat_type` INT NULL,
  `in_area` INT NOT NULL,
  PRIMARY KEY (`furniture_id`),
  INDEX `layout_fk_idx` (`layout_id` ASC),
  INDEX `furniture_type_fk_idx` (`furniture_type` ASC),
  INDEX `default_seat_type_fk_idx` (`default_seat_type` ASC),
  INDEX `furniture_in_area_fk` (`in_area` ASC),
  CONSTRAINT `furniture_layout_fk`
    FOREIGN KEY (`layout_id`)
    REFERENCES `hsulibra_space_app`.`layout` (`layout_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `furniture_type_fk`
    FOREIGN KEY (`furniture_type`)
    REFERENCES `hsulibra_space_app`.`furniture_type` (`furniture_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `default_seat_type_fk`
    FOREIGN KEY (`default_seat_type`)
    REFERENCES `hsulibra_space_app`.`furniture_type` (`furniture_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `furniture_in_area_fk`
	FOREIGN KEY (`in_area`)
	REFERENCES `hsulibra_space_app`.`area` (`area_id`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION)
COMMENT = 'Furniture refers to non seat items that are given a layout x and y coordinate, a type of furniture, and contain the default seat type.';

CREATE TABLE `hsulibra_space_app`.`area_vertices` (
  `area_id` INT NOT NULL,
  `v_y` INT NOT NULL,
  `v_x` INT NOT NULL,
  `load_order` int NOT NULL,
  PRIMARY KEY (`area_id`, `v_y`, `v_x`),
  CONSTRAINT `area_id_fk`
    FOREIGN KEY (`area_id`)
    REFERENCES `hsulibra_space_app`.`area` (`area_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Areas are able to be complex geometric shapes, so there are a minimum but no maximum number of vertice pairs for each area.';

CREATE TABLE `hsulibra_space_app`.`activity` (
  `activity_id` INT NOT NULL AUTO_INCREMENT,
  `activity_description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`activity_id`))
COMMENT = 'An activity is anything that should be tracked by a seat, so there is an ID and a descriptive label.';


CREATE TABLE `hsulibra_space_app`.`survey_record` (
  `survey_id` INT NOT NULL AUTO_INCREMENT,
  `surveyed_by` VARCHAR(45) NOT NULL,
  `layout_id` INT NOT NULL,
  `survey_date` DATETIME NOT NULL,
  PRIMARY KEY (`survey_id`),
  INDEX `layout_id_fk_idx` (`layout_id` ASC),
  CONSTRAINT `layout_id_fk`
    FOREIGN KEY (`layout_id`)
    REFERENCES `hsulibra_space_app`.`layout` (`layout_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Each record of a survey is commited by one author';


CREATE TABLE `hsulibra_space_app`.`survey_area_ratios` (
  `survey_id` INT NOT NULL,
  `area_id` INT NOT NULL,
  `area_use_ratio` FLOAT NULL,
  PRIMARY KEY (`survey_id`, `area_id`),
  INDEX `area_fk_idx` (`area_id` ASC),
  CONSTRAINT `survey_fk`
    FOREIGN KEY (`survey_id`)
    REFERENCES `hsulibra_space_app`.`survey_record` (`survey_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `area_fk`
    FOREIGN KEY (`area_id`)
    REFERENCES `hsulibra_space_app`.`area` (`area_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Each area has a default number of seats in it, divide that by number of occupied seats to get usage ratio of use. Each ratio is dependant on a survey ID and an area ID.';


CREATE TABLE `hsulibra_space_app`.`whiteboard` (
  `furniture_id` INT NOT NULL,
  `survey_id` INT NOT NULL,
  `use_type` INT NOT NULL,
  PRIMARY KEY (`furniture_id`, `survey_id`),
  INDEX `survey_fk_idx` (`survey_id` ASC),
  INDEX `use_fk_idx` (`use_type` ASC),
  CONSTRAINT `attached_to_fk`
    FOREIGN KEY (`furniture_id`)
    REFERENCES `hsulibra_space_app`.`furniture` (`furniture_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `survey_id_fk`
    FOREIGN KEY (`survey_id`)
    REFERENCES `hsulibra_space_app`.`survey_record` (`survey_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `use_fk`
    FOREIGN KEY (`use_type`)
    REFERENCES `hsulibra_space_app`.`activity` (`activity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Whiteboards are used for writing on or partitioning space. They are used by a piece of furniture, and are only entered on a per survey, per use instance.';

CREATE TABLE `hsulibra_space_app`.`modified_furniture` (
  `modified_furn_id` INT NOT NULL AUTO_INCREMENT,
  `furniture_id` INT NOT NULL,
  `new_x` FLOAT NOT NULL,
  `new_y` FLOAT NOT NULL,
  `degree_offset` INT NOT NULL,
  `survey_id` INT NOT NULL,
  `in_area` INT NOT NULL,
  PRIMARY KEY (`modified_furn_id`),
  INDEX `overwriting_furn_fk_idx` (`furniture_id` ASC),
  INDEX `survey_fk_idx` (`survey_id` ASC),
  INDEX `mfurniture_in_area_fk` (`in_area` ASC),
  CONSTRAINT `overwriting_furn_fk`
    FOREIGN KEY (`furniture_id`)
    REFERENCES `hsulibra_space_app`.`furniture` (`furniture_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `survey_mod_furn_fk`
    FOREIGN KEY (`survey_id`)
    REFERENCES `hsulibra_space_app`.`survey_record` (`survey_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `mfurniture_in_area_fk`
	FOREIGN KEY (`in_area`)
	REFERENCES `hsulibra_space_app`.`area` (`area_id`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION)
COMMENT = 'If a piece of furniture is temporarily moved, a survey can record where that piece was moved to without changing the layout.';


CREATE TABLE `hsulibra_space_app`.`seat` (
  `seat_id` INT NOT NULL AUTO_INCREMENT,
  `furniture_id` INT NOT NULL,
  `occupied` TINYINT NOT NULL COMMENT 'Boolean field, 0 is false, all others are true.',
  `seat_position` INT NULL,
  `seat_type` INT NOT NULL,
  `survey_id` INT NOT NULL,
  PRIMARY KEY (`seat_id`),
  INDEX `seat_attached_to_furn_fk_idx` (`furniture_id` ASC),
  INDEX `seat_type_fk_idx` (`seat_type` ASC),
  INDEX `survey_fk_idx` (`survey_id` ASC),
  CONSTRAINT `seat_attached_to_furn_fk`
    FOREIGN KEY (`furniture_id`)
    REFERENCES `hsulibra_space_app`.`furniture` (`furniture_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `seat_type_fk`
    FOREIGN KEY (`seat_type`)
    REFERENCES `hsulibra_space_app`.`furniture_type` (`furniture_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `survey_seat_fk`
    FOREIGN KEY (`survey_id`)
    REFERENCES `hsulibra_space_app`.`survey_record` (`survey_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Seats are the bases of recordings. They can be occupied or not, are attached to a specific piece of furniture (even if that piece of furniture is a seat) they also store which seat on the piece of furniture they are, what type of seat they are and are dependant on their record.';


CREATE TABLE `hsulibra_space_app`.`seat_has_activity` (
  `seat_id` INT NOT NULL,
  `activity_id` INT NOT NULL,
  PRIMARY KEY (`seat_id`, `activity_id`),
  INDEX `activity_fk_idx` (`activity_id` ASC),
  CONSTRAINT `seat_fk`
    FOREIGN KEY (`seat_id`)
    REFERENCES `hsulibra_space_app`.`seat` (`seat_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `activity_fk`
    FOREIGN KEY (`activity_id`)
    REFERENCES `hsulibra_space_app`.`activity` (`activity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Multiple activities may be associated with a seat, track which seat was performing which activities.';

CREATE TABLE `hsulibra_space_app`.`surveyed_room` (
  `furniture_id` INT NOT NULL,
  `total_occupants` INT NOT NULL,
  `survey_id` INT NOT NULL,
  PRIMARY KEY (`furniture_id`, `survey_id`),
  INDEX `room_furn_id_fk_idx` (`furniture_id` ASC),
  INDEX `survey_id_fk_idx` (`survey_id` ASC),
  CONSTRAINT `furn_room_id_fk`
    FOREIGN KEY (`furniture_id`)
    REFERENCES `hsulibra_space_app`.`furniture` (`furniture_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `room_survey_id_fk`
	FOREIGN KEY (`survey_id`)
	REFERENCES `hsulibra_space_app`.`survey_record` (`survey_id`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION)
COMMENT = 'The furniture room doesn\'t hold seat items, it holds a total number of people in the room.';

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 102", "Library Lobby & Circulation Desk");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 101A", "Library Cafe Lounge");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 101", "Library Open Stack Study");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 114", "Lecture");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 115", "Group Study");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 116", "Group Study");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 117", "Group Study");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 118", "Library Conference & Training");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 120", "Digital Media Lab");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 121", "Computer Lab");

-- These scripts are designed to insert the room entities to the hsu_library schema
-- Updated 4/9/18 -->
INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 122", "Computer Lab");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 201", "Open Library Collection");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 205", "Collaboration Lab");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 208", "Math Tutorial Lab");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 209", "Fishbowl");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 301", "Library Open Collection");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 303", "Special Collections");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 308", "Humboldt Room Archives");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 309", "Room 309");

INSERT INTO `hsulibra_space_app`.`room`
(FACILITIES_ID, NAME)
VALUES
("LIB 306", "Room 306");

-- These scripts are intended to insert area, areas_in_layout and area_vertices entities into hsu_library schema
-- This is the Main lobby (Area 1, Floor 1)
INSERT INTO `hsulibra_space_app`.`layout`
(AUTHOR, FLOOR, DATE_CREATED)
VALUES
('SRA', 1, NOW());

insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Main Lobby", "LIB 102");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(1, 1);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values 
(1, 75, 257, 1);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(1, 75, 322, 2);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(1, 189, 322, 3);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(1, 189, 257, 4);


-- This is the Cafe (Area 2, Floor 1)
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Cafe", "LIB 101A");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(2, 1);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(2, 200, 258, 1);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(2, 200, 291, 2);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(2, 189, 297, 3);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(2, 189, 315, 4);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(2, 200, 323, 5);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(2, 200, 356, 6);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(2, 240, 356, 7);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(2, 240, 258, 8);


-- This is the Learning Center and Tutoring Area (Area 3, Floor 1)
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Learning Center and Tutoring Area", "LIB 101");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(3, 1);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(3, 269, 191, 1);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(3, 338, 191, 2);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(3, 338, 56, 3);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(3, 269, 56, 4);


-- This is the Computer Lab (Area 4, Floor 1)
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Computer Lab", "LIB 101");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(4, 1);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 170, 126, 1);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 140, 126, 2);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 140, 192, 3);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 205, 192, 4);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 205, 258, 5);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 235, 258, 6);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 235, 224, 7);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 269, 224, 8);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 269, 56, 9);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(4, 170, 56, 10);

INSERT INTO `hsulibra_space_app`.`layout`
(AUTHOR, FLOOR, DATE_CREATED)
VALUES
('SRA', 2, NOW());

-- This is the Quiet Study Area (Area 5, Floor 2)
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Quiet Study", "LIB 201");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(5, 2);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 101, 61, 1);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 101, 94, 2);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 105.5, 94, 3);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 105.5, 126.5, 4);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 101, 126.5, 5);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 101, 159.2, 6);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 105.5, 159.2, 7);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 105.5, 191, 8);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 115, 191, 9);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 115, 75, 10);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 319, 75, 11);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 319, 191, 12);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 334, 191, 13);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 334, 159.2, 14);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 339, 159.2, 15);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 339, 126.6, 16);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 334, 126.6, 17);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 334, 57, 18);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 301.5, 57, 19);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 301.5, 61.3, 20);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 268.9, 61.3, 21);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 268.9, 57, 22);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 236.2, 57, 23);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 236.2, 61.3, 24);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 203.4, 61.3, 25);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 203.4, 57, 26);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 170.7, 57, 27);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(5, 170.7, 61, 28);


-- This is the SW Group Study (Area 6, Floor 2)
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("SW Group Study", "LIB 201");

insert into `hsulibra_space_app`.`area_in_layout`
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
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("West Window Group Study", "LIB 201");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(7, 2);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (7, 257.125, 213.625, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (7, 257.125, 240.625, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (7, 349.125, 240.625, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (7, 349.125, 213.625, 3);


-- This is the Collaboration Lab(Area 8, Floor 2)
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Collaboration Lab", "LIB 201");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(8, 2);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (8, 257, 190.875, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (8, 257, 213.875, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (8, 349.25, 213.875, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (8, 349.25, 190.875, 3);


-- This is the Whiteboard Group Study Area(Area 9, Floor 2)
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Whiteboard Group Study", "LIB 201");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(9, 2);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (9, 256.25, 105.25, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (9, 256.25, 191, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (9, 442.75, 191, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (9, 442.75, 105.25, 3);


-- This is the Children's Literature Group Study(Area 10, Floor 2)
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Children's Literature Group Study", "LIB 201");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(10, 2);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 281, 454, 1);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 281, 484, 2);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 286, 484, 3);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 286, 497, 4);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 280, 497, 5);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 280, 502, 6);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 268, 502, 7);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 268, 497, 8);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 236, 497, 9);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 236, 502, 10);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 203, 502, 11);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(10, 203, 454, 12);


-- This is the Helen Everett Reading Room Group Study Area (Area 11, Floor 2)
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Helen Everett Reading Room Group Study", "LIB 201");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(11, 2);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(11, 60, 497, 1);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(11, 60, 502, 2);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(11, 203, 502, 3);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(11, 203, 461, 4);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(11, 96, 461, 5);


-- This is the HSU Authors Hall Group Study(Area 12, Floor 2)
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("HSU Authors Hall Group Study", "LIB 201");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(12, 2);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(12, 60, 497, 1);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(12, 55, 497, 2);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(12, 55, 258, 3);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(12, 104, 258, 4);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(12, 104, 443, 5);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(12, 96, 443, 6);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(12, 96, 461, 7);

INSERT INTO `hsulibra_space_app`.`layout`
(AUTHOR, FLOOR, DATE_CREATED)
VALUES
('SRA', 3, NOW());


-- This is the Quiet Area (Area 13, Floor 3)
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Quiet Study", "LIB 301");

insert into `hsulibra_space_app`.`area_in_layout`
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
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Scholars Runway", "LIB 303");

insert into `hsulibra_space_app`.`area_in_layout`
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
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Special Collections", "LIB 303");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(15, 3);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (15, 312.25, 59.5, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (15, 312.25, 132, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (15, 420.25, 132, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (15, 420.25, 59.5, 3);


-- This is the Scholars Lab (Area 16, Floor 3)
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Scholars Lab", "LIB 301");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(16, 3);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (16, 275.75, 166.75, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (16, 275.75, 209.25, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (16, 400, 209.25, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (16, 400, 166.75, 3);


-- This is the Social Group Study (Area 17, Floor 3)
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Social Group Study", "LIB 301");

insert into `hsulibra_space_app`.`area_in_layout`
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
INSERT INTO `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values("Digital Media Lab", "LIB 120");

INSERT INTO `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(18, 1);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(18, 119, 191.75, 1);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(18, 119, 242.25, 2);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(18, 139.6, 242.25, 3);

insert into `hsulibra_space_app`.`area_vertices`
(`area_id`, `v_x`, `v_y`, `load_order`)
values
(18, 139.6, 191.75, 4);

-- areas for rooms
INSERT INTO `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values("Lecture Room", "LIB 114");

INSERT INTO `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(19, 1);

INSERT INTO `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values("Group Study", "LIB 115");

INSERT INTO `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(20, 1);

INSERT INTO `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values("Group Study", "LIB 116");

INSERT INTO `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(21, 1);

INSERT INTO `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values("Group Study", "LIB 117");

INSERT INTO `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(22, 1);

INSERT INTO `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values("Computer Lab", "LIB 121");

INSERT INTO `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(23, 1);

INSERT INTO `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values("Computer Lab", "LIB 122");

INSERT INTO `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(24, 1);

INSERT INTO `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values("Library Conference and Training", "LIB 118");

INSERT INTO `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(25, 1);

-- Room 205
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Collaboration Lab", "LIB 205");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(26, 2);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (26, 355.5, 202, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (26, 355.5, 227.75, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (26, 387.5, 227.75, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (26, 387.5, 202, 3);

-- MF Area
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Micro-Film Area", "LIB 201");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(27, 2);

INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (27, 387.25, 191.25, 0);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (27, 387.25, 242.75, 1);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (27, 453.75, 242.75, 2);
INSERT INTO area_vertices(area_id, v_y, v_x, load_order) VALUES (27, 453.75, 191.25, 3);

-- CTL Classroom
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("CTL Classroom", "LIB 301");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(28, 3);

insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Room 309", "LIB 309");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(29, 3);

insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Room 306", "LIB 306");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(30, 3);

-- Math Lab 2nd floor
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Math Tutorial Lab", "LIB 208");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(31, 2);

-- Fishbowl
insert into `hsulibra_space_app`.`area`
(`name`, `facilities_id`)
values
("Fishbowl", "LIB 209");

insert into `hsulibra_space_app`.`area_in_layout`
(`area_id`, `layout_id`)
values
(32, 2);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('rectangular_table_1', 1);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('rectangular_table_2', 2);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('rectangular_table_3', 3);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('rectangular_table_4', 4);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('counter_curved_2', 2);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('counter_curved_3', 3);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('circular_table_1', 1);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('circular_table_2', 2);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('circular_table_3', 3);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('circular_table_4', 4);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('couch_curved_2', 2);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('couch_2', 2);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('couch_3', 3);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('couch_4', 4);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('couch_6', 6);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('collaboration_station_2', 2);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('collaboration_station_3', 3);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('collaboration_station_4', 4);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('collaboration_station_6', 6);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('room', 0);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('computer_station', 1);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('seat', 1);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('seat_soft', 1);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('fit_desk', 1);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('meditation_corner', 1);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('mf_reader', 1);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('study_carrel_1', 1);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('study_carrel_2', 2);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('study_carrel_3', 3);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('study_carrel_4', 4);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('vid_viewer', 1);

INSERT INTO `hsulibra_space_app`.`furniture_type`
( furniture_name, number_of_seats)
VALUES('chair', 1);

INSERT INTO `hsulibra_space_app`.`furniture_type`( furniture_name, number_of_seats)
VALUES('rectangular_table_6', 6);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (230.75,342.25, 1, 1, 180, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (230.875,333.375, 1, 2, 180, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (230.625,321.875, 1, 2, 180, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (229.125,330.875, 1, 2, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (219.875,330.875, 1, 2, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (219.875,330.875, 1, 2, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (190.625,320.875, 1, 6, 180, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (196.875,289.5, 1, 6, -45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (229.875,301.75, 1, 2, 180, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (229.625,289.75, 1, 2, 180, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (230,278.875, 1, 2, 180, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (230,269.375, 1, 2, 180, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (196.625,154.375, 1, 11, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (223,291.625, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (223.125,280.75, 1, 10, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (223.5,269.75, 1, 10, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (225.5,260.25, 1, 8, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (215.875,259.875, 1, 8, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (209.375,275.375, 1, 4, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (209.375,287.25, 1, 4, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (152.375,286, 1, 14, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (157.75,286.5, 1, 13, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (157.75,294.625, 1, 13, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (175.875,286.875, 1, 14, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (175.125,263.625, 1, 14, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (162.25,260.875, 1, 15, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (129.5625,234.875, 1, 16, 180, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (131,225, 1, 16, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (130.9375,211.5, 1, 16, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (129.8125,221.3125, 1, 16, 180, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (130.8125,197.75, 1, 16, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (130,208.4375, 1, 16, 180, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (125.5,154.375, 1, 20, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (153.5,88.375, 1, 20, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (161.5,186.125, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (166,186.125, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (170.625,186.125, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (175.125,186.125, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (179.625,186.125, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (184.25,186.125, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (188.875,186.125, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (193.625,186.125, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (198.25,186.125, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (203,186.125, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (207.25,186.125, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (167.625,127.375, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (173.375,127.5, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (178.5,123.25, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (183.875,123, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (170.4375,148.5, 1, 11, -120, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (177.1875,143.5625, 1, 11, -55, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (183.875,146.625, 1, 11, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (180.5625,157, 1, 11, 185, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (185.8125,161.25, 1, 11, 140, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (192.75,160.25, 1, 11, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (195.25,147.375, 1, 11, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (190.1875,120.5625, 1, 22, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (175.5,112.125, 1, 12, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (176.875,113.0625, 1, 12, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (177,110.125, 1, 12, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (175.5,101.6875, 1, 12, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (183.375,95.25, 1, 22, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (187.625,83.375, 1, 22, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (175.4375,78.8125, 1, 12, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (176.75,75.625, 1, 12, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (175.125,66.8125, 1, 12, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (180.5625,58.875, 1, 22, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (187.75,58.8125, 1, 22, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (199.5,72.5, 1, 2, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (204.25,72.5, 1, 2, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (208.1875,88.75, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (210.375,83.5625, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (214.125,87.5625, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (215.4375,81.1875, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (219.4375,85.25, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (220.5625,78.75, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (224.625,82.625, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (226.5,76.75, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (230.25,81, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (232.9375,75.5625, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (239.625,103.5, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (233.125,105.4375, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (237.25,109.0625, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (232.5,111.75, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (228.375,108.0625, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (227.875,114.8125, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (223.75,111, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (222.875,117.375, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (218.5625,113.625, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (217.5625,120.25, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (213.6875,116.375, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (212.625,122.875, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (208.6875,118.75, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (231.75,139.125, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (229.75,145.5, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (226.0625,141.8125, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (225.1875,148.3125, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (221.5,144.5625, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (220.5625,151.25, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (216.5,147.4375, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (215.375,153.8125, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (211.375,149.6875, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (210.5625,156.4375, 1, 21, 45, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (252.375,118.25, 1, 12, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (247.5,117.625, 1, 12, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (256.375,117.5, 1, 12, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (252.25,126, 1, 12, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (253.25,144.75, 1, 15, 115, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (261.25,156.25, 1, 33, 115, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (257.125,166.625, 1, 33, 115, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (268.9375,193.5625, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (268.9375,199.125, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (268.875,205, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (268.875,210.3125, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (250.5,223.625, 1, 33, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (234.875,229.125, 1, 12, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (224.625,225.875, 1, 11, 266, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (234.625,237.125, 1, 12, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (228,237.625, 1, 11, 135, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (220.5,257.75, 1, 33, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (283.625,201.25, 1, 20, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (289.5,235.75, 1, 20, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (299.125,208.625, 1, 20, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (315.375,208.375, 1, 20, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (333.25,208.75, 1, 20, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (278.875,61.625, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (286.875,61.5, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (294.625,61.75, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (309,72.25, 1, 17, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (325.25,72.875, 1, 17, 90, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (327.5,80.375, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (318,87.75, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (314.125,76.75, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (305.625,86.875, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (301,76, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (293.375,86.125, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (289.25,75.75, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (282.125,86.875, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (277.625,75.625, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (323.625,113.875, 1, 17, 180, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (316.625,103.875, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (309,115.25, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (299.75,104.625, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (292.25,114.375, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (275,99.875, 1, 10, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (275,110.375, 1, 10, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (275,120.375, 1, 10, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (323.125,147.875, 1, 17, 180, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (317.375,136.25, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (309.375,148.625, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (297.5,137.25, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (289.625,149.625, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (323.75,174.9375, 1, 17, 180, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (322.375,180.125, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (315.9375,169.75, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (309.3125,179.5, 1, 9, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (300.375,160.8125, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (300.375,165.9375, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (295.125,160.75, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (295.0625,165.9375, 1, 21, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (295.4375,179.3125, 1, 23, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (289.875,179.0625, 1, 23, 0, 32, 1);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) VALUES (274.25,180.875, 1, 5, 0200, 32, 1);


INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (312.5,187, 2, 4, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (300,187.25, 2, 4, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (279.5,187.25, 2, 4, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (289,187.25, 2, 4, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (268.25,187.5, 2, 4, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (246,187.5, 2, 4, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (255.5,187.25, 2, 4, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (272.25,224, 2, 4, 90, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (299,224, 2, 4, 90, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (334.875,179.75, 2, 28, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (335,166.5, 2, 28, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (89.5,234.75, 2, 20, 0, 32, 32);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (292.5,235, 2, 20, 0, 32, 31);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (338.25,194.5, 2, 4, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (338.25,208.25, 2, 4, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (329,208.25, 2, 4, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (332.5,223.25, 2, 24, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (308.25,221.75, 2, 25, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (291.25,206, 2, 10, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (277.5,206, 2, 10, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (260.75,202.875, 2, 10, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (247,202.75, 2, 10, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (239.875,213.25, 2, 10, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (334.75,158.125, 2, 28, 0, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (333.625,131.375, 2, 27, 0, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (333.75,137.375, 2, 27, 0, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (333.625,143.25, 2, 27, 0, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (333.625,149.375, 2, 27, 0, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (333.125,115.125, 2, 28, 0, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (333.5,100, 2, 28, 0, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (332.75,81, 2, 28, 0, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (326.125,69.25, 2, 30, 45, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (311.125,68.75, 2, 30, 45, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (248,67.5, 2, 30, 45, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (266,67.625, 2, 30, 45, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (62.25,363, 2, 12, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (282.125,69.875, 2, 28, 90, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (292.25,70, 2, 28, 90, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (228.875,70.625, 2, 28, 90, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (214.375,70.25, 2, 28, 90, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (211.125,201.75, 2, 21, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (216.625,202, 2, 21, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (221.75,196.875, 2, 21, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (216,193.5, 2, 21, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (211,193.375, 2, 21, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (231.625,233.875, 2, 21, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (231.375,241.5, 2, 21, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (226,233.75, 2, 21, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (225.875,241.25, 2, 21, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (208.25,229, 2, 24, 0, 32, 6);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (203.125,66.625, 2, 30, 45, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (187.125,66.625, 2, 30, 45, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (163.875,68, 2, 28, 90, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (148.875,67.375, 2, 28, 90, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (119.375,62.75, 2, 27, 0, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (131,67.25, 2, 28, 90, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (111.375,67.125, 2, 29, 0, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (111.375,80.25, 2, 29, 0, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (111.375,132.125, 2, 29, 0, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (111.125,145.75, 2, 29, 0, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (111.625,116.5, 2, 28, 0, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (112,101.25, 2, 28, 0, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (110.75,165.75, 2, 28, 0, 32, 5);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (109.875,179.75, 2, 28, 0, 32, 5);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (240,262.25, 2, 4, 0, 32, 7);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (230.375,262.25, 2, 4, 0, 32, 7);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (239.875,274.125, 2, 4, 0, 32, 7);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (230,274, 2, 4, 0, 32, 7);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (239.875,292.625, 2, 4, 0, 32, 7);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (230.25,292.75, 2, 4, 0, 32, 7);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (239.875,306.25, 2, 4, 0, 32, 7);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (230.125,306.25, 2, 4, 0, 32, 7);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (239.875,324.625, 2, 4, 0, 32, 7);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (230.125,324.5, 2, 4, 0, 32, 7);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (208.375,301, 2, 19, 90, 32, 8);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (208.5,333.5, 2, 19, 90, 32, 8);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (198,278.875, 2, 19, 270, 32, 8);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (198.5,310.375, 2, 19, 270, 32, 8);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (212.375,357.25, 2, 18, 0, 32, 26);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (212.75,367.625, 2, 18, 0, 32, 26);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (216.125,366, 2, 18, 180, 32, 26);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (216,378.625, 2, 18, 180, 32, 26);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (183.75,292.5, 2, 3, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (183.375,308.75, 2, 3, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (168.75,308.25, 2, 3, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (169.25,292.625, 2, 3, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (183,327.125, 2, 3, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (168.5,327.5, 2, 3, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (183,339.375, 2, 3, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (168.375,339, 2, 3, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (176.125,288.875, 2, 3, 90, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (175.875,366.375, 2, 3, 90, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (61.125,315.625, 2, 22, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (168.5,257.625, 2, 22, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (160,257.625, 2, 22, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (130.375,257.75, 2, 22, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (122.375,257.625, 2, 22, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (60.875,283, 2, 22, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (61.25,292.875, 2, 22, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (61.25,303.875, 2, 22, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (66,330.625, 2, 22, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (65.875,339.75, 2, 22, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (62.375,374.625, 2, 12, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (139.938,381.938, 2, 21, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (132.938,381.812, 2, 21, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (113.875,381.25, 2, 21, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (108.125,381.375, 2, 21, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (158.75,375.25, 2, 10, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (96.375,270.25, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (76.25,270.125, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (86.625,284.625, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (96.5,298.875, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (78,309.5, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (97,318.375, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (79.125,331.625, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (95.375,344.25, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (75.125,353.875, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (91.875,366.625, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (79.875,388.375, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (96.125,397.25, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (79.25,410.25, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (96.75,419, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (96.625,435, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (65.25,426.25, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (65.875,444.625, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (68.75,462, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (69.75,476.125, 2, 10, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (90.125,482.25, 2, 10, 0, 32, 11);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (106.75,482.625, 2, 10, 0, 32, 11);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (143.25,466.5, 2, 10, 0, 32, 11);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (129,477.625, 2, 10, 0, 32, 11);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (64.25,394.938, 2, 12, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (64.3125,408.062, 2, 12, 0, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (59.625,493.125, 2, 11, 180, 32, 12);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (66.875,498.875, 2, 11, 140, 32, 11);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (126.5,498, 2, 11, 90, 32, 11);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (116.875,499.25, 2, 11, 140, 32, 11);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (152.5,495.5, 2, 33, 90, 32, 11);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (166.25,495.75, 2, 33, 90, 32, 11);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (216.875,501.125, 2, 33, 90, 32, 10);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (228.125,500.75, 2, 33, 90, 32, 10);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (176.875,483.375, 2, 10, 0, 32, 11);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (191.875,482.625, 2, 10, 0, 32, 11);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (210,462.5, 2, 10, 0, 32, 10);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (230,462.25, 2, 10, 0, 32, 10);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (253.25,461.75, 2, 10, 0, 32, 10);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (272.625,461.75, 2, 10, 0, 32, 10);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (250.125,488, 2, 10, 0, 32, 10);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (269,487, 2, 10, 0, 32, 10);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (274.125,496.5, 2, 23, 0, 32, 10);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (285.25,485, 2, 23, 0, 32, 10);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (203.5,491.125, 2, 12, 0, 32, 10);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (196.75,482.5, 2, 11, -45, 32, 11);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (202.875,486.25, 2, 11, 0, 32, 11);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (201.75,397.75, 2, 10, 0, 32, 27);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (164,400.25, 2, 10, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (171.5,394, 2, 1, 90, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (178.375,391.125, 2, 13, 90, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (209.375,432.75, 2, 26, 0, 32, 27);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (144.875,394, 2, 26, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (144.938,387.875, 2, 26, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (209.25,438.5, 2, 26, 0, 32, 27);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (215.625,432.562, 2, 26, 0, 32, 27);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (215.375,438.562, 2, 26, 0, 32, 27);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (221.188,435.625, 2, 26, 0, 32, 27);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (209.5,454.062, 2, 1, 90, 32, 10);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (204.875,428.875, 2, 2, 90, 32, 27);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (153.375,431.625, 2, 4, 90, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (153.312,421.375, 2, 4, 90, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (144.625,402.438, 2, 31, 0, 32, 9);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (144.688,408.188, 2, 31, 0, 32, 9);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (117.25,456.75, 3, 20, 0, 32, 30);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (186.5,404, 3, 20, 0, 32, 29);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (237.875,182.5, 3, 20, 0, 32, 28);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (279.75,180.25, 3, 2, 90, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (279.5,197.75, 3, 2, 90, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (318.5,119.5, 3, 1, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (320.438,107.625, 3, 2, 90, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (320.312,118.688, 3, 2, 90, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (311.875,65.125, 3, 27, 45, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (312,73.625, 3, 28, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (287.875,67.125, 3, 28, 90, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (301.25,67.25, 3, 28, 90, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (311,141.25, 3, 28, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (275.062,53.25, 3, 4, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (258,53.625, 3, 2, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (246.5,66.625, 3, 1, 90, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (231.125,53.6875, 3, 2, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (217.375,53.6875, 3, 3, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (195.625,54.25, 3, 33, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (189.5,102.375, 3, 33, 90, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (190,139.25, 3, 33, 90, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (263.125,181.625, 3, 2, 90, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (262.375,199.125, 3, 2, 90, 32, 17);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (208.75,226.25, 3, 10, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (242.375,228.25, 3, 10, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (271.75,228.875, 3, 10, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (253.75,206.875, 3, 23, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (247.75,206.75, 3, 23, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (223.25,207.5, 3, 23, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (217.375,207.5, 3, 23, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (202.875,203.625, 3, 23, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (202.625,181.25, 3, 23, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (202.375,192.875, 3, 23, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (202.5,171, 3, 23, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (183.625,242.062, 3, 21, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (183.625,247.812, 3, 21, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (183.625,253.438, 3, 21, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (183.562,259, 3, 21, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (183.5,264.688, 3, 21, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (183.562,269.875, 3, 21, 0, 32, 17);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (181.125,54, 3, 3, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (167.75,65.75, 3, 28, 90, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (139.75,65.375, 3, 28, 90, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (159.125,66.875, 3, 27, 90, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (151.5,66.75, 3, 27, 90, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (131.938,55.5, 3, 23, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (132.062,61, 3, 23, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (103.812,56.125, 3, 27, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (118.938,56.0625, 3, 27, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (70.5625,66.25, 3, 27, 45, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (65.875,74.3125, 3, 28, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (78.8125,66.625, 3, 28, 90, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (64.625,131.625, 3, 2, 90, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (64.75,121.5, 3, 2, 90, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (64.75,110.625, 3, 2, 90, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (64,203.25, 3, 2, 90, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (64,192.75, 3, 2, 90, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (62,177.062, 3, 23, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (68.25,170.875, 3, 23, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (62.6875,138.562, 3, 28, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (62.5625,156.688, 3, 28, 0, 32, 13);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (71.125,285.125, 3, 10, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (86.625,285.625, 3, 10, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (113.5,284.625, 3, 10, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (135,284.25, 3, 10, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (80.75,305.25, 3, 23, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (68.75,305.25, 3, 23, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (90.5,305.5, 3, 23, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (99.75,305.625, 3, 23, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (109.125,306.5, 3, 23, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (140.875,318.125, 3, 23, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (140.75,326, 3, 23, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (207.875,278.25, 3, 21, 0, 32, 16);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (202.125,286.375, 3, 3, 0, 32, 16);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (192.5,286.375, 3, 3, 0, 32, 16);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (202.75,297.5, 3, 3, 0, 32, 16);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (193,297.375, 3, 3, 0, 32, 16);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (192.625,307.375, 3, 3, 0, 32, 16);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (202.5,307.375, 3, 3, 0, 32, 16);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (198.5,334.5, 3, 18, 180, 32, 16);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (198.25,345.625, 3, 18, 180, 32, 16);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (197.875,362, 3, 18, 180, 32, 16);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (198.25,374, 3, 18, 180, 32, 16);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (183.375,397.5, 3, 18, 180, 32, 16);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (156.375,471.5, 3, 18, 180, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (156.75,488.875, 3, 18, 180, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (144.375,412.875, 3, 18, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (143.875,452, 3, 18, 0, 32, 14);

INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (151.375,480.875, 3, 10, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (138,481, 3, 10, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (124.375,480.625, 3, 10, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (85.625,473.625, 3, 4, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (72.375,473.375, 3, 4, 0, 32, 14);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (99.625,363, 3, 4, 0, 32, 15);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (99.5,370.625, 3, 4, 0, 32, 15);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (88,363, 3, 4, 0, 32, 15);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (87.875,370.5, 3, 4, 0, 32, 15);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (109.375,342.5, 3, 18, 0, 32, 15);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (66.25,373.625, 3, 21, 0, 32, 15);
INSERT INTO furniture (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) 
VALUES (117.625,387.375, 3, 21, 0, 32, 15);
