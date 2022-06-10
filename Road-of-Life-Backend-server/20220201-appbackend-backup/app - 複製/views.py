from django.shortcuts import render,HttpResponse

from plotly.offline import plot
import plotly.graph_objs as go
import plotly.express as px

# Create your views here.
def index(request):
    return HttpResponse(status=204)
    #return render(request, "view_comorbidity.html")
#comorbidity system view
def comorbidity_main(request):
    
    return render(request, "view_comorbidity.html")

