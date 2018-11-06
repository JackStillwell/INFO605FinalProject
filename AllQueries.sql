/* Most Viewed Movie */

SELECT movie.title , t.totalviews 
FROM 

(SELECT
movieid, SUM(timeswatched) as TotalViews
FROM watchhistory
GROUP BY movieid
HAVING SUM(timeswatched)= (SELECT MAX(SUM(timeswatched)) FROM watchhistory GROUP BY movieid))

t JOIN movie ON t.movieid=movie.movieid;

/* Movies Available based on Viewer Age and MPAA Rating */

SELECT * FROM (SELECT v.username AS Username, m.title AS MovieTitle
FROM Viewers v, Movie m
WHERE (months_between(SYSDATE, v.birthdate)/12 < 18
and m.mpaarating = 'G' or m.mpaarating = 'PG' or m.mpaarating = 'PG-13') or (months_between(SYSDATE, v.birthdate)/12 >= 18))
GROUP BY Username, MovieTitle;

/* Viewer's Favorite Performer */

SELECT viewname, performer, MAX(popularity) FROM (SELECT Username AS viewname, 
       pName AS performer, 
       COUNT(pName) AS popularity 
       FROM (SELECT * FROM (SELECT p.Name AS pName, t.Username AS Username 
      FROM performer p 
      JOIN (SELECT * FROM (SELECT movieid AS MovieId, username AS Username, rating AS Rating FROM Ratings WHERE rating >= 3) GROUP BY Username, MovieId, Rating) t
      ON p.movieid = t.movieid) GROUP BY Username, pName)
      GROUP BY username, pname
)
GROUP BY viewname, performer;

/* Overall Worst Movie */

SELECT m.title AS Title FROM movie m,

(SELECT movieid, MIN(viewcount) 
FROM
(
    SELECT m.movieid AS movieid, t.viewcount AS viewcount FROM 
        (
        /* all movies avg rating < 3 */
        SELECT * FROM (SELECT movieid, AVG(rating) as avgrate FROM ratings GROUP BY movieid) WHERE avgrate < 3
        ) m 
        JOIN 
        (
        /* total movie views */
        SELECT movieid, COUNT(movieid) AS viewcount FROM watchhistory GROUP BY movieid
        ) t 
        ON m.movieid = t.movieid
)
GROUP BY movieid) t WHERE m.movieId=t.movieid;

/* Favorite Movie for Age Group */

SELECT m.title AS Title FROM movie m,  

(SELECT movieid, MAX(viewcount) FROM 

(SELECT movieId, COUNT(movieid) AS viewcount FROM 

(SELECT * FROM (SELECT r.movieid AS MovieId, r.username AS Username, r.rating AS Rating
FROM Ratings r, (SELECT username FROM viewers WHERE (months_between(SYSDATE, birthdate)/12 < 20) AND (months_between(SYSDATE, birthdate)/12 > 10)) t
WHERE r.username = t.username AND rating >= 3) GROUP BY Username, MovieId, Rating)

GROUP BY movieId)

GROUP BY movieid) t WHERE m.movieId=t.movieid;