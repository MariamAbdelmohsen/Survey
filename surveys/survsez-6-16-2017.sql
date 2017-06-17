/*
  first version of SurveySez tables
  04/27/2017

  Here are a few notes on things below that may not be self evident:

  INDEXES: You'll see indexes below for example:

  INDEX SurveyID_index(SurveyID)

  Any field that has highly unique data that is either searched on or used as a join should be indexed, which speeds up a
  search on a tall table, but potentially slows down an add or delete

  TIMESTAMP: MySQL currently only supports one date field per table to be automatically updated with the current time.  We'll use a
  field in a few of the tables named LastUpdated:

  LastUpdated TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP

  The other date oriented field we are interested in, DateAdded we'll do by hand on insert with the MySQL function NOW().

  CASCADES: In order to avoid orphaned records in deletion of a Survey, we'll want to get rid of the associated Q & A, etc.
  We therefore want a 'cascading delete' in which the deletion of a Survey activates a 'cascade' of deletions in an
  associated table.  Here's what the syntax looks like:

  FOREIGN KEY (SurveyID) REFERENCES sp17_surveys(SurveyID) ON DELETE CASCADE

  The above is from the Questions table, which stores a foreign key, SurveyID in it.  This line of code tags the foreign key to
  identify which associated records to delete.

  Be sure to check your cascades by deleting a survey and watch all the related table data disappear!


*/


SET foreign_key_checks = 0; #turn off constraints temporarily

#since constraints cause problems, drop tables first, working backward
DROP TABLE IF EXISTS sp17_responses_answers;
DROP TABLE IF EXISTS sp17_responses;
DROP TABLE IF EXISTS sp17_answers;
DROP TABLE IF EXISTS sp17_questions;
DROP TABLE IF EXISTS sp17_surveys;

#all tables must be of type InnoDB to do transactions, foreign key constraints
CREATE TABLE sp17_surveys(
SurveyID INT UNSIGNED NOT NULL AUTO_INCREMENT,
AdminID INT UNSIGNED DEFAULT 0,
Title VARCHAR(255) DEFAULT '',
Description TEXT DEFAULT '',
DateAdded DATETIME,
LastUpdated TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,
TotalResponses INT DEFAULT 0,
Status ENUM('new','active','pending','retired') DEFAULT 'new',
PRIMARY KEY (SurveyID)
)ENGINE=INNODB;

  #assigning first survey to AdminID == 1 or 2
  INSERT INTO sp17_surveys VALUES (NULL,1,'Our First Survey','Description of Survey',NOW(),NOW(),0,'new');
  INSERT INTO sp17_surveys VALUES (NULL,2,'Our Education survey','This is Education survey',NOW(),NOW(),0,'new');
  INSERT INTO sp17_surveys VALUES (NULL,1,'our Hobby Survey','This is our Hobby Survey',NOW(),NOW(),0,'new');
  INSERT INTO sp17_surveys VALUES (NULL,2,'our Music Survey','This is our Music Survey',NOW(),NOW(),0,'new');
  INSERT INTO sp17_surveys VALUES (NULL,2,'our Travel Survey','This is our Travel Survey',NOW(),NOW(),0,'new');
  INSERT INTO sp17_surveys values (NULL,1,'Our First Survey','Description of Survey',NOW(),NOW(),0,'new');
  INSERT INTO sp17_surveys values (NULL,1,'A Python Related Survey','Our second survey',NOW(),NOW(),0,'new');
  INSERT INTO sp17_surveys values (NULL,1,'Yet a third survey','Are we gluttons for punishment?',NOW(),NOW(),0,'new');
  #foreign key field must match size and type, hence SurveyID is INT UNSIGNED
  CREATE TABLE sp17_questions(
  QuestionID INT UNSIGNED NOT NULL AUTO_INCREMENT,
  SurveyID INT UNSIGNED DEFAULT 0,
  Question TEXT DEFAULT '',
  Description TEXT DEFAULT '',
  InputType ENUM('checkbox','radio','select','text') DEFAULT 'radio',
  DateAdded DATETIME,
  LastUpdated TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (QuestionID),
  INDEX SurveyID_index(SurveyID),
  FOREIGN KEY (SurveyID) REFERENCES sp17_surveys(SurveyID) ON DELETE CASCADE
  )ENGINE=INNODB;



#questions for SurveyID #1
INSERT INTO sp17_questions VALUES (NULL,1,'Do You Like Our Website?','We really want to know!','radio',NOW(),NOW());
INSERT INTO sp17_questions VALUES (NULL,1,'Do You Like Cookies?','We like cookies!','select',NOW(),NOW());
INSERT INTO sp17_questions VALUES (NULL,1,'Favorite Toppings?','We like chocolate!','checkbox',NOW(),NOW());


