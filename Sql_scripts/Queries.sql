-- Autores: Britnney Murillo, Jefry Cuendiz, Sharon Chacon,Paula Bolaños
-- Fecha de creación: 28/03/2023
--------------------------------------Códigos--------------------------------------
--      0-  éxito
--     -1 - error en base
--     -2 - key-id ya existente
--     -3 - email repetido
--     -4 - identificación ya registrada
--     -5 - key-id no existe
--     -6 - email no existe
--     -7 - id telefono no existe
--     -8 - columna queda vacía
--     -9 - el nombre ya existe
--     -10 - foreing key no existe

-- FUNCIÓN Registra usuario si este no tiene el mismo username, email o numero de identificacion que otro -------------------------------------
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_user`(IN pfirst_name VARCHAR(50), IN psecond_name VARCHAR(50), IN pfirst_surname VARCHAR(50),
                                         IN psecond_surname VARCHAR(50), IN pbirthday DATE, IN pidentification INT, IN pusername VARCHAR(50), 
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

/* 
	PROCESO: Actualizar email
    Retorna 
    -6 : el old_email no existe
    -3 : el new_email que se quiere registrar ya existe
    -5 : el usuario dado no tiene asociado el old_email dado
    -1 : error generico base
     0 : éxito
     
     call update_email('ADG2023', 'marco.herrera@gmail.com', 'marco.h@gmail.com', @executionCode);

*/

drop procedure if exists update_email;
delimiter //
CREATE DEFINER='root'@'localhost' PROCEDURE update_email (IN pusername VARCHAR(50), IN pold_email VARCHAR(50), IN pnew_email VARCHAR(50), OUT executionCode INT) 	 
BODY: BEGIN
	DECLARE check_email bool;
    DECLARE check_username bool;
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
    
    select if(count(email) = 1, true, false) into check_email from email where email = pold_email;
    if check_email = false then
		SET executionCode = -6; -- old_email no existe
        SIGNAL CUSTOM_EXCEPTION;
	else
		select if(count(email) = 1, true, false) into check_email from email where email = pnew_email;
        if check_email = true then
			SET executionCode = -3; -- el nuevo email ya existe
            SIGNAL CUSTOM_EXCEPTION;
		else
			select if(count(email) = 1, true, false) into check_username from email 
			WHERE person_ref = (SELECT id FROM person  JOIN user_table ON person.user_ref = user_table.username
				WHERE user_table.username = pusername) 
			AND   email = pold_email;
            
			if check_username = false then
				SET executionCode = -5; --  el usuario no tiene asociado el telefono dado 
                SIGNAL CUSTOM_EXCEPTION;
			else
				UPDATE email set email = pnew_email WHERE email = pold_email;
				SET executionCode = 0; -- exito 
                COMMIT;
			end if;
		end if;
	end if;
END//


/* 
    PROCESO: Actualizar telefono
    Retorna 
    -7: el id de telefono no existe
    -5 : el usuario dado no tiene asociado el id de telefono dado
    -1 : error generico base
     0 : éxito
     
     call update_phone('ADG2023',1,60987000, @executionCode);

*/
drop procedure if exists update_phone;
delimiter //
CREATE DEFINER='root'@'localhost' PROCEDURE update_phone(IN pusername VARCHAR(50), IN pphone_id VARCHAR(50), IN pnew_phone VARCHAR(50), OUT executionCode INT) 	 
BODY: BEGIN
	DECLARE id_exists bool;
    DECLARE check_username bool;
    
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

	select if(count(id) = 1, true, false) into id_exists from telephone where id = pphone_id;
    if(id_exists) = false then
		SET executionCode = -7;
        SIGNAL CUSTOM_EXCEPTION;
	else
		select if(count(telephone_number) = 1, true, false) into check_username from telephone 
			WHERE person_ref = (SELECT id FROM person  JOIN user_table 
            ON person.user_ref = user_table.username
			WHERE user_table.username = pusername) 
			AND   id = pphone_id;
            
		if(check_username) = false then
			SET executionCode = -5;
            SIGNAL CUSTOM_EXCEPTION;
		else
			UPDATE telephone set telephone_number = pnew_phone where id = pphone_id;
            SET executionCode = 0;
            COMMIT;
		end if;
    end if;
END//

delimiter ;

-- Proceso: registra una nueva amenidad
-- Recibe el nombre y el id del hotel
-- Retorna 0 si se registro con éxito 
-- Retorna -1 si ocurrio algún error y no se registro
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_amenity`(IN pName VARCHAR(50), IN pHotel_id INT, OUT executionCode INT)
BEGIN
DECLARE exitCode INT DEFAULT 0;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	SET executionCode = -1;
	ROLLBACK;
