-- Ejercicio Nivel Intermedio - Tablas Cancha y Reserva
CREATE TABLE Cancha (
    id_cancha INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(255)
);

CREATE TABLE Reserva (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado VARCHAR(20) NOT NULL,
    id_cancha INT NOT NULL,
    CONSTRAINT chk_estado_reserva CHECK (estado IN ('Pendiente', 'Confirmada', 'Cancelada')),
    CONSTRAINT fk_reserva_cancha FOREIGN KEY (id_cancha) 
        REFERENCES Cancha(id_cancha) ON DELETE RESTRICT
);