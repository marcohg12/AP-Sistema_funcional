DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_booking_price`(p_booking_id INT) RETURNS double
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE price DOUBLE;

SELECT IFNULL(SUM(IFNULL(reservation_x_room.price, GET_CURRENT_ROOM_PRICE_IN_BOOKING(room.id, p_booking_id)) * reservation_x_room.units), 0)
INTO price
FROM reservation_x_room
INNER JOIN room
ON reservation_x_room.room_ref = room.id
WHERE reservation_x_room.reservation_ref = p_booking_id;

RETURN (price * (GET_RESERVATED_DAYS(p_booking_id)-1));
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_booking_price_with_fee`(p_booking_id INT) RETURNS double
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE price_with_fee DOUBLE;
DECLARE fee DOUBLE;
DECLARE price DOUBLE;

SELECT value
INTO fee
FROM setting
WHERE id = 1;

SELECT GET_BOOKING_PRICE(p_booking_id)
INTO price;

SET price_with_fee = price + IFNULL((price * fee), 0);

RETURN price_with_fee;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_current_offer_id_from_room`(p_room_id INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE offer_id INT;

SET offer_id = -1;

SELECT offer.id
INTO offer_id
FROM offer
INNER JOIN offer_x_room
ON offer.id = offer_x_room.offer_ref
INNER JOIN room
ON offer_x_room.room_ref = room.id
WHERE room.id = p_room_id AND (CURDATE() BETWEEN offer.start_date AND offer.ending_date);

RETURN offer_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_current_room_price`(p_room_id INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE current_price INT;
DECLARE offer_id INT;
DECLARE offer_discount INT;

SELECT recommended_price
INTO current_price
FROM room
WHERE id = p_room_id;

SELECT offer.id, offer.discount_rate
INTO offer_id, offer_discount
FROM offer
INNER JOIN offer_x_room
ON offer.id = offer_x_room.offer_ref
INNER JOIN room
ON offer_x_room.room_ref = room.id
WHERE room.id = p_room_id AND (CURDATE() BETWEEN offer.start_date AND offer.ending_date);

IF (offer_id IS NOT NULL) THEN
    SET current_price = current_price  * (1 - (offer_discount/100));
END IF;

RETURN current_price;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_current_room_price_in_booking`(p_room_id INT, p_booking_id INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE current_price INT;
DECLARE offer_id INT;
DECLARE offer_discount INT;
DECLARE minimun_days INT;

SELECT recommended_price
INTO current_price
FROM room
WHERE id = p_room_id;

SELECT offer.id, offer.discount_rate, offer.minimun_reservation_days
INTO offer_id, offer_discount, minimun_days
FROM offer
INNER JOIN offer_x_room
ON offer.id = offer_x_room.offer_ref
INNER JOIN room
ON offer_x_room.room_ref = room.id
WHERE room.id = p_room_id AND (CURDATE() BETWEEN offer.start_date AND offer.ending_date);

IF (offer_id IS NOT NULL AND GET_RESERVATED_DAYS(p_booking_id) >= minimun_days) THEN
    SET current_price = current_price  * (1 - (offer_discount/100));
END IF;

RETURN current_price;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_deal_profit`(p_deal_id INT) RETURNS double
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE profit DOUBLE;
DECLARE fee DOUBLE;

SELECT value
INTO fee
FROM setting
WHERE id = 1;

SELECT IFNULL(SUM(sums),0)
INTO profit
FROM(
SELECT IFNULL(
CASE
WHEN reservation_status_ref = 1 THEN 
SUM(reservation_x_room.price * (GET_RESERVATED_DAYS(reservation.id)-1) * reservation_x_room.units)
WHEN reservation_status_ref = 2 THEN 
SUM(reservation_x_room.price * (GET_RESERVATED_DAYS(reservation.id)-1) * reservation_x_room.units * (cancellation_policy.value / 100))
ELSE 0 END, 0) AS sums
FROM offer
INNER JOIN offer_x_room
ON offer.id = offer_x_room.offer_ref
INNER JOIN room
ON offer_x_room.room_ref = room.id
INNER JOIN reservation_x_room
ON room.id = reservation_x_room.room_ref
INNER JOIN reservation
ON reservation_x_room.reservation_ref = reservation.id
LEFT JOIN cancellation_policy
ON reservation.cancellation_policy_ref = cancellation_policy.id
WHERE offer.id = p_deal_id
GROUP BY reservation.reservation_status_ref) partial_sums;

SET profit = profit + (profit * fee);
RETURN profit;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_hotel_location`(p_hotel_id INT) RETURNS varchar(400) CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE location VARCHAR(400);

SELECT CONCAT(hotel.address, ', ', district.name, ', ', canton.name, ', ', province.name, ', ', country.name)
INTO location
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

RETURN location;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_hotel_profit`(p_hotel_id INT) RETURNS double
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE profit DOUBLE;
DECLARE fee DOUBLE;

SELECT SUM(IF(reservation.reservation_status_ref = 1, reservation_x_room.units * reservation_x_room.price * (GET_RESERVATED_DAYS(reservation.id)-1), 
             (reservation_x_room.units * reservation_x_room.price * (GET_RESERVATED_DAYS(reservation.id)-1)) * ((cancellation_policy.value/100))))
INTO profit
FROM reservation_x_room
INNER JOIN reservation
ON reservation_x_room.reservation_ref = reservation.id
LEFT JOIN cancellation_policy
ON reservation.cancellation_policy_ref = cancellation_policy.id
WHERE reservation.hotel_ref = p_hotel_id AND reservation.reservation_status_ref != 3;

IF (profit IS NULL) THEN
    RETURN 0;
ELSE
    SELECT value
    INTO fee
    FROM setting
    WHERE id = 1;
    
    SET profit = ROUND(profit + (profit * fee),2);
    
    RETURN profit;
END IF;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_person_complete_name`(p_person_id INT) RETURNS varchar(200) CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE complete_name VARCHAR(200);

SELECT CONCAT(first_name, IFNULL(NULLIF(CONCAT(' ', second_name), ' '), ''), ' ', first_surname, IFNULL(NULLIF(CONCAT(' ', second_SURNAME), ' '), ''))
INTO complete_name
FROM person
WHERE id = p_person_id;

RETURN complete_name;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_reservated_days`(p_booking_id INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE count INT;

SELECT DATEDIFF(check_out_date, check_in_date) + 1
INTO count
FROM reservation
WHERE id = p_booking_id;

RETURN count;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_room_count_in_booking`(p_booking_id INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE count INT;

SELECT IFNULL(SUM(units), 0)
INTO count
FROM reservation_x_room
WHERE reservation_ref = p_booking_id;

RETURN count;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_room_units_reservated`(p_room_id INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE count INT;

SELECT IFNULL(SUM(reservation_x_room.units),0)
INTO count
FROM room
INNER JOIN reservation_x_room
ON room.id = reservation_x_room.room_ref
INNER JOIN reservation
ON reservation_x_room.reservation_ref = reservation.id
WHERE (reservation.check_in_date BETWEEN CURDATE() AND (CURDATE() + INTERVAL 1 WEEK)
OR reservation.check_out_date BETWEEN CURDATE() AND (CURDATE() + INTERVAL 1 WEEK))
AND (reservation.reservation_status_ref = 1)
AND room.id = p_room_id;

RETURN count;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_rooms_count_in_booking`(p_booking_id INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE count INT;

SELECT COUNT(*)
INTO count
FROM reservation_x_room
WHERE reservation_ref = p_booking_id;

RETURN count;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_total_bookings_in_hotel`(p_hotel_id INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE count INT;
SET count = 0;

SELECT COUNT(*)
INTO count
FROM reservation
WHERE hotel_ref = p_hotel_id AND reservation_status_ref = 1;

RETURN count;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_total_rooms_in_hotel`(p_hotel_id INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE count INT;

SELECT SUM(units)
INTO count
FROM room
WHERE hotel_ref = p_hotel_id;

IF (count IS NULL) THEN
    RETURN 0;
ELSE
    RETURN count;
END IF;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `is_booking_checked_in`(p_booking_id INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE check_in DATE;

SELECT check_in_date 
INTO check_in
FROM reservation
WHERE id = p_booking_id;

IF (check_in <= CURDATE()) THEN
    RETURN 1;
ELSE
    RETURN 0;
END IF;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `is_booking_reviewd`(p_booking_id INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE check_usage INT;

SELECT IFNULL(COUNT(*),0)
INTO check_usage
FROM reservation
INNER JOIN review
ON reservation.id = review.reservation_ref
WHERE reservation.id = p_booking_id;

RETURN check_usage;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `is_booking_reviewed`(p_booking_id INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE check_usage INT;

SELECT IFNULL(COUNT(*),0)
INTO check_usage
FROM reservation
INNER JOIN review
ON reservation.id = review.reservation_ref
WHERE reservation.id = p_booking_id;

RETURN check_usage;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `is_room_available`(p_room_id INT, check_in DATE, check_out DATE, p_units INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE units_reservated INT;
DECLARE units_of_room INT;

SELECT IFNULL(SUM(reservation_x_room.units),0)
INTO units_reservated
FROM reservation
JOIN reservation_x_room
ON reservation.id = reservation_x_room.reservation_ref
WHERE reservation_x_room.room_ref = p_room_id
AND ((reservation.check_in_date BETWEEN  check_in AND check_out)
  OR (reservation.check_out_date BETWEEN  check_in AND check_out))
AND reservation.reservation_status_ref = 1;
  
SELECT units 
INTO units_of_room
FROM room
WHERE id = p_room_id;

IF (units_of_room - units_reservated >= p_units) THEN
    RETURN 1;
ELSE
    RETURN 0;
END IF;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `is_room_currently_in_offer`(p_room_id INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE flag INT;

SELECT COUNT(*)
INTO flag
FROM offer
INNER JOIN offer_x_room
ON offer.id = offer_x_room.offer_ref
INNER JOIN room
ON offer_x_room.room_ref = room.id
WHERE room.id = p_room_id AND (CURDATE() BETWEEN offer.start_date AND offer.ending_date);

IF (flag = 0) THEN
    RETURN 0;
ELSE
    RETURN 1;
END IF;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `is_room_in_booking_in_offer`(p_room_id INT, p_booking_id INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE flag INT;

SELECT COUNT(*)
INTO flag
FROM offer
INNER JOIN offer_x_room
ON offer.id = offer_x_room.offer_ref
INNER JOIN room
ON offer_x_room.room_ref = room.id
WHERE room.id = p_room_id AND (CURDATE() BETWEEN offer.start_date AND offer.ending_date)
AND GET_RESERVATED_DAYS(p_booking_id) >= offer.minimun_reservation_days;

IF (flag = 0) THEN
    RETURN 0;
ELSE
    RETURN 1;
END IF;

RETURN 1;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `is_room_in_offer`(p_room_id INT, p_start_date DATE, p_ending_date DATE) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE i INT;
DECLARE hotel_id INT;

SELECT hotel_ref
INTO hotel_id
FROM room
WHERE id = p_room_id;

SELECT COUNT(*)
INTO i
FROM offer
INNER JOIN offer_x_room
ON offer.id = offer_x_room.offer_ref
WHERE offer.hotel_ref = hotel_id
AND ((offer.start_date BETWEEN  p_start_date AND p_ending_date)
OR (offer.ending_date BETWEEN  p_start_date AND p_ending_date))
AND offer_x_room.room_ref = p_room_id;

RETURN i;
END$$
DELIMITER ;
