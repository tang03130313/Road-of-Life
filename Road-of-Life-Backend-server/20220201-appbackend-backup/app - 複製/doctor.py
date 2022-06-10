from django.test import TestCase
from app import models
import json
from django.http import HttpResponse,request

def get_hospitals(request):  #ok
    print(request.method)
    if(request.method == 'GET'):
        print("parseData : " + "GET get_hospitals !")
        list = models.Doctor.objects.all()
        list3 = []
        i = 1
        for var in list:
            data = var.hospital
            if not data in list3:
                list3.append(data)
            i += 1
        print(list3)
        response = json.dumps(list3, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)

def get_departments(request):  #ok
    print(request.method)
    if(request.method == 'POST'):
        print("parseData : " + "post get_departments !")
        hospital = request.POST.get('hospital', '')
        list = models.Doctor.objects.filter(hospital=hospital)
        list3 = []
        i = 1
        for var in list:
            data = var.department
            list3.append(data)
            i += 1
        print(list3)
        response = json.dumps(list3, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)

def get_doctors(request):  #ok
    print(request.method)
    if(request.method == 'POST'):
        
        hospital = request.POST.get('hospital', '')
        department = request.POST.get('department', '')
        print("parseData : " + "post get_doctors !",hospital," ",department)
        list = models.Doctor.objects.filter(hospital=hospital,department=department)
        list3 = []
        i = 1
        for var in list:
            data = var.name
            list3.append(data)
            i += 1  
        print(list3)
        response = json.dumps(list3, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)

def check_repeat(request):  #ok
    print(request.method)
    if(request.method == 'POST'):
        print("parseData : " + "post get_doctors !")
        user_id = request.POST.get('user_id', '')
        hospital = request.POST.get('hospital', '')
        department = request.POST.get('department', '')
        name = request.POST.get('name', '')
        list = models.Doctor.objects.filter(hospital=hospital,department=department,name=name)
        doctor_id = ""
        for var in list:
            doctor_id = var.doctorid
        print(doctor_id)
        data = {}
        if  models.DoctorAuth.objects.filter(user_id=user_id,doctor_id=doctor_id).exists():
            data['result'] = "repeat"
        else:
            data['result'] = "fail"
        print(data)
        response = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)

