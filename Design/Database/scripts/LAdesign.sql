-- These scripts implement the tables for hsu_library schema
-- Last modified: 4/9/18
DROP SCHEMA `hsu_library` ;
CREATE SCHEMA `hsu_library` ;

CREATE TABLE `hsu_library`.`furniture_type` (
  `furniture_type_id` INT NOT NULL AUTO_INCREMENT,
  `furniture_name` VARCHAR(45) NOT NULL,
  `number_of_seats` INT NULL,
  PRIMARY KEY (`furniture_type_id`),
  UNIQUE INDEX `furniture_name_UNIQUE` (`furniture_name` ASC))
COMMENT = 'Contains the types of furniture such as tables and chairs, also stores their max number of seats.';

CREATE TABLE `hsu_library`.`room` (
  `facilities_id` VARCHAR(10) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`facilities_id`))
COMMENT = 'Rooms are identified by a facilities id which is unique to the campus, and the also have a human readable name.';

CREATE TABLE `hsu_library`.`layout` (
  `layout_id` INT NOT NULL AUTO_INCREMENT,
  `author` VARCHAR(45) NOT NULL,
  `floor` INT NOT NULL,
  `date_created` DATETIME NULL,
  PRIMARY KEY (`layout_id`))
COMMENT = 'Layouts are the entities that unify which objects are on a certain floor, they also record the author and date of creation.';

