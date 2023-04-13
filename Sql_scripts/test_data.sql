-- CREACIÓN DE PAÍS--------------------------------------------------------------
INSERT INTO country (id, name)
VALUES (default, 'Costa Rica');
-- CREACIÓN DE PROVINCIAS--------------------------------------------------------

INSERT INTO province (id, name, country_ref)
VALUES (default, 'San José', 1);

INSERT INTO province (id, name, country_ref)
VALUES (default, 'Alajuela', 1);

INSERT INTO province (id, name, country_ref)
VALUES (default, 'Heredia', 1);

INSERT INTO province (id, name, country_ref)
VALUES (default, 'Cartago', 1);

INSERT INTO province (id, name, country_ref)
VALUES (default, 'Guanacaste', 1);

INSERT INTO province (id, name, country_ref)
VALUES (default, 'Puntarenas', 1);

INSERT INTO province (id, name, country_ref)
VALUES (default, 'Limón', 1);

-- CREACIÓN DE CANTONES----------------------------------------------------------

-- DE SAN JOSÉ-------------------------------------------------------------------
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'San José', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Acosta', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Alajuelita', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Aserrí', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Curridabat', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Desamparados', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Dota', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Escazú', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Goicoechea', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'León Cortés', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Montes de Oca', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Mora', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Moravia', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Pérez Zeledón', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Puriscal', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Santa Ana', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Tarrazú', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Tibás', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Turrubares', 1);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Vázquez de Coronado', 1);

-- DE ALAJUELA-------------------------------------------------------------------

INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Alajuela', 2);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Atenas', 2);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Grecia', 2);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Guatuso', 2);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Los Chiles', 2);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Naranjo', 2);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Orotina', 2);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Palmares', 2);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Poás', 2);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Río Cuarto', 2);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'San Carlos', 2);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'San Mateo', 2);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'San Ramón', 2);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Sarchí', 2);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Upala', 2);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Zarcero', 2);

-- DE HEREDIA--------------------------------------------------------------------

INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Heredia', 3);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Barva', 3);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Belén', 3);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Flores', 3);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'San Isidro', 3);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'San Pablo', 3);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'San Rafael', 3);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Santa Bárbara', 3);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Santo Domingo', 3);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Sarapiquí', 3);

-- DE CARTAGO--------------------------------------------------------------------

INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Cartago', 4);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Alvarado', 4);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'El Guarco', 4);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Jiménez', 4);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'La Unión', 4);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Oreamuno', 4);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Paraíso', 4);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Turrialba', 4);

-- DE GUANACASTE-----------------------------------------------------------------

INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Liberia', 5);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Abangares', 5);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Bagaces', 5);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Cañas', 5);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Carrillo', 5);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Hojancha', 5);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'La Cruz', 5);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Nandayure', 5);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Nicoya', 5);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Santa Cruz', 5);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Tilarán', 5);

-- DE PUNTARENAS-----------------------------------------------------------------

INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Puntarenas', 6);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Buenos Aires', 6);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Corredores', 6);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Coto Brus', 6);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Esparza', 6);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Garabito', 6);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Golfito', 6);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Montes de Oro', 6);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Osa', 6);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Parrita', 6);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Quepos', 6);

-- DE LIMÓN----------------------------------------------------------------------

INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Limón', 7);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Guácimo', 7);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Matina', 7);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Pococí', 7);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Siquirres', 7);
INSERT INTO canton (id, name, province_ref)
VALUES (default, 'Talamanca', 7);

-- CREACIÓN DE DISTRITOS -------------------------------------------------------