#Question for SurveyID #2 , Education survey
INSERT INTO sp17_questions VALUES (NULL,2,'What is your highest level of education ?','We really want to know!','radio',NOW(),NOW());
INSERT INTO sp17_questions VALUES (NULL,2,'Are you current in school?','Yes , we are nose!','checkbox',NOW(),NOW());


#Question for SurveyID #3 , Hobby survey
INSERT INTO sp17_questions VALUES (NULL,3,'How much time do you spend per week in your hobbies?','are you lazy!','radio',NOW(),NOW());
INSERT INTO sp17_questions VALUES (NULL,3,'Do you prefer indoor or outdoor hobbies?','please dont elaborate!','select',NOW(),NOW());

#Question for SurveyID #4 , Music survey
INSERT INTO sp17_questions VALUES (NULL,4,'What type of music you like to listen','please dont elaborate!','radio',NOW(),NOW());
INSERT INTO sp17_questions VALUES (NULL,4,'How often you listen to music','please dont elaborate!','select',NOW(),NOW());
#Question for SurveyID #5 , Travel survey
INSERT INTO sp17_questions VALUES (NULL,5,'Where You like to teavel ','please dont elaborate!','radio',NOW(),NOW());
INSERT INTO sp17_questions VALUES (NULL,5,'How often do you take vacation ','please dont elaborate!','select',NOW(),NOW());


CREATE TABLE sp17_answers(
AnswerID INT UNSIGNED NOT NULL AUTO_INCREMENT,
QuestionID INT UNSIGNED DEFAULT 0,
Answer TEXT DEFAULT '',
Description TEXT DEFAULT '',
DateAdded DATETIME,
LastUpdated TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,
Status INT DEFAULT 0,
PRIMARY KEY (AnswerID),
INDEX QuestionID_index(QuestionID),
FOREIGN KEY (QuestionID) REFERENCES sp17_questions(QuestionID) ON DELETE CASCADE
)ENGINE=INNODB;



