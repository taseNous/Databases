3.
DELIMITER $
CREATE PROCEDURE employee(IN em_name VARCHAR(20), IN em_surname VARCHAR(20))
BEGIN

SELECT requests.em_username AS Username, requests.jobid AS Job_ID FROM requests
INNER JOIN employe ON requests.em_username=employe.em_username
INNER JOIN user ON employe.em_username=user.username
WHERE em_name=user.name AND em_surname=user.surname;

SELECT evaluation.report AS Report, evaluation.capability AS Capability, evaluation.interview AS Interview,
evaluation.ev_comments AS comments FROM evaluation
INNER JOIN requests ON evaluation.em_username=requests.em_username
INNER JOIN employe ON requests.em_username=employe.em_username
INNER JOIN user ON employe.em_username=user.username
WHERE em_name=user.name AND em_surname=user.surname;


SELECT user.name, user.surname FROM user
INNER JOIN evaluator ON user.username=evaluator.ev_username
INNER JOIN evaluation ON evaluator.ev_username=evaluation.ev_username
WHERE evaluation.ev_username IN
(SELECT evaluation.ev_username FROM evaluation
INNER JOIN requests ON evaluation.em_username=requests.em_username
INNER JOIN employe ON requests.em_username=employe.em_username
INNER JOIN user ON employe.em_username=user.username
WHERE em_name=user.name AND em_surname=user.surname);

END $
DELIMITER ;