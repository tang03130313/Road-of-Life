def keyPathwayAnalysis(patientId, targetDisease, oddsRatio):
	if oddsRatio == "6":
		return {"baseNetwork": [
        {
            "targetNode": "617629",
            "numOfPeople": 280,
            "sourceNode": "999001"
        },
        {
            "targetNode": "690698",
            "numOfPeople": 145,
            "sourceNode": "617629"
        },
        {
            "targetNode": "617629",
            "numOfPeople": 110,
            "sourceNode": "780789"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 145,
            "sourceNode": "690698"
        },
        {
            "targetNode": "249259",
            "numOfPeople": 130,
            "sourceNode": "999001"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 130,
            "sourceNode": "249259"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 135,
            "sourceNode": "617629"
        },
        {
            "targetNode": "640649",
            "numOfPeople": 110,
            "sourceNode": "617629"
        },
        {
            "targetNode": "999999",
            "numOfPeople": 96,
            "sourceNode": "401405"
        },
        {
            "targetNode": "650659",
            "numOfPeople": 135,
            "sourceNode": "401405"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 110,
            "sourceNode": "640649"
        },
        {
            "targetNode": "780789",
            "numOfPeople": 110,
            "sourceNode": "999001"
        },
        {
            "targetNode": "999999",
            "numOfPeople": 32,
            "sourceNode": "650659"
        }
    ],
    "sufferDisease": [
        "780789",
        "690698"
    ],
    "distinctGene": [
        "617629",
        "249259",
        "401405"
    ],
    "keyPathway": [
        "780789_617629",
        "617629_640649",
        "640649_401405",
        "690698_401405",
        "401405_999999"
    ]}
	elif oddsRatio == "5":
		return {"baseNetwork": [
        {
            "targetNode": "617629",
            "numOfPeople": 931,
            "sourceNode": "999001"
        },
        {
            "targetNode": "460466",
            "numOfPeople": 393,
            "sourceNode": "401405"
        },
        {
            "targetNode": "640649",
            "numOfPeople": 150,
            "sourceNode": "460466"
        },
        {
            "targetNode": "560569",
            "numOfPeople": 133,
            "sourceNode": "780789"
        },
        {
            "targetNode": "460466",
            "numOfPeople": 210,
            "sourceNode": "617629"
        },
        {
            "targetNode": "690698",
            "numOfPeople": 145,
            "sourceNode": "617629"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 643,
            "sourceNode": "999001"
        },
        {
            "targetNode": "90099",
            "numOfPeople": 121,
            "sourceNode": "780789"
        },
        {
            "targetNode": "650659",
            "numOfPeople": 121,
            "sourceNode": "90099"
        },
        {
            "targetNode": "617629",
            "numOfPeople": 231,
            "sourceNode": "780789"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 479,
            "sourceNode": "690698"
        },
        {
            "targetNode": "249259",
            "numOfPeople": 255,
            "sourceNode": "999001"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 210,
            "sourceNode": "460466"
        },
        {
            "targetNode": "690698",
            "numOfPeople": 189,
            "sourceNode": "460466"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 130,
            "sourceNode": "249259"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 319,
            "sourceNode": "617629"
        },
        {
            "targetNode": "650659",
            "numOfPeople": 121,
            "sourceNode": "617629"
        },
        {
            "targetNode": "640649",
            "numOfPeople": 231,
            "sourceNode": "617629"
        },
        {
            "targetNode": "520529",
            "numOfPeople": 125,
            "sourceNode": "617629"
        },
        {
            "targetNode": "650659",
            "numOfPeople": 125,
            "sourceNode": "520529"
        },
        {
            "targetNode": "460466",
            "numOfPeople": 189,
            "sourceNode": "999001"
        },
        {
            "targetNode": "999999",
            "numOfPeople": 265,
            "sourceNode": "401405"
        },
        {
            "targetNode": "690698",
            "numOfPeople": 145,
            "sourceNode": "780789"
        },
        {
            "targetNode": "640649",
            "numOfPeople": 184,
            "sourceNode": "401405"
        },
        {
            "targetNode": "650659",
            "numOfPeople": 385,
            "sourceNode": "401405"
        },
        {
            "targetNode": "999999",
            "numOfPeople": 100,
            "sourceNode": "640649"
        },
        {
            "targetNode": "999999",
            "numOfPeople": 53,
            "sourceNode": "460466"
        },
        {
            "targetNode": "520529",
            "numOfPeople": 125,
            "sourceNode": "249259"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 110,
            "sourceNode": "640649"
        },
        {
            "targetNode": "780789",
            "numOfPeople": 630,
            "sourceNode": "999001"
        },
        {
            "targetNode": "560569",
            "numOfPeople": 132,
            "sourceNode": "617629"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 265,
            "sourceNode": "560569"
        },
        {
            "targetNode": "999999",
            "numOfPeople": 164,
            "sourceNode": "650659"
        }
    ],
    "sufferDisease": [
        "780789",
        "690698"
    ],
    "distinctGene": [
        "617629",
        "249259",
        "401405"
    ],
    "keyPathway": [
        "780789_617629",
        "617629_650659",
        "650659_999999",
        "690698_401405",
        "401405_999999"
    ]}
	elif oddsRatio == "4":
		return {"baseNetwork": [
        {
            "targetNode": "560569",
            "numOfPeople": 133,
            "sourceNode": "780789"
        },
        {
            "targetNode": "650659",
            "numOfPeople": 551,
            "sourceNode": "90099"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 803,
            "sourceNode": "690698"
        },
        {
            "targetNode": "90099",
            "numOfPeople": 177,
            "sourceNode": "999001"
        },
        {
            "targetNode": "650659",
            "numOfPeople": 123,
            "sourceNode": "660669"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 130,
            "sourceNode": "249259"
        },
        {
            "targetNode": "210229",
            "numOfPeople": 140,
            "sourceNode": "999001"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 392,
            "sourceNode": "520529"
        },
        {
            "targetNode": "640649",
            "numOfPeople": 1931,
            "sourceNode": "617629"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 994,
            "sourceNode": "780789"
        },
        {
            "targetNode": "460466",
            "numOfPeople": 186,
            "sourceNode": "780789"
        },
        {
            "targetNode": "780789",
            "numOfPeople": 277,
            "sourceNode": "617629"
        },
        {
            "targetNode": "690698",
            "numOfPeople": 468,
            "sourceNode": "999001"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 2573,
            "sourceNode": "640649"
        },
        {
            "targetNode": "560569",
            "numOfPeople": 132,
            "sourceNode": "617629"
        },
        {
            "targetNode": "640649",
            "numOfPeople": 451,
            "sourceNode": "780789"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 169,
            "sourceNode": "614616"
        },
        {
            "targetNode": "617629",
            "numOfPeople": 3496,
            "sourceNode": "999001"
        },
        {
            "targetNode": "460466",
            "numOfPeople": 333,
            "sourceNode": "617629"
        },
        {
            "targetNode": "555558",
            "numOfPeople": 149,
            "sourceNode": "460466"
        },
        {
            "targetNode": "249259",
            "numOfPeople": 530,
            "sourceNode": "999001"
        },
        {
            "targetNode": "110118",
            "numOfPeople": 157,
            "sourceNode": "999001"
        },
        {
            "targetNode": "660669",
            "numOfPeople": 123,
            "sourceNode": "460466"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 1878,
            "sourceNode": "617629"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 140,
            "sourceNode": "210229"
        },
        {
            "targetNode": "650659",
            "numOfPeople": 956,
            "sourceNode": "617629"
        },
        {
            "targetNode": "520529",
            "numOfPeople": 282,
            "sourceNode": "617629"
        },
        {
            "targetNode": "617629",
            "numOfPeople": 833,
            "sourceNode": "460466"
        },
        {
            "targetNode": "640649",
            "numOfPeople": 297,
            "sourceNode": "530539"
        },
        {
            "targetNode": "640649",
            "numOfPeople": 192,
            "sourceNode": "614616"
        },
        {
            "targetNode": "640649",
            "numOfPeople": 275,
            "sourceNode": "249259"
        },
        {
            "targetNode": "640649",
            "numOfPeople": 688,
            "sourceNode": "401405"
        },
        {
            "targetNode": "520529",
            "numOfPeople": 235,
            "sourceNode": "460466"
        },
        {
            "targetNode": "640649",
            "numOfPeople": 144,
            "sourceNode": "690698"
        },
        {
            "targetNode": "614616",
            "numOfPeople": 169,
            "sourceNode": "780789"
        },
        {
            "targetNode": "555558",
            "numOfPeople": 215,
            "sourceNode": "999001"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 131,
            "sourceNode": "630639"
        },
        {
            "targetNode": "640649",
            "numOfPeople": 556,
            "sourceNode": "999001"
        },
        {
            "targetNode": "690698",
            "numOfPeople": 145,
            "sourceNode": "617629"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 2696,
            "sourceNode": "999001"
        },
        {
            "targetNode": "90099",
            "numOfPeople": 121,
            "sourceNode": "780789"
        },
        {
            "targetNode": "560569",
            "numOfPeople": 231,
            "sourceNode": "999001"
        },
        {
            "targetNode": "617629",
            "numOfPeople": 448,
            "sourceNode": "780789"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 1435,
            "sourceNode": "460466"
        },
        {
            "targetNode": "630639",
            "numOfPeople": 131,
            "sourceNode": "999001"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 364,
            "sourceNode": "555558"
        },
        {
            "targetNode": "690698",
            "numOfPeople": 189,
            "sourceNode": "460466"
        },
        {
            "targetNode": "90099",
            "numOfPeople": 131,
            "sourceNode": "617629"
        },
        {
            "targetNode": "690698",
            "numOfPeople": 145,
            "sourceNode": "780789"
        },
        {
            "targetNode": "617629",
            "numOfPeople": 332,
            "sourceNode": "520529"
        },
        {
            "targetNode": "650659",
            "numOfPeople": 275,
            "sourceNode": "640649"
        },
        {
            "targetNode": "780789",
            "numOfPeople": 275,
            "sourceNode": "401405"
        },
        {
            "targetNode": "999999",
            "numOfPeople": 525,
            "sourceNode": "650659"
        },
        {
            "targetNode": "460466",
            "numOfPeople": 393,
            "sourceNode": "401405"
        },
        {
            "targetNode": "90099",
            "numOfPeople": 122,
            "sourceNode": "460466"
        },
        {
            "targetNode": "640649",
            "numOfPeople": 546,
            "sourceNode": "460466"
        },
        {
            "targetNode": "560569",
            "numOfPeople": 158,
            "sourceNode": "460466"
        },
        {
            "targetNode": "650659",
            "numOfPeople": 163,
            "sourceNode": "530539"
        },
        {
            "targetNode": "520529",
            "numOfPeople": 332,
            "sourceNode": "999001"
        },
        {
            "targetNode": "999999",
            "numOfPeople": 51,
            "sourceNode": "780789"
        },
        {
            "targetNode": "530539",
            "numOfPeople": 297,
            "sourceNode": "999001"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 157,
            "sourceNode": "110118"
        },
        {
            "targetNode": "650659",
            "numOfPeople": 125,
            "sourceNode": "520529"
        },
        {
            "targetNode": "780789",
            "numOfPeople": 157,
            "sourceNode": "460466"
        },
        {
            "targetNode": "460466",
            "numOfPeople": 3278,
            "sourceNode": "999001"
        },
        {
            "targetNode": "999999",
            "numOfPeople": 2006,
            "sourceNode": "401405"
        },
        {
            "targetNode": "650659",
            "numOfPeople": 550,
            "sourceNode": "401405"
        },
        {
            "targetNode": "999999",
            "numOfPeople": 364,
            "sourceNode": "640649"
        },
        {
            "targetNode": "999999",
            "numOfPeople": 53,
            "sourceNode": "460466"
        },
        {
            "targetNode": "520529",
            "numOfPeople": 125,
            "sourceNode": "249259"
        },
        {
            "targetNode": "780789",
            "numOfPeople": 2213,
            "sourceNode": "999001"
        },
        {
            "targetNode": "614616",
            "numOfPeople": 192,
            "sourceNode": "999001"
        },
        {
            "targetNode": "401405",
            "numOfPeople": 654,
            "sourceNode": "560569"
        }
    ],
    "sufferDisease": [
        "780789",
        "690698"
    ],
    "distinctGene": [
        "617629",
        "530539",
        "249259",
        "401405"
    ],
    "keyPathway": [
        "780789_999999",
        "690698_401405",
        "401405_999999"
    ]}
	return {}
