-- Autores: David Pastor, Bryan Castro, Adrian Herrera
-- Fecha de creación: 21/03/2023

CREATE TABLE IF NOT EXISTS Gender(
id   INT NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,

CONSTRAINT gender_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Country(
id   INT NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,

CONSTRAINT country_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Province(
id          INT NOT NULL AUTO_INCREMENT,
name        VARCHAR(50) NOT NULL,
country_ref INT NOT NULL,

CONSTRAINT province_pk PRIMARY KEY (id),
FOREIGN KEY (country_ref) REFERENCES Country(id)
);

CREATE TABLE IF NOT EXISTS Canton(
id           INT NOT NULL AUTO_INCREMENT,
name         VARCHAR(50) NOT NULL,
province_ref INT NOT NULL,

CONSTRAINT canton_pk PRIMARY KEY (id),
FOREIGN KEY (province_ref) REFERENCES Province(id)
);

CREATE TABLE IF NOT EXISTS District(
id         INT NOT NULL AUTO_INCREMENT,
name       VARCHAR(50) NOT NULL,
canton_ref INT NOT NULL,

CONSTRAINT district_pk PRIMARY KEY (id),
FOREIGN KEY (canton_ref) REFERENCES Canton(id)
);

CREATE TABLE IF NOT EXISTS User_type(
id   INT NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,

CONSTRAINT usertype_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Nationality(
id   INT NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,

CONSTRAINT nationality_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Setting(
id    INT NOT NULL AUTO_INCREMENT,
name  VARCHAR(50) NOT NULL,
value DOUBLE NOT NULL,

CONSTRAINT setting_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Reservation_status(
 id   INT NOT NULL AUTO_INCREMENT,
 name VARCHAR(50) NOT NULL,

CONSTRAINT reservationstatus_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Id_type(
id   INT NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,

CONSTRAINT idtype_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Classification(
id   INT NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,

CONSTRAINT classification_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Hotel(
id                 INT NOT NULL AUTO_INCREMENT,
name               VARCHAR(50) NOT NULL,
registration_date  DATE NOT NULL,
address	           VARCHAR(100) NOT NULL,
classification_ref INT NOT NULL,
district_ref	   INT NOT NULL,

CONSTRAINT hotel_pk PRIMARY KEY (id),
FOREIGN KEY (classification_ref) REFERENCES Classification(id),
FOREIGN KEY (district_ref) REFERENCES District(id)
);

CREATE TABLE IF NOT EXISTS User_table(
	username       VARCHAR(50) NOT NULL,
    user_type_ref  INT NOT NULL,
    photo          MEDIUMBLOB,
    user_password  VARCHAR(100) NOT NULL, 
    hotel_ref	   INT,
    
    CONSTRAINT username_pk PRIMARY KEY (username),
    FOREIGN KEY (user_type_ref) REFERENCES User_type(id),
    FOREIGN KEY (hotel_ref) REFERENCES Hotel(id)
);

CREATE TABLE IF NOT EXISTS Amenity(
id        INT NOT NULL AUTO_INCREMENT,
name      VARCHAR(50) NOT NULL,
hotel_ref INT NOT NULL,

CONSTRAINT amenity_pk PRIMARY KEY (id),
FOREIGN KEY (hotel_ref) REFERENCES Hotel(id)
);

CREATE TABLE IF NOT EXISTS Person(
id                    INT NOT NULL AUTO_INCREMENT,
birthdate             DATE NOT NULL,
first_name            VARCHAR(50) NOT NULL,
second_name           VARCHAR(50),
first_surname         VARCHAR(50) NOT NULL,
second_surname        VARCHAR(50),
identification_number INT(9) NOT NULL,
gender_ref			  INT NOT NULL,
id_type_ref           INT NOT NULL,
user_ref 		      VARCHAR(50) NOT NULL,

CONSTRAINT person_pk PRIMARY KEY (id),
FOREIGN KEY (gender_ref) REFERENCES Gender(id),
FOREIGN KEY (id_type_ref) REFERENCES Id_type(id),
FOREIGN KEY (user_ref) REFERENCES User_table(username)
);

CREATE TABLE IF NOT EXISTS Telephone(
id		         INT NOT NULL AUTO_INCREMENT,
telephone_number INT NOT NULL,
person_ref		 INT NOT NULL,
    
CONSTRAINT telephone_pk PRIMARY KEY (id),
FOREIGN KEY (person_ref) REFERENCES Person(id)
);

CREATE TABLE IF NOT EXISTS Email(
email      VARCHAR(50) NOT NULL,
person_ref INT NOT NULL,

CONSTRAINT email_pk PRIMARY KEY (email),
FOREIGN KEY (person_ref) REFERENCES Person(id)
);

CREATE TABLE IF NOT EXISTS Photo(
id        INT NOT NULL AUTO_INCREMENT,
photo     BLOB,
hotel_ref INT NOT NULL,

CONSTRAINT photo_pk PRIMARY KEY (id),
FOREIGN KEY (hotel_ref) REFERENCES Hotel(id)
);

CREATE TABLE IF NOT EXISTS Payment_method(
id        INT NOT NULL AUTO_INCREMENT,
name      VARCHAR(50) NOT NULL,
hotel_ref INT NOT NULL,

CONSTRAINT paymentmethod_pk PRIMARY KEY (id),
FOREIGN KEY (hotel_ref) REFERENCES Hotel(id)
);

CREATE TABLE IF NOT EXISTS Room(
id     	          INT NOT NULL AUTO_INCREMENT,
name   			  VARCHAR(50) NOT NULL,
capacity   	      INT NOT NULL,
recommended_price INT NOT NULL,
discount_code	  INT(8),
discount_rate	  INT,
hotel_ref	      INT NOT NULL,

CONSTRAINT room_pk PRIMARY KEY (id),
FOREIGN KEY (hotel_ref) REFERENCES Hotel(id)
);

CREATE TABLE IF NOT EXISTS Offer(
id                      INT NOT NULL AUTO_INCREMENT,
name                    VARCHAR(50) NOT NULL,
start_date              DATE,
ending_date             DATE,
discount_rate           INT NOT NULL,
minimun_reservation_days INT NOT NULL,
hotel_ref				INT NOT NULL,

CONSTRAINT offer_pk PRIMARY KEY (id),
FOREIGN KEY (hotel_ref) REFERENCES Hotel(id)
);

CREATE TABLE IF NOT EXISTS Cancellation_policy(
id                INT NOT NULL AUTO_INCREMENT,
anticipation_time INT NOT NULL,
value             INT NOT NULL,
hotel_ref		  INT NOT NULL,

CONSTRAINT cancellationpolicyid_pk PRIMARY KEY (id),
FOREIGN KEY (hotel_ref) REFERENCES Hotel(id)
);

CREATE TABLE IF NOT EXISTS Reservation(
id                       INT NOT NULL AUTO_INCREMENT,
check_in_date            DATE,
check_out_date           DATE,
confirmation_date        DATE,
reservation_status_ref   INT NOT NULL,
cancellation_policy_ref  INT NOT NULL,
payment_method_ref 	     INT NOT NULL,
user_ref 		         VARCHAR(50) NOT NULL,

CONSTRAINT reservation_pk PRIMARY KEY (id),
FOREIGN KEY (reservation_status_ref) REFERENCES Reservation_status(id),
FOREIGN KEY (cancellation_policy_ref) REFERENCES Cancellation_policy(id),
FOREIGN KEY (payment_method_ref) REFERENCES Payment_method(id),
FOREIGN KEY (user_ref) REFERENCES User_table(username)
);

CREATE TABLE IF NOT EXISTS Commentary(
id              INT NOT NULL AUTO_INCREMENT,
commentary_date DATE,
commentary      VARCHAR(100) NOT NULL,
reservation_ref  INT NOT NULL,

CONSTRAINT idy_pk PRIMARY KEY (id),
FOREIGN KEY (reservation_ref) REFERENCES Reservation(id)
);

CREATE TABLE IF NOT EXISTS Review(
id              INT NOT NULL AUTO_INCREMENT,
stars 		    INT NOT NULL,
reservation_ref INT NOT NULL,

CONSTRAINT review_pk PRIMARY KEY (id),
FOREIGN KEY (reservation_ref) REFERENCES RESERVATION(id)
);

CREATE TABLE IF NOT EXISTS Admin (
username VARCHAR(50) NOT NULL,
hotel_ref INT NOT NULL,
  
CONSTRAINT username_pk  PRIMARY KEY (username),
FOREIGN KEY (username) REFERENCES User_table(username),
FOREIGN KEY (hotel_ref) REFERENCES Hotel(id)
);

CREATE TABLE Amenity_X_Room (
amenity_ref INT NOT NULL,
room_ref 	INT NOT NULL,
  
CONSTRAINT amenity_x_room_pk PRIMARY KEY (amenity_ref, room_ref),
FOREIGN KEY (amenity_ref) REFERENCES Amenity(id),
FOREIGN KEY (room_ref) REFERENCES Room(id)
);

CREATE TABLE Hotel_X_User(
hotel_ref INT NOT NULL,
user_ref  VARCHAR(50) NOT NULL,
  
CONSTRAINT hotel_x_user_pk PRIMARY KEY(hotel_ref, user_ref),
FOREIGN KEY (hotel_ref) REFERENCES Hotel(id),
FOREIGN KEY (user_ref) REFERENCES User_table(username)
);

CREATE TABLE Offer_X_Room(
offer_ref INT NOT NULL,
room_ref  INT NOT NULL,
  
CONSTRAINT offer_x_room_pk PRIMARY KEY (offer_ref, room_ref),
FOREIGN KEY (offer_ref) REFERENCES Offer(id),
FOREIGN KEY (room_ref) REFERENCES Room(id)
);

CREATE TABLE Person_X_Nationality(
nationality_ref INT NOT NULL,
person_ref      INT NOT NULL,
  
CONSTRAINT person_x_nationality_pk PRIMARY KEY (nationality_ref, person_ref),
FOREIGN KEY (nationality_ref) REFERENCES Nationality(id),
FOREIGN KEY (person_ref) REFERENCES Person(id)
);

CREATE TABLE Reservation_X_Room(
reservation_ref INT NOT NULL,
room_ref        INT NOT NULL,
prince          INT NOT NULL,
  
CONSTRAINT reservation_x_room_pk PRIMARY KEY (reservation_ref, room_ref),
FOREIGN KEY (reservation_ref) REFERENCES Reservation(id),
FOREIGN KEY (room_ref) REFERENCES Room(id)
);