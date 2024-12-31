Tener en cuenta la creación se las subnet privadas,
Crear una carpeta dentro del s3 llamada "src" ahí estarán ubicados los Dags
Dentro del s3 crear un archivo "requirements.txt" donde estarán las librerias a importar
si no funciona el despliegue al primer intento entonces crear un endpoint gateway para los s3

///////////////////////////////////////////////////////////////////////////////////////////////////////
Caso extremo, ejecutar estos comando y hacer un redeploy:
///////////////////////////////////////////////////////////////////////////////////////////////////////

aws mwaa create-cli-token --name MyAirflowEnvironment

aws mwaa create-cli-token --name test-mwaa-dev

export AIRFLOW_CLI_TOKEN="eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJjbGkiLCJleHAiOjE3MzU1ODE4NjQsInVzZXIiOiJyb290In0.olv-kqiY8pQh8u3Hs6_bG9UCcwi-NAf5DEi7bVzN34is10wk3SQWYLvqeLiyzol0oKWpfZQk950_GaveLWasOTG2ZBfSLSJ57I9qzDkPAvH0qtWh0z1_Ajb6_oPanXMaiEzmHyPrz2KVhXmdNrThYkX8qbRSVmojGKfo_HD8MRgd3Tk3UMsxnkqGTd607oJ0GcjyW-LtXz8OpLzmEUsMuLm9cjg_U2ERy3jmeqipnpfKA1gaT9M-mpEdJSEBEh-EUvhDu7zaST8P40zhtluM3L5CYR_ntFyHnTzITHsHQvx9femVW3XBKBGTHtGPriC1IrKFm3dgSwgfrbBTRJTlLA"

export AIRFLOW_WEBSERVER_HOST="2a4436f5-bded-469c-b26c-0cdf330afdd2.c7.us-east-2.airflow.amazonaws.com"