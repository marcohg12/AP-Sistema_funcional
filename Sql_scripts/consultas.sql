-- Queries de consultas 
-- Creado por: Alejandro Alfaro, Juleisy Porras, Nelson Alvarado, Bianka Mora

-- Consulta que recupera todos los hoteles junto a su fecha de registro, total de habitaciones,
-- total de reservas y total facturado.
-- Permite filtrar por nombre de hotel, o rango de fecha de registro.
DROP PROCEDURE IF EXISTS get_hotels_query;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotels_query`(IN pHotel_name VARCHAR(50), pStart_date VARCHAR(50), pEnding_date VARCHAR(50))
BEGIN
	SELECT h.name AS 'Nombre', h.registration_date AS 'Fecha de registro', IFNULL(CONCAT(r.hotel_ref) * r.units, 0) AS 'Total de habitaciones', COUNT(re.hotel_ref) AS 'Total de reservas', IFNULL(SUM(rxr.price) * rxr.units, 0) AS 'Total facturado'     
	FROM hotel h     
	LEFT JOIN room r     
	ON h.id = r.hotel_ref     
	LEFT JOIN reservation re     
	ON h.id = re.hotel_ref     
	LEFT JOIN reservation_x_room rxr     
	ON re.id = rxr.reservation_ref          
	WHERE h.name = IFNULL(NULLIF(pHotel_name, ''), h.name)   
	AND (h.registration_date BETWEEN IFNULL(STR_TO_DATE(NULLIF(pStart_date,''), '%d/%m/%Y %H:%i:%s'),   STR_TO_DATE('01/01/1000 00:00:00', '%d/%m/%Y %H:%i:%s'))  
	AND IFNULL(STR_TO_DATE(NULLIF(pEnding_date,''), '%d/%m/%Y %H:%i:%s'), SYSDATE()))
	GROUP BY h.name;
END$$
DELIMITER ;

-- Consulta que recupera el top "n" de los dias con mayor numero de reservas de un hotel
DROP PROCEDURE IF EXISTS get_top_n_days_with_most_booking;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_days_with_most_booking`(IN photel_id INT, ptop_n INT) 
BEGIN
    SELECT confirmation_date AS Fecha_del_dia, COUNT(*) AS Total_reservas_concretadas
    FROM reservation
    WHERE hotel_ref = photel_id
    GROUP BY Fecha_del_dia
    ORDER BY Total_reservas_concretadas DESC
    LIMIT ptop_n;
END $$
DELIMITER ;

-- Consulta que recupera el top "n" de los dias con menor numero de reservas de un hotel
DROP PROCEDURE IF EXISTS get_top_n_days_with_fewer_booking;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_days_with_fewer_booking`(IN photel_id INT, ptop_n INT) 
BEGIN
	SELECT confirmation_date AS Fecha_del_dia, COUNT(*) AS Total_reservas_concretadas
    FROM reservation
    WHERE hotel_ref = photel_id
    GROUP BY Fecha_del_dia
    ORDER BY Total_reservas_concretadas ASC
    LIMIT ptop_n;
END $$
DELIMITER ;

-- Consulta que recupera todas las reviews para un hotel junto al usuario que la hizo, la fecha de checkin
-- y checkout, y sus respectivos comentarios si los hubiera.
DROP PROCEDURE IF EXISTS get_hotel_review_average_report;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotel_review_average_report`(IN pHotel_id INT)
BEGIN
	SELECT reservation.id AS 'Booking', review.stars AS 'Estrellas', user_table.username AS 'Usuario', reservation.check_in_date AS 'Check-in', reservation.check_out_date AS 'Check-out'    
	FROM reservation    
	INNER JOIN review     
	ON review.reservation_ref = reservation.id     
	INNER JOIN user_table     
	ON user_table.username = reservation.user_ref     
	WHERE reservation.hotel_ref = pHotel_id
	GROUP BY reservation.id;
END$$
DELIMITER ;

-- Consulta que recupera todos los comentarios de una reserva
DROP PROCEDURE IF EXISTS get_reservation_comments;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_reservation_comments`(IN pReservation_id INT)
BEGIN
	SELECT commentary.commentary_date AS 'Fecha del comentario', commentary.commentary AS 'Comentario'    
	FROM commentary
	WHERE commentary.reservation_ref = pReservation_id;
END$$
DELIMITER ;


-- Consulta que obtiene el porcentaje de las reviews de un respectivo hotel
DROP PROCEDURE IF EXISTS get_review_average;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_review_average`(IN pHotel_id INT)
BEGIN
    SELECT  IFNULL(SUM(review.stars)/COUNT(review.id),0)  AS "Promedio"
    FROM reservation
    INNER JOIN review
    ON review.reservation_ref = reservation.id
    WHERE reservation.hotel_ref = pHotel_id;
END$$
DELIMITER ;



-- Consulta que obtiene las ofertas de un hotel y el monto facturado por filtros de fecha
DROP PROCEDURE IF EXISTS get_deals_report;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_deals_report`(IN pHotel_id INT, pStart_date VARCHAR(50), pEnding_date VARCHAR(50))
BEGIN
	
	SELECT o.name as 'Nombre', h.name as "Hotel",  o.discount_rate as "Descuento", 
		   o.minimun_reservation_days as "Cantidad de Días", o.start_date as "Inicio", o.ending_date as "Final"
           , IFNULL(SUM(rxr.price * rxr.units * (get_reservated_days(rxr.reservation_ref) - 1) ), 0) as "Total facturado"
    FROM offer o
    INNER JOIN hotel h
    ON h.id = o.hotel_ref
    LEFT JOIN offer_x_room oxr
    ON oxr.offer_ref = o.id
    LEFT JOIN room r
    ON oxr.room_ref = r.id
    LEFT JOIN reservation_x_room rxr
    ON rxr.room_ref = r.id
    LEFT JOIN reservation re     
	ON re.hotel_ref = r.hotel_ref 
    WHERE o.hotel_ref = pHotel_id AND o.start_date >= IFNULL(STR_TO_DATE(NULLIF(pStart_date,''), '%d/%m/%Y'), STR_TO_DATE('01/01/1000 00:00:00', '%d/%m/%Y'))  
	AND o.ending_date <= IFNULL(STR_TO_DATE(NULLIF(pEnding_date,''), '%d/%m/%Y'), SYSDATE())
    GROUP BY o.id;
END$$
DELIMITER ;