CREATE TABLE `hsu_library`.`area` (
  `area_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `facilities_id` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`area_id`),
  INDEX `room_id_idx` (`facilities_id` ASC),
  CONSTRAINT `room_id_fk`
    FOREIGN KEY (`facilities_id`)
    REFERENCES `hsu_library`.`room` (`facilities_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'All the spaces on a layout are made up of areas. They have an ID, a human name that defaults to a room name if there is no sub area, the room id, and a layout.';

CREATE TABLE `hsu_library`.`area_in_layout` (
  `area_id` INT NOT NULL,
  `layout_id` INT NULL,
  PRIMARY KEY (`area_id`),
  INDEX `layout_AL_fk_idx` (`layout_id` ASC),
  CONSTRAINT `area_AL_fk`
    FOREIGN KEY (`area_id`)
    REFERENCES `hsu_library`.`area` (`area_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `layout_AL_fk`
    FOREIGN KEY (`layout_id`)
    REFERENCES `hsu_library`.`layout` (`layout_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Areas might not change with each new layout, so areas and layouts are a many-to-many relationship.';

CREATE TABLE `hsu_library`.`furniture` (
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
    REFERENCES `hsu_library`.`layout` (`layout_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `furniture_type_fk`
    FOREIGN KEY (`furniture_type`)
    REFERENCES `hsu_library`.`furniture_type` (`furniture_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `default_seat_type_fk`
    FOREIGN KEY (`default_seat_type`)
    REFERENCES `hsu_library`.`furniture_type` (`furniture_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `furniture_in_area_fk`
	FOREIGN KEY (`in_area`)
	REFERENCES `hsu_library`.`area` (`area_id`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION)
COMMENT = 'Furniture refers to non seat items that are given a layout x and y coordinate, a type of furniture, and contain the default seat type.';

CREATE TABLE `hsu_library`.`area_vertices` (
  `area_id` INT NOT NULL,
  `v_y` INT NOT NULL,
  `v_x` INT NOT NULL,
  `load_order` int NOT NULL,
  PRIMARY KEY (`area_id`, `v_y`, `v_x`),
  CONSTRAINT `area_id_fk`
    FOREIGN KEY (`area_id`)
    REFERENCES `hsu_library`.`area` (`area_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Areas are able to be complex geometric shapes, so there are a minimum but no maximum number of vertice pairs for each area.';

CREATE TABLE `hsu_library`.`activity` (
  `activity_id` INT NOT NULL AUTO_INCREMENT,
  `activity_description` VARCHAR(45) NOT NULL,
  `wb_activity` TINYINT,
  PRIMARY KEY (`activity_id`))
COMMENT = 'An activity is anything that should be tracked by a seat, so there is an ID and a descriptive label.';


CREATE TABLE `hsu_library`.`survey_record` (
  `survey_id` INT NOT NULL AUTO_INCREMENT,
  `surveyed_by` VARCHAR(45) NOT NULL,
  `layout_id` INT NOT NULL,
  `survey_date` DATETIME NOT NULL,
  PRIMARY KEY (`survey_id`),
  INDEX `layout_id_fk_idx` (`layout_id` ASC),
  CONSTRAINT `layout_id_fk`
    FOREIGN KEY (`layout_id`)
    REFERENCES `hsu_library`.`layout` (`layout_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Each record of a survey is commited by one author';


CREATE TABLE `hsu_library`.`survey_area_ratios` (
  `survey_id` INT NOT NULL,
  `area_id` INT NOT NULL,
  `area_use_ratio` FLOAT NULL,
  PRIMARY KEY (`survey_id`, `area_id`),
  INDEX `area_fk_idx` (`area_id` ASC),
  CONSTRAINT `survey_fk`
    FOREIGN KEY (`survey_id`)
    REFERENCES `hsu_library`.`survey_record` (`survey_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `area_fk`
    FOREIGN KEY (`area_id`)
    REFERENCES `hsu_library`.`area` (`area_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Each area has a default number of seats in it, divide that by number of occupied seats to get usage ratio of use. Each ratio is dependant on a survey ID and an area ID.';


CREATE TABLE `hsu_library`.`whiteboard` (
  `whiteboard_id` INT NOT NULL AUTO_INCREMENT,
  `furniture_id` INT NOT NULL,
  `survey_id` INT NOT NULL,
  PRIMARY KEY (`whiteboard_id`),
  INDEX `survey_fk_idx` (`survey_id` ASC),
  CONSTRAINT `attached_to_fk`
    FOREIGN KEY (`furniture_id`)
    REFERENCES `hsu_library`.`furniture` (`furniture_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `survey_id_fk`
    FOREIGN KEY (`survey_id`)
    REFERENCES `hsu_library`.`survey_record` (`survey_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Whiteboards are used for writing on or partitioning space. They are used by a piece of furniture, and are only entered on a per survey, per use instance.';

CREATE TABLE `hsu_library`.`modified_furniture` (
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
    REFERENCES `hsu_library`.`furniture` (`furniture_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `survey_mod_furn_fk`
    FOREIGN KEY (`survey_id`)
    REFERENCES `hsu_library`.`survey_record` (`survey_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `mfurniture_in_area_fk`
	FOREIGN KEY (`in_area`)
	REFERENCES `hsu_library`.`area` (`area_id`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION)
COMMENT = 'If a piece of furniture is temporarily moved, a survey can record where that piece was moved to without changing the layout.';


CREATE TABLE `hsu_library`.`seat` (
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
    REFERENCES `hsu_library`.`furniture` (`furniture_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `seat_type_fk`
    FOREIGN KEY (`seat_type`)
    REFERENCES `hsu_library`.`furniture_type` (`furniture_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `survey_seat_fk`
    FOREIGN KEY (`survey_id`)
    REFERENCES `hsu_library`.`survey_record` (`survey_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Seats are the bases of recordings. They can be occupied or not, are attached to a specific piece of furniture (even if that piece of furniture is a seat) they also store which seat on the piece of furniture they are, what type of seat they are and are dependant on their record.';


CREATE TABLE `hsu_library`.`seat_has_activity` (
  `seat_id` INT NOT NULL,
  `activity_id` INT NOT NULL,
  PRIMARY KEY (`seat_id`, `activity_id`),
  INDEX `activity_fk_idx` (`activity_id` ASC),
  CONSTRAINT `seat_fk`
    FOREIGN KEY (`seat_id`)
    REFERENCES `hsu_library`.`seat` (`seat_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `activity_fk`
    FOREIGN KEY (`activity_id`)
    REFERENCES `hsu_library`.`activity` (`activity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Multiple activities may be associated with a seat, track which seat was performing which activities.';


CREATE TABLE `hsu_library`.`surveyed_room` (
  `furniture_id` INT NOT NULL,
  `total_occupants` INT NOT NULL,
  `survey_id` INT NOT NULL,
  PRIMARY KEY (`furniture_id`, `survey_id`),
  INDEX `room_furn_id_fk_idx` (`furniture_id` ASC),
  INDEX `survey_id_fk_idx` (`survey_id` ASC),
  CONSTRAINT `furn_room_id_fk`
    FOREIGN KEY (`furniture_id`)
    REFERENCES `hsu_library`.`furniture` (`furniture_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `room_survey_id_fk`
	FOREIGN KEY (`survey_id`)
	REFERENCES `hsu_library`.`survey_record` (`survey_id`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION)
COMMENT = 'The furniture room doesn\'t hold seat items, it holds a total number of people in the room.';

CREATE TABLE `hsu_library`.`wb_has_activity` (
  `whiteboard_id` INT NOT NULL,
  `activity_id` INT NOT NULL,
  PRIMARY KEY (`whiteboard_id`, `activity_id`),
  INDEX `wb_activity_fk_idx` (`activity_id` ASC),
  CONSTRAINT `wb_fk`
    FOREIGN KEY (`whiteboard_id`)
    REFERENCES `hsu_library`.`whiteboard` (`whiteboard_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `wb_activity_fk`
    FOREIGN KEY (`activity_id`)
    REFERENCES `hsu_library`.`activity` (`activity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Multiple activities may be associated with a whiteboard, track which whiteboard was performing which activities.';
