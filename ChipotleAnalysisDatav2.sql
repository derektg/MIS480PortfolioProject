CREATE DATABASE MIS480_analysis;

USE MIS480_analysis;

CREATE TABLE ChipotleOrders (
	order_id INT NOT NULL,
    quantity INT NOT NULL,
    item_name VARCHAR(1000) NOT NULL,
    choice_description VARCHAR(1000) NULL,
    item_price DECIMAL(5,2) NOT NULL
    );

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/chipotle.csv'
INTO TABLE ChipotleOrders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE ChipotleAnalysisData (
	id INT NOT NULL AUTO_INCREMENT,
    order_id INT NOT NULL,
    item_name VARCHAR(1000) NOT NULL,
    salsa VARCHAR(255) NOT NULL,
    beans INT NOT NULL,
    rice INT NOT NULL,
    cheese INT NOT NULL,
    sourcream INT NOT NULL,
    guacamole INT NOT NULL,
    lettuce INT NOT NULL,
    fajitavegetables INT NOT NULL,
    lineitemtotal DECIMAL(5,2) NULL,
    ordertotal DECIMAL(6,2) NULL,
    PRIMARY KEY(id)
    ) ENGINE = InnoDB;
 
INSERT INTO ChipotleAnalysisData (order_id,item_name,salsa,beans,rice,cheese,sourcream,guacamole,lettuce,fajitavegetables,lineitemtotal)
SELECT	CO.order_id,
		CO.item_name,
		CASE	WHEN CO.choice_description LIKE '[Tomatillo-Red Chili Salsa (Hot)%' THEN 'Tomatillo Red-Hot'
				WHEN CO.choice_description LIKE '[Fresh Tomato Salsa (Mild)%' THEN 'Tomato-Mild'
                WHEN CO.choice_description LIKE '[Tomatillo Red Chili Salsa%' THEN 'Tomatillo Red-Regular'
                WHEN CO.choice_description LIKE '[Tomatillo Green Chili Salsa%' THEN 'Tomatillo Green-Regular'
                WHEN CO.choice_description LIKE '[Fresh Tomato Salsa%' THEN 'Tomato-Regular'
                WHEN CO.choice_description LIKE '[Roasted Chili Corn Salsa%' THEN 'Chili Corn-Regular'
                WHEN CO.choice_description LIKE '[Tomatillo-Green Chili Salsa (Medium)%' THEN 'Tomatillo Green-Medium'
                WHEN CO.choice_description LIKE '[Roasted Chili Corn Salsa (Medium)%' THEN 'Chili Corn-Medium'
                WHEN CO.choice_description LIKE '[[%' THEN 'Multiple Salsas'
                ELSE 'No Salsa' END AS salsa,
		CASE 	WHEN CO.choice_description LIKE '%bean%' THEN 1
				ELSE 0 END AS beans,
		CASE	WHEN CO.choice_description LIKE '%rice%' THEN 1
				ELSE 0 END AS rice,
		CASE	WHEN CO.choice_description LIKE '%cheese%' THEN 1
				ELSE 0 END AS cheese,
		CASE	WHEN CO.choice_description LIKE '%sour cream%' THEN 1
				ELSE 0 END AS sourcream,
		CASE	WHEN CO.choice_description LIKE '%guacamole%' THEN 1
				ELSE 0 END AS guacamole,
		CASE 	WHEN CO.choice_description LIKE '%lettuce%' THEN 1
				ELSE 0 END AS lettuce,
		CASE	WHEN CO.choice_description LIKE '%fajita vegetables%' THEN 1
				ELSE 0 END AS fajitavegetables,
		CO.item_price
FROM ChipotleOrders CO;

CREATE TEMPORARY TABLE ChipotlePlaceholder
SELECT	CAD.order_id, 
		CAD.item_name, 
        CAD.salsa, 
        CAD.beans, 
        CAD.rice, 
        CAD.cheese, 
        CAD.sourcream, 
        CAD.guacamole, 
        CAD.lettuce, 
        CAD.fajitavegetables, 
        CAD.lineitemtotal,
        SQ1.order_total
FROM ChipotleAnalysisData CAD
INNER JOIN (
	SELECT order_id, SUM(item_price) AS order_total
	FROM ChipotleOrders
	GROUP BY order_id
    ) SQ1
	ON CAD.order_id = SQ1.order_id;
 
TRUNCATE TABLE ChipotleAnalysisData;
 
INSERT INTO ChipotleAnalysisData (order_id,item_name,salsa,beans,rice,cheese,sourcream,guacamole,lettuce,fajitavegetables,lineitemtotal,ordertotal)
SELECT order_id,item_name,salsa,beans,rice,cheese,sourcream,guacamole,lettuce,fajitavegetables,lineitemtotal,order_total
FROM ChipotlePlaceholder;

SELECT item_name, COUNT(item_name), AVG(ordertotal)
FROM ChipotleAnalysisData
GROUP BY item_name
ORDER BY AVG(ordertotal) DESC;

