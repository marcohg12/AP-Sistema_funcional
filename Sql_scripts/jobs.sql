DELIMITER //
DROP EVENT IF EXISTS generate_view_with_deals; //
CREATE EVENT generate_view_with_deals ON SCHEDULE 
EVERY 1 DAY
STARTS '2023-05-13 19:38:00' ON COMPLETION PRESERVE ENABLE 
DO
BEGIN
DROP VIEW IF EXISTS deals_view;
CREATE VIEW deals_view AS

SELECT offer.id AS offer_id, offer.name AS offer_name, offer.start_date AS start_date,
       offer.ending_date AS ending_date, hotel.id AS hotel_id, hotel.name AS hotel_name, 
       province.id AS province_id, country.id AS country_id
FROM offer
INNER JOIN hotel
ON offer.hotel_ref = hotel.id
INNER JOIN district
ON hotel.district_ref = district.id
INNER JOIN canton
ON district.canton_ref = canton.id
INNER JOIN province
ON canton.province_ref = province.id
INNER JOIN country
ON province.country_ref = country.id
WHERE ((CURDATE() BETWEEN offer.start_date AND offer.ending_date) OR (CURDATE() <= offer.ending_date));

END;
//

DELIMITER //
DROP EVENT IF EXISTS generate_view_with_rooms; //
CREATE EVENT generate_view_with_rooms ON SCHEDULE 
EVERY 1 DAY
STARTS '2023-05-13 07:00:00' ON COMPLETION PRESERVE ENABLE 
DO
BEGIN
DROP VIEW IF EXISTS rooms_view;
CREATE VIEW rooms_view AS

SELECT room.name, room.capacity, room.recommended_price, room.units, 
       (room.units - GET_ROOM_UNITS_RESERVATED(room.id)) AS units_available,
       room.hotel_ref AS hotel_id
FROM room;

END;
//