END;

INSERT INTO amenity(id, name, hotel_ref)
VALUES(default, pName, pHotel_id);

SET executionCode = exitCode;
COMMIT;
END

-- Proceso: actualiza el nombre de una amenidad
-- Recibe el id de la amenidad y el nuevo nombre
-- Retorna 0 si se actualizo
-- Retorna -1 si ocurrió algún error 
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_amenity`(IN pAmenity_id INT, IN pNew_name VARCHAR (50), OUT executionCode INT)
BEGIN
DECLARE exitCode INT DEFAULT 0;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	SET executionCode = -1;
	ROLLBACK;
END;

UPDATE amenity SET name = pNew_name
WHERE id = pAmenity_id; 
IF ROW_COUNT() = 0 THEN
        SET executionCode = -1;
        ROLLBACK;
    ELSE
        SET executionCode = exitCode;
        COMMIT;
    END IF;
COMMIT;
END

-- Proceso: eliminar una amenidad
-- Recibe el id de la amenidad
-- Retorna 0 si se elimino con éxito
-- Retorna -1 si ocurrio algún problema
-- Retorna -8 si esta relacionada la amenidad con alguna habitación 
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

SELECT COUNT(*) 
INTO check_ussage 
FROM amenity_x_room
WHERE amenity_ref =  p_amenity_id;

IF (check_ussage > 0) THEN
    SET execution_code = -8;
    SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM amenity
WHERE id = p_amenity_id;

COMMIT;
SET execution_code = 0;
END

--Proceso: registrar un nuevo hotel
-- Recibe el nombre, la dirección, el id del distrito y el id de la clasificacion
-- Retorna 0 si se registro 
-- Retorna -1 si ocurrió algún error 
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_hotel`(IN pName VARCHAR(50), IN pAdress VARCHAR (50), IN pDistrict_id INT, 
															IN pClassification_id INT,  OUT executionCode INT)
BEGIN
DECLARE exitCode INT DEFAULT 0;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	SET executionCode = -1;
	ROLLBACK;
END;

INSERT INTO hotel
VALUES (default, pName, CURDATE(), pAdress, pDistrict_id, pClassification_id);

SET executionCode = exitCode;

COMMIT;
END


-- Proceso: registrar un nuevo metodo de pago
-- Recibe el nombre y el id del hotel
-- Retorna 0 si se registro 
-- Retorna -1 si ocurrió algún error 

CREATE DEFINER=`root`@`localhost` PROCEDURE `register_payment_method`(IN pname VARCHAR(50), IN photel_id INT, OUT executionCode INT)
BODY: BEGIN

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


INSERT INTO payment_method (id, name, hotel_ref)
VALUES (default, pname, photel_id);

SET executionCode = 0;
COMMIT;

END


-- Proceso: actualizar un metodo de pago
-- Recibe el id del metodo a actualizar y el nuevo nombre
-- Retorna 0 si se actualizó
-- Retorna -1 si ocurrió algún error de base
-- Retorna -5 si la id del metodo indicado no existe

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_payment_method`(IN ppayment_method_id INT, IN pnew_name VARCHAR(50), OUT executionCode INT)
BODY: BEGIN
DECLARE check_id INT;

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

SELECT COUNT(*) INTO check_id FROM payment_method WHERE id = ppayment_method_id;

IF (check_id = 0) THEN
SET executionCode =-5;
SIGNAL CUSTOM_EXCEPTION;
END IF;

UPDATE payment_method SET name = pnew_name
WHERE id = ppayment_method_id;

SET executionCode = 0;
COMMIT;

END

-- Proceso: borrar un metodo de pago
-- Recibe el id del metodo a borrar
-- Retorna 0 si se borró
-- Retorna -1 si ocurrió algún error de base
-- Retorna -5 si la id del metodo indicado no existe
-- Retorna -8 si el metodo está siendo usado por una reservación

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_payment_method`(IN ppayment_method_id INT, OUT executionCode INT)
BODY: BEGIN
DECLARE check_id INT;
DECLARE check_usage INT;

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

