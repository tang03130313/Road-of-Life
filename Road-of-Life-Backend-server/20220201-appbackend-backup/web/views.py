from django.shortcuts import render

# Create your views here.

from django.http import HttpResponse
from django.http import JsonResponse

import logging

from web import models
from web import keyPathwayAnalysis
from web import Kpa

def login(request):
	if not 'service_unit' in request.session:
		return render(request, template_name = "new/login.html", context = {})
	else:
		service_unit = request.session['service_unit']
		docter_id = request.session['docter_id']
		docter_password = request.session['docter_password']
		try:
			userInfo = models.Doctor.objects.get(doctorid=docter_id)
		except:
			del request.session['service_unit']
			del request.session['docter_id']
			del request.session['docter_password']
			return render(request, template_name = "new/login.html", context = {})
		if docter_password == userInfo.password and service_unit == userInfo.hospital:
			return render(request, template_name = "new/index.html", context = {"service_unit": service_unit, "docter_id": docter_id})
		else:
			del request.session['service_unit']
			del request.session['docter_id']
			del request.session['docter_password']
			return render(request, template_name = "new/login.html", context = {})

def index(request):
	if request.method == 'POST':
		if not 'service_unit' in request.session:
			service_unit = request.POST['service_unit']
			docter_id = request.POST['docter_id']
			docter_password = request.POST['docter_password']
			try:
				userInfo = models.Doctor.objects.get(doctorid=docter_id)
			except:
				message = "登入資料有誤"
				return render(request, template_name = "new/login.html", context = {"message": message})
			if docter_password == userInfo.password and service_unit == userInfo.hospital:
				request.session['service_unit'] = service_unit
				request.session['docter_id'] = docter_id
				request.session['docter_password'] = docter_password
				return render(request, template_name = "new/index.html", context = {"service_unit": service_unit, "docter_id": docter_id})
			else:
				message = "登入資料有誤"
				return render(request, template_name = "new/login.html", context = {"message": message})
		else:
			service_unit = request.session['service_unit']
			docter_id = request.session['docter_id']
			docter_password = request.session['docter_password']
			try:
				userInfo = models.Doctor.objects.get(doctorid=docter_id)
			except:
				del request.session['service_unit']
				del request.session['docter_id']
				del request.session['docter_password']
				return render(request, template_name = "new/login.html", context = {})
			if docter_password == userInfo.password and service_unit == userInfo.hospital:
				return render(request, template_name = "new/index.html", context = {"service_unit": service_unit, "docter_id": docter_id})
			else:
				del request.session['service_unit']
				del request.session['docter_id']
				del request.session['docter_password']
				return render(request, template_name = "new/login.html", context = {})
	else:
		if not 'service_unit' in request.session:
			message = ""
			return render(request, template_name = "new/login.html", context = {"message": message})
		else:
			service_unit = request.session['service_unit']
			docter_id = request.session['docter_id']
			docter_password = request.session['docter_password']
			try:
				userInfo = models.Doctor.objects.get(doctorid=docter_id)
			except:
				del request.session['service_unit']
				del request.session['docter_id']
				del request.session['docter_password']
				message = ""
				return render(request, template_name = "new/login.html", context = {"message": message})
			if docter_password == userInfo.password and service_unit == userInfo.hospital:
				return render(request, template_name = "new/index.html", context = {"service_unit": service_unit, "docter_id": docter_id})
			else:
				del request.session['service_unit']
				del request.session['docter_id']
				del request.session['docter_password']
				message = ""
				return render(request, template_name = "new/login.html", context = {"message": message})

def logout(request):
	if 'service_unit' in request.session:
		del request.session['service_unit']
		del request.session['docter_id']
		del request.session['docter_password']
	return render(request, template_name = "new/login.html", context = {})

def searchPatient(request):
	patientId = request.POST['patientId']
	docter_id = request.session['docter_id']
	patientIdList = {"patientIdList": []}
	try:
		doctorAuths = models.DoctorAuth.objects.filter(doctor_id=docter_id)
		for doctorAuth in doctorAuths:
			if patientId.upper() in doctorAuth.user_id:
				patientIdList["patientIdList"].append(doctorAuth.user_id)
	except:
		patientIdList = {"patientIdList": []}
	return JsonResponse(patientIdList)

def httpPostkeyPathwayAnalysis(request):
	Logger = logging.getLogger('logger')

	patientId = request.POST['patientId']
	targetDisease = request.POST['targetDisease']
	oddsRatio = request.POST['oddsRatio']

	# if targetDisease == "心臟衰竭" and oddsRatio == "6":
	# 	oddsRatio = "5"

	kpa = Kpa.Kpa(patientId, targetDisease, oddsRatio)
	Logger.info("complete step 1")

	kpa.createGraphDictInstance()
	Logger.info("complete step 2")

	kpa.createGcSufferFromDisease()
	Logger.info("complete step 3")

	if len(kpa.gcSufferFromDisease) == 0:
		return JsonResponse({})

	kpa.createNewPathSetDictInstance()
	Logger.info("complete step 4")

	kpa.iterationAnalysis()
	Logger.info("complete step 5")

	keyPathwayJson = kpa.createResultJsonFile()
	Logger.info("complete step 6")

	# keyPathwayJson = keyPathwayAnalysis.keyPathwayAnalysis(patientId, targetDisease, oddsRatio)
	
	return JsonResponse(keyPathwayJson)