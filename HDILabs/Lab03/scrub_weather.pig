Source = LOAD '/weather/heathrow.txt' USING PigStorage('\t') AS (year:chararray, month:int, maxtemp:float, mintemp:float, frostdays:int, rainfall:float, sunshinehours:chararray);

Data = FILTER Source BY maxtemp IS NOT NULL AND mintemp IS NOT NULL AND year != 'yyyy';

DataVals = FOREACH Data GENERATE year, month, maxtemp, mintemp, frostdays, rainfall, REPLACE(sunshinehours, '---', '') AS sunshinehours;

CleanReadings = FILTER DataVals BY INDEXOF(sunshinehours, '#', 0) <= 0;
DirtyReadings = FILTER DataVals BY INDEXOF(sunshinehours, '#', 0) > 0;

CleanedReadings = FOREACH DirtyReadings GENERATE year, month, maxtemp, mintemp, frostdays, rainfall, SUBSTRING(sunshinehours, 0, INDEXOF(sunshinehours, '#', 0)) AS sunshinehours;

Readings = UNION CleanReadings, CleanedReadings;

SortedReadings = ORDER Readings BY year ASC, month ASC;

STORE SortedReadings INTO '/weather/scrubbedweather' USING PigStorage(' ');
