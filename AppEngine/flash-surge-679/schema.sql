DROP TABLE IF EXISTS user_activities;
DROP TABLE IF EXISTS friends;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS activities;
DROP TABLE IF EXISTS categories;


CREATE TABLE users
(
	ID int NOT NULL AUTO_INCREMENT,
	username varchar(32),
	lastname varchar(32),
	firstname varchar(32),
	email varchar(128),
	password_hash varchar(64),
	PRIMARY KEY (ID)
);

CREATE TABLE categories
(
	ID int NOT NULL AUTO_INCREMENT,
	category_name varchar(64),
	PRIMARY KEY (ID) 
);

CREATE TABLE activities
(
	ID int NOT NULL AUTO_INCREMENT,
	activity_name varchar(64),
	category_ID int,
	FOREIGN KEY (category_ID) REFERENCES categories(ID),
	PRIMARY KEY (ID)
);

CREATE TABLE user_activities
(
	user_ID int,
	activity_ID int,
	FOREIGN KEY (user_ID) REFERENCES users(ID),
	FOREIGN KEY (activity_ID) REFERENCES activities(ID)
);

CREATE TABLE events
(
	ID int NOT NULL AUTO_INCREMENT,
	name varchar(64),
	user_ID int,
	activity_ID int,
	description varchar(512),
	number_interested int DEFAULT 0,
	FOREIGN KEY (user_ID) REFERENCES users(ID),
	FOREIGN KEY (activity_ID) REFERENCES activities(ID),
	PRIMARY KEY (ID)
);

CREATE TABLE friends
(
	user1_ID int,
	user2_ID int,
	FOREIGN KEY (user1_ID) REFERENCES users(ID),
	FOREIGN KEY (user2_ID) REFERENCES users(ID)
);