-- DE SAN JOSÉ / SAN JOSÉ -------------------------------------------------------
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Carmen', 1);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Merced', 1);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Hospital', 1);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Catedral', 1);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Zapote', 1);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Francisco de Dos Ríos', 1);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Uruca', 1);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Mata Redonda', 1);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Pavas', 1);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Hatillo', 1);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Sebastián', 1);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Escazú', 8);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Antonio', 8);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Rafael', 8);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Desamparados', 6);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Miguel', 6);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Juan de Dios', 6);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Rafael Arriba', 6);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Antonio', 6);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Frailes', 6);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Patarrá', 6);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Cristóbal', 6);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Rosario', 6);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Damas', 6);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Rafael Abajo', 6);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Gravilias', 6);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Los Guido', 6);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santiago', 15);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Mercedes Sur', 15);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Barbacoas', 15);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Grifo Alto', 15);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Rafael', 15);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Candelarita', 15);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Desamparaditos', 15);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Antonio', 15);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Chires', 15);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Marcos', 17);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Lorenzo', 17);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Carlos', 17);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Aserrí', 4);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tarbaca', 4);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Vuelta de Jorco', 4);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Gabriel', 4);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Legua', 4);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Monterrey', 4);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Salitrillos', 4);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Colón', 12);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Guayabo', 12);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tabarcia', 12);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Piedras Negras', 12);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Picagres', 12);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Jaris', 12);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Quitirrisi', 12);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Guadalupe', 9);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Francisco', 9);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Calle Blancos', 9);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Mata de Platano', 9);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Ipís', 9);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Rancho Redondo', 9);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Purral', 9);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Ana', 16);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Salitral', 16);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Pozos', 16);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Uruca', 16);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Piedades', 16);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Brasil', 16);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Alajuelita', 3);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Josecito', 3);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Antonio', 3);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Concepción', 3);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Felipe', 3);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Isidro', 20);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Rafael', 20);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Dulce Nombre de Jesús', 20);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Patalillo', 20);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cascajal', 20);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Ignacio', 2);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Guaitil', 2);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Palmichal', 2);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cangrejal', 2);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Sabanillas', 2);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Juan', 18);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cinco Esquinas', 18);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Alselmo Llorente', 18);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'León Xlll', 18);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Colima', 18);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Vicente', 13);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Jerónimo', 13);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Trinidad', 13);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Pedro', 11);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Sabanilla', 11);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Mercedes', 11);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Rafael', 11);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Pablo', 19);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Pedro', 19);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Juan de Mata', 19);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Luis', 19);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Carara', 19);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa María', 7);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Jardin', 7);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Copey', 7);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Curridabat', 5);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Granadilla', 5);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Sánchez', 5);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tirrases', 5);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Isidro de El General', 14);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'El General', 14);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Daniel Flores', 14);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Rivas', 14);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Pedro', 14);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Platanares', 14);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Pejibaye', 14);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cajón', 14);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Barú', 14);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Río Nuevo', 14);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Paramo', 14);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Amistad', 14);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Pablo', 10);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Andrés', 10);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Llano Bonito', 10);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Isidro', 10);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Cruz', 10);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Antonio', 10);

