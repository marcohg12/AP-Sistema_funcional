/*
Creador Jefry Cuendiz
Contiene
Estadísticas
get_clients_by_age_range(hotel_id, gender_id)
get_top_most_booked_rooms(hotel_id, top_n)

*/


/*
Procedimiento get clients by age
devuelve la lista de clientes de un hotel ordenados por fecha de nacimiento
como parametros de entrada
hotel id es el hotel
gender id es el gender.

*/
DELIMITER //
DROP PROCEDURE IF EXISTS get_clients_by_age_range; //
CREATE PROCEDURE `get_clients_by_age_range`(IN hotel_id int,in gender_id int)
BEGIN


select p.birthdate, p.first_name, p.second_name, p.first_surname, p.second_surname, p.identification_number, p.gender_ref, p.id_type_ref, r.check_in_date, r.check_out_date from person p
inner join reservation r
on p.user_ref = r.user_ref and gender_id = p.gender_ref and r.hotel_ref = hotel_id
order by p.birthdate;

COMMIT;

END //

/*
Procedimiento get_top_most_booked_rooms
devuelve los cuartos mas reservados en un hotel
ocupa el id del hotel
ocupa el topn para saber cuantos devolver.

*/
DELIMITER //
DROP PROCEDURE IF EXISTS get_top_most_booked_rooms; //
CREATE PROCEDURE `get_top_most_booked_rooms`(IN hotel_id int,in top_n int)
BEGIN


select re.room_ref, count(*) as cantidad,  r.name,r.capacity, r.recommended_price, r.discount_code, r.discount_rate, r.units  from room r
inner join reservation_x_room re
on r.id = room_ref and r.hotel_ref = hotel_id
group by r.name, re.room_ref
order by cantidad desc
limit top_n 
;
COMMIT;

END //