SELECT COUNT(*) INTO check_id FROM payment_method WHERE id = ppayment_method_id;
SELECT COUNT(*) INTO check_usage FROM reservation WHERE payment_method_ref = ppayment_method_id;

IF (check_id = 0) THEN
SET executionCode =-5;
SIGNAL CUSTOM_EXCEPTION;
END IF;

IF (check_usage > 0) THEN
SET executionCode =-8;
SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM payment_method WHERE id = ppayment_method_id;

SET executionCode = 0;
COMMIT;

END


--Proceso: actualizar un parámetro
-- Recibe el id del parametro a actualizar, el nuevo nombre y el nuevo valor
-- Retorna 0 si se actualizó
-- Retorna -1 si ocurrió algún error de base
-- Retorna -5 si la id del metodo indicado no existe
-- Retorna -9 si ya existe un parámetro con ese nombre

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_parameter`(IN pparameter_id INT, IN pnew_name VARCHAR(50), IN pnew_value DOUBLE, OUT executionCode INT)
BODY: BEGIN
DECLARE check_name INT;
DECLARE check_id INT;

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

SELECT COUNT(*) INTO check_id FROM setting WHERE id = pparameter_id;
SELECT COUNT(*) INTO check_name FROM setting WHERE name = pnew_name;

IF (check_id = 0) THEN
SET executionCode =-5;
SIGNAL CUSTOM_EXCEPTION;
END IF;

IF (check_name > 0) THEN
SET executionCode =-9;
SIGNAL CUSTOM_EXCEPTION;
END IF;

UPDATE setting SET name = pnew_name, value = pnew_value
WHERE id = pparameter_id;

SET executionCode = 0;
COMMIT;

END

-- Proceso: borrar un parámetro
-- Recibe el id del parámetro a borrar
-- Retorna 0 si se borró
-- Retorna -1 si ocurrió algún error de base
-- Retorna -5 si la id del metodo indicado no existe

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_parameter`(IN pparameter_id INT, OUT executionCode INT)
BODY: BEGIN
DECLARE check_id INT;

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

SELECT COUNT(*) INTO check_id FROM setting WHERE id = pparameter_id;

IF (check_id = 0) THEN
SET executionCode =-5;
SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM setting WHERE id = pparameter_id;

SET executionCode = 0;
COMMIT;

END

-- Proceso: obtener la información de una provincia
-- Recibe el id de la provincia a buscar
-- Retorna el id de la provincia, su nombre y un codigo de error
-- El codigo de error retorna 0 si se encuentra
-- El codigo de error retorna -1 si ocurrió algún error de base
-- El codigo de error retorna -5 si la id de la provincia no existe

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_province`(IN pprovince_id INT, OUT province_id INT, OUT province_name VARCHAR(50), OUT executionCode INT)
BODY: BEGIN
DECLARE check_id INT;

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

SELECT COUNT(*) INTO check_id FROM province WHERE id = pprovince_id;

IF (check_id = 0) THEN
SET executionCode =-5;
SIGNAL CUSTOM_EXCEPTION;
END IF;

SELECT id, name INTO province_id, province_name FROM province WHERE id = pprovince_id;

SET executionCode = 0;
COMMIT;

END


-- Proceso: obtener la información de un cantón
-- Recibe el id del cantón a buscar
-- Retorna el id del cantón, su nombre y un codigo de error
-- El codigo de error retorna 0 si se encuentra
-- El codigo de error retorna -1 si ocurrió algún error de base
-- El codigo de error retorna -5 si la id del cantón no existe

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_canton`(IN pcanton_id INT, OUT canton_id INT, OUT canton_name VARCHAR(50), OUT executionCode INT)
BODY: BEGIN
DECLARE check_id INT;

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

SELECT COUNT(*) INTO check_id FROM canton WHERE id = pcanton_id;

IF (check_id = 0) THEN
SET executionCode =-5;
SIGNAL CUSTOM_EXCEPTION;
END IF;

SELECT id, name INTO canton_id, canton_name FROM canton WHERE id = pcanton_id;

SET executionCode = 0;
COMMIT;

END




