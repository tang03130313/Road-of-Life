from django.db import models

# Create your models here.
class Doctor(models.Model):
    doctorid = models.CharField(max_length=10)
    account = models.CharField(max_length=10)
    password = models.CharField(max_length=15)
    hospital = models.CharField(max_length=50, blank=True, null=True)
    department = models.CharField(max_length=30)
    name = models.CharField(max_length=15)

    class Meta:
        managed = False
        db_table = 'doctor'


class DoctorAuth(models.Model):
    user_id = models.CharField(max_length=11)
    doctor_id = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'doctor_auth'


class HealthPassport(models.Model):
    user_id = models.CharField(max_length=11)
    time = models.DateTimeField()
    passport = models.TextField(blank=True, null=True)  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'health_passport'


class Patient(models.Model):
    name = models.CharField(max_length=10)
    phone = models.CharField(max_length=10)
    email = models.CharField(max_length=40)
    password = models.CharField(max_length=15)
    user_id = models.CharField(max_length=11, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'patient'