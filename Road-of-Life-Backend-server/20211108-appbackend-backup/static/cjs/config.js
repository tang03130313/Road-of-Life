/* ----- main.js ----- */
const OR_SLIDER_MAX_VALUE = 2;
const OR_SLIDER_VALUE = 2;

/* ----- logic.js ----- */
const OR_BIAS = 4;

/* ----- cycy.js ----- */
const START_LABEL = '起始';
const TARGET_LABEL = '目標疾病';
const TOTAL_SOURCE_GROUP_BG_COLOR = '#87CEFA';
const TOTAL_SOURCE_GROUP_BORDER_WIDTH = 3;
const NODE_FONT_COLOR = 'black';
const EDGE_CURVE_STYLE = 'bezier';
const EDGE_TARGET_ARROW_SHAPE = 'triangle';
const EDGE_FONT_COLOR = 'greenyellow';
const NORMAL_NODE_SIZE = 40;
const SPECIAL_NODE_SIZE = 55;
const IMPORTANT_NODE_BORDER_WIDTH = 8;
const IMPORTANT_NODE_BORDER_STYLE = 'solid';
const NODE_FONT_SIZE = 20;
const EDGE_FONT_SIZE = 20;
const EDGE_MARGIN_Y = 30;
const MIN_ZOOM_VALUE = 0.1;
const MAX_ZOOM_VALUE = 1.9;
const SUFFER_DISEASE_NODE_COLOR = 'yellow';
const TARGET_DISEASE_NODE_COLOR = 'red';
const KEY_PATHWAY_EDGE_WIDTH = 8;
const KEY_PATHWAY_EDGE_LINE_COLOR = 'yellow';
const KEY_PATHWAY_EDGE_TARGET_ARROW_COLOR = 'yellow';
const DISTINCT_GENE_SHAPE = 'diamond';
const NORMAL_LINE_STYLE = 'dashed';
const KEY_PATHWAY_LINE_STYLE = 'solid';
const NORMAL_LINE_DASH_PATTERN = [5, 10];
const ICD9_DICT_CH = {
	"1009": "腸道傳染疾病",
	"10018": "結核病",
	"20027": "動物媒介細菌性疾病",
	"30041": "其他細菌性疾病",
	"42042": "人類免疫不全病毒感染",
	"45049": "脊髓灰白質炎及其他非節肢動物媒介之中樞神經系統病毒性疾病",
	"50059": "伴有發疹之病毒性疾病",
	"60066": "節肢動物媒介之病毒性疾病",
	"70079": "病毒及衣原菌屬所致之其他疾病",
	"80088": "立克次體及其他節肢動物媒介之疾病",
	"90099": "梅毒及其他性病",
	"100104": "其他螺旋體病",
	"110118": "黴菌病",
	"120129": "蠕蟲病",
	"130136": "其他傳染病及寄生蟲病",
	"137139": "傳染病及寄生蟲病之後期影響",
	
	"140149": "唇、口腔及咽喉之惡性腫瘤",
	"150159": "消化器及腹膜之惡性腫瘤",
	"160165": "呼吸及胸內器官之惡性腫瘤",
	"170175": "骨、結締組織、皮膚及乳房之惡性腫瘤",
	"176176": "卡波西氏肉瘤",
	"179189": "泌尿生殖器官惡性腫瘤",
	"190199": "其他及未明示位置之惡性腫瘤",
	"200208": "淋巴及造血組織之惡性腫瘤",
	"209209": "神經內分泌腫瘤",
	"210229": "良性腫瘤",
	"230234": "原位癌",
	"235238": "性態未明之腫瘤",
	"239239": "未明示性質之腫瘤",
	
	"240246": "甲狀腺疾患",
	"249259": "其他內分泌腺疾病",
	"260269": "營養缺乏",
	"270279": "其他新陳代謝失調及免疫失調",
	
	"280": "鐵質缺乏性貧血",
	"281": "其他物質缺乏造成之貧血",
	"282": "遺傳性溶血性貧血",
	"283": "後天性溶血性貧血",
	"284": "再生不良性貧血",
	"285": "其他及未明示性貧血",
	"286": "血液凝固缺陷",
	"287": "紫斑症及其他出血性病態",
	"288": "白血球疾病",
	"289": "其他血液與造血器官疾病",
	
	"290294": "器質性精神病態",
	"295299": "其他精神病",
	"300316": "精神官能症、人格違常及其他非精神病心理疾患",
	"317319": "智能不足",
	
	"320327": "中樞神經系統之炎性疾病",
	"330337": "中樞神經系統之遺傳性及變質性疾病",
	"338338": "疼痛",
	"339339": "其他頭痛綜合症",
	"340349": "其他中樞神經系統疾患",
	"350359": "末梢神經系統疾患",
	"360379": "眼睛及附屬器官之疾患",
	"380389": "耳及乳突之疾患",
	
	"390392": "急性風濕熱",
	"393398": "慢性風濕性心臟病",
	"401405": "高血壓疾病",
	"410414": "缺血性心臟病",
	"415417": "肺性循環疾病",
	"420429": "其他形態心臟病",
	"430438": "腦血管疾病",
	"440448": "動脈、小動脈及毛細血管疾病",
	"451459": "循環系統靜脈及淋巴管疾病",
	
	"460466": "急性呼吸道感染",
	"470478": "其他上呼吸道疾病",
	"480488": "肺炎及流行性感冒",
	"490496": "慢性阻塞性肺部疾病(C.O.P.D.)及有關病態",
	"500508": "外物所致之肺沉著症及其他肺部疾病",
	"510519": "呼吸系統之其他疾病",
	
	"520529": "口腔、唾液腺及顎骨之疾病",
	"530538": "食道、胃及十二指腸之疾病",
	"540543": "闌尾炎",
	"550553": "腹腔疝氣",
	"555558": "非傳染性腸炎及大腸炎",
	"560569": "腸及腹膜之其他疾病",
	"570579": "消化系統之其他疾病",
	
	"580589": "腎炎、腎徵候群及腎變性病",
	"590599": "其他泌尿系統疾病",
	"600608": "男性生殖器官疾病",
	"610611": "乳房疾病",
	"614616": "女性骨盆腔內器官之炎症",
	"617629": "女性生殖道之其他疾患",
	
	"630639": "伴有流產後果之妊娠",
	"640649": "與妊娠有關之主要併發症",
	"650659": "正常生產和其他姙娠、分娩及生產時所需照顧之徵象",
	"660669": "主要發生於分娩及生產過程之併發症",
	"670677": "產後併發症",
	"678679": "其他母嬰並發症",
	
	"680686": "皮膚及皮下組織感染",
	"690698": "皮膚及皮下組織之其他炎性病態",
	"700709": "其他皮膚及皮下組織疾病",
	
	"710719": "關節病變及有關疾患",
	"720724": "背部病變",
	"725729": "風濕症, 背部除外",
	"730739": "骨病變、軟骨病變及後天性肌肉骨骼畸形",
	
	"740": "無腦顱症及類似畸形",
	"741": "脊椎裂",
	"742": "神經系統之其他先天畸形",
	"743": "眼睛先天性畸形",
	"744": "耳、臉及頸部之先天畸形",
	"745": "心球(胚胎)及心臟中隔閉合之畸形",
	"746": "心臟之其他先天畸形",
	"747": "循環系統之其他先天畸形",
	"748": "呼吸系統先天畸形",
	"749": "腭裂及唇裂",
	"750": "上消化道之其他先天畸形",
	"751": "消化系統之其他先天畸形",
	"752": "生殖器官先天畸形",
	"753": "泌尿系統先天畸形",
	"754": "先天性肌肉骨骼變形",
	"755": "四肢之其他先天畸形",
	"756": "其他先天性肌肉骨骼畸形",
	"757": "外皮之先天畸形",
	"758": "染色體異常",
	"759": "其他及未明示之先天異常",
	
	"760763": "圍產期發病率和死亡率的孕產原因",
	"764779": "圍產期其他疾病",
	
	"780789": "徵候",
	"790796": "非特定性異常所見",
	"797799": "診斷欠明及原因不明之病因及死因",
	
	"800804": "顱骨骨折",
	"805809": "脊柱和軀幹骨折",
	"810819": "上肢骨折",
	"820829": "下肢骨折",
	"830839": "脫臼",
	"840848": "關節和鄰近肌肉的扭傷和拉傷",
	"850854": "顱內損傷, 顱骨骨折者除外",
	"860869": "胸部, 腹部和骨盆內部受傷",
	"870879": "頭, 頸和軀幹開放性傷口",
	"880887": "上肢開放性傷口",
	"890897": "下肢開放性傷口",
	"900904": "血管受傷",
	"905909": "傷害, 中毒, 毒性作用和其他外部原因的後期影響",
	"910919": "淺表傷",
	"920924": "皮膚表面完整的挫傷",
	"925929": "壓傷",
	"930939": "異物進入孔口的影響",
	"940949": "燒傷",
	"950957": "對神經和脊髓的損傷",
	"958959": "某些創傷性並發症和未指明的損傷",
	"960979": "藥物，藥物和生物物質中毒",
	"980989": "物質的毒性作用主要是非藥用的",
	"990995": "其他外部原因和未指定的影響",
	"996999": "外科和醫療並發症, 未分類",
	
	"999001": "樣本族群",
	"999999": "目標疾病"
};
const ICD9_DICT_EN = {
	"1009": "Intestinal Infectious Diseases",
	"10018": "Tuberculosis",
	"20027": "Zoonotic Bacterial Diseases",
	"30041": "Other Bacterial Diseases",
	"42042": "Human Immunodeficiency Virus",
	"45049": "Poliomyelitis And Other Non-Arthropod-Borne Viral Diseases Of Central Nervous System",
	"50059": "Viral Diseases Accompanied By Exanthem",
	"60066": "Arthropod-Borne Viral Diseases",
	"70079": "Other Diseases Due To Viruses And Chlamydiae",
	"80088": "Rickettsioses And Other Arthropod-Borne Diseases",
	"90099": "Syphilis And Other Venereal Diseases",
	"100104": "Otherspirochetal Diseases",
	"110118": "Mycoses",
	"120129": "Helminthiases",
	"130136": "Other Infectious And Parasitic Diseases",
	"137139": "Late Effects Of Infectious And Parasitic Diseases",
	
	"140149": "Malignant Neoplasm Of Lip, Oral Cavity, And Pharynx",
	"150159": "Malignant Neoplasm Of Digestive Organs And Peritoneum",
	"160165": "Malignant Neoplasm Of Respiratory And Intrathoracic Organs",
	"170175": "Malignant Neoplasm Of Bone, Connective Tissue, Skin, And Breast",
	"176176": "Kaposi's Sarcoma",
	"179189": "Malignant Neoplasm Of Genitourinary Organs",
	"190199": "Malignant Neoplasm Of Other And Unspecified Sites",
	"200208": "Malignant Neoplasm Of Lymphatic And Hematopoietic Tissue",
	"209209": "Neuroendocrine Tumors",
	"210229": "Benign Neoplasms",
	"230234": "Carcinoma In Situ",
	"235238": "Neoplasms Of Uncertain Behavior",
	"239239": "Neoplasms Of Unspecified Nature",
	
	"240246": "Disorders Of Thyroid Gland",
	"249259": "Diseases Of Other Endocrine Glands",
	"260269": "Nutritional Deficiencies",
	"270279": "Other Metabolic Disorders And Immunity Disorders",
	
	"280": "Iron deficiency anemias",
	"281": "Other deficiency anemias",
	"282": "Hereditary hemolytic anemias",
	"283": "Acquired hemolytic anemias",
	"284": "Aplastic anemia",
	"285": "Other and unspecified anemias",
	"286": "Coagulation defects",
	"287": "Purpura and other hemorrhagic conditions",
	"288": "Diseases of white blood cells",
	"289": "Other diseases of blood and blood-forming organs",
	
	"290294": "Organic Psychotic Conditions",
	"295299": "Other Psychoses",
	"300316": "Neurotic Disorders, Personality Disorders, And Other Nonpsychotic Mental Disorders",
	"317319": "Mental Retardation",
	
	"320327": "Inflammatory Diseases Of The Central Nervous System",
	"330337": "Hereditary And Degenerative Diseases Of The Central Nervous System",
	"338338": "Pain",
	"339339": "Other Headache Syndromes",
	"340349": "Other Disorders Of The Central Nervous System",
	"350359": "Disorders Of The Peripheral Nervous System",
	"360379": "Disorders Of The Eye And Adnexa",
	"380389": "Diseases Of The Ear And Mastoid Process",
	
	"390392": "Acute Rheumatic Fever",
	"393398": "Chronic Rheumatic Heart Disease",
	"401405": "Hypertensive Disease",
	"410414": "Ischemic Heart Disease",
	"415417": "Diseases Of Pulmonary Circulation",
	"420429": "Other Forms Of Heart Disease",
	"430438": "Cerebrovascular Disease",
	"440448": "Diseases Of Arteries, Arterioles, And Capillaries",
	"451459": "Diseases Of Veins And Lymphatics, And Other Diseases Of Circulatory System",
	
	"460466": "Acute Respiratory Infections",
	"470478": "Other Diseases Of Upper Respiratory Tract",
	"480488": "Pneumonia And Influenza",
	"490496": "Chronic Obstructive Pulmonary Disease And Allied Conditions",
	"500508": "Pneumoconioses And Other Lung Diseases Due To External Agents",
	"510519": "Other Diseases Of Respiratory System",
	
	"520529": "Diseases Of Oral Cavity, Salivary Glands, And Jaws",
	"530538": "Diseases Of Esophagus, Stomach, And Duodenum",
	"540543": "Appendicitis",
	"550553": "Hernia Of Abdominal Cavity",
	"555558": "Noninfective Enteritis And Colitis",
	"560569": "Other Diseases Of Intestines And Peritoneum",
	"570579": "Other Diseases Of Digestive System",
	
	"580589": "Nephritis, Nephrotic Syndrome, And Nephrosis",
	"590599": "Other Diseases Of Urinary System",
	"600608": "Diseases Of Male Genital Organs",
	"610611": "Disorders Of Breast",
	"614616": "Inflammatory Disease Of Female Pelvic Organs",
	"617629": "Other Disorders Of Female Genital Tract",
	
	"630639": "Ectopic And Molar Pregnancy And Other Pregnancy With Abortive Outcome",
	"640649": "Complications Mainly Related To Pregnancy",
	"650659": "Normal Delivery, And Other Indications For Care In Pregnancy, Labor, And Delivery",
	"660669": "Complications Occurring Mainly In The Course Of Labor And Delivery",
	"670677": "Complications Of The Puerperium",
	"678679": "Other Maternal And Fetal Complications",
	
	"680686": "Infections Of Skin And Subcutaneous Tissue",
	"690698": "Other Inflammatory Conditions Of Skin And Subcutaneous Tissue",
	"700709": "Other Diseases Of Skin And Subcutaneous Tissue",
	
	"710719": "Arthropathies And Related Disorders",
	"720724": "Dorsopathies",
	"725729": "Rheumatism, Excluding The Back",
	"730739": "Osteopathies, Chondropathies, And Acquired Musculoskeletal Deformities",
	
	"740": "Anencephalus and similar anomalies",
	"741": "Spina bifida",
	"742": "Other congenital anomalies of nervous system",
	"743": "Congenital anomalies of eye",
	"744": "Congenital anomalies of ear face and neck",
	"745": "Bulbus cordis anomalies and anomalies of cardiac septal closure",
	"746": "Other congenital anomalies of heart",
	"747": "Other congenital anomalies of circulatory system",
	"748": "Congenital anomalies of respiratory system",
	"749": "Cleft palate and cleft lip",
	"750": "Other congenital anomaly of upper alimentary tract",
	"751": "Other congenital anomalies of digestive system",
	"752": "Congenital anomalies of genital organs",
	"753": "Congenital anomalies of urinary system",
	"754": "Certain congenital musculoskeletal deformities",
	"755": "Other congenital anomalies of limbs",
	"756": "Other congenital musculoskeletal anomalies",
	"757": "Congenital anomalies of the integument",
	"758": "Chromosomal anomalies",
	"759": "Other and unspecified congenital anomalies",
	
	"760763": "Maternal Causes Of Perinatal Morbidity And Mortality",
	"764779": "Other Conditions Originating In The Perinatal Period",
	
	"780789": "Symptoms",
	"790796": "Nonspecific Abnormal Findings",
	"797799": "Ill-Defined And Unknown Causes Of Morbidity And Mortality",
	
	"800804": "Fracture Of Skull",
	"805809": "Fracture Of Spine And Trunk",
	"810819": "Fracture Of Upper Limb",
	"820829": "Fracture Of Lower Limb",
	"830839": "Dislocation",
	"840848": "Sprains And Strains Of Joints And Adjacent Muscles",
	"850854": "Intracranial Injury, Excluding Those With Skull Fracture",
	"860869": "Internal Injury Of Chest, Abdomen, And Pelvis",
	"870879": "Open Wound Of Head, Neck, And Trunk",
	"880887": "Open Wound Of Upper Limb",
	"890897": "Open Wound Of Lower Limb",
	"900904": "Injury To Blood Vessels",
	"905909": "Late Effects Of Injuries, Poisonings, Toxic Effects, And Other External Causes",
	"910919": "Superficial Injury",
	"920924": "Contusion With Intact Skin Surface",
	"925929": "Crushing Injury",
	"930939": "Effects Of Foreign Body Entering Through Orifice",
	"940949": "Burns",
	"950957": "Injury To Nerves And Spinal Cord",
	"958959": "Certain Traumatic Complications And Unspecified Injuries",
	"960979": "Poisoning By Drugs, Medicinals And Biological Substances",
	"980989": "Toxic Effects Of Substances Chiefly Nonmedicinal As To Source",
	"990995": "Other And Unspecified Effects Of External Causes",
	"996999": "Complications Of Surgical And Medical Care, Not Elsewhere Classified",
	
	"999001": "Total Source Group",
	"999999": "Target Disease"
};

/* ----- Demo ----- */
/*
const PREMATURE_BIRTH_GRAPH_ODDS_RATIO_6 = {
    "baseNetwork": [
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
    ]
}
const PREMATURE_BIRTH_GRAPH_ODDS_RATIO_5 = {
    "baseNetwork": [
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
    ]
};
const PREMATURE_BIRTH_GRAPH_ODDS_RATIO_4 = {
    "baseNetwork": [
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
    ]
}
*/
