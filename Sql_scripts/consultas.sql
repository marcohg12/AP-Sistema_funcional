-- Queries de consultas 
-- Creado por: Alejandro Alfaro, Juleisy Porras, Nelson Navarro, Bianka Mora

-- Consulta que recupera todos los hoteles junto a su fecha de registro, total de habitaciones,
-- total de reservas y total facturado.
-- Permite filtrar por nombre de hotel, o rango de fecha de registro.
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotels_query`(IN pHotel_name VARCHAR(50), pStart_date VARCHAR(50), pEnding_date VARCHAR(50)) BEGIN
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
