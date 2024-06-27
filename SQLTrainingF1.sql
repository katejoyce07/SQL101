FROM TIL_PLAYGROUND.F1.DRIVERS;

//EXERCISE
SELECT
FASTESTLAPSPEED::double,
FORENAME,
SURNAME
FROM DRIVERS AS D
    FULL JOIN RESULTS AS R ON D.DRIVERID = R.DRIVERID
WHERE FASTESTLAPSPEED IS! null;

SELECT 
max(FASTESTLAPSPEED::double),
FORENAME,
SURNAME
FROM DRIVERS AS D
JOIN RESULTS AS R ON D.DRIVERID = R.DRIVERID
WHERE FASTESTLAPSPEED IS! null
GROUP BY FORENAME, SURNAME
ORDER BY max(FASTESTLAPSPEED::double) DESC;

SELECT 
max(FASTESTLAPSPEED::double) AS FASTESTLAPSPEEDEVER,
FORENAME,
SURNAME,
YEAR,
RA.NAME
FROM DRIVERS AS D
JOIN RESULTS AS R 
    ON D.DRIVERID = R.DRIVERID
JOIN RACES AS RA
    ON RA.RACEID = R.RACEID
WHERE FASTESTLAPSPEED IS! null
AND YEAR = 2021
AND RA.NAME = 'Monaco Grand Prix'
GROUP BY FORENAME, SURNAME, YEAR, RA.NAME
ORDER BY max(FASTESTLAPSPEED::double) DESC;



//subqueries
SELECT 
    D.FORENAME,
    D.SURNAME,
    MAX(R.FASTESTLAPSPEED::double) as FASTESTLAPSPEEDEVER,
    (SELECT
        MAX(FASTESTLAPSPEED)
     FROM RESULTS) AS FASTESTOFALLTIME,
    total_wins
FROM DRIVERS AS D
JOIN RESULTS AS R
    ON D.DRIVERID = R.DRIVERID
JOIN RACES AS RA
    ON R.RACEID = RA.RACEID
JOIN 
    (select 
        driverid,
        count(position) as total_wins
    from driver_standings as ds
    join races as r
        on ds.raceid = r.raceid
    where position = 1
        and name = 'Monaco Grand Prix'
    group by driverid) AS W ON d.driverid = W.driverid
WHERE FASTESTLAPSPEED IS NOT NULL
    AND RA.NAME = 'Monaco Grand Prix'
    AND RA.YEAR = 2021
GROUP BY FORENAME,SURNAME, FASTESTOFALLTIME, total_wins
ORDER BY FASTESTLAPSPEEDEVER DESC;


SELECT *
FROM DRIVERS
WHERE NATIONALITY = 'Irish';