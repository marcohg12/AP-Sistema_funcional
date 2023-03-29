-- Autores: Britnney Murillo, Jefry Cuendiz, Sharon Chacon,Paula Bolaños
-- Fecha de creación: 28/03/2023
--------------------------------------Códigos--------------------------------------
--      0- éxito
--     -1 - error en base
--     -2 - key-id ya existente
--     -3 - email repetido
--     -4 - identificación ya registrada
--     -5 - key-id no existe
--     -6 - email no existe
--     -7 - id telefono no existe
--     -8 - columna queda vacía

-- FUNCIÓN Registra usuario si este no tiene el mismo username, email o numero de identificacion que otro -------------------------------------
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_user`(IN pfirst_name VARCHAR(50), IN psecond_name VARCHAR(50), IN pfirst_surname VARCHAR(50),
                                         IN psecond_surname VARCHAR(50), IN pbirthday DATE, IN pidentification INT, IN pusername VARCHAR(50), 
                                         IN ppassword VARCHAR(35), IN pphoto MEDIUMBLOB, IN pnationality_id INT, IN ptelephone INT,
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

END


-- FUNCIÓN Actualiza usuario solo si este no tiene el mismo numero de identificación que otro ---------------------------------
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user`(IN pusername VARCHAR(50), IN pfirst_name VARCHAR(50), IN psecond_name VARCHAR(50), IN pfirst_surname VARCHAR(50),
                                         IN psecond_surname VARCHAR(50), IN pbirthday DATE, IN pidentification INT, 
                                         IN ppassword VARCHAR(35), IN pphoto MEDIUMBLOB, IN pgender_id INT, IN pid_type_id INT, OUT executionCode INT)
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

SELECT COUNT(*) INTO check_identification FROM person WHERE identification_number = pidentification;

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

END


-- FUNCIÓN Elimina email solo sí no es el único email registrado ------------------------------------------------
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_email`(IN pUsername VARCHAR(50), IN pEmail VARCHAR(50),  OUT executionCode INT)
    READS SQL DATA
BODY: BEGIN

DECLARE amount_emails INT;

SELECT COUNT(DISTINCT email.email) INTO amount_emails
FROM person
JOIN user_table ON person.user_ref = user_table.username
JOIN email ON person.id = email.person_ref
WHERE person.id = person_ref;
    
IF (amount_emails > 1) THEN DELETE FROM email
WHERE person_ref = (SELECT id FROM person 
JOIN user_table ON person.user_ref = user_table.username
WHERE user_table.username = pUsername) 
AND email = pEmail;
SET executionCode = 0;

ELSE 
SET executionCode = -8;
END IF;

END

-- FUNCIÓN Elimina teléfono solo sí no es el único email registrado ------------------------------------------------
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_phone`(IN pUsername VARCHAR(50), IN pPhone INT, OUT executionCode INT)
    READS SQL DATA
BODY: BEGIN

DECLARE amount_phones INT;

SELECT COUNT(DISTINCT telephone.telephone_number) INTO amount_phones
FROM person
JOIN user_table ON person.user_ref = user_table.username
JOIN telephone ON person.id = telephone.person_ref
WHERE person.id = person_ref;

IF (amount_phones > 1) THEN DELETE FROM telephone 
WHERE person_ref = (SELECT id FROM person 
JOIN user_table ON person.user_ref = user_table.username
WHERE user_table.username = pUsername) 
AND telephone_number = pPhone;
SET executionCode = 0;

ELSE 
SET executionCode = -8;
END IF;

END

/*
Funcion add_phone
Recibe un username y el telefono
Si con el usuario brindado no se encuentra, devuelve -5
Si se encuentra, agarra el id de person y agrega telefono y person_ref(id) a telephone 
Devuelve 0 si se agrego exitosamente
*/
DELIMITER //
DROP PROCEDURE IF EXISTS add_phone; // 
CREATE PROCEDURE add_phone(IN p_username VARCHAR(50), IN p_phone int, OUT execution_code INT)
BEGIN
DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE p_id int;
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
  ROLLBACK;
  END;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -5;
    ROLLBACK;
END;


SELECT id into p_id from person where user_ref = p_username;
INSERT INTO telephone(telephone_number, person_ref)
VALUES(p_phone, p_id);
SET execution_code = 0;
COMMIT;

END; // 

/*
Funcion add_email
Recibe un username y el email
Se busca el usuario, si no se encuentra, devuelve -5
Si el correo esta repetido, devuelve -3
Finalmente, se agrega y devuelve 0 de exito
*/
DELIMITER //
DROP PROCEDURE IF EXISTS add_email; // 
CREATE PROCEDURE add_email(IN p_username VARCHAR(50), IN p_email varchar(50), OUT execution_code INT)
BEGIN
DECLARE p_id int;
DECLARE id_check int;
DECLARE email_check int;
DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE EXIT HANDLER FOR SQLSTATE '45000'
  BEGIN
  ROLLBACK;
  END;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    SET execution_code = -5;
    ROLLBACK;
END;

SELECT id into p_id from person where user_ref = p_username;
SELECT COUNT(*) INTO id_check FROM person WHERE user_ref = p_username;
SELECT COUNT(*) INTO email_check FROM email WHERE email = p_email;

if(id_check = 0) then
	SET execution_code = -5;
	SIGNAL CUSTOM_EXCEPTION;
END IF;

if(email_check > 0) then
	SET execution_code = -3;
	SIGNAL CUSTOM_EXCEPTION;
END IF;

INSERT INTO EMAIL(email, person_ref)
VALUES(p_email, p_id);
SET execution_code = 0;

END; // 






