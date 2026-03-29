IF OBJECT_ID('Drivers','U') IS NULL
CREATE TABLE Drivers(
DriverID INT CONSTRAINT PK_D PRIMARY KEY IDENTITY(1,1),
DriverName NVARCHAR(20) NOT NULL,
LicenseType NVARCHAR(10),
JoiningDate DATE CONSTRAINT D_D DEFAULT GETDATE()
)

IF OBJECT_ID('Shipments','U') IS NULL
CREATE TABLE Shipments(
ShipmentID INT CONSTRAINT PK_S PRIMARY KEY IDENTITY(1,1),
DriverID INT CONSTRAINT FK_SD FOREIGN KEY REFERENCES Drivers(DriverID),
Weight_KG DECIMAL(10,2) CONSTRAINT CK_W CHECK (Weight_KG > 0),
Status NVARCHAR(15) CONSTRAINT CH_S CHECK (Status IN ('Pending', 'In Transit', 'Delivered')),
DeliveryDate DATE
)

INSERT INTO Drivers(DriverName, LicenseType,JoiningDate) VALUES 
('Sami','Light','2026-03-16'),
('Ali','Heavy','2025-5-2'),
('Hassan','Light','2022-7-5')

INSERT INTO Shipments(DriverID,Weight_KG,Status,DeliveryDate) VALUES 
(1, 520.00, 'Delivered', '2026-04-01'),
(1, 1500.00, 'In Transit', NULL),
(2, 300.00, 'Delivered', '2026-03-30'),
(3, 750.00, 'Pending', NULL),
(3, 1200.00, 'In Transit', NULL)

SELECT s.ShipmentID, d.DriverName, 
COALESCE(CONVERT(VARCHAR(20), s.DeliveryDate),'Not Delivered Yet') 
FROM Drivers d
JOIN Shipments s ON d.DriverID = s.DriverID

SELECT *,
DENSE_RANK() OVER(ORDER BY Weight_KG DESC) AS 'Perfoemance'
FROM Shipments

WITH CTE AS(
SELECT d.DriverName, s.*,
SUM(Weight_KG) OVER(PARTITION BY d.DriverID ORDER BY Weight_KG) AS TotalWeight
FROM Drivers d
JOIN Shipments s ON d.DriverID = s.DriverID
)
SELECT * 
FROM CTE
WHERE TotalWeight > 10000

CREATE VIEW v_ActiveShipments AS
SELECT * FROM Shipments
WHERE Status != 'Delivered'

SELECT * FROM v_ActiveShipments

CREATE PROCEDURE sp_CompleteDelivery @ShipID INT AS 
BEGIN
UPDATE Shipments
SET Status = 'Delivered'
WHERE ShipmentID = @ShipID
PRINT('Shipment '+ CAST(@ShipID AS VARCHAR(10)) + ' Updated to Delivered')
END

EXEC sp_CompleteDelivery 2
