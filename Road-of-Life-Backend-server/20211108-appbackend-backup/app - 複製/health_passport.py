from django.test import TestCase
from app import models
import json
from django.http import HttpResponse,request
import time
import codecs
import ast 
data = {}

def check_health_passport(request):  #ok
    print(request.method)
    if(request.method == 'POST'):
        #print("parseData : " + "post check_id !")
        email = request.POST.get('email', '')
        password = request.POST.get('password', '')
        print("parseData : " + "post check_id !"+email+password)
        list3 = []
        data = {}
        user_id = ''
        data['result'] = "fail"
        list = models.Patient.objects.filter(email=email,password=password)
        for var in list:
            user_id = var.user_id
        list = models.HealthPassport.objects.filter(user_id=user_id)
        if len(list) > 0:
            data['result'] = 'success'
        print(data['result'] )
        response = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)


def get_health_passport(request):
    print(request.method)
    if(request.method == 'POST'):
        email = request.POST.get('email', '')
        password = request.POST.get('password', '')
        user_id = request.POST.get('user_id', '')
        data = {}
        data['result'] = "fail"
        i = 1
        list = models.HealthPassport.objects.filter(user_id=user_id).order_by('-id')
        for var in list:
            #print(len(json.loads(var.passport)))
            count = 0
            for var_2 in json.loads(var.passport):
                count += len(json.loads(var.passport)[var_2])
            array = '["'+str(var.time)[0:19:1]+'","'+str(count)+'"]'
            print(count," ",var.passport)
            data[str(i)] = json.loads(array)
            data['result'] = "success"
            i+=1
        print(data)
        response = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)

def insert_health_passport(request):
    path = './output.txt'
    f = open(path, 'w')
    print(request.method+" "+insert_health_passport)
    f.write(request.method+" "+insert_health_passport)
    if(request.method == 'POST'):
        email = request.POST.get('email', '')
        password = request.POST.get('password', '')
        passport_json =  request.POST.get('passport_json', '')  
        print(passport_json)
        f.write(passport_json)
        passport_json = json.loads(passport_json)
        user_id = request.POST.get('user_id', '') 
        now_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        print(now_time," ",user_id)
        f.write(now_time," ",user_id)
        data = {}
        def passport_simplify_2(num):
            if num == 'r1':
                data[num] = []
                for var_2 in range(0,len(passport_json['myhealthbank']['bdata']['r1'])):
                    print("aaa"+str(var_2)+"ss"+passport_json['myhealthbank']['bdata']['r1'][var_2]['r1.5'])
                    tmp = {}
                    tmp['date'] = passport_json['myhealthbank']['bdata']['r1'][var_2]['r1.5']
                    tmp['icd'] = passport_json['myhealthbank']['bdata']['r1'][var_2]['r1.8']
                    tmp['detail'] = passport_json['myhealthbank']['bdata']['r1'][var_2]['r1.9']
                    data[num].append(tmp)
            elif num == 'r2':
                data[num] = []
                for var_2 in range(0,len(passport_json['myhealthbank']['bdata']['r2'])):
                    tmp = {}
                    tmp['date'] = passport_json['myhealthbank']['bdata']['r2'][var_2]['r2.5']
                    tmp['icd'] = passport_json['myhealthbank']['bdata']['r2'][var_2]['r2.10']
                    tmp['detail'] = passport_json['myhealthbank']['bdata']['r2'][var_2]['r2.11']
                    data[num].append(tmp)
            elif num == 'r3':
                data[num] = []
                for var_2 in range(0,len(passport_json['myhealthbank']['bdata']['r3'])):
                    tmp = {}
                    tmp['date'] = passport_json['myhealthbank']['bdata']['r3'][var_2]['r3.5']
                    tmp['icd'] = passport_json['myhealthbank']['bdata']['r3'][var_2]['r3.7']
                    tmp['detail'] = passport_json['myhealthbank']['bdata']['r3'][var_2]['r3.8']
                    data[num].append(tmp)
            elif num == 'r9':
                data[num] = []
                for var_2 in range(0,len(passport_json['myhealthbank']['bdata']['r9'])):
                    tmp = {}
                    tmp['date'] = passport_json['myhealthbank']['bdata']['r9'][var_2]['r9.5']
                    tmp['icd'] = passport_json['myhealthbank']['bdata']['r9'][var_2]['r9.7']
                    tmp['detail'] = passport_json['myhealthbank']['bdata']['r9'][var_2]['r9.8']
                    data[num].append(tmp)
        bdata = passport_json['myhealthbank']['bdata']
        for var in bdata:
            print(var)
            passport_simplify_2(str(var))
        if user_id != '':
            Passport = models.HealthPassport()
            Passport.user_id = user_id
            Passport.time = now_time
            Passport.passport = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
            Passport.origin = json.dumps(passport_json, sort_keys=True, indent=4, ensure_ascii=False)
            Passport.save()
            data['result'] = "sucess"
        else:
            data['result'] = "fail"
        print(data['result'] )
        f.write(data['result'])
        f.close()
        response = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)
from django.core.files.storage import FileSystemStorage
def insert_health_passport_2(request):
    path = './output.txt'
    f = open(path, 'w')
    print(request.method+" "+insert_health_passport)
    f.write(request.method+" "+insert_health_passport)
    if(request.method == 'POST') and request.FILES['mhbjson']:
        email = request.POST.get('email', '')
        password = request.POST.get('password', '')
        mhbjson =  request.FILES['mhbjson']  
        fs = FileSystemStorage()
        filename = fs.save(myfile.name, myfile)
        uploaded_file_url = fs.url(filename)
        passport_json = json.loads(passport_json)
        user_id = request.POST.get('user_id', '')
        data = {}
        data['result'] = "sucess"
        response = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)

def delete_health_passport(request):  #ok
    print(request.method)
    if(request.method == 'POST'):
        email = request.POST.get('email', '')
        password = request.POST.get('password', '')
        position = request.POST.get('position', '')
        user_id = request.POST.get('user_id', '')
        data = {}
       # user_id = ''
        data['result'] = "fail"
        #list = models.Patient.objects.filter(email=email,password=password)
        #for var in list:
            #user_id = var.user_id
        i = 1
        list = models.HealthPassport.objects.filter(user_id=user_id).order_by('-id')
        print(position)
        for var in list:
            print(i)
            if i == int(position):
                print(var.time)
                list_2 = models.HealthPassport.objects.filter(user_id=user_id,time=var.time).delete()
                data['result'] = "success"
            i += 1
        print(data)
        response = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)
        
def get_key(request):
    print(request.method)
    if(request.method == 'GET'):
        data = {}
        data['result'] = "8bf841483aba48129bb6d0d851da9075"
        response = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)
