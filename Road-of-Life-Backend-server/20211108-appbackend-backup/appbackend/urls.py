"""appbackend URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from app import views
from app import account,doctor,doctor_auth,health_passport,views
from django.conf.urls import url,include
from web import views as webViews

urlpatterns = [
    path('admin/', admin.site.urls),
    url(r'^$', webViews.index),
    url(r'^doctor/get_hospitals$', doctor.get_hospitals),
    url(r'^doctor/get_hospitals_ios$', doctor.get_hospitals_ios),
    url(r'^doctor/get_departments$', doctor.get_departments),
    url(r'^doctor/get_departments_ios$', doctor.get_departments_ios),
    url(r'^doctor/get_doctors$', doctor.get_doctors),
    url(r'^doctor/get_doctors_ios$', doctor.get_doctors_ios),
    url(r'^doctor/check_repeat$', doctor.check_repeat),
    url(r'^doctor_auth/get_doctor_auth$', doctor_auth.get_doctor_auth),
    url(r'^doctor_auth/get_doctor_auth_ios$', doctor_auth.get_doctor_auth_ios),
    url(r'^doctor_auth/insert_doctor_auth$', doctor_auth.insert_doctor_auth),
    url(r'^doctor_auth/delete_doctor_auth$', doctor_auth.delete_doctor_auth),
    url(r'^health_passport/check_health_passport$', health_passport.check_health_passport),
    url(r'^health_passport/get_health_passport$', health_passport.get_health_passport),
    url(r'^health_passport/get_health_passport_ios$', health_passport.get_health_passport_ios),
    url(r'^health_passport/insert_health_passport$', health_passport.insert_health_passport),
    url(r'^health_passport/insert_health_passport_ios$', health_passport.insert_health_passport_ios),
    url(r'^health_passport/delete_health_passport$', health_passport.delete_health_passport),
    url(r'^health_passport/get_api$', health_passport.get_key),
    url(r'^health_passport/get_api_ios$', health_passport.get_key_ios),
    url(r'^account/login$', account.login),
    url(r'^account/register$', account.register),
    url(r'^account/check_password$', account.check_password),
    url(r'^account/check_id$', account.check_id),
    url(r'^account/get_personal_data$', account.get_personal_data),
    url(r'^account/edit_personal_data$', account.edit_personal_data),
    url(r'^views/get_main_disease_cate_ios$', views.get_main_disease_cate_ios),
    url(r'^views/post_main_comorbidity_ios$', views.post_main_comorbidity_ios),
    url(r'^views/comorbidity_main$', views.comorbidity_main),

    path('web/login/', webViews.login),
    path('web/index/', webViews.index),
    path('web/logout/', webViews.logout),
    path('web/searchPatient/', webViews.searchPatient),
    path('web/httpPostkeyPathwayAnalysis/', webViews.httpPostkeyPathwayAnalysis),
]
#url(r'^$', views.index),