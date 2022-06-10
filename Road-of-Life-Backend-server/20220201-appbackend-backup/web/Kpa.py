from web.Structure import NodeEdgeInfo, NodeInfo

from web import models

import math
import logging

class Kpa:
    def __init__(self, patientId, aimDesease, odsRatio):
        self.patientId = patientId
        self.odsRatio = int(odsRatio)
        self.graphDict = dict()
        self.newPathSetDict = dict()

        self.gcAimDesease = aimDesease
        self.gcSufferFromDisease = list()
        # 暫時使用
        # self.gcSufferFromDisease = ["780789", "690698"]

        self.gvKeyPathGroup = list()
        self.gvPathEntropy = float("inf")
        self.gvNumberOfTimes = 0
        self.gvDisList = list()

    def createGraphDictInstance(self):
        analysisOddsRatio = []
        try:
            temp = models.AnalysisOddsRatio.objects.get(disease=self.gcAimDesease, oddsratio=self.odsRatio)
            analysisOddsRatio = eval(temp.data)
        except Exception as e:
            analysisOddsRatio = []

        for i in analysisOddsRatio:
            temp = i.split(' ')

            sourceNode = temp[0]
            targetNode = temp[1]
            amount = int(temp[2])

            if sourceNode not in self.graphDict:
                self.graphDict[sourceNode] = NodeEdgeInfo()
            self.graphDict[sourceNode].targetNodes.append(targetNode)
            self.graphDict[sourceNode].targetNodesAmounts[targetNode] = amount
            
            if targetNode not in self.graphDict:
                self.graphDict[targetNode] = NodeEdgeInfo()
            self.graphDict[targetNode].sourceNodes.append(sourceNode)
            self.graphDict[targetNode].sourceNodesAmounts[sourceNode] = amount

    def createGcSufferFromDisease(self):
        passport = {}
        try:
            temp = models.HealthPassport.objects.filter(user_id=self.patientId).order_by('-time').first()
            passport = eval(temp.passport)
        except Exception as e:
            passport = {}

        for i in passport:
            for j in passport[i]:
                if j["icd"] in self.graphDict:
                    self.gcSufferFromDisease.append(j["icd"])

    def createNewPathSetDictInstance(self):
        pathwayForOr = []
        try:
            temp = models.PathwayForOr.objects.get(disease=self.gcAimDesease, oddsratio=self.odsRatio)
            pathwayForOr = eval(temp.data)
        except Exception as e:
            pathwayForOr = []

        for patway in pathwayForOr:
            arr = patway.split(' ')

            for i in range(len(arr) - 1):
                path = [arr[i]]
                for j in range(i + 1, len(arr)):
                    path.append(arr[j])
                if arr[i] not in self.newPathSetDict:
                    self.newPathSetDict[arr[i]] = list()
                self.newPathSetDict[arr[i]].append(path)

    def iterationAnalysis(self):
        self.recursivePathMach(0, [])

    def recursivePathMach(self, ind, pathRecord):
        for i in self.newPathSetDict[self.gcSufferFromDisease[ind]]:
            pathRecord.append(i)
            if ind == len(self.gcSufferFromDisease) - 1:
                pathWayDisease = set()
                for j in pathRecord:
                    for k in j:
                        pathWayDisease.add(k)
                disList = dict()
                for j in self.graphDict.keys():
                    if j =="999001":
                        continue
                    if j not in disList:
                        disList[j] = NodeInfo()
                self.pathEntropyAnalysis(pathRecord, disList, pathWayDisease)
            else:
                self.recursivePathMach(ind + 1, pathRecord)
            pathRecord.pop()

    def pathEntropyAnalysis(self, pathRecord, disList, pathWayDisease):
        graphEntropy = 0
        for i in disList.keys():
            disList[i].piv, disList[i].pov, disList[i].entropy = self.nodeAnalysis(i, pathWayDisease, pathRecord)
            graphEntropy += disList[i].entropy
            if graphEntropy > self.gvPathEntropy:
                return
        if graphEntropy < self.gvPathEntropy:
            self.gvKeyPathGroup = pathRecord.copy()
            self.gvPathEntropy = graphEntropy
            self.gvDisList = disList.copy()
            self.gvNumberOfTimes = self.numberOfTimesCalculate(pathRecord)
        elif graphEntropy == self.gvPathEntropy:
            numberOfTimes = self.numberOfTimesCalculate(pathRecord)
            if numberOfTimes > self.gvNumberOfTimes:
                self.gvKeyPathGroup = pathRecord.copy()
                self.gvPathEntropy = graphEntropy
                self.gvDisList = disList.copy()
                self.gvNumberOfTimes = numberOfTimes

    def nodeAnalysis(self, dis, pathWayDisease, pathRecord):
        totalLinks = 0
        for amount in self.graphDict[dis].sourceNodesAmounts.values():
            totalLinks += amount
        for amount in self.graphDict[dis].targetNodesAmounts.values():
            totalLinks += amount
        innerLinks = 0
        outerLinks = 0
        if dis in pathWayDisease:
            for sourceNode in self.graphDict[dis].sourceNodes:
                isInner = False
                for i in pathRecord:
                    sourceNodeIndex = -1
                    try:
                        sourceNodeIndex = i.index(sourceNode)
                    except ValueError:
                        continue
                    if sourceNodeIndex + 1 <= len(i) and i[sourceNodeIndex + 1] == dis:
                        isInner = True
                        break
                if isInner:
                    innerLinks += self.graphDict[dis].sourceNodesAmounts[sourceNode]
                else:
                    outerLinks += self.graphDict[dis].sourceNodesAmounts[sourceNode]
            for targetNode in self.graphDict[dis].targetNodes:
                isInner = False
                for i in pathRecord:
                    targetNodeIndex = -1
                    try:
                        targetNodeIndex = i.index(targetNode)
                    except ValueError:
                        continue
                    if targetNodeIndex - 1 > 0 and i[targetNodeIndex - 1] == dis:
                        isInner = True
                        break
                if isInner:
                    innerLinks += self.graphDict[dis].targetNodesAmounts[targetNode]
                else:
                    outerLinks += self.graphDict[dis].targetNodesAmounts[targetNode]
        else:
            for i in self.graphDict[dis].sourceNodes:
                if i in pathWayDisease:
                    innerLinks += self.graphDict[dis].sourceNodesAmounts[i]
                else:
                    outerLinks += self.graphDict[dis].sourceNodesAmounts[i]
            for i in self.graphDict[dis].targetNodes:
                if i in pathWayDisease:
                    innerLinks += self.graphDict[dis].targetNodesAmounts[i]
                else:
                    outerLinks += self.graphDict[dis].targetNodesAmounts[i]
        piv = innerLinks / totalLinks
        pov = outerLinks / totalLinks
        entropy = self.entropyCalculator(piv, pov)
        return piv, pov, entropy

    def entropyCalculator(self, piv, pov):
        if piv == 0 or pov == 0:
            return 0
        return -piv * math.log(piv, 2) - pov * math.log(pov, 2)

    def numberOfTimesCalculate(self, keyPathGroup):
        count = 0
        recordSet = set()
        for i in keyPathGroup:
            for j in range(len(i) - 1):
                record = i[j] + i[j + 1]
                if record in recordSet:
                    continue
                else:
                    recordSet.add(record)
                    count += self.graphDict[i[j]].targetNodesAmounts[i[j + 1]]
        return count

    def createResultJsonFile(self):
        Logger = logging.getLogger('logger')

        keyPathwayJson = {}
        try:
            temp = models.CytoscapeJsonConfig.objects.get(disease=self.gcAimDesease, oddsratio=self.odsRatio)
            keyPathwayJson = eval(temp.data)
        except Exception as e:
            keyPathwayJson = {}

        keyPathwayJson["sufferDisease"] = self.gcSufferFromDisease

        Logger.info(keyPathwayJson)

        for i in self.gvKeyPathGroup:
            for j in range(len(i) - 1):
                keyPathway = i[j] + "_" + i[j + 1]
                if keyPathway not in keyPathwayJson["keyPathway"]:
                    keyPathwayJson["keyPathway"].append(keyPathway)

        Logger.info("exit")

        return keyPathwayJson