-- DE Alajuela / ALAJUELA -------------------------------------------------------
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Alajuela', 21);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San José', 21);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Carrizal', 21);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Antonio', 21);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Guácima', 21);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Isidro', 21);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Sabanilla', 21);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Rafael', 21);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Río Segundo', 21);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Desamparados', 21);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Turrúcares', 21);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tambor', 21);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Garita', 21);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Sarapiquí', 21);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Ramón', 33);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santiago', 33);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Juan', 33);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Piedades Norte', 33);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Piedades Sur', 33);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Rafael', 33);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Isidro', 33);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Ángeles', 33);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Alfaro', 33);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Volio', 33);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Concepcion', 33);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Zapotal', 33);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Peñas Blancas', 33);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Lorenzo', 33);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Grecia', 23);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Isidro', 23);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San José', 23);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Roque', 23);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tacares', 23);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Puente de Piedra', 23);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Bolívar', 23);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Mateo', 32);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Desmonte', 32);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Jesús María', 32);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Labrador', 32);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Atenas', 22);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Jesús', 22);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Mercedes', 22);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Isidro', 22);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Concepcion', 22);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San José', 22);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Eulalia', 22);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Escobal', 22);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Naranjo', 26);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Miguel', 26);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San José', 26);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cirrí Sur', 26);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Jeronimo', 26);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Juan', 26);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'El Rosario', 26);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Palmitos', 26);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Palmares', 28);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Zaragoza', 28);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Buenos Aires', 28);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santiago', 28);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Candelaria', 28);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Esquipulas', 28);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Granja', 28);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Pedro', 29);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Juan', 29);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Rafael', 29);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Carrillos', 29);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Sabana Redonda', 29);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Orotina', 27);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'El Mastate', 27);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Hacienda Vieja', 27);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Coyolar', 27);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Ceiba', 27);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Quesada', 31);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Florencia', 31);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Buenavista', 31);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Aguas Zarcas', 31);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Venecia', 31);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Pital', 31);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Fortuna', 31);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Tigra', 31);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Palmera', 31);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Venado', 31);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cutris', 31);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Monterrey', 31);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Pocosol', 31);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Zarcero', 36);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Laguna', 36);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tapesco', 36);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Guadalupe', 36);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Palmira', 36);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Zapote', 36);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Brisas', 36);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Sarchí Norte', 34);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Sarchí Sur', 34);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Toro Amarillo', 34);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Pedro', 34);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Rodriguez', 34);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Upala', 35);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Aguas Claras', 35);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Jose(Pizote)', 35);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Bijagua', 35);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Delicias', 35);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Dos Ríos', 35);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Yolillal', 35);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Canalete', 35);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Los Chiles', 25);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Caño Negro', 25);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'El Amparo', 25);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Jorge', 25);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Rafael', 24);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Buenavista', 24);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cote', 24);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Katira', 24);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Rio Cuarto', 30);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Rita', 30);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Isabel', 30);

-- DE Heredia / Heredia -------------------------------------------------------

INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Heredia', 37);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Mercedes', 37);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Francisco', 37);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Ulloa', 37);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Varablanca', 37);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Barva', 38);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Pedro', 38);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Pablo', 38);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Roque', 38);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Lucía', 38);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San José de la Montaña', 38);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santo Domingo', 45);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Vicente', 45);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Miguel', 45);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Paracito', 45);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santo Tomás', 45);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Rosa', 45);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tures', 45);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Pará', 45);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Barbara', 44);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Pedro', 44);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Juan', 44);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Jesús', 44);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santo Domingo', 44);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Purabá', 44);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Rafael', 43);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Josecito', 43);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santiago', 43);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Ángeles', 43);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Concepción', 43);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Isidro', 41);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San José', 41);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Concepción', 41);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Francisco', 41);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Antonio', 39);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Ribera', 39);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Asunción', 39);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Joaquín', 40);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Barrantes', 40);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Llorente', 40);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Pablo', 42);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Rincón de Sabanilla', 42);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Puerto Viejo', 46);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Virgen', 46);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Horquetas', 46);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Llanuras del Gaspar', 46);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cureña', 46);


-- DE Cartago / CARTAGO -------------------------------------------------------

INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Oriental', 47);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Occidental', 47);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Carmen', 47);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Nicolás', 47);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Aguacaliente', 47);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Guadalupe', 47);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Corralillo', 47);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tierra Blanca', 47);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Dulce Nombre', 47);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Llano Grande', 47);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Quebradilla', 47);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Paraíso', 53);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santiago', 53);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Orosí', 53);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cachí', 53);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Llanos de Santa Lucia', 53);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tres Ríos', 51);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Diego', 51);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Juan', 51);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Rafael', 51);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Concepción', 51);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Dulce Nombre', 51);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Ramón', 51);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Río Azul', 51);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Juan Viñas', 50);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tucurrique', 50);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Pejibaye', 50);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Turrialba', 54);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Suiza', 54);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Peralta', 54);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Cruz', 54);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Teresita', 54);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Pavones', 54);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tuis', 54);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tayutic', 54);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Rosa', 54);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tres Equis', 54);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Isabel', 54);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Chirripó', 54);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Pacayas', 48);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cervantes', 48);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Capellades', 48);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Rafael', 52);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cot', 52);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Potrero Cerrado', 52);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cipreses', 52);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Rosa', 52);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'El Tejar', 49);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Isidro', 49);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tobosi', 49);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Patio de Agua', 49);

