from django.db import models

class AnalysisOddsRatio(models.Model):
    disease = models.TextField()
    oddsratio = models.TextField()
    data = models.TextField()

    class Meta:
        managed = False
        db_table = 'analysis_odds_ratio'


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.IntegerField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.IntegerField()
    is_active = models.IntegerField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class CytoscapeJsonConfig(models.Model):
    disease = models.TextField()
    oddsratio = models.TextField()
    data = models.TextField()

    class Meta:
        managed = False
        db_table = 'cytoscape_json_config'


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.PositiveSmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


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


class PathwayForOr(models.Model):
    disease = models.TextField()
    oddsratio = models.TextField()
    data = models.TextField()

    class Meta:
        managed = False
        db_table = 'pathway_for_or'


class Patient(models.Model):
    name = models.CharField(max_length=10)
    phone = models.CharField(max_length=10)
    email = models.CharField(max_length=40)
    password = models.CharField(max_length=15)
    user_id = models.CharField(max_length=11, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'patient'