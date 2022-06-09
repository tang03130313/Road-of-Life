# Generated by Django 3.0.6 on 2020-05-21 06:53

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('web', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='AnalysisOddsRatio',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('disease', models.TextField()),
                ('oddsratio', models.IntegerField(db_column='oddsRatio')),
                ('data', models.TextField()),
            ],
            options={
                'db_table': 'analysis_odds_ratio',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='PathwayForOr',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('disease', models.TextField()),
                ('oddrsratio', models.IntegerField(db_column='oddrsRatio')),
                ('data', models.TextField()),
            ],
            options={
                'db_table': 'pathway_for_or',
                'managed': False,
            },
        ),
    ]