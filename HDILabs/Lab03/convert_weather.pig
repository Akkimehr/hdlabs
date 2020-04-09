REGISTER 'wasb:///weather/convert_temp.py' using jython as convert_temp;

Source = LOAD '/weather/scrubbedweather' AS (celsius_readings:chararray);

ConvertedReadings = FOREACH Source GENERATE FLATTEN(convert_temp.fahrenheit(celsius_readings));

STORE ConvertedReadings INTO '/weather/convertedweather';