#answers for survay #1
INSERT INTO sp17_answers VALUES (NULL,1,'Yes','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,1,'No','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,2,'Yes','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,2,'No','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,2,'Maybe','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,3,'Chocolate','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,3,'Butterscotch','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,3,'Pineapple','',NOW(),NOW(),0);

#Answers for survey #2 ,
 the education survey question 4 and 5
#Grade school , High School,  college , Bachelors Degree, masters degree , phd

#answer to question 4
INSERT INTO sp17_answers VALUES (NULL,4,'Grade School','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,4,'High School','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,4,'College','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,4,'Bachelors Degree','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,4,'Masters Degree','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,4,'PHD','',NOW(),NOW(),0);

#answer to question 5

INSERT INTO sp17_answers VALUES (NULL,5,'Yes','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,5,'No','',NOW(),NOW(),0);

#Answers for survey #3

the hoppy survey question 6 and 7

#answer to question 6
#Zero, 1-5 hours , 6-10 hours, 11 hours or more
INSERT INTO sp17_answers VALUES (NULL,6,'Zero','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,6,'1-5 hours','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,6,'6-10 hours','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,6,'11 hours or more','',NOW(),NOW(),0);

#answer to question 7

INSERT INTO sp17_answers VALUES (NULL,7,'Indoor','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,7,'outdoor','',NOW(),NOW(),0);


#Answers for survey #4

the Music survey question 8 and 9

#answer to question 8
#What type of music you like to listen to?
INSERT INTO sp17_answers VALUES (NULL,8,'Jazz','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,8,'Classical Music','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,8,'Blues','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,8,'Melody','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,8,'Rock music','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,8,'hip hop music','',NOW(),NOW(),0);


#answer to question 9
#Zero, 1-5 hours , 6-10 hours, 11 hours or more
INSERT INTO sp17_answers VALUES (NULL,9,'Zero','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,9,'1-5 hours','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,9,'6-10 hours','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,9,'11 hours or more','',NOW(),NOW(),0);

#Answers for survey #5

the Travel survey question 10 and 11

#answer to question 10  where You like to teavel?

INSERT INTO sp17_answers VALUES (NULL,10,'Domestic','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,10,'international','',NOW(),NOW(),0);


#answer to question 11 How often do you take vacation
#Zero, 1-5 hours , 6-10 hours, 11 months or more

INSERT INTO sp17_answers VALUES (NULL,9,'Zero','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,9,'1-5 months','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,9,'6-10 months','',NOW(),NOW(),0);
INSERT INTO sp17_answers VALUES (NULL,9,'11 months or more','',NOW(),NOW(),0);



DROP TABLE IF EXISTS sp17_responses;

CREATE TABLE sp17_responses(
ResponseID INT UNSIGNED NOT NULL AUTO_INCREMENT,
SurveyID INT UNSIGNED NOT NULL DEFAULT 0,
DateAdded DATETIME,
PRIMARY KEY (ResponseID),
INDEX SurveyID_index(SurveyID),
FOREIGN KEY (SurveyID) REFERENCES sp17_surveys(SurveyID) ON DELETE CASCADE
)ENGINE=INNODB;


#here are 5 responses to survey 1
INSERT INTO sp17_responses VALUES (NULL,1,NOW());
INSERT INTO sp17_responses VALUES (NULL,1,NOW());
INSERT INTO sp17_responses VALUES (NULL,1,NOW());
INSERT INTO sp17_responses VALUES (NULL,1,NOW());
INSERT INTO sp17_responses VALUES (NULL,1,NOW());

#here are 3 responses to survey 2
INSERT INTO sp17_responses VALUES (NULL,2,NOW());
INSERT INTO sp17_responses VALUES (NULL,2,NOW());
INSERT INTO sp17_responses VALUES (NULL,2,NOW());


#here are 6 responses to survey 3
INSERT INTO sp17_responses VALUES (NULL,3,NOW());
INSERT INTO sp17_responses VALUES (NULL,3,NOW());
INSERT INTO sp17_responses VALUES (NULL,3,NOW());
INSERT INTO sp17_responses VALUES (NULL,3,NOW());
INSERT INTO sp17_responses VALUES (NULL,3,NOW());
INSERT INTO sp17_responses VALUES (NULL,3,NOW());


#here are 5 responses to survey 4
INSERT INTO sp17_responses VALUES (NULL,4,NOW());
INSERT INTO sp17_responses VALUES (NULL,4,NOW());
INSERT INTO sp17_responses VALUES (NULL,4,NOW());
INSERT INTO sp17_responses VALUES (NULL,4,NOW());
INSERT INTO sp17_responses VALUES (NULL,4,NOW());

#here are 4 responses to survey 5
INSERT INTO sp17_responses VALUES (NULL,5,NOW());
INSERT INTO sp17_responses VALUES (NULL,5,NOW());
INSERT INTO sp17_responses VALUES (NULL,5,NOW());
INSERT INTO sp17_responses VALUES (NULL,5,NOW());



CREATE TABLE sp17_responses_answers(
RQID INT UNSIGNED NOT NULL AUTO_INCREMENT,
ResponseID INT UNSIGNED DEFAULT 0,
QuestionID INT DEFAULT 0,
AnswerID INT DEFAULT 0,
PRIMARY KEY (RQID),
INDEX ResponseID_index(ResponseID),
FOREIGN KEY (ResponseID) REFERENCES sp17_responses(ResponseID) ON DELETE CASCADE
)ENGINE=INNODB;


#responses to survey #1, questions 1-3, answers 1-8
INSERT INTO sp17_responses_answers VALUES (NULL,1,1,1);
INSERT INTO sp17_responses_answers VALUES (NULL,1,2,4);
INSERT INTO sp17_responses_answers VALUES (NULL,1,3,7);
INSERT INTO sp17_responses_answers VALUES (NULL,1,3,8);

INSERT INTO sp17_responses_answers VALUES (NULL,2,1,1);
INSERT INTO sp17_responses_answers VALUES (NULL,2,2,5);
INSERT INTO sp17_responses_answers VALUES (NULL,2,3,6);
INSERT INTO sp17_responses_answers VALUES (NULL,2,3,7);
INSERT INTO sp17_responses_answers VALUES (NULL,2,3,8);

INSERT INTO sp17_responses_answers VALUES (NULL,3,1,2);
INSERT INTO sp17_responses_answers VALUES (NULL,3,2,5);
INSERT INTO sp17_responses_answers VALUES (NULL,3,3,8);

INSERT INTO sp17_responses_answers VALUES (NULL,4,1,2);
INSERT INTO sp17_responses_answers VALUES (NULL,4,2,5);
INSERT INTO sp17_responses_answers VALUES (NULL,4,3,8);

INSERT INTO sp17_responses_answers VALUES (NULL,5,1,2);
INSERT INTO sp17_responses_answers VALUES (NULL,5,2,5);
INSERT INTO sp17_responses_answers VALUES (NULL,5,3,8);

#responses to survey #2, questions 4 & 5, answers 9-13
INSERT INTO sp17_responses_answers VALUES (NULL,6,4,9);
INSERT INTO sp17_responses_answers VALUES (NULL,6,5,11);

INSERT INTO sp17_responses_answers VALUES (NULL,7,4,10);
INSERT INTO sp17_responses_answers VALUES (NULL,7,5,12);
INSERT INTO sp17_responses_answers VALUES (NULL,7,5,13);

INSERT INTO sp17_responses_answers VALUES (NULL,8,4,10);
INSERT INTO sp17_responses_answers VALUES (NULL,8,5,11);
INSERT INTO sp17_responses_answers VALUES (NULL,8,5,13);



SET foreign_key_checks = 1; #turn foreign key check back on