/*
Funcion Register_cancelation_policy
Registra una politica de cancelacion
retorna el codigo
0 si es exitoso
-1 si falla.
*/
DELIMITER //
DROP PROCEDURE IF EXISTS register_cancelation_policy; // 
CREATE PROCEDURE register_cancelation_policy(in pname varchar(50), in panticipation_time int, in cancelation_fee int, in hotel_id int, OUT execution_code INT)
BEGIN

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

INSERT INTO cancellation_policy( name, anticipation_time, value, hotel_ref)
VALUES(pname,panticipation_time, cancelation_fee , hotel_id);
set execution_code = 0;
commit;
END; // 

/*

/*
Funcion update_cancelation_policy
Recibe una politica
retorna el codigo
edita la politica
0 si es exitoso
-5 si el item no existe
-1 si falla 
*/
DELIMITER //
DROP PROCEDURE IF EXISTS update_cancelation_policy; // 
CREATE PROCEDURE update_cancelation_policy(in policy_id int, in new_name varchar(50), in new_anticipation_time int, in new_cancelation_fee int, OUT execution_code INT)
BEGIN
DECLARE check_id INT; 
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

SELECT COUNT(*) INTO check_id FROM cancellation_policy WHERE id = policy_id;

IF (check_id = 0) THEN
SET execution_code =-5;
SIGNAL CUSTOM_EXCEPTION;
END IF;

UPDATE reservation_system.cancellation_policy 
SET name = new_name, 
anticipation_time = new_anticipation_time,
value = new_cancelation_fee
WHERE id = policy_id;
SET execution_code = 0;

COMMIT;

END; // 

/*

/*
Funcion Delete_cancelation_policy
Recibe una politica
retorna el codigo
borra la politica
0 si es exitoso
-5 si el item no existe
-1 si falla 
*/
DELIMITER //
DROP PROCEDURE IF EXISTS delete_cancelation_policy; // 
CREATE PROCEDURE delete_cancelation_policy(in policy_id int, OUT execution_code INT)
BEGIN
DECLARE check_id INT; 
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

SELECT COUNT(*) INTO check_id FROM cancellation_policy WHERE id = policy_id;

IF (check_id = 0) THEN
SET execution_code =-5;
SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM cancellation_policy WHERE id = policy_id;
SET execution_code = 0;

COMMIT;

END; // 

/*


/*
Funcion update_hotel
Recibe un hotel y sus parametros
retorna el codigo
edita el hotel
0 si es exitoso
-5 si el item no existe
-1 si falla 
*/
DELIMITER //
DROP PROCEDURE IF EXISTS update_hotel; // 
CREATE PROCEDURE update_hotel(in hotel_id int , new_name VARCHAR(50) , in new_address VARCHAR(150), in district_id int, in classification_id int , OUT execution_code INT)
BEGIN
DECLARE check_id INT; 
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

SELECT COUNT(*) INTO check_id FROM hotel WHERE id = hotel_id;

IF (check_id = 0) THEN
SET execution_code =-5;
SIGNAL CUSTOM_EXCEPTION;
END IF;

UPDATE reservation_system.hotel 
SET name = new_name, 
address = new_address,
district_ref = district_id,
classification_ref =classification_id
WHERE id = hotel_id;
SET execution_code = 0;

COMMIT;

END; // 

/*



/*
Funcion register_deal
Recibe un deal en offer
retorna el codigo
0 si es exitoso
-1 si falla.
*/
DELIMITER //
DROP PROCEDURE IF EXISTS register_deal; // 
CREATE PROCEDURE register_deal(in pname varchar(50), in pstart_date date, in pending_date date,in pdiscount_rate int,in pminimum_days int , IN photel_id int , OUT execution_code INT)
BEGIN

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

INSERT INTO offer(name, start_date, ending_date, discount_rate, minimun_reservation_days, hotel_ref)
VALUES(pname,pstart_date, pending_date , pdiscount_rate,pminimum_days , photel_id);
set execution_code = 0;

END; // 

/*


/*
Funcion update_deal
Recibe un deal y sus parametros
retorna el codigo
0 si es exitoso
-5 si el item no existe
-1 si falla 
*/
DELIMITER //
DROP PROCEDURE IF EXISTS update_deal; // 
CREATE PROCEDURE update_deal(in deal_id int, in new_name varchar(50) ,in new_start_date date, in new_ending_date date, in new_discount_rate int, in new_minimum_days int, OUT execution_code INT)
BEGIN
DECLARE check_id INT; 
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

