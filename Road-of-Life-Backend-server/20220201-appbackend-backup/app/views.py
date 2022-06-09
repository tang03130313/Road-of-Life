from django.shortcuts import render,HttpResponse

from plotly.offline import plot
import plotly.graph_objs as go
import plotly.express as px
import json
from app import models

# Create your views here.
def index(request):
    return HttpResponse(status=204)
    #return render(request, "view_comorbidity.html")
#comorbidity system view
def comorbidity_main(request):
    
    return render(request, "view_comorbidity.html")

def get_main_disease_cate_ios(request):  #ok
    print(request.method)
    if(request.method == 'GET'):
        print("parseData : " + "GET get_hospitals !")
        #list = models.Doctor.objects.all()
        list = models.MainDiseaseList.objects.values_list('category', flat=True).distinct()
        result = {}
        list3 = []
        i = 0
        result["result"] = "fail"
        for var in list:
            tmp = {"id": i, "name": var}
            list3.append(tmp)
            result["result"] = "success"
            i += 1
        result["data"] = list3
        result["result"] = "success"
        #result["data"] = [{"id": 0,"name": "常見疾病"},{"id": 1,"name": "慢性病"},{"id": 2,"name": "癌症"},{"id": 3,"name": "婦病"},{"id": 4,"name": "幼病"}]
        print(list3)
        response = json.dumps(result, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)

def post_main_comorbidity_ios(request):  #ok
    print(request.method)
    if(request.method == 'POST'):
        print("parseData : " + "post post_main_comorbidity_ios !")
        state = request.POST.get('state', '')
        list_ori = models.MainDiseaseList.objects.values_list('category', flat=True).distinct()
        tmp = ""
        for i, var in enumerate(list_ori):
            if i == int(state):
                tmp = var
                break
        list = models.MainDiseaseList.objects.filter(category=list_ori[int(state)])
        result = {}
        #result = {"result":"success", "data":[{"id": 0,"name": "aaa"},{"id": 1,"name": "nnn"}]}
        list3 = []
        result["result"] = "fail"
        i = 0
        for var in list:
            tmp = {"id": i, "name": var.name, "img": var.imgurl, "detail": var.detail, "score": str(var.score)}
            list3.append(tmp)
            result["result"] = "success"
            i += 1
        print(list3)
        result["data"] = list3
        response = json.dumps(result, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)
    
        
def get_test(request):  #ok
    print(request.method)
    if(request.method == 'GET'):
        print("parseData : " + "GET get_hospitals !")
        list = models.MainDiseaseList.objects.all()
        list3 = []
        i = 1
        for var in list:
            data = var.score
            if not data in list3:
                list3.append(data)
            #list3.append(type(var.score))
            i += 1
        print(list3)
        response = json.dumps(list3, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)