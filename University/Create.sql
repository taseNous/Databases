create database StaffEvaluation;
use StaffEvaluation;

DROP TABLE IF EXISTS user;
CREATE TABLE user(
	username VARCHAR(20) NOT NULL DEFAULT 'unknown',
	name VARCHAR(10) NOT NULL DEFAULT 'unknown',
	surname VARCHAR(10) NOT NULL DEFAULT 'unknown',
	email VARCHAR(20) NOT NULL DEFAULT 'unknown',
	sign_in_date DATE NOT NULL,
	password VARCHAR(10) NOT NULL,
	PRIMARY KEY(username)
);

CREATE TABLE log(
	logid INT(10) NOT NULL AUTO_INCREMENT,
	username VARCHAR(20) NOT NULL DEFAULT 'unknown',
	actiondatetime DATETIME NOT NULL,
	action ENUM ('insert','update','delete'),
	success ENUM ('0','1'),
	tablename VARCHAR(20) NOT NULL DEFAULT 'unknown',
	PRIMARY KEY(logid),
	CONSTRAINT LOGUS
	FOREIGN KEY(username) REFERENCES user(username)
	ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS company;

CREATE TABLE company(
companyName VARCHAR(20) NOT NULL DEFAULT 'unknown',
afm INT(10) NOT NULL DEFAULT '0',
DOY VARCHAR(15) NOT NULL DEFAULT 'unknown',
phonenumber INT(10) NOT NULL DEFAULT '0',
country VARCHAR(15) NOT NULL DEFAULT 'unknown',
town VARCHAR(15) NOT NULL DEFAULT 'unknown',
street VARCHAR(15) NOT NULL DEFAULT 'unknown',
arithmos INT(10) NOT NULL DEFAULT '0',
PRIMARY KEY(afm)
);


DROP TABLE IF EXISTS employe;

CREATE TABLE employe (
  em_username VARCHAR(20) NOT NULL REFERENCES user(username),
  certifications VARCHAR(25) NOT NULL DEFAULT 'unknown',
  am INT(10) NOT NULL DEFAULT '0',
  cv TEXT NOT NULL,
  companyAfm INT(10) NOT NULL DEFAULT '0',
  workyears INT(10) NOT NULL DEFAULT '0',
  achievement VARCHAR(25)  NOT NULL DEFAULT 'not_found',
  languages VARCHAR(25) NOT NULL DEFAULT 'unknown',
  PRIMARY KEY (em_username),
  CONSTRAINT COMAFM
  FOREIGN KEY(companyAfm) REFERENCES company(afm)
  ON DELETE CASCADE ON UPDATE CASCADE
) ;

DROP TABLE IF EXISTS administrator;

CREATE TABLE administrator(
    ad_username VARCHAR(20) NOT NULL REFERENCES user(username),
    PRIMARY KEY(ad_username)
);

DROP TABLE IF EXISTS evaluator;

CREATE TABLE evaluator(
    ev_username VARCHAR(20) NOT NULL REFERENCES user(username),
    ev_code INT(10) NOT NULL DEFAULT '0',
    company_afm INT(10) NOT NULL DEFAULT '0',
    PRIMARY KEY(ev_username)
);



DROP TABLE IF EXISTS manager;

CREATE TABLE manager (
  m_username varchar(20) NOT NULL REFERENCES user(username),
  workyears int(2) NOT NULL DEFAULT 0,
  companyAfm bigint(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (m_username)
);




DROP TABLE IF EXISTS updates;

CREATE TABLE updates(
m_username VARCHAR(20) NOT NULL,
em_username VARCHAR(20) NOT NULL,
PRIMARY KEY(m_username,em_username),
CONSTRAINT UPDM
FOREIGN KEY (m_username) REFERENCES manager(m_username)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT UPDEM
FOREIGN KEY (em_username) REFERENCES employe(em_username)
ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS works;

CREATE TABLE works(
username VARCHAR(20) NOT NULL,
afm INT(10) NOT NULL DEFAULT '0',
PRIMARY KEY(username,afm),
CONSTRAINT WORK
FOREIGN KEY(username) REFERENCES user(username)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT WORKAFM
FOREIGN KEY(afm) REFERENCES company(afm)
ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS degree;

CREATE TABLE degree(
dtitle VARCHAR(50) NOT NULL ,
idrima VARCHAR(40) NOT NULL,
etosktisis INT(4) NOT NULL,
bathmos ENUM('LYKEIO','UNIV','MASTER','PHD'),
username VARCHAR(20) NOT NULL,
PRIMARY KEY(dtitle,idrima),
CONSTRAINT DEG
FOREIGN KEY(username) REFERENCES employe(em_username)
ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS project;

CREATE TABLE project(
aa INT(10) NOT NULL AUTO_INCREMENT,
url VARCHAR(60) NOT NULL,
perigrafi TEXT NOT NULL,
username VARCHAR(20) NOT NULL,
PRIMARY KEY(aa),
CONSTRAINT PRJE
FOREIGN KEY(username) REFERENCES employe(em_username)
ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS requests;

CREATE TABLE requests(
	em_username VARCHAR(20) NOT NULL DEFAULT 'unknown',
	jobid INT(10) NOT NULL DEFAULT '0',
	PRIMARY KEY(em_username,jobid),
	CONSTRAINT RQS1
	FOREIGN KEY (em_username) REFERENCES employe(em_username)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT RQS3
	FOREIGN KEY (jobid) REFERENCES announces(jobid)
	ON DELETE CASCADE ON UPDATE CASCADE
); 


DROP TABLE IF EXISTS evaluation;

CREATE TABLE evaluation(
    evalid INT(10) NOT NULL DEFAULT '0',
    report ENUM ('0','1','2','3','4'),
    capability ENUM ('0','1','2'),
    em_username VARCHAR(20) NOT NULL DEFAULT 'unknown',
    evaljob VARCHAR(20) NOT NULL DEFAULT 'unknown',
    ev_username VARCHAR(20) NOT NULL DEFAULT 'unknown',
    ev_comments VARCHAR(100) DEFAULT 'unknown', 
    interview ENUM ('0','1','2','3','4'),
    PRIMARY KEY(evalid),
    CONSTRAINT EMPL2
    FOREIGN KEY(em_username) REFERENCES requests(em_username),
    CONSTRAINT SJDJAS 
    FOREIGN KEY(ev_username) REFERENCES evaluator(ev_username)
    ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS givesreport;

CREATE TABLE givesreport(
	evalid INT(10) NOT NULL DEFAULT '0',
	mReport varchar(20) NOT NULL,
	m_username varchar(20) NOT NULL,
	PRIMARY KEY (evalid,m_username),
	CONSTRAINT GR1
	FOREIGN KEY (evalid) REFERENCES evaluation(evalid)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT GR2
	FOREIGN KEY (m_username) REFERENCES manager(m_username)
	ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS evaluationresult;

CREATE TABLE evaluationresult(
    reid INT(10) NOT NULL AUTO_INCREMENT,
    ad_username VARCHAR(20) NOT NULL DEFAULT 'unknown',
    evalid INT(10) NOT NULL,
    finalgrade INT(10) NOT NULL DEFAULT '0',
    PRIMARY KEY(reid),
    CONSTRAINT USRNAME 
    FOREIGN KEY(ad_username) REFERENCES administrator(ad_username)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT EVID 
    FOREIGN KEY(evalid) REFERENCES evaluation(evalid)
    ON DELETE CASCADE ON UPDATE CASCADE
    );

DROP TABLE IF EXISTS job_position;

CREATE TABLE job_position(
    jobid INT(10) NOT NULL DEFAULT '0',
    jobedra VARCHAR(20) NOT NULL DEFAULT 'unknown',
    salary INT(10) NOT NULL DEFAULT '0',
    jobtitle VARCHAR(50) NOT NULL DEFAULT 'unknown',
    PRIMARY KEY(jobid)
    );

DROP TABLE IF EXISTS announces;

CREATE TABLE announces(
        username VARCHAR(20) NOT NULL DEFAULT 'unknown',
        jobid INT(10) NOT NULL DEFAULT '0',
        opendate DATE NOT NULL,
        closedate DATE NOT NULL, 
        PRIMARY KEY(username,jobid),
        CONSTRAINT USRNM
        FOREIGN KEY(username) REFERENCES evaluator(ev_username)
        ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT JOBID 
        FOREIGN KEY(jobid) REFERENCES job_position(jobid)
        ON DELETE CASCADE ON UPDATE CASCADE
    );



DROP TABLE IF EXISTS field;

CREATE TABLE field(
        ftitle VARCHAR(50) NOT NULL DEFAULT 'unknown',
        perigrafi VARCHAR(20) NOT NULL DEFAULT 'unknown',
        jobid INT(10) NOT NULL DEFAULT '0',
        PRIMARY KEY(ftitle),
        CONSTRAINT JBID1
        FOREIGN KEY(jobid) REFERENCES job_position(jobid)
        ON DELETE CASCADE ON UPDATE CASCADE
        );

CREATE TABLE belongs(
	ftitle VARCHAR(50) NOT NULL DEFAULT 'unknown',
        perigrafi VARCHAR(20) NOT NULL DEFAULT 'unknown',
	parent VARCHAR(50) NOT NULL DEFAULT 'unknown',
	PRIMARY KEY(ftitle),
	CONSTRAINT PRNT 
        FOREIGN KEY(parent) REFERENCES belongs(ftitle)
        ON DELETE CASCADE ON UPDATE CASCADE
    );

DROP TABLE IF EXISTS decides;

CREATE TABLE decides(
	m_username VARCHAR(50) NOT NULL DEFAULT 'unknown',
	jobid INT(10) NOT NULL DEFAULT '0',
	PRIMARY KEY(m_username,jobid),
	CONSTRAINT DEMA
	FOREIGN KEY(m_username) REFERENCES manager(m_username)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT DEJOB
	FOREIGN KEY(jobid) REFERENCES job_position(jobid)
	ON DELETE CASCADE ON UPDATE CASCADE
);