CREATE TABLE `libraryapp`.`furniture_type` (
  `furniture_type_id` INT NOT NULL COMMENT 'Unique identifier for furniture type.',
  `furniture_name` VARCHAR(45) NOT NULL COMMENT 'The human name of a piece of furniture.',
  `num_seats` INT NOT NULL COMMENT 'The default number of seats a piece of furniture supports.',
  PRIMARY KEY (`furniture_type_id`))
COMMENT = 'Types of furniture, their name and number of seats they support';


CREATE TABLE `libraryapp`.`furniture` (
  `furniture_id` INT NOT NULL COMMENT 'Identifier for furniture piece.',
  `furniture_type_id` INT NOT NULL COMMENT 'foreign key to furniture type.',
  `x_loc` FLOAT NOT NULL COMMENT 'Furniture piece\'s x location.',
  `y_loc` FLOAT NOT NULL COMMENT 'Furniture piece\'s y location.',
  `area_id` INT NOT NULL COMMENT 'Furniture pieces area id (foreign key) which dictates a room and floor number.',
  `recording_timestamp` TIMESTAMP NOT NULL COMMENT 'Furniture piece\'s placing in time.',
  PRIMARY KEY (`furniture_id`),
  UNIQUE INDEX `furniture_id_UNIQUE` (`furniture_id` ASC))
    CONSTRAINT `furniture_type_fk`
    FOREIGN KEY (`furniture_type_id`)
    REFERENCES `libraryapp`.`furniture_type` (`furniture_type_id`)
COMMENT = 'Contains furniture type and their location in time & space';
  
  
  CREATE TABLE `libraryapp`.`room` (
  `maintenance_id` VARCHAR(10) NOT NULL COMMENT 'This datafield has a max length of 10, but may need to be changed pending finding out format of facilities room numbers.',
  `room_name` VARCHAR(45) NOT NULL COMMENT 'Human readable and used name, specific to the building.',
  PRIMARY KEY (`maintenance_id`))
COMMENT = 'The rooms of a building have a human name, and a unique facilities/maintenance ID that is campus wide.';


CREATE TABLE `libraryapp`.`area` (
  `area_id` INT NOT NULL COMMENT 'The unique identifier of an area.',
  `area_name` VARCHAR(45) NOT NULL COMMENT 'Human readable for area.',
  `room_maintenance_id` VARCHAR(10) NULL COMMENT 'Foreign key for the room that the area is in.',
  PRIMARY KEY (`area_id`),
  INDEX `room_maintenance_id_idx` (`room_maintenance_id` ASC),
  CONSTRAINT `room_maintenance_id`
    FOREIGN KEY (`room_maintenance_id`)
    REFERENCES `libraryapp`.`room` (`maintenance_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Areas are subsets of rooms, and can be by default the entire area of a room if there are no sub areas.';


CREATE TABLE `libraryapp`.`activity` (
  `activity_id` INT NOT NULL COMMENT 'Unique identifier for an activity.',
  `activity_name` VARCHAR(45) NULL COMMENT 'Description of the activity.',
  PRIMARY KEY (`activity_id`))
COMMENT = 'Contains activities that may be performed at each seat.';


CREATE TABLE `libraryapp`.`whiteboard` (
  `furniture_attached_to` INT NOT NULL COMMENT 'Foreign key of the furniture piece associated with the whiteboard.',
  `activity_id` INT NOT NULL COMMENT 'Foreign key of activity type to describe whiteboard use.',
  PRIMARY KEY (`furniture_attached_to`),
  INDEX `activity_idx` (`activity_id` ASC),
  CONSTRAINT `furniture_id`
    FOREIGN KEY (`furniture_attached_to`)
    REFERENCES `libraryapp`.`furniture` (`furniture_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `activity`
    FOREIGN KEY (`activity_id`)
    REFERENCES `libraryapp`.`activity` (`activity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Describes which pieces of furniture are using a whiteboard and their activity type.';


CREATE TABLE `libraryapp`.`seat` (
  `seat_id` INT NOT NULL,
  `furniture_fk_id` INT NOT NULL COMMENT 'Foreign Key of the furniture the seat is attached to.',
  `seat_occupied` TINYINT NOT NULL COMMENT 'True or False if seat is occupied. (Value of 0 is false, anything else is true)',
  PRIMARY KEY (`seat_id`, `furniture_fk_id`),
  INDEX `furniture_id_idx` (`furniture_fk_id` ASC),
  CONSTRAINT `furniture_fk_id`
    FOREIGN KEY (`furniture_fk_id`)
    REFERENCES `libraryapp`.`furniture` (`furniture_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Unique instance of a seat, indicates whether or not it is occupied.';


CREATE TABLE `libraryapp`.`seat_activities` (
  `seat_id` INT NOT NULL COMMENT 'foreign key for seat.',
  `furniture_id` INT NOT NULL COMMENT 'Foreign key for furniture id.',
  `activity_id` INT NULL COMMENT 'Foreign key for activity id.',
  PRIMARY KEY (`seat_id`, `furniture_id`),
  INDEX `furniture_fk_idx` (`furniture_id` ASC),
  INDEX `activity_fk_idx` (`activity_id` ASC),
  CONSTRAINT `seat_fk`
    FOREIGN KEY (`seat_id`)
    REFERENCES `libraryapp`.`seat` (`seat_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `furniture_fk`
    FOREIGN KEY (`furniture_id`)
    REFERENCES `libraryapp`.`seat` (`furniture_fk_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `activity_fk`
    FOREIGN KEY (`activity_id`)
    REFERENCES `libraryapp`.`activity` (`activity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Dictates which activity is associated with which seat.';


CREATE TABLE `libraryapp`.`furniture_attachment` (
  `furniture_parent` INT NOT NULL COMMENT 'Foreign key of parent furniture piece.',
  `furniture_child` INT NOT NULL COMMENT 'Foreign key of child furniture piece.',
  PRIMARY KEY (`furniture_parent`, `furniture_child`),
  INDEX `child_fk_idx` (`furniture_child` ASC),
  CONSTRAINT `parent_fk`
    FOREIGN KEY (`furniture_parent`)
    REFERENCES `libraryapp`.`furniture` (`furniture_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `child_fk`
    FOREIGN KEY (`furniture_child`)
    REFERENCES `libraryapp`.`furniture` (`furniture_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Describes which pieces of furniture are attached to each other.';

ALTER TABLE `libraryapp`.`furniture` 
DROP FOREIGN KEY `furniture_type_id`;
ALTER TABLE `libraryapp`.`furniture` 
ADD CONSTRAINT `furniture_type_id`
  FOREIGN KEY (`furniture_type_id`)
  REFERENCES `libraryapp`.`furniture_type` (`furniture_type_id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION;

