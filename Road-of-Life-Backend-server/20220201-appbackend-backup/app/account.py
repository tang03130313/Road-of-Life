from django.test import TestCase
from app import models
import json
from django.http import HttpResponse,request

def login(request):  #ok
    print(request.method)
    if(request.method == 'POST'):
        print("parseData : " + "post login !")
        email = request.POST.get('email', '')
        password = request.POST.get('password', '')
        print(type(email))
        print(len(email))
        print("email ",email," password ",password)
        data = {}
        data['result'] = "sucess" if models.Patient.objects.filter(email=email).filter(password=password).exists() else "fail"
        print(data)
        response = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)

def register(request):  #ok
    print(request.method)
    if(request.method == 'POST'):
        print("parseData : " + "post register !")
        name = request.POST.get('name', '')
        phone = request.POST.get('phone', '')
        email = request.POST.get('email', '')
        password = request.POST.get('password', '')
        doctor_auth = "{}"
        health_passport = "{}"
        list3 = []
        data = {}
        if not models.Patient.objects.filter(email=email).exists():
            test2 = models.Patient()
            test2.name = name
            test2.phone = phone
            test2.email = email
            test2.password = password
            test2.save()
            data['name'] = name
            data['phone'] = phone
            data['email'] = email
            data['password'] = password
            data['result'] = "sucess"
        else:
            data['result'] = "fail"
        print(data)
        response = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)

def check_password(request):  #ok
    print(request.method)
    if(request.method == 'POST'):
        print("parseData : " + "post check_password !")
        email = request.POST.get('email', '')
        password = request.POST.get('password', '')
        list3 = []
        data = {}
        data['result'] = "sucess" if models.Patient.objects.filter(email=email).filter(password=password).exists() else "fail"
        print(data)
        response = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)

def check_id(request):  #ok
    print(request.method)
    if(request.method == 'POST'):
        #print("parseData : " + "post check_id !")
        email = request.POST.get('email', '')
        password = request.POST.get('password', '')
        print("parseData : " + "post check_id !"+email+password)
        list3 = []
        data = {}
        if models.Patient.objects.filter(email=email,password=password).exists():
            list = models.Patient.objects.filter(email=email,password=password)
            for var in list:
                data['result'] = var.user_id if var.user_id is not None else "fail"
        else:
            data['result'] = "fail"
        print(data['result'] )
        response = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)

def get_personal_data(request):  #ok
    print(request.method)
    if(request.method == 'POST'):
        print("parseData : " + "post get_persol_data !")
        email = request.POST.get('email', '')
        password = request.POST.get('password', '')
        print("email : " +email+ "password : "+password)
        data = {}
        if models.Patient.objects.filter(email=email,password=password).exists():
            list = models.Patient.objects.filter(email=email,password=password)
            i = 1
            for var in list:
                data['result'] = "sucess"
                data['name'] = var.name
                data['phone'] = var.phone
                data['email'] = var.email
                data['password'] = var.password
                data['user_id'] = var.user_id
                i += 1
        else:
            data['result'] = "fail"
        print(data)
        response = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)

def edit_personal_data(request):  #ok
    print(request.method)
    if(request.method == 'POST'):
        print("parseData : " + "post edit_persol_data !")
        name = request.POST.get('name', '')
        phone = request.POST.get('phone', '')
        email = request.POST.get('email', '')
        password = request.POST.get('password', '')
        user_id = request.POST.get('user_id', '')
        data = {}
        list = models.Patient.objects.filter(email=email)
        for var in list:
            origin_user_id = var.user_id
        if origin_user_id != user_id and not models.DoctorAuth.objects.filter(user_id=user_id).exists():
            if models.DoctorAuth.objects.filter(user_id=origin_user_id).update(user_id=user_id):
                 data['result'] = "sucess"
            else :
                data['result'] ="fail"
        print(data)
        if origin_user_id != user_id and not models.HealthPassport.objects.filter(user_id=user_id).exists():
            if models.HealthPassport.objects.filter(user_id=origin_user_id).update(user_id=user_id):
                 data['result'] = "sucess"
            else :
                data['result'] ="fail"
        print(data)
        if models.Patient.objects.filter(email=email).update(name=name,phone=phone,password=password,user_id=user_id):
            data['result'] = "sucess"
        else :
            data['result'] ="fail"
        print(data)
        response = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)