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