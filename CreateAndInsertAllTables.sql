CREATE TABLE Movie
(
    MovieId NUMBER(9)
        CONSTRAINT movie_pk PRIMARY KEY,
    Title VARCHAR(50)
        CONSTRAINT movie_nn_title NOT NULL,
    ReleaseDate DATE
        CONSTRAINT movie_nn_releasedate NOT NULL
        CONSTRAINT movie_valid_releasedate CHECK (ReleaseDate > TO_DATE('1900/01/01', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American')),
    RunningTime NUMBER(3)        CONSTRAINT movie_nn_runningtime NOT NULL,
    MPAARating VARCHAR(7)
        CONSTRAINT movie_nn_movierating NOT NULL
        CONSTRAINT movie_valid_movierating CHECK (MPAARating IN ('G','PG','PG-13','R','NC-17','UNRATED'))
);

CREATE TABLE CastAndCrew
(
    Name VARCHAR(50),
    BirthDate DATE,
    Gender CHAR(1)
        CONSTRAINT castandcrew_nn_gender NOT NULL
        CONSTRAINT castandcrew_valid_gender CHECK ( Gender IN ( 'M' , 'F' , 'X' ) ),
    CONSTRAINT castandcrew_pk PRIMARY KEY ( Name , BirthDate )
);

CREATE TABLE Viewers
(
    Username VARCHAR(20)
        CONSTRAINT viewers_pk PRIMARY KEY,
    BirthDate DATE
        CONSTRAINT viewers_nn_birthdate NOT NULL
        CONSTRAINT viewers_valid_birthdate CHECK (BirthDate > TO_DATE('1900/01/01', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American')),
     AccountCreationDate DATE DEFAULT SYSDATE
);

CREATE TABLE Producer
(
    Name VARCHAR(50),
    BirthDate DATE,
    MovieId NUMBER(9)
        CONSTRAINT producer_fk_movieid REFERENCES Movie(MovieId) ON DELETE CASCADE,
    CONSTRAINT producer_fk_castandcrew FOREIGN KEY (Name , BirthDate) REFERENCES CastAndCrew( Name , BirthDate ) ON DELETE CASCADE,
    CONSTRAINT producer_pk PRIMARY KEY (Name, BirthDate, MovieId)
);

CREATE TABLE Director
(
    Name VARCHAR(50),
    BirthDate DATE,
    MovieId NUMBER(9)
        CONSTRAINT director_fk_movieid REFERENCES Movie(MovieId) ON DELETE CASCADE,
    CONSTRAINT director_fk_castandcrew FOREIGN KEY (Name , BirthDate) REFERENCES CastAndCrew( Name , BirthDate ) ON DELETE CASCADE,
    CONSTRAINT director_pk PRIMARY KEY (Name, BirthDate, MovieId)
);

CREATE TABLE Performer
(
    Name VARCHAR(50),
    BirthDate DATE,
    MovieId NUMBER(9)
        CONSTRAINT performer_fk_movieid REFERENCES Movie(MovieId) ON DELETE CASCADE,
    CONSTRAINT performer_fk_castandcrew FOREIGN KEY (Name , BirthDate) REFERENCES CastAndCrew( Name , BirthDate ) ON DELETE CASCADE,
    CONSTRAINT performer_pk PRIMARY KEY (Name, BirthDate, MovieId)
);

CREATE TABLE Ratings
(
    Username VARCHAR(20)
        CONSTRAINT ratings_fk_username REFERENCES Viewers(Username) ON DELETE CASCADE,
    MovieId NUMBER(9)
        CONSTRAINT ratings_fk_movieid REFERENCES Movie(MovieId) ON DELETE CASCADE,
    Rating NUMBER(1)
        CONSTRAINT ratings_nn_rating NOT NULL
        CONSTRAINT ratings_valid_rating CHECK ( Rating BETWEEN 1 AND 5 ),
    CONSTRAINT ratings_pk PRIMARY KEY (Username , MovieId)
);

CREATE TABLE WatchHistory
(
    Username VARCHAR(20)
        CONSTRAINT watchhistory_fk_username REFERENCES Viewers(Username) ON DELETE CASCADE,
    MovieId NUMBER(9)
        CONSTRAINT watchhistory_fk_movieid REFERENCES Movie(MovieId) ON DELETE CASCADE,
    TimesWatched NUMBER(3)
        CONSTRAINT watchhistory_nn_timeswatched NOT NULL
        CONSTRAINT watchhistory_valid_timeswatch CHECK ( TimesWatched BETWEEN 0 AND 999 ),
    CONSTRAINT watchhistory_pk PRIMARY KEY (Username , MovieId)
);

INSERT INTO Movie (MovieId, Title, ReleaseDate, RunningTime, MPAARating) VALUES (000000001, 'About Time', TO_DATE('2013/11/08', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 123, 'R');

INSERT INTO Movie (MovieId, Title, ReleaseDate, RunningTime, MPAARating) VALUES (000000002, 'Spirit: Stallion of the Cimmaron', TO_DATE('2002/05/24', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 83, 'G');

INSERT INTO Movie (MovieId, Title, ReleaseDate, RunningTime, MPAARating) VALUES (000000003, 'Arrival', TO_DATE('2016/11/11', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 116, 'PG-13');

INSERT INTO CastAndCrew (Name, BirthDate, Gender) VALUES ('Richard Curtis', TO_DATE('1956/11/08', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 'M');

INSERT INTO CastAndCrew (Name, BirthDate, Gender) VALUES ('Domhnall Gleeson', TO_DATE('1983/05/12', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 'M');

INSERT INTO CastAndCrew (Name, BirthDate, Gender) VALUES ('Tim Bevan', TO_DATE('1957/12/20', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 'M');

INSERT INTO CastAndCrew (Name, BirthDate, Gender) VALUES ('Kelly Asbury', TO_DATE('1960/01/15', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 'M');

INSERT INTO CastAndCrew (Name, BirthDate, Gender) VALUES ('Matt Damon', TO_DATE('1970/10/08', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 'M');

INSERT INTO CastAndCrew (Name, BirthDate, Gender) VALUES ('Jeffrey Katzenberg', TO_DATE('1950/12/21', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 'M');

INSERT INTO CastAndCrew (Name, BirthDate, Gender) VALUES ('Denis Villeneuve', TO_DATE('1967/10/03', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 'M');

INSERT INTO CastAndCrew (Name, BirthDate, Gender) VALUES ('Amy Adams', TO_DATE('1974/08/20', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 'F');

INSERT INTO CastAndCrew (Name, BirthDate, Gender) VALUES ('David Linde', TO_DATE('1960/02/08', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 'M');

INSERT INTO Viewers (Username, BirthDate) VALUES ('Jack', TO_DATE('1997/06/20', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'));

INSERT INTO Viewers (Username, BirthDate) VALUES ('Parent', TO_DATE('1953/10/15', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'));

INSERT INTO Viewers (Username, BirthDate) VALUES ('YoungSibling', TO_DATE('2001/06/18', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'));

INSERT INTO Producer (Name, BirthDate, MovieId) VALUES ('Tim Bevan', TO_DATE('1957/12/20', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 000000001);

INSERT INTO Producer (Name, BirthDate, MovieId) VALUES ('Jeffrey Katzenberg', TO_DATE('1950/12/21', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 000000002);

INSERT INTO Producer (Name, BirthDate, MovieId) VALUES ('David Linde', TO_DATE('1960/02/08', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 000000003);

INSERT INTO Director (Name, BirthDate, MovieId) VALUES ('Richard Curtis', TO_DATE('1956/11/08', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 000000001);

INSERT INTO Director (Name, BirthDate, MovieId) VALUES ('Kelly Asbury', TO_DATE('1960/01/15', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 000000002);

INSERT INTO Director (Name, BirthDate, MovieId) VALUES ('Denis Villeneuve', TO_DATE('1967/10/03', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 000000003);

INSERT INTO Performer (Name, BirthDate, MovieId) VALUES ('Domhnall Gleeson', TO_DATE('1983/05/12', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 000000001);

INSERT INTO Performer (Name, BirthDate, MovieId) VALUES ('Matt Damon', TO_DATE('1970/10/08', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 000000002);

INSERT INTO Performer (Name, BirthDate, MovieId) VALUES ('Amy Adams', TO_DATE('1974/08/20', 'yyyy/mm/dd','NLS_DATE_LANGUAGE = American'), 000000003);

INSERT INTO Ratings (Username, MovieId, Rating) VALUES ('Jack', 000000001, 4);

INSERT INTO Ratings (Username, MovieId, Rating) VALUES ('Parent', 000000001, 5);

INSERT INTO Ratings (Username, MovieId, Rating) VALUES ('YoungSibling', 000000001, 2);

INSERT INTO Ratings (Username, Movieid, Rating) VALUES ('YoungSibling', 2, 3);

INSERT INTO Ratings (Username, Movieid, Rating) VALUES ('Jack', 2, 3);

INSERT INTO Ratings (Username, MovieId, Rating) VALUES ('Jack', 3, 1);

INSERT INTO Ratings (Username, MovieId, Rating) VALUES ('Parent', 3, 1);

INSERT INTO Ratings (Username, MovieId, Rating) VALUES ('YoungSibling', 3, 1);

INSERT INTO WatchHistory (Username, MovieId, TimesWatched) VALUES ('Jack', 000000001, 2);

INSERT INTO WatchHistory (Username, MovieId, TimesWatched) VALUES ('Parent', 000000001, 4);

INSERT INTO WatchHistory (Username, MovieId, TimesWatched) VALUES ('YoungSibling', 000000001, 1);

INSERT INTO WatchHistory (Username, MovieId, TimesWatched) VALUES ('Jack', 3, 1);

INSERT INTO WatchHistory (Username, MovieId, TimesWatched) VALUES ('Parent', 3, 1);

INSERT INTO WatchHistory (Username, MovieId, TimesWatched) VALUES ('YoungSibling', 3, 1);