-- DE Guanacaste / GUANACASTE -------------------------------------------------------

INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Liberia', 55);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cañas Dulces', 55);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Mayorga', 55);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Nacascolo', 55);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Curubandé', 55);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Nicoya', 63);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Mansión', 63);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Antonio', 63);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Sámara', 63);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Nosara', 63);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Belén de Nosarita', 63);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Cruz', 64);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Bolsón', 64);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Veintisiete de Abril', 64);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tempate', 64);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cartagena', 64);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cuajiniquil', 64);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Diriá', 64);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cabo Velas', 64);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tamarindo', 64);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Bagaces', 57);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Fortuna', 57);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Mogote', 57);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Río Naranjo', 57);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Filadelfia', 59);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Palmira', 59);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Sardinal', 59);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Belén', 59);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cañas', 58);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Palmira', 58);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Miguel', 58);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Bebedero', 58);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Porozal', 58);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Juntas', 56);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Sierra', 56);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Juan', 56);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Colorado', 56);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tilarán', 65);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Quebrada Grande', 65);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tronadora', 65);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Rosa', 65);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Líbano', 65);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tierras Morenas', 65);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Arenal', 65);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cabeceras', 65);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Carmona', 62);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Rita', 62);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Zapotal', 62);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Pablo', 62);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Porvenir', 62);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Bejuco', 62);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Cruz', 61);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Cecilia', 61);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Garita', 61);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Santa Elena', 61);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Hojancha', 60);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Monte Romo', 60);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Puerto Carrillo', 60);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Huacas', 60);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Matambú', 60);

-- DE Puntarenas / PUNTARENAS -------------------------------------------------------

INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Puntarenas', 66);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Pitahaya', 66);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Chomes', 66);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Lepanto', 66);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Paquera', 66);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Manzanillo', 66);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Guacimal', 66);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Barranca', 66);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Monte Verde', 66);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Isla del Coco', 66);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cóbano', 66);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Chacarita', 66);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Chira', 66);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Acapulco', 66);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'El Roble', 66);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Arancibia', 66);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Espíritu Santo', 70);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Juan Grande', 70);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Macacona', 70);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Rafael', 70);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Jerónimo', 70);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Caldera', 70);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Buenos Aires', 67);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Volcán', 67);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Potrero Grande', 67);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Boruca', 67);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Pilas', 67);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Colinas', 67);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Chánguena', 67);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Biolley', 67);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Brunka', 67);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Miramar', 73);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Unión', 73);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Isidro', 73);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Puerto Cortés', 74);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Palmar', 74);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Sierpe', 74);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Bahía Ballena', 74);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Piedras Blancas', 74);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Bahía Drake', 74);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Quepos', 76);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Savegre', 76);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Naranjito', 76);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Golfito', 72);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Puerto Jimenez', 72);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Guaycará', 72);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Pavón', 72);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'San Vito', 72);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Sabalito', 69);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Aguabuena', 69);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Limocito', 69);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Pittier', 69);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Gutiérrez Braun', 69);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Parrita', 75);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Corredor', 68);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Cuesta', 68);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Canoas', 68);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Laurel', 68);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Jacó', 71);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Tárcoles', 71);


-- DE Limon / LIMON -------------------------------------------------------

INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Limón', 77);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Valle La Estrella', 77);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Río Blanco', 77);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Matama', 77);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Guápiles', 80);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Jiménez', 80);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Rita', 80);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Roxana', 80);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cariari', 80);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Colorado', 80);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'La Colonia', 80);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Siquirres', 81);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Pacuarito', 81);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Florida', 81);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Germania', 81);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'El Cairo', 81);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Alegría', 81);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Reventazón', 81);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Bratsi', 82);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Sixaola', 82);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Cahuita', 82);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Telire', 82);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Matina', 79);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Batán', 79);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Carrandi', 79);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Guácimo', 78);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Mercedes', 78);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Pocora', 78);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Río Jiménez', 78);
INSERT INTO district (id, name, canton_ref)
VALUES(default, 'Duacarí', 78);

-- CREACIÓN DE GÉNEROS ---------------------------------------------------------

INSERT INTO gender (id, name)
VALUES (default, 'Mujer');
INSERT INTO gender (id, name)
VALUES (default, 'Hombre');
INSERT INTO gender (id, name)
VALUES (default, 'Otro');

-- CREACIÓN DE USER TYPE---------------------------------------------------------

INSERT INTO user_type(id,name)
VALUES(default,'Administrador');

-- CREACIÓN DE ID TYPE ---------------------------------------------------------

INSERT INTO id_type(id,name)
VALUES(default,'Pasaporte');
INSERT INTO id_type(id,name)
VALUES(default,'Cédula de identidad');

-- CREACIÓN DE SETTING --------------------------------------------------------
INSERT INTO setting(id,name,value)
VALUES(default,'IVA',0.13);

-- CREACIÓN DE CLASSIFICATION --------------------------------------------------------
INSERT INTO classification(id,name)
VALUES(default,'Muy bajo');

INSERT INTO classification(id,name)
VALUES(default,'Bajo');

INSERT INTO classification(id,name)
VALUES(default,'Medio');

INSERT INTO classification(id,name)
VALUES(default,'Alto');

INSERT INTO classification(id,name)
VALUES(default,'Muy alto');

-- CREACIÓN DE HOTEL --------------------------------------------------------
INSERT INTO hotel(id,name,registration_date,address,classification_ref,district_ref)
VALUES(default,'Maracuyá', STR_TO_DATE('27/3/2023', '%d/%m/%Y'), 'Contiguo al parque Morazán', 5, 1);

INSERT INTO hotel(id,name,registration_date,address,classification_ref,district_ref)
VALUES(default,'La Punta', STR_TO_DATE('12/4/2023', '%d/%m/%Y'), '75 m. oeste de San Lucas Beach Club', 3, 53);

INSERT INTO hotel(id,name,registration_date,address,classification_ref,district_ref)
VALUES(default,'Hotel Playa Westfalia', STR_TO_DATE('12/4/2023', '%d/%m/%Y'), '2 Kilómetros al sur del aeropuerto de Limón', 4, 24);

INSERT INTO hotel(id,name,registration_date,address,classification_ref,district_ref)
VALUES(default,'Pura Vida', STR_TO_DATE('12/4/2023', '%d/%m/%Y'), 'Corner of Tuetal Sur y Tuetal Norte, Tuetal Sur, 20102', 1, 17);

-- CREACIÓN DE nationality --------------------------------------------------------
INSERT INTO nationality(id,name)
VALUES(default,'Costarricense');

INSERT INTO nationality(id,name)
VALUES(default,'Pañameño');

-- CREACIÓN DE user_table --------------------------------------------------------
INSERT INTO user_table(username, user_type_ref, photo, user_password, hotel_ref)
VALUES('ADG2023',1, null,'1234', 1);
-- CREACIÓN DE PERSONAS --------------------------------------------------------
INSERT INTO person (id,first_name,second_name,first_surname,second_surname,birthdate,gender_ref,identification_number, id_type_ref, user_ref)
VALUES (default, 'Marco', null, 'Herrera', 'González', STR_TO_DATE('12/10/2003', '%d/%m/%Y'), 2, 118760722,2, 'ADG2023');

