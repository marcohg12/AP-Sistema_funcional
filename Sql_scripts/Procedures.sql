DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_amenity_to_room`(IN p_room_id INT, IN p_amenity_id INT, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO amenity_x_room (room_ref, amenity_ref)
VALUES (p_room_id, p_amenity_id);

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_email`(IN p_username VARCHAR(50), IN p_email VARCHAR(50), OUT execution_code INT)
BEGIN
DECLARE p_id INT;
DECLARE email_check INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
BEGIN
  ROLLBACK;
END;
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT COUNT(*) INTO email_check FROM email WHERE email = p_email;

IF (email_check > 0) THEN
	SET execution_code = -2;
	SIGNAL CUSTOM_EXCEPTION;
END IF;

SELECT id INTO p_id FROM person WHERE user_ref = p_username;

INSERT INTO EMAIL(email, person_ref)
VALUES(p_email, p_id);
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_hotel_to_favorites`(IN p_hotel_id INT, IN p_username VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO hotel_x_user(hotel_ref, user_ref)
VALUES (p_hotel_id, p_username);

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_nationality_to_user`(IN pUsername VARCHAR(50), IN pNationality_id INT, OUT executionCode INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET executionCode = -1;
    ROLLBACK;
END;

INSERT INTO person_x_nationality(person_ref, nationality_ref) 
VALUES ((SELECT id FROM person WHERE user_ref = pUsername), pNationality_id);

SET executionCode = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_phone`(IN p_username VARCHAR(50), IN p_phone int, OUT execution_code INT)
BEGIN

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE p_id int;

DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
  ROLLBACK;
  END;
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT id INTO p_id FROM person WHERE user_ref = p_username;

INSERT INTO telephone(telephone_number, person_ref)
VALUES(p_phone, p_id);

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_photo_to_hotel`(IN p_hotel_id INT, IN p_photo MEDIUMBLOB, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO photo(hotel_ref, photo)
VALUES (p_hotel_id, p_photo);

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_room_to_booking`(IN p_booking_id INT, IN p_room_id INT, IN p_units INT,
                                        IN p_admin_price INT, OUT execution_code INT)
BEGIN

DECLARE check_usage INT;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT COUNT(*)
INTO check_usage
FROM reservation_x_room
WHERE room_ref = p_room_id 
AND reservation_ref = p_booking_id;

IF (check_usage = 0) THEN
    INSERT INTO reservation_x_room (reservation_ref, room_ref, price, is_code_applied, units)
    VALUES (p_booking_id, p_room_id, p_admin_price, 0, p_units);
ELSE 
    UPDATE reservation_x_room
    SET units = p_units,
        price = p_admin_price
	WHERE room_ref = p_room_id 
    AND reservation_ref = p_booking_id;
END IF;
	

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_room_to_deal`(IN p_room_id INT, IN p_deal_id INT, OUT execution_code INT)
BEGIN

DECLARE deal_start_date DATE;
DECLARE deal_ending_date DATE;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
      ROLLBACK;
  END;
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	SET execution_code = -1;
	ROLLBACK;
END;

SELECT start_date, ending_date
INTO deal_start_date, deal_ending_date
FROM offer
WHERE id = p_deal_id;

IF (is_room_in_offer(p_room_id, deal_start_date, deal_ending_date) > 0) THEN
    SET execution_code = -11;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

INSERT INTO offer_x_room (room_ref, offer_ref) 
VALUES (p_room_id, p_deal_id);

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `apply_discount_code`(IN p_booking_id INT, IN p_code VARCHAR(20), OUT execution_code INT)
BEGIN

DECLARE check_room_id INT;
DECLARE room_discount INT;
DECLARE check_usage INT;


DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
BEGIN
    ROLLBACK;
END;


DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT room.id, room.discount_rate
INTO check_room_id, room_discount
FROM room
INNER JOIN reservation_x_room
ON room.id = reservation_x_room.room_ref
WHERE reservation_x_room.reservation_ref = p_booking_id
AND room.discount_code = p_code;

IF (check_room_id IS NULL) THEN
    SET execution_code = -16;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

SELECT is_code_applied
INTO check_usage
FROM reservation_x_room
WHERE room_ref = check_room_id
AND reservation_ref = p_booking_id;

IF (check_usage = 1) THEN
    SET execution_code = -17;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

UPDATE reservation_x_room
    SET is_code_applied = 1,
        price = GET_CURRENT_ROOM_PRICE_IN_BOOKING(check_room_id, p_booking_id) * (1 - (room_discount/100))
WHERE room_ref = check_room_id
AND reservation_ref = p_booking_id;

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cancel_booking`(IN p_booking_id INT, OUT execution_code INT)
BEGIN

DECLARE v_hotel_id INT;
DECLARE v_check_in_date DATE;
DECLARE v_policy_id INT;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	SET execution_code = -1;
	ROLLBACK;
END;

SELECT hotel_ref, check_in_date
INTO v_hotel_id, v_check_in_date
FROM reservation
WHERE id = p_booking_id; 

SELECT id
INTO v_policy_id
FROM cancellation_policy 
WHERE hotel_ref = v_hotel_id
AND anticipation_time >= (DATEDIFF(v_check_in_date, CURDATE()))
ORDER BY anticipation_time ASC
LIMIT 1;

UPDATE reservation
SET cancellation_policy_ref = v_policy_id,
	reservation_status_ref = 2
WHERE id = p_booking_id;

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `confirm_booking`(IN p_booking_id INT, IN p_method_id INT, OUT execution_code INT)
BEGIN

DECLARE room_count INT;
DECLARE rooms_available_count INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
BEGIN
	ROLLBACK;
END;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	SET execution_code = -1;
	ROLLBACK;
END;

SELECT COUNT(*)
INTO room_count
FROM reservation
INNER JOIN reservation_x_room
ON reservation.id = reservation_x_room.reservation_ref
WHERE reservation.id = p_booking_id;

SELECT SUM(IS_ROOM_AVAILABLE(room.id, reservation.check_in_date, reservation.check_out_date, reservation_x_room.units))
INTO rooms_available_count
FROM reservation
INNER JOIN reservation_x_room
ON reservation.id = reservation_x_room.reservation_ref
INNER JOIN room
ON reservation_x_room.room_ref = room.id
WHERE reservation.id = p_booking_id;

IF (room_count != rooms_available_count) THEN
    SET execution_code = -15;
    SIGNAL CUSTOM_EXCEPTION;
END IF;


UPDATE reservation
SET confirmation_date = CURDATE(),
    reservation_status_ref = 1,
    payment_method_ref = p_method_id
WHERE id = p_booking_id;

UPDATE reservation_x_room AS r_x_r
INNER JOIN (
    SELECT room.id
    FROM room
) AS rooms
ON r_x_r.room_ref = rooms.id
SET r_x_r.price = (GET_CURRENT_ROOM_PRICE_IN_BOOKING(rooms.id, p_booking_id))
WHERE r_x_r.reservation_ref = p_booking_id
AND r_x_r.price IS NULL;

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_amenity`(IN p_amenity_id INT, OUT execution_code INT)
BEGIN

DECLARE check_ussage INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
      ROLLBACK;
  END;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

DELETE FROM amenity_x_room
WHERE amenity_ref = p_amenity_id;

DELETE FROM amenity
WHERE id = p_amenity_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_amenity_from_room`(IN p_room_id INT, IN p_amenity_id INT, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

DELETE FROM amenity_x_room
WHERE room_ref = p_room_id
AND   amenity_ref = p_amenity_id;

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_booking`(IN p_booking_id INT, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

DELETE FROM reservation_x_room
WHERE reservation_ref = p_booking_id;

DELETE FROM reservation
WHERE id = p_booking_id;

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_cancelation_policy`(IN p_policy_id INT, OUT execution_code INT)
BEGIN

DECLARE check_usage INT; 

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
  ROLLBACK;
END;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT COUNT(*) 
INTO check_usage 
FROM reservation 
WHERE cancellation_policy_ref = p_policy_id;

IF (check_usage > 0) THEN
    SET execution_code = -8;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM cancellation_policy 
WHERE id = p_policy_id;

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_canton`(IN p_canton_id INT, OUT execution_code INT)
BEGIN

DECLARE check_ussage INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
      ROLLBACK;
  END;
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT COUNT(*) 
INTO check_ussage 
FROM district 
WHERE canton_ref = p_canton_id;

IF (check_ussage > 0) THEN
    SET execution_code = -8;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM canton
WHERE id = p_canton_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_classification`(IN p_classification_id INT, OUT execution_code INT)
BEGIN

DECLARE check_ussage INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
      ROLLBACK;
  END;
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT COUNT(*) 
INTO check_ussage 
FROM hotel
WHERE classification_ref = p_classification_id;

IF (check_ussage > 0) THEN
    SET execution_code = -8;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM classification
WHERE id = p_classification_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_country`(IN p_country_id INT, OUT execution_code INT)
BEGIN

DECLARE check_ussage INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
      ROLLBACK;
  END;
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT COUNT(*) 
INTO check_ussage 
FROM province 
WHERE country_ref = p_country_id;

IF (check_ussage > 0) THEN
    SET execution_code = -8;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM country
WHERE id = p_country_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_deal`(IN p_deal_id INT, OUT execution_code INT)
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

DELETE FROM offer_x_room
WHERE offer_ref = p_deal_id;

DELETE FROM offer 
WHERE id = p_deal_id; 

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_district`(IN p_district_id INT, OUT execution_code INT)
BEGIN

DECLARE check_ussage INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
      ROLLBACK;
  END;
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT COUNT(*) 
INTO check_ussage 
FROM hotel 
WHERE district_ref = p_district_id;

IF (check_ussage > 0) THEN
    SET execution_code = -8;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM district
WHERE id = p_district_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_email_from_user`(IN pUsername VARCHAR(50), IN pEmail VARCHAR(50), OUT executionCode INT)
BEGIN

DECLARE check_emails INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
  ROLLBACK;
  END;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET executionCode = -1;
    ROLLBACK;
END;

SELECT COUNT(*) 
INTO check_emails
FROM person 
INNER JOIN email
ON person.id = email.person_ref
WHERE person.user_ref = pUsername;

IF (check_emails - 1 <= 0) THEN
SET executionCode = -8;
SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM email
WHERE email = pEmail;

SET executionCode = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_gender`(IN p_gender_id INT, OUT execution_code INT)
BEGIN

DECLARE check_ussage INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
      ROLLBACK;
  END;
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT COUNT(*) 
INTO check_ussage 
FROM person 
WHERE gender_ref = p_gender_id;

IF (check_ussage > 0) THEN
    SET execution_code = -8;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM gender
WHERE id = p_gender_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_hotel`(IN p_hotel_id INT, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

START TRANSACTION;

DELETE FROM reservation
WHERE hotel_ref = p_hotel_id;

DELETE FROM reservation_x_room
WHERE room_ref IN (SELECT id FROM room WHERE hotel_ref = p_hotel_id);

DELETE FROM amenity_x_room
WHERE amenity_ref IN (SELECT id FROM amenity WHERE hotel_ref = p_hotel_id);

DELETE FROM offer_x_room
WHERE offer_ref IN (SELECT id FROM offer WHERE hotel_ref = p_hotel_id);

DELETE FROM amenity
WHERE hotel_ref = p_hotel_id;

DELETE FROM offer
WHERE hotel_ref = p_hotel_id;

DELETE FROM room
WHERE hotel_ref = p_hotel_id;

DELETE FROM payment_method
WHERE hotel_ref = p_hotel_id;

DELETE FROM cancellation_policy
WHERE hotel_ref = p_hotel_id;

DELETE FROM photo
WHERE hotel_ref = p_hotel_id;

DELETE FROM hotel_x_user
WHERE hotel_ref = p_hotel_id;

UPDATE user_table
SET hotel_ref = NULL
WHERE hotel_ref = p_hotel_id;

UPDATE user_table
SET user_type_ref = 3
WHERE username IN (
    SELECT username
    FROM admin
    WHERE admin.hotel_ref = p_hotel_id
);

DELETE FROM admin
WHERE hotel_ref = p_hotel_id;

UPDATE user_table
SET hotel_ref = NULL
WHERE hotel_ref = p_hotel_id;

DELETE FROM hotel
WHERE id = p_hotel_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_hotel_from_default`(IN p_username VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

UPDATE user_table
SET hotel_ref = NULL
WHERE username = p_username;
    
SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_hotel_from_favorites`(IN p_hotel_id INT, IN p_username VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

DELETE FROM hotel_x_user
WHERE hotel_ref = p_hotel_id 
AND user_ref = p_username;

SET execution_code = 0;
COMMIT;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_id_type`(IN p_id_type_id INT, OUT execution_code INT)
BEGIN

DECLARE check_ussage INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
      ROLLBACK;
  END;
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT COUNT(*) 
INTO check_ussage 
FROM person
WHERE id_type_ref = p_id_type_id;

IF (check_ussage > 0) THEN
    SET execution_code = -8;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM id_type
WHERE id = p_id_type_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_nationality`(IN p_nationality_id INT, OUT execution_code INT)
BEGIN

DECLARE check_ussage INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
      ROLLBACK;
  END;
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT COUNT(*) 
INTO check_ussage 
FROM person_x_nationality 
WHERE nationality_ref = p_nationality_id;

IF (check_ussage > 0) THEN
    SET execution_code = -8;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM nationality
WHERE id = p_nationality_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_nationality_from_user`(IN pUsername VARCHAR(50), IN pNationality_id INT, OUT executionCode INT)
BEGIN

DECLARE check_nationalities INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
  ROLLBACK;
  END;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET executionCode = -1;
    ROLLBACK;
END;

SELECT COUNT(*) 
INTO check_nationalities 
FROM person 
INNER JOIN person_x_nationality
ON person.id = person_x_nationality.person_ref
WHERE person.user_ref = pUsername;

IF (check_nationalities - 1 <= 0) THEN
SET executionCode = -8;
SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM person_x_nationality
WHERE person_ref = (SELECT id FROM person WHERE user_ref = pUsername) 
AND nationality_ref = pNationality_id;

SET executionCode = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_parameter`(IN p_parameter_id INT, OUT execution_code INT)
BEGIN
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

DELETE FROM setting
WHERE id = p_parameter_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_payment_method`(IN p_payment_method_id INT, OUT execution_code INT)
BEGIN

DECLARE check_usage INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
  ROLLBACK;
  END;
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT COUNT(*) 
INTO check_usage 
FROM reservation 
WHERE payment_method_ref = p_payment_method_id;

IF (check_usage > 0) THEN
SET execution_code = -8;
SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM payment_method
WHERE id = p_payment_method_id;

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_phone_from_user`(IN pUsername VARCHAR(50), IN pPhone_id INT, OUT executionCode INT)
BEGIN

DECLARE check_phones INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
  ROLLBACK;
  END;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET executionCode = -1;
    ROLLBACK;
END;

SELECT COUNT(*) 
INTO check_phones
FROM person 
INNER JOIN telephone
ON person.id = telephone.person_ref
WHERE person.user_ref = pUsername;

IF (check_phones - 1 <= 0) THEN
SET executionCode = -8;
SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM telephone
WHERE id = pPhone_id;

SET executionCode = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_photo_from_hotel`(IN p_photo_id INT, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

DELETE FROM photo
WHERE id = p_photo_id;

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_province`(IN p_province_id INT, OUT execution_code INT)
BEGIN

DECLARE check_ussage INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
      ROLLBACK;
  END;
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT COUNT(*) 
INTO check_ussage 
FROM canton 
WHERE province_ref = p_province_id;

IF (check_ussage > 0) THEN
    SET execution_code = -8;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM province
WHERE id = p_province_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_room`(IN p_room_id INT, OUT execution_code INT)
BEGIN

DECLARE check_ussage INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
      ROLLBACK;
END;
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT COUNT(*) 
INTO check_ussage 
FROM reservation_x_room 
WHERE room_ref = p_room_id;

IF (check_ussage > 0) THEN
    SET execution_code = -8;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM room
WHERE id = p_room_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_room_from_booking`(IN p_room_id INT, p_booking_id INT, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

DELETE FROM reservation_x_room 
WHERE room_ref = p_room_id 
AND reservation_ref = p_booking_id;

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_room_from_deal`(IN p_room_id INT, IN p_deal_id INT, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	SET execution_code = -1;
	ROLLBACK;
END;
 
 DELETE FROM offer_x_room
 WHERE offer_ref = p_deal_id
 AND room_ref = p_room_id;

SET execution_code= 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_user`(IN p_username VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE person_id INT;
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT id
INTO person_id
FROM person
WHERE user_ref = p_username;

DELETE FROM telephone
WHERE person_ref = person_id;

DELETE FROM email
WHERE person_ref = person_id;

DELETE FROM person_x_nationality
WHERE person_ref = person_id;

DELETE FROM reservation
WHERE user_ref = p_username;

DELETE FROM admin
WHERE username = p_username;

DELETE FROM person
WHERE user_ref = p_username;

DELETE FROM user_table
WHERE username = p_username;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_user_type`(IN p_type_id INT, OUT executionCode INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	SET executionCode = -1;
	ROLLBACK;
END;

DELETE FROM user_type 
WHERE id = p_type_id;

SET executionCode = 0;

COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_amenities`(IN p_hotel_id INT)
BEGIN

SELECT id, name
FROM amenity
WHERE hotel_ref = p_hotel_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_amenities_in_room`(IN p_room_id INT)
BEGIN

SELECT amenity.id, amenity.name
FROM amenity
INNER JOIN amenity_x_room
ON amenity.id = amenity_x_room.amenity_ref
WHERE amenity_x_room.room_ref = p_room_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_amenities_not_in_room`(IN p_room_id INT, IN p_hotel_id INT)
BEGIN

SELECT amenity.id, amenity.name
FROM amenity
LEFT JOIN amenity_x_room
ON amenity.id = amenity_x_room.amenity_ref 
AND amenity_x_room.room_ref = p_room_id
WHERE amenity_x_room.amenity_ref IS NULL
AND amenity.hotel_ref = p_hotel_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_booked_people`(IN p_hotel_id INT, IN p_column INT, IN p_order INT,
																IN p_name VARCHAR(50), IN p_id_type INT, IN p_id_num VARCHAR(50),
                                                                IN p_check_in VARCHAR(50), IN p_check_out VARCHAR(50), IN p_price DOUBLE)
BEGIN

SELECT reservation.id AS booking_id, user_table.username AS username,
       GET_PERSON_COMPLETE_NAME(person.id) AS name, person.identification_number AS id_num, id_type.name AS id_type,
       reservation.check_in_date AS check_in, reservation.check_out_date AS check_out, GET_BOOKING_PRICE_WITH_FEE(reservation.id) AS price
FROM reservation
INNER JOIN user_table
ON reservation.user_ref = user_table.username
INNER JOIN person
ON user_table.username = person.user_ref
INNER JOIN id_type
ON person.id_type_ref = id_type.id
WHERE reservation.hotel_ref = p_hotel_id
AND reservation.reservation_status_ref = 1
AND GET_PERSON_COMPLETE_NAME(person.id) LIKE IFNULL(NULLIF(CONCAT('%',p_name,'%'), '%%'), GET_PERSON_COMPLETE_NAME(person.id))
AND person.id_type_ref = IFNULL(p_id_type, person.id_type_ref)
AND person.identification_number = IFNULL(NULLIF(p_id_num, ''), person.identification_number)
AND GET_BOOKING_PRICE_WITH_FEE(reservation.id)  = IFNULL(p_price, GET_BOOKING_PRICE_WITH_FEE(reservation.id))
AND reservation.check_in_date = IFNULL(DATE(p_check_in), reservation.check_in_date)
AND reservation.check_out_date = IFNULL(DATE(p_check_out), reservation.check_out_date)
ORDER BY 

    CASE WHEN p_column = 1 AND p_order = 1 THEN
        name
    END,
    CASE WHEN p_column = 1 AND p_order = 2 THEN
        name
    END DESC,
    
    CASE WHEN p_column = 2 AND p_order = 1 THEN
        id_num
    END,
    CASE WHEN p_column = 2 AND p_order = 2 THEN
        id_num
    END DESC,
    
    CASE WHEN p_column = 3 AND p_order = 1 THEN
        id_type
    END,
    CASE WHEN p_column = 3 AND p_order = 2 THEN
        id_type
    END DESC,
    
    CASE WHEN p_column = 4 AND p_order = 1 THEN
        check_in
    END,
    CASE WHEN p_column = 4 AND p_order = 2 THEN
        check_in
    END DESC,
    
    CASE WHEN p_column = 5 AND p_order = 1 THEN
        check_out
    END,
    CASE WHEN p_column = 5 AND p_order = 2 THEN
        check_out
    END DESC,
    
    CASE WHEN p_column = 6 AND p_order = 1 THEN
        price
    END,
    CASE WHEN p_column = 6 AND p_order = 2 THEN
        price
    END DESC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_booking_comments`(IN pReservation_id INT)
BEGIN
	SELECT commentary.commentary_date AS date, commentary.commentary AS comment    
	FROM commentary
	WHERE commentary.reservation_ref = pReservation_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_booking_data`(IN p_booking_id INT)
BEGIN

SELECT reservation.id, reservation.check_in_date, reservation.check_out_date,
       reservation.reservation_status_ref AS status_id, reservation_status.name AS status_name, reservation.cancellation_policy_ref AS cancellation_policy_id,
       cancellation_policy.name AS cancellation_policy_name, cancellation_policy.value AS cancelation_fee, reservation.payment_method_ref AS payment_method_id, 
	   payment_method.name AS payment_method_name, reservation.hotel_ref AS hotel_id, 
       hotel.name AS hotel_name, user_ref AS username, GET_RESERVATED_DAYS(p_booking_id)-1 AS nights,
       GET_ROOM_COUNT_IN_BOOKING(p_booking_id) AS room_count, GET_BOOKING_PRICE(p_booking_id) AS price,
       GET_BOOKING_PRICE_WITH_FEE(p_booking_id) AS price_with_fee, IS_BOOKING_REVIEWED(p_booking_id) AS is_reviewed,
       review.review_date AS review_date, review.stars, IS_BOOKING_CHECKED_IN(p_booking_id) AS is_checked_in
FROM reservation
INNER JOIN reservation_status
ON reservation.reservation_status_ref = reservation_status.id
LEFT JOIN cancellation_policy
ON reservation.cancellation_policy_ref = cancellation_policy.id
LEFT JOIN payment_method
ON reservation.payment_method_ref = payment_method.id
LEFT JOIN review
ON reservation.id = review.reservation_ref
INNER JOIN hotel
ON reservation.hotel_ref = hotel.id
WHERE reservation.id = p_booking_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_bookins`(IN p_hotel_id INT)
BEGIN

SELECT reservation.id, reservation.user_ref AS username, reservation.check_in_date, reservation.check_out_date, 
       reservation_status.name AS status, reservation_status.id AS status_id
FROM reservation
INNER JOIN reservation_status
ON reservation.reservation_status_ref = reservation_status.id
WHERE reservation.hotel_ref = p_hotel_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_cancel_policy_to_apply_in_booking`(IN p_booking_id INT)
BEGIN

DECLARE v_hotel_id INT;
DECLARE v_check_in_date DATE;

SELECT hotel_ref, check_in_date
INTO v_hotel_id, v_check_in_date
FROM reservation
WHERE id = p_booking_id; 

SELECT id, name, anticipation_time, value, IF(v_check_in_date >= CURDATE(), 1, 0) AS is_cancelable
FROM cancellation_policy 
WHERE hotel_ref = v_hotel_id
AND anticipation_time >= (DATEDIFF(v_check_in_date, CURDATE()))
ORDER BY anticipation_time ASC
LIMIT 1;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_cancelation_policies`(IN p_hotel_id INT)
BEGIN

SELECT id, name, anticipation_time, value
FROM cancellation_policy
WHERE hotel_ref = p_hotel_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_cantons`(IN p_province_id INT)
BEGIN
    SELECT id, name
    FROM canton
    WHERE province_ref = p_province_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_classification`()
BEGIN
    SELECT id, name
    FROM classification;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_classifications`()
BEGIN
    SELECT id, name
    FROM classification;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_clients_by_age_range`(IN p_hotel_id INT, p_gender_id INT)
BEGIN

SELECT a.age_range, a.client_count, (CASE WHEN a.client_count = 0 AND b.total_clients = 0 THEN 0 ELSE a.client_count / b.total_clients END) * 100 AS client_percent
FROM
(SELECT '0-18' age_range, COUNT(DISTINCT reservation.user_ref) AS client_count

FROM person
INNER JOIN user_table
ON person.user_ref = user_table.username
LEFT JOIN reservation
ON user_table.username = reservation.user_ref

WHERE FLOOR(DATEDIFF (CURDATE(), person.birthdate)/365) BETWEEN 0 AND 18
AND reservation.hotel_ref = p_hotel_id AND reservation.reservation_status_ref = 1
AND person.gender_ref = IFNULL(p_gender_id, person.gender_ref)

UNION

SELECT '19-30' age_range, COUNT(DISTINCT reservation.user_ref) AS client_count

FROM person
INNER JOIN user_table
ON person.user_ref = user_table.username
LEFT JOIN reservation
ON user_table.username = reservation.user_ref

WHERE FLOOR(DATEDIFF (CURDATE(), person.birthdate)/365) BETWEEN 19 AND 30
AND reservation.hotel_ref = p_hotel_id AND reservation.reservation_status_ref = 1
AND person.gender_ref = IFNULL(p_gender_id, person.gender_ref)

UNION

SELECT '31-45' age_range, COUNT(DISTINCT reservation.user_ref) AS client_count

FROM person
INNER JOIN user_table
ON person.user_ref = user_table.username
LEFT JOIN reservation
ON user_table.username = reservation.user_ref

WHERE FLOOR(DATEDIFF (CURDATE(), person.birthdate)/365) BETWEEN 31 AND 45
AND reservation.hotel_ref = p_hotel_id AND reservation.reservation_status_ref = 1
AND person.gender_ref = IFNULL(p_gender_id, person.gender_ref)

UNION

SELECT '46-60' age_range, COUNT(DISTINCT reservation.user_ref) AS client_count

FROM person
INNER JOIN user_table
ON person.user_ref = user_table.username
LEFT JOIN reservation
ON user_table.username = reservation.user_ref

WHERE FLOOR(DATEDIFF (CURDATE(), person.birthdate)/365) BETWEEN 46 AND 60
AND reservation.hotel_ref = p_hotel_id AND reservation.reservation_status_ref = 1
AND person.gender_ref = IFNULL(p_gender_id, person.gender_ref)

UNION

SELECT '61-75' age_range, COUNT(DISTINCT reservation.user_ref) AS client_count

FROM person
INNER JOIN user_table
ON person.user_ref = user_table.username
LEFT JOIN reservation
ON user_table.username = reservation.user_ref

WHERE FLOOR(DATEDIFF (CURDATE(), person.birthdate)/365) BETWEEN 61 AND 75
AND reservation.hotel_ref = p_hotel_id AND reservation.reservation_status_ref = 1
AND person.gender_ref = IFNULL(p_gender_id, person.gender_ref)

UNION

SELECT 'Mayor de 75' age_range, COUNT(DISTINCT reservation.user_ref) AS client_count

FROM person
INNER JOIN user_table
ON person.user_ref = user_table.username
LEFT JOIN reservation
ON user_table.username = reservation.user_ref

WHERE FLOOR(DATEDIFF (CURDATE(), person.birthdate)/365) > 75
AND reservation.hotel_ref = p_hotel_id AND reservation.reservation_status_ref = 1
AND person.gender_ref = IFNULL(p_gender_id, person.gender_ref)) a,

(SELECT COUNT(DISTINCT reservation.user_ref) AS total_clients
 FROM person
 INNER JOIN user_table
 ON person.user_ref = user_table.username
 LEFT JOIN reservation
 ON user_table.username = reservation.user_ref

 WHERE reservation.hotel_ref = p_hotel_id AND reservation.reservation_status_ref = 1
 AND person.gender_ref = IFNULL(p_gender_id, person.gender_ref)) b;
 
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_countries`()
BEGIN
    SELECT id, name
    FROM country;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_deal_data`(IN p_deal_id INT)
BEGIN

SELECT id, name, start_date, ending_date, discount_rate, minimun_reservation_days, hotel_ref AS hotel_id
FROM offer
WHERE id = p_deal_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_deals`(IN p_hotel_id INT)
BEGIN

SELECT id, name, start_date, ending_date, discount_rate, minimun_reservation_days
FROM offer
WHERE hotel_ref = p_hotel_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_deals_for_clients`(IN p_hotel_id INT)
BEGIN

SELECT id, name, start_date, ending_date, discount_rate, minimun_reservation_days
FROM offer
WHERE hotel_ref = p_hotel_id
AND (
(CURDATE() BETWEEN start_date AND ending_date) OR
(CURDATE() <= ending_date)
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_deals_report`(IN p_hotel_id INT, IN p_name VARCHAR(100), IN p_start_date VARCHAR(50), IN p_ending_date VARCHAR(50))
BEGIN

SELECT offer.id, offer.name, offer.start_date, offer.ending_date, offer.discount_rate, 
	   GET_DEAL_PROFIT(offer.id) AS profit, ROUND(((100 * GET_DEAL_PROFIT(offer.id))/(100 - offer.discount_rate)),2) AS og_profit
FROM offer
WHERE offer.hotel_ref = p_hotel_id
AND (offer.name LIKE CONCAT('%', IFNULL(NULLIF(p_name, ''), offer.name), '%'))
AND ((IFNULL(DATE(p_start_date), offer.start_date) BETWEEN offer.start_date AND offer.ending_date)
OR (IFNULL(DATE(p_ending_date), offer.start_date) BETWEEN offer.start_date AND offer.ending_date)
OR (offer.start_date BETWEEN IFNULL(DATE(p_start_date), DATE("0001-01-01")) AND IFNULL(DATE(p_ending_date), offer.start_date))
OR (offer.ending_date BETWEEN IFNULL(DATE(p_start_date), DATE("0001-01-01")) AND IFNULL(DATE(p_ending_date), offer.ending_date)))
ORDER BY offer.start_date ASC;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_deals_view`(IN p_province_id INT)
BEGIN

SELECT * FROM deals_view
WHERE province_id = IFNULL(p_province_id, province_id);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_districts`(IN p_canton_id INT)
BEGIN
    SELECT id, name
    FROM district
    WHERE canton_ref = p_canton_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_emails_from_user`(IN pUsername VARCHAR(50))
BEGIN
    SELECT email.email
    FROM user_table 
    INNER JOIN person
    ON user_table.username = person.user_ref
    INNER JOIN email
    ON person.id = email.person_ref
    WHERE username = pUsername;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_genders`()
BEGIN
    SELECT id, name
    FROM gender;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotel_catalog`()
BEGIN

SELECT hotel.id AS id, hotel.name AS name, GET_HOTEL_LOCATION(hotel.id) AS location, classification.name AS classification,
       hotel.district_ref AS district_id, hotel.classification_ref AS classification_id
FROM hotel
INNER JOIN district
ON hotel.district_ref = district.id
INNER JOIN classification
ON hotel.classification_ref =  classification.id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotel_comments`(IN hotel_id INT)
BEGIN

SELECT commentary.id, commentary.commentary_date AS date, commentary.commentary, GET_PERSON_COMPLETE_NAME(person.id) AS name, photo, user_table.username, review.stars
FROM commentary 
INNER JOIN reservation 
ON reservation.id = commentary.reservation_ref
INNER JOIN user_table
ON reservation.user_ref = user_table.username
INNER JOIN person
ON user_table.username = person.user_ref
LEFT JOIN review
ON reservation.id = review.reservation_ref
WHERE reservation.hotel_ref = hotel_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotel_data`(IN p_hotel_id INT)
BEGIN

SELECT hotel.name, hotel.address, classification_ref AS classification_id, district_ref AS district_id,
       canton.id AS canton_id, province.id AS province_id, country.id AS country_id, hotel.id AS hotel_id
FROM hotel
INNER JOIN district
ON hotel.district_ref = district.id
INNER JOIN canton
ON district.canton_ref = canton.id
INNER JOIN province
ON canton.province_ref = province.id
INNER JOIN country
ON province.country_ref = country.id
WHERE hotel.id = p_hotel_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotel_data_for_client`(IN p_hotel_id INT)
BEGIN

SELECT hotel.id, hotel.name, GET_HOTEL_LOCATION(hotel.id) AS address, classification.name AS classification_name
FROM hotel 
INNER JOIN classification
ON hotel.classification_ref = classification.id
WHERE hotel.id = p_hotel_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotel_deals_for_clients`(IN p_hotel_id INT)
BEGIN

SELECT id, name, start_date, ending_date, discount_rate, minimun_reservation_days
FROM offer
WHERE hotel_ref = p_hotel_id
AND (
(CURDATE() BETWEEN start_date AND ending_date) OR
(CURDATE() <= ending_date)
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotel_photos`(IN p_hotel_id INT)
BEGIN

SELECT id, photo
FROM photo
WHERE hotel_ref = p_hotel_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotel_review_average_report`(IN pHotel_id INT)
BEGIN
	SELECT reservation.id AS booking_id, review.stars AS stars, user_table.username AS username, GET_PERSON_COMPLETE_NAME(person.id) AS name, reservation.check_in_date AS check_in, reservation.check_out_date AS check_out   
	FROM reservation    
	LEFT JOIN review     
	ON review.reservation_ref = reservation.id     
	INNER JOIN user_table     
	ON user_table.username = reservation.user_ref
    INNER JOIN person
    ON user_table.username = person.user_ref
	WHERE reservation.hotel_ref = pHotel_id AND reservation.reservation_status_ref = 1;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotel_reviews`(IN hotel_id INT)
BEGIN

SELECT review.id, review.review_date, GET_PERSON_COMPLETE_NAME(person.id) AS name, photo, user_table.username, review.stars
FROM review 
INNER JOIN reservation 
ON reservation.id = review.reservation_ref
INNER JOIN user_table
ON reservation.user_ref = user_table.username
INNER JOIN person
ON user_table.username = person.user_ref
WHERE reservation.hotel_ref = hotel_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotels_list`()
BEGIN

SELECT * FROM (
SELECT hotel.id, hotel.name AS hotel_name, classification.name AS classification_name, province.name AS province_name, country.name AS country_name, photo.photo, ROW_NUMBER() OVER (PARTITION BY hotel.id) AS row_num
FROM hotel
INNER JOIN classification
ON hotel.classification_ref = classification.id
INNER JOIN district
ON hotel.district_ref = district.id
INNER JOIN canton
ON district.canton_ref = canton.id
INNER JOIN province
ON canton.province_ref = province.id
INNER JOIN country
ON province.country_ref = country.id
LEFT JOIN photo
ON photo.hotel_ref = hotel.id
GROUP BY hotel.id, hotel.name, classification.name, province.name, country.name, photo.photo
) hotels_list WHERE hotels_list.row_num = 1;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotels_query`(IN pHotel_name VARCHAR(50), pStart_date VARCHAR(50), pEnding_date VARCHAR(50))
BEGIN
	SELECT id, name, registration_date, GET_TOTAL_ROOMS_IN_HOTEL(id) AS room_count, 
           GET_TOTAL_BOOKINGS_IN_HOTEL(id) AS bookings_count, GET_HOTEL_PROFIT(id) AS profit     
	FROM hotel           
	WHERE name = IFNULL(NULLIF(pHotel_name, ''), name)   
	AND (registration_date BETWEEN IFNULL(DATE(pStart_date), DATE("0001-01-01")) AND IFNULL(DATE(pEnding_date), CURDATE()));
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotels_to_admin`()
BEGIN

SELECT id, name
FROM hotel;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_id_types`()
BEGIN
    SELECT id, name, max_characters, is_alphanumeric
    FROM id_type;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_log_query`(IN p_hotel_id INT, IN p_username VARCHAR(50), IN p_room_name VARCHAR(50),
                                  IN p_old_price INT, IN p_new_price INT, IN p_start_date VARCHAR(50),
								  IN p_ending_date VARCHAR(50))
BEGIN

SELECT id, username, room_name, old_price, new_price, modification_date
FROM log
WHERE hotel_id = p_hotel_id
AND username = IFNULL(NULLIF(p_username, ''), username)
AND room_name = IFNULL(NULLIF(p_room_name, ''), room_name)
AND old_price = IFNULL(p_old_price, old_price)
AND new_price = IFNULL(p_new_price, new_price)
AND (modification_date BETWEEN IFNULL(DATE(p_start_date), DATE("0001-01-01")) AND IFNULL(DATE(p_ending_date), CURDATE()));

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_nationalities`()
BEGIN
    SELECT id, name
    FROM nationality;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_nationalities_from_user`(IN pUsername VARCHAR(50))
BEGIN
    SELECT nationality.id, nationality.name
    FROM user_table 
    INNER JOIN person
    ON user_table.username = person.user_ref
    INNER JOIN person_x_nationality
    ON person.id = person_x_nationality.person_ref
    INNER JOIN nationality
    ON nationality.id = person_x_nationality.nationality_ref
    WHERE username = pUsername;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_nationalities_not_in_user`(IN pUsername VARCHAR(50))
BEGIN

DECLARE person_id_v INT;

SELECT id
INTO person_id_v
FROM person
WHERE user_ref = pUsername;

SELECT nationality.id, nationality.name
FROM nationality
LEFT JOIN person_x_nationality
ON nationality.id = person_x_nationality.nationality_ref 
AND person_x_nationality.person_ref = person_id_v
WHERE person_x_nationality.nationality_ref IS NULL;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_parameters`()
BEGIN
    SELECT id, name, value
    FROM setting;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_payment_methods`(IN p_hotel_id INT)
BEGIN

SELECT id, name
FROM payment_method
WHERE hotel_ref = p_hotel_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_person_by_email`(IN p_email VARCHAR(50))
BEGIN

SELECT GET_PERSON_COMPLETE_NAME(person.id) AS name, username
FROM user_table
INNER JOIN person
ON user_table.username = person.user_ref
INNER JOIN email
ON person.id = email.person_ref
WHERE email.email = p_email;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_person_by_id_number`(IN p_id_number VARCHAR(50), IN p_id_type_id INT)
BEGIN

SELECT GET_PERSON_COMPLETE_NAME(person.id) AS name, username
FROM user_table
INNER JOIN person
ON user_table.username = person.user_ref
WHERE person.identification_number = p_id_number
AND person.id_type_ref = p_id_type_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_person_by_username`(IN p_username VARCHAR(50))
BEGIN

SELECT GET_PERSON_COMPLETE_NAME(person.id) AS name, username
FROM user_table
INNER JOIN person
ON user_table.username = person.user_ref
WHERE username = p_username;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_person_data`(IN pUsername VARCHAR(50))
BEGIN

SELECT CONCAT(first_name, ' ',COALESCE(second_name,'')) AS name, CONCAT(first_surname, ' ', COALESCE(second_surname,'')) AS last_name, birthdate,
	    identification_number, gender_ref, id_type_ref, username, photo
FROM user_table
INNER JOIN person
ON user_table.username = person.user_ref
WHERE username = pUsername;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_phones_from_user`(IN pUsername VARCHAR(50))
BEGIN
    SELECT telephone.id, telephone.telephone_number
    FROM user_table 
    INNER JOIN person
    ON user_table.username = person.user_ref
    INNER JOIN telephone
    ON person.id = telephone.person_ref
    WHERE username = pUsername;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_provinces`(IN p_country_id INT)
BEGIN
    SELECT id, name
    FROM province
    WHERE country_ref = p_country_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_review_avarage`(IN pHotel_id INT)
BEGIN
    SELECT  IFNULL(SUM(review.stars)/COUNT(review.id),0)  AS avarage
    FROM reservation
    INNER JOIN review
    ON review.reservation_ref = reservation.id
    WHERE reservation.hotel_ref = pHotel_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_review_average`(IN pHotel_id INT)
BEGIN
    SELECT  IFNULL(SUM(review.stars)/COUNT(review.id),0)  AS avarage
    FROM reservation
    INNER JOIN review
    ON review.reservation_ref = reservation.id
    WHERE reservation.hotel_ref = pHotel_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_room_detail`(IN p_room_id INT)
BEGIN

SELECT id, name , capacity, recommended_price AS price, get_current_room_price(id) AS current_price, 
       is_room_currently_in_offer(id) AS is_in_offer, units, discount_code, discount_rate, hotel_ref AS hotel_id, 
       get_current_offer_id_from_room(id) AS offer_id
FROM room 
WHERE room.id = p_room_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_rooms`(IN p_hotel_id INT)
BEGIN

SELECT id, name, capacity, recommended_price AS price, discount_code, discount_rate, 
       units, IS_ROOM_CURRENTLY_IN_OFFER(id) AS is_in_offer, GET_CURRENT_ROOM_PRICE(id) AS current_price
FROM room
WHERE hotel_ref = p_hotel_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_rooms_available_for_deal`(IN p_deal_id INT)
BEGIN

DECLARE hotel_id INT;

SELECT hotel_ref
INTO hotel_id
FROM offer
WHERE id = p_deal_id;

SELECT room.id, room.name, room.recommended_price AS price
FROM room
LEFT JOIN offer_x_room
ON room.id = offer_x_room.room_ref
AND offer_x_room.offer_ref = p_deal_id
WHERE offer_x_room.offer_ref IS NULL
AND room.hotel_ref = hotel_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_rooms_in_booking`(IN booking_id INT)
BEGIN

SELECT room.id, room.name, room.capacity, room.recommended_price AS price, reservation_x_room.units, 
       GET_CURRENT_ROOM_PRICE_IN_BOOKING(room.id, booking_id) AS current_price,
       IS_ROOM_IN_BOOKING_IN_OFFER(room.id, booking_id) AS is_in_offer, reservation_x_room.price AS admin_price
FROM room 
INNER JOIN reservation_x_room 
ON reservation_x_room.room_ref = room.id
WHERE reservation_x_room.reservation_ref = booking_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_rooms_in_deal`(IN p_deal_id INT)
BEGIN

DECLARE discount INT;

SELECT discount_rate 
INTO discount
FROM offer 
WHERE id = p_deal_id;

SELECT room.id, room.name, room.recommended_price AS price, (room.recommended_price  * (1 - (discount/100))) AS current_price, room.capacity
FROM room
INNER JOIN offer_x_room
ON room.id = offer_x_room.room_ref
WHERE offer_x_room.offer_ref = p_deal_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_rooms_to_book`(IN hotel_id INT)
BEGIN

SELECT room.id, room.name , room.capacity, room.recommended_price AS price, get_current_room_price(room.id) AS current_price, 
       is_room_currently_in_offer(room.id) AS is_in_offer, room.units
FROM room 
WHERE room.hotel_ref = hotel_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_rooms_view`(IN p_hotel_id INT)
BEGIN

SELECT * FROM rooms_view
WHERE hotel_id = p_hotel_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_most_booked_rooms`(IN p_hotel_id INT, p_top_n INT)
BEGIN

IF (p_top_n IS NOT NULL) THEN
    SELECT * FROM (
        SELECT a.id, a.name, a.room_count, (IFNULL(a.room_count / b.total_count,0)) * 100 AS room_percent, DENSE_RANK() OVER(ORDER BY room_count DESC) AS ranking
        FROM
        
        (SELECT e.id, e.name, COUNT(e.status) AS room_count
        FROM 
        (SELECT room.id, room.name, NULLIF(reservation.reservation_status_ref,2) AS status
         FROM room
         LEFT JOIN reservation_x_room
		 ON room.id = reservation_x_room.room_ref
		 LEFT JOIN reservation
		 ON reservation_x_room.reservation_ref = reservation.id
         WHERE room.hotel_ref = p_hotel_id AND (reservation.reservation_status_ref != 3 OR reservation.reservation_status_ref IS NULL)) e
         GROUP BY e.id) a,
        
        (SELECT COUNT(*) total_count
        FROM room
        INNER JOIN reservation_x_room
        ON room.id = reservation_x_room.room_ref
        INNER JOIN reservation
        ON reservation_x_room.reservation_ref = reservation.id
        WHERE room.hotel_ref = p_hotel_id
        AND reservation.reservation_status_ref = 1) b
        ) c WHERE ranking <= p_top_n;
ELSE
    SELECT * FROM (
        SELECT a.id, a.name, a.room_count, (IFNULL(a.room_count / b.total_count,0)) * 100 AS room_percent, DENSE_RANK() OVER(ORDER BY room_count DESC) AS ranking
        FROM
        
        (SELECT e.id, e.name, COUNT(e.status) AS room_count
        FROM 
        (SELECT room.id, room.name, NULLIF(reservation.reservation_status_ref,2) AS status
         FROM room
         LEFT JOIN reservation_x_room
		 ON room.id = reservation_x_room.room_ref
		 LEFT JOIN reservation
		 ON reservation_x_room.reservation_ref = reservation.id
         WHERE room.hotel_ref = p_hotel_id AND (reservation.reservation_status_ref != 3 OR reservation.reservation_status_ref IS NULL)) e
         GROUP BY e.id) a,
        
        (SELECT COUNT(*) total_count
        FROM room
        INNER JOIN reservation_x_room
        ON room.id = reservation_x_room.room_ref
        INNER JOIN reservation
        ON reservation_x_room.reservation_ref = reservation.id
        WHERE room.hotel_ref = p_hotel_id
        AND reservation.reservation_status_ref = 1) b
        ) c;
END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_days_with_fewer_booking`(IN p_hotel_id INT, IN p_top INT,
                                                                                IN p_start_date VARCHAR(50), IN p_ending_date VARCHAR(50))
BEGIN

IF (p_top IS NOT NULL) THEN

    SELECT * FROM (
        SELECT date, reservations, DENSE_RANK() OVER(ORDER BY reservations ASC) AS ranking
        FROM (
            SELECT confirmation_date AS date, COUNT(*) AS reservations
            FROM reservation
            WHERE hotel_ref = p_hotel_id
            AND (confirmation_date BETWEEN IFNULL(DATE(p_start_date), DATE("0001-01-01")) AND IFNULL(DATE(p_ending_date), CURDATE()))
            GROUP BY confirmation_date
            ) reservations_from_hotel ) top
     WHERE ranking <= p_top;

ELSE 
    SELECT confirmation_date AS date, COUNT(*) AS reservations
    FROM reservation
    WHERE hotel_ref = p_hotel_id
    AND (confirmation_date BETWEEN IFNULL(DATE(p_start_date), DATE("0001-01-01")) AND IFNULL(DATE(p_ending_date), CURDATE()))
    GROUP BY confirmation_date
    ORDER BY COUNT(*) ASC;
END IF;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_days_with_most_booking`(IN p_hotel_id INT, IN p_top INT,
																			   IN p_start_date VARCHAR(50), IN p_ending_date VARCHAR(50))
BEGIN

IF (p_top IS NOT NULL) THEN

    SELECT * FROM (
        SELECT date, reservations, DENSE_RANK() OVER(ORDER BY reservations DESC) AS ranking
        FROM (
            SELECT confirmation_date AS date, COUNT(*) AS reservations
            FROM reservation
            WHERE hotel_ref = p_hotel_id
            AND (confirmation_date BETWEEN IFNULL(DATE(p_start_date), DATE("0001-01-01")) AND IFNULL(DATE(p_ending_date), CURDATE()))
            GROUP BY confirmation_date
            ) reservations_from_hotel ) top
     WHERE ranking <= p_top;
     
ELSE 
    SELECT confirmation_date AS date, COUNT(*) AS reservations
    FROM reservation
    WHERE hotel_ref = p_hotel_id
    AND (confirmation_date BETWEEN IFNULL(DATE(p_start_date), DATE("0001-01-01")) AND IFNULL(DATE(p_ending_date), CURDATE()))
    GROUP BY confirmation_date
    ORDER BY COUNT(*) DESC;
END IF;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_bookings`(IN p_username VARCHAR(50))
BEGIN

SELECT reservation.id AS booking_id, hotel.id AS hotel_id, hotel.name AS hotel_name, reservation.check_in_date, reservation.check_out_date,
       reservation_status.id AS status_id, reservation_status.name AS status_name
FROM reservation
INNER JOIN hotel
ON reservation.hotel_ref = hotel.id
INNER JOIN reservation_status
ON reservation.reservation_status_ref = reservation_status.id
WHERE reservation.user_ref = p_username
ORDER BY reservation.check_in_date DESC;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_by_username`(IN pUsername VARCHAR(50))
BEGIN
    SELECT user_table.username, user_password, photo, user_type_ref, admin.hotel_ref, 
           user_table.hotel_ref AS hotel_client_id, GET_PERSON_COMPLETE_NAME(person.id) AS name
    FROM user_table
    LEFT JOIN admin
    ON user_table.username = admin.username
    INNER JOIN person
    ON user_table.username = person.user_ref
    WHERE user_table.username = pUsername;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_favorite_hotels`(IN p_username VARCHAR(50))
BEGIN

SELECT * FROM (
SELECT hotel.id, hotel.name AS hotel_name, classification.name AS classification_name, province.name AS province_name, country.name AS country_name, photo.photo, ROW_NUMBER() OVER (PARTITION BY hotel.id) AS row_num
FROM hotel
INNER JOIN classification
ON hotel.classification_ref = classification.id
INNER JOIN district
ON hotel.district_ref = district.id
INNER JOIN canton
ON district.canton_ref = canton.id
INNER JOIN province
ON canton.province_ref = province.id
INNER JOIN country
ON province.country_ref = country.id
LEFT JOIN photo
ON photo.hotel_ref = hotel.id
INNER JOIN hotel_x_user
ON hotel.id = hotel_x_user.hotel_ref
WHERE hotel_x_user.user_ref = p_username
GROUP BY hotel.id, hotel.name, classification.name, province.name, country.name, photo.photo
) hotels_list WHERE hotels_list.row_num = 1;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_types`()
BEGIN

SELECT id, name
FROM user_type;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_users`(IN p_username VARCHAR(50))
BEGIN

SELECT user_table.username, user_type.id AS user_type_id, user_type.name AS user_type, hotel.id AS hotel_id, hotel.name AS hotel
FROM user_table
INNER JOIN user_type
ON user_table.user_type_ref = user_type.id
LEFT JOIN admin
ON user_table.username = admin.username
LEFT JOIN hotel
ON admin.hotel_ref = hotel.id
WHERE user_table.username != p_username
ORDER BY user_type.name ASC;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `is_hotel_favorite`(p_username VARCHAR(50), p_hotel_id INT)
BEGIN

SELECT IFNULL(COUNT(*),0) AS count
FROM hotel_x_user
WHERE user_ref = p_username
AND hotel_ref = p_hotel_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_amenity`(IN p_name VARCHAR(50), IN p_hotel_id INT, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	SET execution_code = -1;
	ROLLBACK;
END;

INSERT INTO amenity(name, hotel_ref)
VALUES(p_name, p_hotel_id);

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_booking`(IN p_username VARCHAR(50), IN p_check_in DATE, IN p_check_out DATE,
									 IN p_hotel_id INT, OUT execution_code INT, OUT booking_id INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET booking_id = -1;
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO reservation (user_ref, check_in_date, check_out_date, hotel_ref, reservation_status_ref)
VALUES (p_username, p_check_in, p_check_out, p_hotel_id, 3);

SET booking_id = LAST_INSERT_ID();
SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_cancelation_policy`(IN p_name VARCHAR(50), IN p_anticipation_time INT, 
                                             IN p_cancelation_fee INT, IN p_hotel_id INT, OUT execution_code INT)
BEGIN

DECLARE check_usage INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
  ROLLBACK;
END;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;


SELECT COUNT(*)
INTO check_usage
FROM cancellation_policy
WHERE anticipation_time = p_anticipation_time
AND hotel_ref = p_hotel_id;

IF (check_usage > 0) THEN
    SET execution_code = -3;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

INSERT INTO cancellation_policy (name, anticipation_time, value, hotel_ref)
VALUES(p_name, p_anticipation_time, p_cancelation_fee, p_hotel_id);

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_canton`(IN p_province_id INT, IN p_name VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO canton(name, province_ref) VALUES (p_name, p_province_id);
COMMIT;

SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_classification`(IN p_name VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO classification(name) VALUES (p_name);
COMMIT;

SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_country`(IN p_name VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO country(name) VALUES (p_name);
COMMIT;

SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_deal`(IN p_name VARCHAR(100), IN p_start_date DATE, IN p_ending_date DATE, IN p_discount_rate INT, IN p_minimum_days INT, IN p_hotel_id INT, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO offer(name, start_date, ending_date, discount_rate, minimun_reservation_days, hotel_ref)
VALUES(p_name, p_start_date, p_ending_date , p_discount_rate, p_minimum_days, p_hotel_id);

set execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_district`(IN p_canton_id INT, IN p_name VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO district(name, canton_ref) VALUES (p_name, p_canton_id);
COMMIT;

SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_gender`(IN p_name VARCHAR(50), OUT execution_code INT)
BEGIN
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO gender(name) VALUES (p_name);
COMMIT;

SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_hotel`(IN p_name VARCHAR(50), IN p_address VARCHAR(150),
                                                             IN p_district INT, IN p_classification_id INT, OUT execution_code INT)
BEGIN
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO hotel(name, registration_date, address, classification_ref, district_ref) 
		  VALUES (p_name, CURDATE(), p_address, p_classification_id, p_district);
COMMIT;

SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_id_type`(IN p_name VARCHAR(50), IN p_max_characters INT, IN p_is_alphanumeric INT, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO id_type(name, max_characters, is_alphanumeric) VALUES (p_name, p_max_characters, p_is_alphanumeric);
COMMIT;

SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_nationality`(IN p_name VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO nationality(name) VALUES (p_name);
COMMIT;

SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_parameter`(IN p_name VARCHAR(50), IN p_value DOUBLE, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO setting(name, value) VALUES (p_name, p_value);
COMMIT;

SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_payment_method`(IN p_name VARCHAR(50), IN p_hotel_id INT, OUT execution_code INT)
BEGIN
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO payment_method (name, hotel_ref)
VALUES (p_name, p_hotel_id);

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_province`(IN p_country_id INT, IN p_name VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO province(name, country_ref) VALUES (p_name, p_country_id);
COMMIT;

SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_room`(IN p_name VARCHAR(50), IN p_capacity INT, 
                                  IN p_price INT, IN p_units INT, IN p_discount_code VARCHAR(20),
                                  IN p_discount_rate INT, IN p_hotel_ref INT, OUT execution_code INT)
BEGIN

DECLARE check_ussage INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
      ROLLBACK;
END;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;


IF (p_discount_code IS NOT NULL) THEN

SELECT COUNT(*)
INTO check_ussage
FROM room
WHERE hotel_ref = p_hotel_ref AND discount_code = p_discount_code;

IF (check_ussage > 0) THEN
    SET execution_code = -2;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

END IF;

INSERT INTO room(name, capacity, recommended_price, discount_code, discount_rate, units, hotel_ref)
VALUES (p_name, p_capacity, p_price, p_discount_code, p_discount_rate, p_units, p_hotel_ref);

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_user`(IN pfirst_name VARCHAR(50), IN psecond_name VARCHAR(50), IN pfirst_surname VARCHAR(50),
                                         IN psecond_surname VARCHAR(50), IN pbirthday DATE, IN pidentification VARCHAR(15), IN pusername VARCHAR(50), 
                                         IN ppassword VARCHAR(100), IN pphoto MEDIUMBLOB, IN pnationality_id INT, IN ptelephone INT,
                                         IN pemail VARCHAR(50), IN pgender_id INT, IN pid_type_id INT, OUT executionCode INT)
BODY: BEGIN
DECLARE check_username INT;
DECLARE check_email INT;
DECLARE check_identification INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
  ROLLBACK;
  END;
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET executionCode = -1;
    ROLLBACK;
END;

SELECT COUNT(*) INTO check_email FROM email WHERE email = pemail;
SELECT COUNT(*) INTO check_username FROM user_table WHERE username = pusername;
SELECT COUNT(*) INTO check_identification FROM person WHERE identification_number = pidentification AND id_type_ref = pid_type_id;

IF (check_username > 0) THEN
SET executionCode = -2;
SIGNAL CUSTOM_EXCEPTION;
END IF;

IF (check_email > 0) THEN
SET executionCode = -3;
SIGNAL CUSTOM_EXCEPTION;
END IF;

IF (check_identification > 0) THEN
SET executionCode = -4;
SIGNAL CUSTOM_EXCEPTION;
END IF;

INSERT INTO user_table (username, user_type_ref, photo, user_password, hotel_ref)
VALUES (pusername, 3, pphoto, ppassword, null);

INSERT INTO person(id, birthdate, first_name, second_name, first_surname, second_surname, identification_number, gender_ref, id_type_ref, user_ref)
VALUES(default, pbirthday, pfirst_name, psecond_name, pfirst_surname, psecond_surname, pidentification, pgender_id, pid_type_id, pusername);

SET @last_id = LAST_INSERT_ID();

INSERT INTO email(email, person_ref)
VALUES(pemail, @last_id);

INSERT INTO person_x_nationality(nationality_ref, person_ref)
VALUES(pnationality_id, @last_id);

INSERT INTO telephone(telephone_number, person_ref)
VALUES(ptelephone, @last_id);

SET executionCode = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_user_type`(IN p_name VARCHAR(50), OUT executionCode INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	SET executionCode = -1;
	ROLLBACK;
END;

INSERT INTO user_type(name)
VALUES (p_name);

SET executionCode = 0;

COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `send_comment`(IN p_booking_id INT, IN p_comment VARCHAR(100), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO commentary (reservation_ref, commentary, commentary_date)
VALUES (p_booking_id, p_comment, CURDATE());

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `send_review`(IN p_booking_id INT, IN p_review INT, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

INSERT INTO review (reservation_ref, stars, date)
VALUES (p_booking_id, p_review, CURDATE());

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `set_hotel_as_default`(IN p_hotel_id INT, IN p_username VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

UPDATE user_table
SET hotel_ref = p_hotel_id
WHERE username = p_username;
    
SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_amenity`(IN p_amenity_id INT, IN p_new_name VARCHAR (50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	SET execution_code = -1;
	ROLLBACK;
END;

UPDATE amenity 
SET name = p_new_name
WHERE id = p_amenity_id; 

SET execution_code= 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_booking_dates`(IN p_check_in DATE, IN p_check_out DATE, IN p_booking_id INT, IN execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

UPDATE reservation
    SET check_in_date = p_check_in,
        check_out_date = p_check_out
WHERE id = p_booking_id;

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_cancelation_policy`(IN p_policy_id INT, IN p_name VARCHAR(50), IN p_anticipation_time INT, 
                                                                        IN p_cancelation_fee INT, OUT execution_code INT)
BEGIN

DECLARE check_usage INT;
DECLARE hotel_id INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
  ROLLBACK;
END;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT hotel_ref
INTO hotel_id
FROM cancellation_policy
WHERE id = p_policy_id;

SELECT COUNT(*)
INTO check_usage
FROM cancellation_policy
WHERE anticipation_time = p_anticipation_time
AND hotel_ref = hotel_id AND id != p_policy_id;

IF (check_usage > 0) THEN
    SET execution_code = -3;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

UPDATE cancellation_policy
SET name = p_name,
    anticipation_time = p_anticipation_time,
    value = p_cancelation_fee
WHERE id = p_policy_id;

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_canton`(IN p_canton_id INT, IN p_new_name VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

UPDATE canton
SET name = p_new_name
WHERE id = p_canton_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_classification`(IN p_classification_id INT, IN p_new_name VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

UPDATE classification
SET name = p_new_name
WHERE id = p_classification_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_country`(IN p_country_id INT, IN p_new_name VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

UPDATE country
SET name = p_new_name
WHERE id = p_country_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_deal`(IN deal_id INT, IN new_name VARCHAR(100), IN new_start_date DATE, 
                             IN new_ending_date DATE, IN new_discount_rate INT, IN new_minimum_days INT, 
                             OUT execution_code INT)
BEGIN

DECLARE rooms_in_offer INT;
DECLARE check_rooms INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
  ROLLBACK;
END;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

SELECT COUNT(*)
INTO rooms_in_offer
FROM offer_x_room
WHERE offer_ref = deal_id;

SELECT SUM(is_room_in_offer(room_ref, new_start_date, new_ending_date))
INTO check_rooms
FROM offer_x_room
WHERE offer_ref = deal_id;

IF (check_rooms > rooms_in_offer) THEN
    SET execution_code = -11;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

UPDATE offer 
SET name                     = new_name, 
    start_date               = new_start_date, 
	ending_date              = new_ending_date, 
    discount_rate            = new_discount_rate, 
    minimun_reservation_days = new_minimum_days
WHERE id = deal_id; 

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_district`(IN p_district_id INT, IN p_new_name VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

UPDATE district
SET name = p_new_name
WHERE id = p_district_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_email`(IN pusername VARCHAR(50), IN pold_email VARCHAR(50), IN pnew_email VARCHAR(50), OUT executionCode INT)
BEGIN

DECLARE check_email INT;
DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';

DECLARE EXIT HANDLER FOR SQLSTATE '45000'
BEGIN
    ROLLBACK;
END;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET executionCode = -1;
	ROLLBACK;
END;

SELECT COUNT(*)
INTO check_email
FROM email
WHERE email = pnew_email
AND person_ref != (SELECT id FROM person WHERE user_ref = pusername);

IF (check_email >= 1) THEN
    SET executionCode = -2;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

UPDATE email
SET email = pnew_email
WHERE email = pold_email;

SET executionCode = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_gender`(IN p_gender_id INT, IN p_new_name VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

UPDATE gender
SET name = p_new_name
WHERE id = p_gender_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_hotel`(IN p_name VARCHAR(50), IN p_address VARCHAR(150), IN p_classification_id INT,
                                 IN p_district_id INT, IN p_hotel_id INT, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

UPDATE hotel
SET name = p_name,
    address = p_address,
    classification_ref = p_classification_id,
    district_ref = p_district_id
WHERE id = p_hotel_id;
    
SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_id_type`(IN p_id_type_id INT, IN p_new_name VARCHAR(50), IN p_max_characters INT, IN p_is_alphanumeric INT, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

UPDATE id_type
SET name = p_new_name,
    max_characters = p_max_characters,
    is_alphanumeric = p_is_alphanumeric
WHERE id = p_id_type_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_nationality`(IN p_nationality_id INT, IN p_new_name VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

UPDATE nationality
SET name = p_new_name
WHERE id = p_nationality_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_parameter`(IN p_parameter_id INT, IN p_name VARCHAR(50), IN p_value DOUBLE, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

UPDATE setting
SET name = p_name,
    value = p_value
WHERE id = p_parameter_id;

COMMIT;

SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_payment_method`(IN p_payment_method_id INT, IN p_new_name VARCHAR(50), OUT execution_code INT)
BEGIN
  
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

UPDATE payment_method 
SET name = p_new_name
WHERE id = p_payment_method_id;

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_phone`(IN pphone_id VARCHAR(50), IN pnew_phone VARCHAR(50), OUT executionCode INT)
BEGIN
    
DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
	BEGIN
        ROLLBACK;
	END;
    
DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET executionCode = -1;
		ROLLBACK;
	END;

UPDATE telephone 
SET telephone_number = pnew_phone 
WHERE id = pphone_id;

SET executionCode = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_province`(IN p_province_id INT, IN p_new_name VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

UPDATE province
SET name = p_new_name
WHERE id = p_province_id;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_room`(IN p_room_id INT, IN p_name VARCHAR(50), IN p_capacity INT, 
                                  IN p_price INT, IN p_units INT, IN p_discount_code VARCHAR(20),
                                  IN p_discount_rate INT, IN p_username VARCHAR(50), OUT execution_code INT)
BEGIN

DECLARE check_ussage INT;
DECLARE v_old_price INT;
DECLARE v_hotel_id INT;
DECLARE v_room_name VARCHAR(50);

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
      ROLLBACK;
END;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

IF (p_discount_code IS NOT NULL) THEN

SELECT COUNT(*)
INTO check_ussage
FROM room
WHERE hotel_ref = (SELECT hotel_ref FROM room WHERE id = p_room_id) 
AND id != p_room_id
AND discount_code = p_discount_code;

IF (check_ussage > 0) THEN
    SET execution_code = -2;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

END IF;

SELECT recommended_price, name, hotel_ref
INTO v_old_price, v_room_name, v_hotel_id
FROM room
WHERE id = p_room_id;

UPDATE room
SET name = p_name, 
    capacity = p_capacity, 
    recommended_price = p_price, 
    discount_code = p_discount_code, 
    discount_rate = p_discount_rate, 
    units = p_units
WHERE id = p_room_id;

DELETE rooms 
FROM reservation_x_room AS rooms
INNER JOIN reservation 
ON rooms.reservation_ref = reservation.id
WHERE rooms.room_ref = p_room_id AND reservation.reservation_status_ref = 3;

IF (v_old_price != p_price) THEN
    INSERT INTO log(username, old_price, new_price, modification_date, room_name, hotel_id)
    VALUES (p_username, v_old_price, p_price, CURDATE(), v_room_name, v_hotel_id);
END IF;

SET execution_code = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user`(IN pusername VARCHAR(50), IN pfirst_name VARCHAR(50), IN psecond_name VARCHAR(50), IN pfirst_surname VARCHAR(50),
                                         IN psecond_surname VARCHAR(50), IN pbirthday DATE, IN pidentification VARCHAR(15), 
                                         IN ppassword VARCHAR(100), IN pphoto MEDIUMBLOB, IN pgender_id INT, IN pid_type_id INT, OUT executionCode INT)
BODY: BEGIN

DECLARE check_identification INT;

DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
  ROLLBACK;
  END;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET executionCode = -1;
    ROLLBACK;
END;

SELECT COUNT(*) INTO check_identification FROM person WHERE identification_number = pidentification AND id_type_ref = pid_type_id AND user_ref != pusername;

IF (check_identification > 0) THEN
SET executionCode = -4;
SIGNAL CUSTOM_EXCEPTION;
END IF;

UPDATE person SET birthdate = pbirthday, first_name = pfirst_name, second_name = psecond_name, first_surname = pfirst_surname,
 second_surname = psecond_surname, identification_number = pidentification, gender_ref = pgender_id, id_type_ref = pid_type_id
WHERE user_ref = pusername;

UPDATE user_table SET photo = pphoto, user_password = ppassword
WHERE username = pusername;

SET executionCode = 0;
COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user_role`(IN p_username VARCHAR(50), IN p_user_type_id INT, IN p_hotel_id INT, OUT execution_code INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -1;
    ROLLBACK;
END;

UPDATE user_table
SET user_type_ref = p_user_type_id
WHERE username = p_username;

IF (p_user_type_id = 1) THEN
    INSERT INTO admin (username, hotel_ref) 
    VALUES (p_username, p_hotel_id)
    ON DUPLICATE KEY UPDATE
    username = p_username,
    hotel_ref = p_hotel_id;

ELSE
    DELETE FROM admin 
    WHERE username = p_username;
    
END IF;

COMMIT;
SET execution_code = 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user_type`(IN p_type_id INT, IN p_name VARCHAR(50), OUT executionCode INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	SET executionCode = -1;
	ROLLBACK;
END;

UPDATE user_type 
SET name = p_name
WHERE id = p_type_id;

SET executionCode = 0;

COMMIT;
END$$
DELIMITER ;