SELECT COUNT(*) INTO check_id FROM offer WHERE id = deal_id;

IF (check_id = 0) THEN
SET execution_code =-5;
SIGNAL CUSTOM_EXCEPTION;
END IF;

UPDATE reservation_system.offer 
SET name = new_name, 
start_date =new_start_date , 
ending_date =new_ending_date , 
discount_rate = new_discount_rate, 
minimun_reservation_days = new_minimum_days
WHERE id = deal_id;
SET execution_code = 0;

COMMIT;

END; // 

/*

/*
Funcion Delete_deal
Recibe un deal
retorna el codigo
borra el deal en offer
0 si es exitoso
-5 si el item no existe
-1 si falla 
*/
DELIMITER //
DROP PROCEDURE IF EXISTS delete_deal; // 
CREATE PROCEDURE delete_deal(in deal_id int, OUT execution_code INT)
BEGIN
DECLARE check_id INT; 
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

SELECT COUNT(*) INTO check_id FROM offer WHERE id = deal_id;

IF (check_id = 0) THEN
SET execution_code =-5;
SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE from offer where id =deal_id; 
SET execution_code = 0;

COMMIT;

END; // 

/*


/* 
	PROCESO: Registrar cuarto
    Retorna 
    -10 : el hotel a asociar no existe
    -1 : error generico base
     0 : éxito
     
     INSERT INTO room VALUES(default, 'Habitación 200', 5, 800, 0, 0,1);

*/
drop procedure if exists register_room;
delimiter $$
CREATE DEFINER='root'@'localhost' PROCEDURE register_room (IN pname VARCHAR(50), IN pcapacity int, IN pprice int,IN pdiscount_code int,IN pdiscount_rate int, IN photel_id int,OUT execution_code INT) 	 
BODY: BEGIN
	DECLARE check_hotel bool;
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
    
    select if(count(id) = 1, true, false) into check_hotel from hotel where id = photel_id;
    if(check_hotel) = false then 
		SET execution_code = -10;
        SIGNAL CUSTOM_EXCEPTION;
	else
		INSERT INTO room VALUES(default,pname, pcapacity, pprice, pdiscount_code, pdiscount_rate, photel_id);
        SET execution_code = 0;
        COMMIT;
	end IF;
    
END$$


/* 
	PROCESO: Actualizar cuarto
    Retorna 
    -5 : el id del cuarto no existe
    -1 : error generico base
     0 : éxito
     
     call register_room('Habitación 2.0', 5, 800, 0, 0,1, @execution_code);

*/
drop procedure if exists update_room;
delimiter $$
CREATE DEFINER='root'@'localhost' PROCEDURE update_room (IN room_id int,IN new_name VARCHAR(50), IN new_capacity int, IN new_price int,IN new_discount_code int,IN new_discount_rate int,OUT execution_code INT) 	 
BODY: BEGIN
	DECLARE check_room bool;
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
    
    select if(count(id) = 1, true, false) into check_room from room where id = room_id;
    if(check_room) = false then 
		SET execution_code = -5;
        SIGNAL CUSTOM_EXCEPTION;
	else
        UPDATE room set 
        name = new_name,
        capacity = new_capacity,
        recommended_price = new_price,
        discount_code = new_discount_code,
        discount_rate = new_discount_rate
        where id = room_id;
        SET execution_code = 0;
        COMMIT;
	end IF;
    
END$$


/* 
	PROCESO: Eliminar cuarto
    Retorna 
    -5 : el id del cuarto no existe
    -1 : error generico base
     0 : éxito
     
     call delete_room(2, @execution_code);

*/
drop procedure if exists delete_room;
delimiter $$
CREATE DEFINER='root'@'localhost' PROCEDURE delete_room (IN room_id int, OUT execution_code INT) 	 
BODY: BEGIN
	DECLARE check_room bool;
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
    
    select if(count(id) = 1, true, false) into check_room from room where id = room_id;
    if(check_room) = false then 
		SET execution_code = -5;
        SIGNAL CUSTOM_EXCEPTION;
	else
        DELETE FROM room where id = room_id;
        SET execution_code = 0;
        COMMIT;
	end IF;
    
END$$


