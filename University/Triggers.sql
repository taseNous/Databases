1.
//Insert
CREATE TRIGGER job_insert
AFTER INSERT ON job_position
FOR EACH ROW
BEGIN
DECLARE currDate DATETIME;
SET currDate=CURRENT_TIMESTAMP();
INSERT INTO log VALUES(DEFAULT,'ABernard',currDate,'insert','1','job_position');
END$

CREATE TRIGGER employe_insert
AFTER INSERT ON employe
FOR EACH ROW
BEGIN
DECLARE currDate DATETIME;
SET currDate=CURRENT_TIMESTAMP();
INSERT INTO log VALUES(DEFAULT,'ABernard',currDate,'insert','1','employe');
END$

CREATE TRIGGER requests_insert
BEFORE INSERT ON requests
FOR EACH ROW
BEGIN
DECLARE currDate DATETIME;
SET currDate=CURRENT_TIMESTAMP();
INSERT INTO log VALUES(DEFAULT,'ABernard',currDate,'insert','1','requests');
END$


//Update
CREATE TRIGGER job_update
AFTER UPDATE ON job_position
FOR EACH ROW
BEGIN
DECLARE currDate DATETIME;
SET currDate=CURRENT_TIMESTAMP();
INSERT INTO log VALUES(DEFAULT,'ABernard',currDate,'update','1','job_position');
END$

CREATE TRIGGER employe_update
AFTER UPDATE ON employe
FOR EACH ROW
BEGIN
DECLARE currDate DATETIME;
SET currDate=CURRENT_TIMESTAMP();
INSERT INTO log VALUES(DEFAULT,'ABernard',currDate,'update','1','employe');
END$

CREATE TRIGGER requests_update
AFTER UPDATE ON requests
FOR EACH ROW
BEGIN
DECLARE currDate DATETIME;
SET currDate=CURRENT_TIMESTAMP();
INSERT INTO log VALUES(DEFAULT,'ABernard',currDate,'update','1','requests');
END$

//Delete
CREATE TRIGGER job_delete
AFTER DELETE ON job_position
FOR EACH ROW
BEGIN
DECLARE currDate DATETIME;
SET currDate=CURRENT_TIMESTAMP();
INSERT INTO log VALUES(DEFAULT,'ABernard',currDate,'delete','1','job_position');
END$

CREATE TRIGGER employe_delete
AFTER DELETE ON employe
FOR EACH ROW
BEGIN
DECLARE currDate DATETIME;
SET currDate=CURRENT_TIMESTAMP();
INSERT INTO log VALUES(DEFAULT,'ABernard',currDate,'delete','1','employe');
END$

CREATE TRIGGER requests_delete
AFTER DELETE ON requests
FOR EACH ROW
BEGIN
DECLARE currDate DATETIME;
SET currDate=CURRENT_TIMESTAMP();
INSERT INTO log VALUES(DEFAULT,'ABernard',currDate,'delete','1','requests');
END$