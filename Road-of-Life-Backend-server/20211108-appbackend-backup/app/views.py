from django.shortcuts import render,HttpResponse

from plotly.offline import plot
import plotly.graph_objs as go
import plotly.express as px
import json

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
        result = {}
        list3 = []
        i = 1
        '''result["result"] = "fail"
        for var in list:
            data = var.hospital
            if not data in list3:
                list3.append(data)
                result["result"] = "success"
            i += 1
        result["data"] = list3'''
        result["result"] = "success"
        result["data"] = [{"id": 0,"name": "常見疾病"},{"id": 1,"name": "慢性病"},{"id": 2,"name": "癌症"},{"id": 3,"name": "婦病"},{"id": 4,"name": "幼病"}]
        print(list3)
        response = json.dumps(result, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)

def post_main_comorbidity_ios(request):  #ok
    print(request.method)
    if(request.method == 'POST'):
        print("parseData : " + "post post_main_comorbidity_ios !")
        state = request.POST.get('state', '')
        #list = models.Doctor.objects.all()
        result = {}
        #result = {"result":"success", "data":[{"id": 0,"name": "aaa"},{"id": 1,"name": "nnn"}]}
        #list3 = []
        #result["result"] = "success"
        #list3 = [{"id": "0","name": "aaa"},{"id": "1","name": "nnn"}]
        #result["data"] = []
        #result["data"].append({"id": "0","name": "aaa"})
        #print(list3)
        a1 = [{"id": 0,"name": "心臟衰竭", "img": "heart", "detail": "管狀動脈的疾病、高血壓、心瓣膜疾病 ...","score": "40"},{"id": 1,"name": "早產", "img": "maternity", "detail": "迫切早產、產前狀況或合併症、產早期分娩...", "score": "33"}, {"id": 2,"name": "老人痴呆症", "img": "walker-2", "detail": "初老年期癡呆症、老年期癡呆症併憂鬱或妄想現象、老年期精神病態 ... ", "score": "8"}]
        a2 = [{"id": 0,"name": "心臟衰竭", "img": "heart", "detail": "管狀動脈的疾病、高血壓、心瓣膜疾病 ...","score": "40"},{"id":1,"name": "白內障", "img": "maternity", "detail": "眼睛內原本透明清澈的水晶體變得混濁，遮住了視線...", "score": "20"}, {"id": 2,"name": "老人痴呆症", "img": "walker-2", "detail": "初老年期癡呆症、老年期癡呆症併憂鬱或妄想現象、老年期精神病態 ... ", "score": "8"}]
        a3 = [{"id":0,"name": "肺癌", "img": "heart", "detail": "肺部惡性上皮細胞腫瘤，由上皮細胞病變而造成...","score": "15"},{"id":1,"name": "結直腸癌", "img": "maternity", "detail": "排便習慣改變、體重減輕、消化道出血、腹痛、腹脹、細便及貧血...", "score": "7"},{"id":2,"name": "肝癌", "img": "walker-2", "detail": "是肝臟最常見的惡性腫瘤之一。 也是全世界最常見癌症的第五位 ... ", "score": "2"}]
        result["result"] = "fail"
        if state == "0":
            result["data"] = a1
            result["result"] = "success"
        elif state == "1":
            result["data"] = a2
            result["result"] = "success"
        elif state == "2":
            result["data"] = a3
            result["result"] = "success"
        response = json.dumps(result, sort_keys=True, indent=4, ensure_ascii=False)
        return HttpResponse(response)