-- CREACIÓN DE person_x_nationality --------------------------------------------------------
INSERT INTO person_x_nationality(nationality_ref,person_ref)
VALUES(1,1);
-- CREACIÓN DE telephone --------------------------------------------------------
INSERT INTO telephone(id,telephone_number,person_ref)
VALUES(default,60987448,1); 
-- CREACIÓN DE payment_method --------------------------------------------------------
INSERT INTO payment_method(id,name,hotel_ref)
VALUES(default,'Tarjeta',1);


-- CREACIÓN DE email --------------------------------------------------------
INSERT INTO email(email,person_ref)
VALUES('marco.herrera@gmail.com',1);

-- CREACIÓN DE amenity --------------------------------------------------------
INSERT INTO amenity(id,name, hotel_ref)
VALUES(default,'Vista al mar',1);
INSERT INTO amenity(id,name, hotel_ref)
VALUES(default,'Cerca de la playa',1);
 
-- CREACIÓN DE reservation status --------------------------------------------------------
INSERT INTO reservation_status(id,name)
VALUES(default,'Reservado');

-- CREACIÓN DE photo --------------------------------------------------------
INSERT INTO photo(id,photo, hotel_ref)
VALUES(default,null,1);


-- CREACIÓN DE offer --------------------------------------------------------
INSERT INTO offer(id,name, start_date, ending_date, discount_rate, minimun_reservation_days, hotel_ref)
VALUES(default,'2X1',STR_TO_DATE('12/02/2023', '%d/%m/%Y'), STR_TO_DATE('12/06/2023', '%d/%m/%Y'),50,10,1);

-- CREACIÓN DE cancellation_policy --------------------------------------------------------
INSERT INTO cancellation_policy(id, anticipation_time, value, hotel_ref)
VALUES(default,5,60,1);

-- CREACIÓN DE admin --------------------------------------------------------
INSERT INTO admin(username, hotel_ref)
VALUES('ADG2023',1);

-- CREACIÓN DE room --------------------------------------------------------
INSERT INTO room(id, name, capacity, recommended_price, discount_code, discount_rate, hotel_ref)
VALUES(default, 'Habitación 404', 2, 400, 0, 0,1);

-- CREACIÓN DE amenity_x_room -------------------------------------------------------------------------

INSERT INTO amenity_x_room(amenity_ref, room_ref)
VALUES(1, 1);
INSERT INTO amenity_x_room(amenity_ref, room_ref)
VALUES(2, 1);

-- CREACIÓN DE hotel_x_user -------------------------------------------------------------------------

INSERT INTO hotel_x_user(hotel_ref, user_ref)
VALUES(1, 'ADG2023');

-- CREACIÓN DE reservation -------------------------------------------------------------------------

INSERT INTO reservation(id, check_in_date, check_out_date, confirmation_date, reservation_status_ref, cancellation_policy_ref,
payment_method_ref, user_ref)
VALUES(default, STR_TO_DATE('14/02/2023', '%d/%m/%Y'), STR_TO_DATE('16/02/2023', '%d/%m/%Y'), STR_TO_DATE('11/02/2023', '%d/%m/%Y'), 1, 1, 1, 'ADG2023');

-- CREACIÓN DE commentary -----------------------------------------------------------------------

INSERT INTO commentary(id, commentary_date, commentary, reservation_ref)
VALUES(default, STR_TO_DATE('12/02/2023', '%d/%m/%Y'), 'Excelente lugar', 1);
INSERT INTO commentary(id, commentary_date, commentary, reservation_ref)
VALUES(default, STR_TO_DATE('14/02/2023', '%d/%m/%Y'), 'Buenas vistas', 1);

-- CREACIÓN DE review -------------------------------------------------------------------------

INSERT INTO review(id, stars, reservation_ref)
VALUES(default, 5, 1);
INSERT INTO review(id, stars, reservation_ref)
VALUES(default, 4, 1);

-- CREACIÓN DE reservation_x_room -------------------------------------------------------------------------

INSERT INTO reservation_x_room(reservation_ref, room_ref, prince)
VALUES(1, 1, 400);