/* 
	PROCESO: Actualizar clasificación
    Retorna 
    -5 : el id de clasificación no existe
    -1 : error generico base
     0 : éxito
     
     call update_classification(1, "actualizando clasi", @execution_code);

*/
drop procedure if exists update_classification;
delimiter $$
CREATE DEFINER='root'@'localhost' PROCEDURE update_classification (IN classification_id int,IN new_name VARCHAR(50), OUT execution_code INT) 	 
BODY: BEGIN
	DECLARE check_classification bool;
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
    
    select if(count(id) = 1, true, false) into check_classification from classification where id = classification_id;
    if(check_classification) = false then 
		SET execution_code = -5;
        SIGNAL CUSTOM_EXCEPTION;
	else
        UPDATE classification SET NAME = new_name where id = classification_id;
        SET execution_code = 0;
        COMMIT;
	end IF;
    
END$$

/* 
	PROCESO: Eliminar clasificación
    Retorna 
    -5 : el id de clasificación no existe
    -1 : error generico base
     0 : éxito
     
     call delete_classification(2, @execution_code);

*/
drop procedure if exists delete_classification;
delimiter $$
CREATE DEFINER='root'@'localhost' PROCEDURE delete_classification (IN classification_id int, OUT execution_code INT) 	 
BODY: BEGIN
	DECLARE check_classification bool;
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
    
    select if(count(id) = 1, true, false) into check_classification from classification where id = classification_id;
    if(check_classification) = false then 
		SET execution_code = -5;
        SIGNAL CUSTOM_EXCEPTION;
	else
        DELETE FROM classification where id = classification_id;
        SET execution_code = 0;
        COMMIT;
	end IF;
    
END$$



/* 
	PROCESO: get distrito
    Retorna 
    -5 : el id del distrito no existe
    -1 : error generico base
     0 : éxito
     
     call get_district(1, @execution_code);

*/
drop procedure if exists get_district;
delimiter $$
CREATE DEFINER='root'@'localhost' PROCEDURE get_district (IN district_id int, OUT execution_code INT) 	 
BODY: BEGIN
	DECLARE check_district bool;
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
    
    select if(count(id) = 1, true, false) into check_district from district where id = district_id;
    if(check_district) = false then 
		SET execution_code = -5;
        SIGNAL CUSTOM_EXCEPTION;
	else
        SELECT id, name FROM district where id = district_id;
        SET execution_code = 0;
        COMMIT;
	end IF;
    
END$$







/*
Funcion get_room_detail
recibe el id del cuarto
devuelve los detalles y el codigo que indica:
0 si es exitoso
-1 si falla.
-5 si el cuarto no es encontrado.
*/
DELIMITER //
DROP PROCEDURE IF EXISTS get_room_detail; // 
CREATE PROCEDURE get_room_detail(in room_id int, out rname varchar(50), out rcapacity int, out r_price int , out r_discount_code int, out r_discount_rate int, out runits int, out hotel_id int,  OUT execution_code INT)
BEGIN
DECLARE check_id INT;
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

SELECT COUNT(*) INTO check_id FROM room WHERE id = room_id;

IF (check_id = 0) THEN
SET execution_code =-5;
SIGNAL CUSTOM_EXCEPTION;
END IF;

SELECT name , capacity , recommended_price , discount_code, discount_rate, units, hotel_ref
into rname, rcapacity, r_price, r_discount_code, r_discount_rate, runits, hotel_id
from room where id = room_id;

SET execution_code = 0;
COMMIT;
END; // 

/*

/*
Funcion get_hotel_payment_methods
retorna los metodos asociados al hotel
recibe el id del hotel
*/
DELIMITER //
DROP PROCEDURE IF EXISTS get_hotel_payment_methods; // 
CREATE PROCEDURE get_hotel_payment_methods(in hotel_id int)
BEGIN
SELECT id, name from payment_method where hotel_ref = hotel_id;
END; // 

/*


/*
Funcion get_hotel_rooms
retorna los cuartos asociados a un hotel
recibe el id del hotel
*/
DELIMITER //
DROP PROCEDURE IF EXISTS get_hotel_rooms; // 
CREATE PROCEDURE get_hotel_rooms(in hotel_id int)
BEGIN


SELECT id, name, capacity, recommended_price, discount_code, discount_rate, units from room where hotel_ref = hotel_id;
END; // 

