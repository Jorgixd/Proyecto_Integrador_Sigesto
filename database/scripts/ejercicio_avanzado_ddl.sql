-- Ejercicio Nivel Avanzado - Sanciones e Índice Compuesto
CREATE TABLE Sancion_Jugador (
    id_sancion INT AUTO_INCREMENT PRIMARY KEY,
    id_partido INT NOT NULL,
    id_jugador INT NOT NULL,
    tipo_tarjeta ENUM('Amarilla', 'Roja') NOT NULL,
    minuto INT,
    motivo VARCHAR(255)
);

-- Índice compuesto para acelerar los reportes de rendimiento
CREATE INDEX idx_partido_jugador ON Sancion_Jugador(id_partido, id_jugador);