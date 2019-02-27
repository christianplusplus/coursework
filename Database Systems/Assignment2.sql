CREATE TABLE Person(
    pid BIGINT AUTO_INCREMENT,
    firstName VARCHAR(100) NOT NULL DEFAULT 'John_Doe',
    middleName VARCHAR(100),
    lastName VARCHAR(100),
    dob DATE,
    dod DATE,
    gender VARCHAR(20),
    bio VARCHAR(1024),
    country VARCHAR(50),
    state VARCHAR(50),
    street VARCHAR(50),
    buildNum INTEGER,
    aptNum INTEGER,
    postalCode INTEGER,
    CONSTRAINT PRIMARY KEY (pid)
);

CREATE TABLE PrevNames(
    pid BIGINT,
    firstName VARCHAR(100) NOT NULL,
    middleName VARCHAR(100),
    lastName VARCHAR(100),
    dateChanged DATE,
    CONSTRAINT PRIMARY KEY (pid),
    CONSTRAINT FOREIGN KEY (pid) REFERENCES Person (pid)
    	ON DELETE CASCADE ON UPDATE NO ACTION
);

CREATE TABLE Association(
    pid1 BIGINT,
    pid2 BIGINT,
    assocType VARCHAR(20),
    CONSTRAINT PRIMARY KEY (pid1, pid2, assocType),
    CONSTRAINT FOREIGN KEY (pid1) REFERENCES Person (pid)
    	ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT FOREIGN KEY (pid2) REFERENCES Person (pid)
    	ON DELETE CASCADE ON UPDATE NO ACTION
);

CREATE TABLE Event(
    eid INTEGER AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    date DATE,
    description VARCHAR(1024),
    CONSTRAINT PRIMARY KEY (eid)
);

CREATE TABLE Present(
    eid INTEGER,
    pid BIGINT,
    CONSTRAINT PRIMARY KEY (eid, pid),
    CONSTRAINT FOREIGN KEY (eid) REFERENCES Event (eid)
    	ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT FOREIGN KEY (pid) REFERENCES Person (pid)
    	ON DELETE CASCADE ON UPDATE NO ACTION
);

CREATE TABLE User(
    username VARCHAR(20),
    passHash INTEGER NOT NULL,
    firstName VARCHAR(100) NOT NULL,
    middleNameOrInitial VARCHAR(100),
    LastName VARCHAR(100) NOT NULL,
    email VARCHAR(365) NOT NULL UNIQUE,
    CONSTRAINT PRIMARY KEY (username)
);

CREATE TABLE AuthorizedUser(
    username VARCHAR(20),
    CONSTRAINT PRIMARY KEY (username),
    CONSTRAINT FOREIGN KEY (username) REFERENCES User (username)
    	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Admin(
    username VARCHAR(20),
    CONSTRAINT PRIMARY KEY (username),
    CONSTRAINT FOREIGN KEY (username) REFERENCES AuthorizedUser (username)
    	ON DELETE CASCADE ON UPDATE CASCADE
);