/*

/*
Funcion get_hotel_amenities
retorna los amenities del hotel
recibe el id del hotel
*/
DELIMITER //
DROP PROCEDURE IF EXISTS get_hotel_amenities; // 
CREATE PROCEDURE get_hotel_amenities(in hotel_id int)
BEGIN


SELECT id, name from amenity where hotel_ref = hotel_id;
END; // 

/*



/*
Funcion add_hotel_to_favorites
Registra un favorito
retorna el codigo
0 si es exitoso
-1 fallo generico
-2 ya se encuentra el favorito registrado.
-10 si el user no existe
-11 si el hotel no existe
*/
DELIMITER //
DROP PROCEDURE IF EXISTS add_hotel_to_favorites; // 
CREATE PROCEDURE add_hotel_to_favorites(in username varchar(50), in hotel_id int, OUT execution_code INT)
BEGIN
DECLARE check_id INT;
DECLARE check_hotel INT;
DECLARE check_user INT; 
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
SELECT COUNT(*) INTO check_id from hotel_x_user where hotel_ref = hotel_id and user_ref = username;
SELECT COUNT(*) INTO check_hotel from hotel where id = hotel_id;
SELECT COUNT(*) INTO check_user from user_table where user_table.username = username;

IF (check_id > 0) THEN
SET execution_code =-2;
SIGNAL CUSTOM_EXCEPTION;
END IF;

IF (check_hotel = 0) THEN
SET execution_code =-10;
SIGNAL CUSTOM_EXCEPTION;
END IF;

IF (check_user = 0) THEN
SET execution_code =-11;
SIGNAL CUSTOM_EXCEPTION;
END IF;


INSERT INTO hotel_x_user(hotel_ref, user_ref)
VALUES(hotel_id, username);
set execution_code = 0;
commit;
END; // 

/*


/*
Funcion delete_hotel_from_favorites
borra un favorito del usuario
retorna el codigo
0 si es exitoso
-1 fallo generico
-5 fila no encontrada
*/
DELIMITER //
DROP PROCEDURE IF EXISTS delete_hotel_from_favorites; // 
CREATE PROCEDURE delete_hotel_from_favorites(in username varchar(50), in hotel_id int, OUT execution_code INT)
BEGIN
DECLARE check_id INT;
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
SELECT COUNT(*) INTO check_id from hotel_x_user where hotel_ref = hotel_id and user_ref = username;

IF (check_id = 0) THEN
SET execution_code =-5;
SIGNAL CUSTOM_EXCEPTION;
END IF;

DELETE FROM hotel_x_user where hotel_ref = hotel_id and user_ref = username; 
SET execution_code = 0;
commit;
END; // 

/*

/*
Funcion get_hotel_reviews
devuelve las reviews con el siguiente orden
estrellas, usuario y id de reserva.
*/
DELIMITER //
DROP PROCEDURE IF EXISTS get_hotel_reviews; // 
CREATE PROCEDURE get_hotel_reviews(in hotel_id int)
BEGIN

SELECT re.user_ref, r.stars, re.id from reservation re
inner join review r
on r.reservation_ref = re.id and re.hotel_ref = hotel_id;
END; // 

/*
/*
Funcion get_hotel_deals
devuelve las ofertas del hotel
recibe el hotel
*/
DELIMITER //
DROP PROCEDURE IF EXISTS get_hotel_deals; // 
CREATE PROCEDURE get_hotel_deals(in hotel_id int)
BEGIN

SELECT f.id , f.name, f.start_date, f.ending_date, f.discount_rate, f.minimun_reservation_days from offer f
where f.hotel_ref = hotel_id;

END; // 

/*
*/
-- Proceso: retornar los detalles de una oferta
-- Recibe: el id de la oferta
-- Retorna: nombre, fecha de inicio, fecha final, descuento, minimo de días
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_deal_details`(IN deal_id INT)
BEGIN

SELECT name, start_date, ending_date, discount_rate, minimun_reservation_days 
FROM offer
WHERE id = deal_id;

END //

-- Proceso: retornar la información de las habitaciones en una reserva
-- Recibe: el id de la reserva
-- Retorna: id de la habitación, nombre, precio, precio en oferta, capacidad, unidades
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_rooms_in_booking`(IN booking_id INT)
BEGIN
DECLARE id_room INT;
DECLARE price_offer INT;

