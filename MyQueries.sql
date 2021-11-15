/*Вывести (выбрать) максимальный номер заказа сотрудника Buchanan Steven.*/
SELECT MAX(OrderID) as MaxOrderID, FirstName, LastName
FROM Orders
Join Employees
ON Orders.EmployeeID = Employees.EmployeeID
WHERE FirstName = 'Steven' AND LastName = 'Buchanan'

/*Вывести (выбрать) товары, цены которых больше средней цены по всем продуктам.*/
SELECT ProductName , Price
FROM Products
Where Price > (SELECT AVG(Price) FROM Products)

/*Посчитать и вывести для каждого заказа его итоговую стоимость при помощи цены и количества для каждого товара.*/ 
SELECT OrderID, SUM(Price*Quantity)
FROM OrderDetails
JOIN Products
ON OrderDetails.ProductID = Products.ProductID
GROUP BY OrderID

/*Создать пользователя в таблице Employees с номером 11.*/
insert into Employees
(EmployeeID, LastName, FirstName, BirthDate)
values ( 11, 'Ivanenko', 'Ivan', '2000-02-11')

/*Изменить (обновить) значение в колонке EmployeeID на 11 для CustomerID in (89, 90).*/
UPDATE Orders
SET EmployeeID = 11
WHERE CustomerID in (89, 90);

--Для товаров, у которых цена больше средней цены по всем продуктам, повысить цену еще на 10% (обновить значения цены). 
UPDATE Products
SET Price = Price*1.1 
WHERE Price > (SELECT AVG(Price) FROM Products)

--Вывести (выбрать) заказы, закрепленные за сотрудником, в виде: OrderID, LastName, FirstName.
SELECT Orders.OrderID, LastName, FirstName
from Orders
INNER JOIN Employees
ON Orders.EmployeeID = Employees.EmployeeID

/*Вывести (выбрать) всю информацию о сотрудниках, у которых нет ни одного заказа
 (используйте один из видов join для решения).*/
SELECT Employees.*, Orders.OrderID
from Employees
LEFT JOIN Orders
ON Employees.EmployeeID = Orders.EmployeeID
WHERE  OrderID IS NULL

/*У нас есть две таблицы: Shippers и Suppliers, их необходимо объединить, чтобы сделать общую таблицу,
 состоящую из двух колонок (в первой колонке - имя таблицы, с которой взята запись,
 во второй колонке -название ShipperName или SupplierName.*/
SELECT "Shippers" as TableName, ShipperName as Name
FROM Shippers
UNION
SELECT "Suppliers", SupplierName
FROM Suppliers

--Вывести (сделать выборку) всех сотрудников с именем Robert.
SELECT * from Employees
WHERE FirstName = "Robert"

--Вывести (выбрать) наименования продуктов с кодами 1, 3, 7, 9 и цену, уменьшенную на 50%. 
SELECT ProductName, Price*0.5 AS New_price
FROM Products
WHERE ProductID IN (1,3,7,9)

--Вывести (выбрать) все заказы сотрудника с номером 5 или заказы клиента с кодом больше 88 и кодом грузоотправителя 1. 
SELECT * FROM Orders
WHERE EmployeeID = 5 OR CustomerID > 88 AND SnipperID = 1

--Вывести все продукты, у которых код продукта >= 64 или продукты, у которых поставщик = "Tokyo Traders" (подзапрос).
SELECT * FROM Products
WHERE ProductID >= 64 OR SupplierID = 
(SELECT SupplierID FROM SupplierS 
WHERE SupplierName =  "Tokyo Traders");

/*Query DML https://sql-ex.ru/:
Exercise: 1
Add following model into the PC table: 
code: 20 
model: 2111 
speed: 950 
ram: 512 
hd: 60
cd: 52x */
INSERT INTO pc (code, model, speed, ram, hd, cd, price)
VALUES (20, 2111, 950, 512, 60, '52x', 1100)

/*Exercise: 2
Add to the Product table following products from maker Z:
printer model 4003, PC model 4001 and laptop model 4002*/
INSERT INTO product (maker, type, model)
 VALUES
 ('Z', 'Printer', 4003),
 ('Z', 'PC', 4001),
 ('Z', 'Laptop', 4002)

/*Exercise: 3
Add the model 4444 with code=22, speed=1200 and price=1350 into the PC table.
The absent features should be supplied with the default values for corresponding columns.*/
INSERT INTO pc  
 (model, code, speed, price)
VALUES
 (4444,22,1200,1350)

/*Exercise: 4
For each group of laptops with the identical model number, add following record into PC table:
code: minimal code among laptops in the group +20; 
model: laptop's model number +1000;
speed: maximal speed among laptops in the group; 
ram: maximal ram size among laptops in the group *2
      hd: maximal hd capacity among laptops in the group *2; 
cd: default value; 
price: maximal price among laptops in the group divided by 1.5.
Remark. Consider model number as numeric.*/
INSERT INTO pc (code, model, speed, ram, hd, price)
 SELECT min(code) + 20,
        model + 1000,
        max(speed),
        max(ram) * 2,
        max(hd) * 2,
        max(price) / 1.5
        FROM laptop
  GROUP BY model

/*Exercise: 5
Delete from PC table the computers having minimal hdd size or minimal ram size*/
DELETE FROM PC
WHERE hd = (SELECT min(hd) FROM pc) OR
      ram = (SELECT min(ram) FROM pc)

/*Exercise: 6
Delete from the Laptop table all the laptops of those makers who don't produce printers.*/
DELETE FROM laptop 
WHERE model NOT IN
 (SELECT model FROM product where maker in
   (SELECT maker from product where type = 'Printer'))

/*Exercise: 7
Maker A has passed manufacture of printers to maker Z. Perform necessary changes.*/
UPDATE product 
SET maker = 'Z'
WHERE maker = 'A' AND type = 'Printer'

/*Exercise: 9
Modify data in Classes table so that gun calibers are measured in centimeters (1 inch = 2.5cm), and the displacement 
- in metric tons (1 metric ton = 1.1 tons).
Calculate displacement to within integer.*/
      UPDETE Classes
SET bore=bore*2.5,
 displacement= ROUND(displacement/1.1,0)

/*Exercise: 10 
Add into the PC table all the PC models from the Product table that are absent from the PC table. Along with above the inserted models must have the specifications:
1. The code should be equal to the model number plus maximal code value which has been in the PC table before insert operation. 
2. Speed, RAM and HD capacities, and CD-speed should be maximal among all available corresponding values in the PC table.
3. The price should be an average among all the PCs which have been in the PC table before insert operation.
INSERT INTO pc (code, model, speed, ram, hd, cd, price)*/
 SELECT 
 (SELECT MAX(code) from pc) + model,
 model,
 (SELECT MAX(speed) from pc),
 (SELECT MAX(ram) from pc),
 (SELECT MAX(hd) from pc),
 (SELECT MAX(cd) from pc),
 (SELECT AVG(price) from pc)
 FROM product
 WHERE  type = 'PC' AND model NOT IN (SELECT model from pc)
