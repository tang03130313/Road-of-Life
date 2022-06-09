@ECHO ON

call  activate django

cd C:\Users\biolab\LunSenLu\appbackend

python manage.py runserver_plus --cert lunsenlu.cf.crt 0.0.0.0:8000

PAUSE

ECHO finish