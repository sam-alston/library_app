INSERT INTO `hsu_library`.`furniture_type`
(`furniture_name`, `number_of_seats`)
VALUES ('table_four', 4);

INSERT INTO `hsu_library`.`furniture_type`
(`furniture_name`, `number_of_seats`)
VALUES ('chair', 1);

INSERT INTO `hsu_library`.`room`
(`facilities_id`, `name`)
VALUES ('LIB 100', '100');

INSERT INTO `hsu_library`.`layout`
(author,floor, date_created)
VALUES ('SRA', 1, NOW());

INSERT INTO `hsu_library`.`area`
(`name`, `facilities_id`)
VALUES ('Main Lobby', 'LIB 100');

INSERT INTO `hsu_library`.`area_in_layout`
(`area_id`, `layout_id`)
VALUES (1, 1);

INSERT INTO `hsu_library`.`furniture`
(`x_location`, `y_location`, `layout_id`, `furniture_type`, `default_seat_type`)
VALUES (200, 250, 1, 1, 2);

INSERT INTO `hsu_library`.`furniture`
(`x_location`, `y_location`, `layout_id`, `furniture_type`, `default_seat_type`)
VALUES (250, 250, 1, 1, 2);

INSERT INTO `hsu_library`.`activity`
(`activity_description`)
VALUES ('social');

INSERT INTO `hsu_library`.`activity`
(`activity_description`)
VALUES ('study');