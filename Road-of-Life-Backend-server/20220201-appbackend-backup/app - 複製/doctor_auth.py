from django.test import TestCase
from app import models
import json
from django.http import HttpResponse,request

def get_doctor_auth(request):  #ok
    print(request.method)
    if(request.method == 'POST'):
        user_id = request.POST.get('user_id', '')
        email = request.POST.get('email', '')
        print("parseData : " + "post get_doctor_auth ! ",user_id)
        list = models.DoctorAuth.objects.filter(user_id=user_id).order_by('-id')
        i = 1
        j = 1
        data = {}
        data['result'] = 'fail'
        for var in list:
            list_2 = models.Doctor.objects.filter(doctorid=var.doctor_id)
            for var_2 in list_2:
                array = '["'+var_2.hospital+'","'+var_2.department+'","'+var_2.name+'"]'
                data[str(j)] = json.loads(array)
                j+=1
            data['result'] = 'success'
            i += 1
        print(data)
        response = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)

def insert_doctor_auth(request):  #ok
    print(request.method)
    if(request.method == 'POST'):
        print("parseData : " + "post insert_doctor_auth !")
        user_id = request.POST.get('user_id', '')
        hospital = request.POST.get('hospital', '')
        department = request.POST.get('department', '')
        name = request.POST.get('name', '')
        list = models.Doctor.objects.filter(hospital=hospital,department=department,name=name)
        doctorid = ""
        for var in list:
            doctorid = var.doctorid
        list = models.DoctorAuth.objects.filter(user_id=user_id,doctor_id=doctorid)

        data = {}
        check = False
        i = 1
        data['result'] = "fail"
        if doctorid == "":
            data['result'] = "fail"
        elif len(list) > 0:
            data['result'] = "repeat"
        else:
            test2 = models.DoctorAuth()
            test2.user_id = user_id
            test2.doctor_id = doctorid
            test2.save()
            data['user_id'] = user_id
            data['doctor_id'] = doctorid
            data['result'] = "sucess"
        response = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)

def delete_doctor_auth(request):  #ok
    print(request.method)
    if(request.method == 'POST'):
        print("parseData : " + "post delete_doctor_auth !")
        user_id = request.POST.get('user_id', '')
        doctor_id = request.POST.get('doctor_id', '')
        doctor_hospital = request.POST.get('doctor_hospital', '')
        position = request.POST.get('position', '')
        print(position)
        email = request.POST.get('email', '')
        list = models.DoctorAuth.objects.filter(user_id=user_id).order_by('-id')
        data = {}
        data['result'] = "fail"
        i = 1
        for var in list:
            if i == int(position):
                print(var.doctor_id)
                list = models.DoctorAuth.objects.filter(user_id=user_id,doctor_id=var.doctor_id).order_by('-id').delete()
                data['result'] = "success"
            i += 1
        print(data)
        response = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)