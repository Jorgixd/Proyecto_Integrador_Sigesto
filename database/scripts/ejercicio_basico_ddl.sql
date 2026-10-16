-- Ejercicio Nivel Básico - Tabla Arbitro
CREATE TABLE Arbitro (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(8) UNIQUE NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    categoria VARCHAR(50)
);