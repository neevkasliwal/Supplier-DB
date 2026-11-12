DROP DATABASE IF EXISTS SupplierDB;
CREATE DATABASE SupplierDB;
USE SupplierDB;

CREATE TABLE Suppliers(
sid INT PRIMARY KEY,
sname VARCHAR(50) NOT NULL,
city VARCHAR(50) NOT NULL
);

CREATE TABLE Parts(
pid INT PRIMARY KEY,
pname VARCHAR(50) NOT NULL,
color VARCHAR(30) NOT NULL 
);

CREATE TABLE Catalog(
sid INT,
pid INT,
cost DECIMAL(10,2) NOT NULL CHECK (cost>=0),

PRIMARY KEY (sid,pid),
FOREIGN KEY (sid) REFERENCES Suppliers(sid)
ON DELETE RESTRICT
ON UPDATE CASCADE,

FOREIGN KEY (pid) REFERENCES Parts(pid)
ON DELETE RESTRICT
ON UPDATE CASCADE 
);
INSERT INTO Suppliers VALUES
(10001,'Acme Widget','Bangalore'),
(10002,'Johns','Kolkata'),
(10003,'Vimal','Mumbai'),
(10004,'Reliance','Delhi');

INSERT INTO Parts VALUES
(20001,'Book','Red'),
(20002,'Pen','Red'),
(20003,'Pencil','Green'),
(20004,'Mobile','Green'),
(20005,'Charger','Black');

INSERT INTO Catalog VALUES
(10001,20001,10),
(10001,20002,10),
(10001,20003,30),
(10001,20004,10),
(10001,20005,10),
(10002,20001,10),
(10002,20002,20),
(10003,20003,30),
(10004,20003,40);


SELECT * FROM Suppliers;
SELECT * FROM Parts;
SELECT * FROM Catalog;


SELECT p.pname,s.sname,c.cost
FROM Catalog c 
JOIN Parts p on p.pid = c.pid
JOIN Suppliers s on s.sid = c.sid
WHERE c.cost = (
SELECT MAX(cost)
FROM catalog
);

SELECT s.sname FROM Suppliers s
WHERE NOT EXISTS (
SELECT * FROM Catalog c
JOIN Parts p ON c.pid = p.pid
WHERE c.sid = s.sid
AND color = 'Red'
);

SELECT s.sname , SUM(c.cost) AS total_values FROM Suppliers s
JOIN Catalog c on s.sid = c.sid
GROUP BY s.sid,s.sname;

SELECT s.sname FROM Suppliers s
JOIN Catalog c ON s.sid = c.sid
WHERE c.cost < 720
GROUP BY s.sid,s.sname
HAVING COUNT(DISTINCT c.pid) >= 2;

SELECT p.pname, s.sname, c.cost
FROM Catalog c
JOIN Parts p ON c.pid = p.pid
JOIN Suppliers s ON c.sid = s.sid
WHERE c.cost = (
    SELECT MIN(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = c.pid
);

CREATE VIEW ExpensiveSupplier AS
SELECT p.pid, p.pname, s.sid, s.sname, c.cost
FROM Catalog c
JOIN Parts p ON c.pid = p.pid
JOIN Suppliers s ON c.sid = s.sid
WHERE c.cost = (
    SELECT MAX(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = c.pid
);

SELECT DISTINCT p.pname
FROM Parts p
JOIN Catalog c ON p.pid = c.pid;

SELECT s.sname FROM Suppliers s
JOIN Catalog c on s.sid = c.sid
GROUP BY s.sid,s.sname
HAVING COUNT(DISTINCT c.pid) = (SELECT COUNT(*) FROM Parts);

SELECT s.sname FROM Suppliers s
JOIN Catalog c on s.sid = c.sid
JOIN Parts p on c.pid = p.pid
WHERE p.color = 'Red'
GROUP BY s.sid,s.sname 
HAVING COUNT(DISTINCT p.pid) = (SELECT COUNT(*) FROM Parts WHERE color = 'Red');

SELECT DISTINCT c1.sid
FROM Catalog c1
WHERE c1.cost > (
    SELECT AVG(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = c1.pid
);

SELECT p.pname
FROM Suppliers s
JOIN Catalog c on s.sid = c.sid
JOIN Parts p on c.pid = p.pid
GROUP BY p.pid,p.pname
HAVING COUNT(DISTINCT c.sid) = 1
AND MAX(s.sname) = 'Acme Widget';

SELECT p.pname,s.sname
FROM Suppliers s
JOIN Catalog c on s.sid = c.sid
JOIN Parts p on c.pid = p.pid
WHERE c.cost = (SELECT MAX(c2.cost)
FROM Catalog c2
WHERE c2.pid = c.pid);

