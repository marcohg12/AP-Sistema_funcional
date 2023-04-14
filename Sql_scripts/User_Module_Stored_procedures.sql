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
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_id_types`()
BEGIN
    SELECT id, name
    FROM id_type;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_person_data`(IN pUsername VARCHAR(50))
BEGIN

SELECT CONCAT(first_name, ' ',second_name) AS name, CONCAT(first_surname, ' ', second_surname) AS last_name, birthdate,
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_by_username`(IN pUsername VARCHAR(50))
BEGIN
    SELECT user_table.username, user_password, photo, user_type_ref, admin.hotel_ref, user_table.hotel_ref AS hotel_client_id
    FROM user_table
    LEFT JOIN admin
    ON user_table.username = admin.username
    WHERE user_table.username = pUsername;
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
SELECT COUNT(*) INTO check_identification FROM person WHERE identification_number = pidentification;

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
VALUES (pusername, 1, pphoto, ppassword, null);

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

SELECT COUNT(*) INTO check_identification FROM person WHERE identification_number = pidentification AND user_ref != pusername;

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
