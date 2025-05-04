INSERT INTO user VALUES 
('MScott','Michael','Scott','mscott@gmail.com','2000-02-02','mscott123'),
('DSchrute','Dwight','Schrute','dschrute@gmail.com','2000-02-03','dschrute12'),
('PBeesly','Pam','Beesly','pbeesly@gmail.com','2000-02-04','pbeesly123'),
('JHalpert','Jim','Halpert','jhalpert@gmail.com','2000-02-05','jhalpert12'),
('CBratton','Creed','Bratton','cbratton@gmail.com','2000-02-06','cbratton12'),
('AMartin','Angela','Martin','amartin@gmail.com','2000-02-07','amartin123'),
('TFlenderson','Toby','Flenderson','tflenders@gmail.com','2000-02-08','tflender12'),
('RHoward','Ryan','Howard','rhoward@gmail.com','2000-02-09','rhoward123'),
('JLevinson','Jan','Levinson','jlevinson@gmail.com','2000-02-10','jlevinson1'),
('SHudson','Stanley','Hudson','shudson@gmail.com','2000-02-11','shudson12'),
('ABernard','Andy','Bernard','abernard@gmail.com','2000-02-12','abernard12');

INSERT INTO company VALUES 
('Dunder Mifflin',12345678,'DOY1',261012345,'Greece','Skydra','Korinthou',34,'MScott'),
('Corporate',23456789,'DOY2',261023456,'Greece','Edessa','Aiolou',23,'Jlevinson'),
('Stamford',34567891,'DOY3',261034567,'Greece','Giannitsa','Maizwnos',4,'SHudson');

INSERT INTO employe VALUES
('DSchrute','Master the Market',2345678,'MyCV1',12345678,20,'Best Employee','Greek,French'),
('PBeesly','The Paper God',3456789,'MyCV2',23456789,20,'Best Receptionist','Greek,Spanish'),
('JHalpert','How to Sell Paper',4567891,'MyCV3',23456789,20,'Best Comedian','Greek,Italian'),
('CBratton','Just Be Idle',5678912,'MyCV4',34567891,20,'Lazy & Thief','Greek,German');

INSERT INTO evaluator VALUES 
('AMartin',1,12345678),
('TFlenderson',2,23456789),
('RHoward',3,34567891);

INSERT INTO manager VALUES 
('MScott',20,12345678),
('JLevinson',20,23456789),
('SHudson',20,34567891);

INSERT INTO administrator VALUES 
('ABernard');

INSERT INTO degree VALUES 
('Financial Management ','Université du Montreal à Québec',2000,'MASTER','DSchrute'),
('Supply Chain Management & Logistics ','Amsterdam University of Applied Sciences',1999,'MASTER','PBeesly'),
('Business Analytics','Univeristy of Patras',2000,'UNIV','JHalpert'),
('Communication Science','University of Thessalonikh',1999,'UNIV','CBratton');

INSERT INTO project VALUES 
(1,'https://github.com/Project1','MyProject1','DSchrute'),
(2,'https://github.com/Project2','MyProject2','PBeesly'),
(3,'https://github.com/Project3','MyProject3','JHalpert'),
(4,'https://github.com/Project4','MyProject4','CBratton');

INSERT INTO job_position VALUES 
(1,'Skydra',10000,'Manager of Marketing'),
(2,'Edessa',7000,'Web Designer'),
(3,'Giannitsa',5000,'Logistics'),
(4,'Giannitsa',6000,'Project Manager'),
(5,'Skydra',5000,'Social Media Assistant'),
(6,'Edessa',7000,'Public Relations'),
(7,'Skydra',6500,'Chief Executive Officer'),
(8,'Edessa',7500,'Human Resources');

INSERT INTO field VALUES 
('Marketing','Promoting Products',1),
('Computer Science','Developing Software',2),
('Economics','Budget Management',3),
('Management','Methods Application',4),
('Journalism','Products Marketing',5),
('Business Marketing','Improves Relations',6),
('Administration','Managing Operations',7),
('Psychology','Managing People',8);

INSERT INTO evaluation VALUES 
(1,'4','2','DSchrute',1,'AMartin','Excellent! The position was made for him!','4'),
(2,'3','2','PBeesly',3,'TFlenderson','Very Good! We should give him the position!','3'),
(3,'2','1','JHalpert',4,'RHoward','Average! We should think carefully about giving him the position!','2'),
(4,'1','1','CBratton',8,'AMartin','Horrendous! He must be kidding about his request for promotion!','1'),
(5,'3','2','JHalpert',5,'RHoward',NULL,NULL);

INSERT INTO announces VALUES 
('AMartin',1,'2000-02-13','2000-02-20'),
('TFlenderson',3,'2000-02-14','2000-02-21'),
('RHoward',4,'2000-02-15','2000-02-22'),
('AMartin',8,'2000-02-16','2000-02-23');

INSERT INTO works VALUES 
('MScott',12345678),
('DSchrute',12345678),
('PBeesly',23456789),
('JHalpert',23456789),
('CBratton',34567891),
('AMartin',12345678),
('TFlenderson',23456789),
('RHoward',34567891),
('JLevinson',23456789),
('SHudson',34567891);

INSERT INTO decides VALUES 
('MScott',1),
('JLevinson',2),
('SHudson',3),
('SHudson',4),
('MScott',5),
('JLevinson',6),
('MScott',7),
('JLevinson',8);

INSERT INTO updates VALUES 
('MScott','DSchrute'),
('JLevinson','PBeesly'),
('JLevinson','JHalpert'),
('SHudson','CBratton');

INSERT INTO requests VALUES 
('DSchrute',1),
('PBeesly',3),
('JHalpert',4),
('CBratton',8);

INSERT INTO givesreport VALUES 
(1,'4','MScott'),
(2,'3','SHudson'),
(3,'2','SHudson'),
(4,'1','JLevinson');

INSERT INTO belongs VALUES 
('Marketing','Promoting Products','Marketing'),
('Computer Science','Developing Software','Computer Science'),
('Economics','Budget Management','Economics'),
('Management','Methods Application','Management'),
('Journalism','Products Marketing','Journalism'),
('Business Marketing','Improves Relations','Business Marketing'),
('Administration','Managing Operations','Administration'),
('Psychology','Managing People','Psychology');