SELECT room.id
INTO id_room FROM room 
JOIN reservation_x_room ON reservation_x_room.room_ref = room.id
WHERE reservation_x_room.reservation_ref = booking_id;

SET price_offer = get_current_room_price(id_room);

SELECT room.id, room.name, room.capacity, room.recommended_price, reservation_x_room.units, price_offer
FROM room JOIN reservation_x_room ON reservation_x_room.room_ref = room.id
WHERE reservation_x_room.reservation_ref = booking_id;

END//

-- Proceso: retornar la información de las habitaciones de un hotel
-- Recibe: el id del hotel
-- Retorna: id de la habitación, nombre, precio, precio en oferta, capacidad
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_rooms_to_book`(IN hotel_id INT)
BEGIN
DECLARE id_room INT;
DECLARE price_offer INT;

SELECT room.id
INTO id_room FROM room 
WHERE room.hotel_ref = hotel_id;

SET price_offer = get_current_room_price(id_room);

SELECT room.id, room.name, room.capacity, room.recommended_price, price_offer
FROM room 
WHERE room.hotel_ref = hotel_id;

END//

-- Proceso: retornar la información de las habitaciones relacionadas a una oferta
-- Recibe: el id de la oferta
-- Retorna: id de la habitación, nombre, precio, precio en oferta, capacidad, código de descuento,
-- descuento, id del hotel
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_rooms_in_deal`(IN deal_id INT)
BEGIN
DECLARE id_room INT;
DECLARE price_offer INT;

SELECT room.id
INTO id_room FROM room 
JOIN offer_x_room ON offer_x_room.room_ref = room.id
WHERE offer_x_room.offer_ref = deal_id;

SET price_offer = get_current_room_price(id_room); 

SELECT room.id, room.name, room.capacity, room.recommended_price, room.discount_code, 
room.discount_rate, room.hotel_ref, price_offer
FROM room JOIN offer_x_room ON offer_x_room.room_ref = room.id
WHERE offer_x_room.offer_ref = deal_id;

END//

-- Proceso: retornar los comentarios de un hotel 
-- Recibe: el id del hotel
-- Retorna: el id del comentario, la fecha y el comentario
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotel_comments`(IN hotel_id INT)
BEGIN

SELECT commentary.id, commentary.commentary_date, commentary.commentary
FROM commentary 
JOIN reservation ON reservation.id = commentary.reservation_ref
WHERE reservation.hotel_ref = hotel_id;

COMMIT;
END//

/* 
	PROCESO: get_booking_detail
    Retorna 
	-5 : booking_id no existe
    -1 : error generico base
     0 : éxito
     
     call get_booking_detail(1,@execution_code);

*/
drop procedure if exists get_booking_detail;
delimiter //
CREATE DEFINER='root'@'localhost' PROCEDURE get_booking_detail(IN booking_id int,  OUT execution_code INT) 	 
BODY: BEGIN
	DECLARE check_booking float;
	DECLARE iva float;
    DECLARE rooms int;
    DECLARE pprice float;
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
    
    select if(count(id) = 1, true, false) into check_booking from reservation where id = booking_id;
    if(check_booking) = false then 
		SET execution_code = -5;
        SIGNAL CUSTOM_EXCEPTION;
	else
		select value + 1 into iva from setting where name = 'IVA';
		select SUM(price) into pprice from reservation_x_room where reservation_ref = booking_id;
		select SUM(units) into rooms from reservation_x_room where reservation_ref = booking_id;

		select reservation.check_in_date, reservation.check_out_date, reservation_status.name AS status_name, reservation.reservation_status_ref AS status_id, 
		TIMESTAMPDIFF(DAY, reservation.check_in_date, reservation.check_out_date) AS noches, 
		rooms, pprice, ROUND(pprice * iva)  as iva_price, payment_method.name AS metodo_pago
		FROM reservation
		JOIN reservation_status ON
		reservation_status.id = reservation.reservation_status_ref
		JOIN payment_method ON
		payment_method.id = reservation.payment_method_ref
		JOIN reservation_x_room ON
		reservation_ref = reservation.id
		WHERE reservation.id = booking_id
		LIMIT 1;
        SET execution_code = 0;
        COMMIT;
	end IF;
    
END//


