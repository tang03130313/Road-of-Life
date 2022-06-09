/*
 * <<Tutorial>>
 * 
 * Cytoscape.js
 * https://js.cytoscape.org/
 * 
 * Getting started with Cytoscape.js
 * https://blog.js.cytoscape.org/2016/05/24/getting-started/
 * 
 */

/**
 * 圖形初始化
 */
function cyInitialize() {
    cy = cytoscape({
        container: document.getElementById('cy'),
        style: [
            {
                selector: '.TotalSourceGroup',
                style: {
                    'label': 'data(id)',
                    'color': NODE_FONT_COLOR,
                    'font-size': NODE_FONT_SIZE,
                    'background-color': TOTAL_SOURCE_GROUP_BG_COLOR,
                    'border-width': TOTAL_SOURCE_GROUP_BORDER_WIDTH,
                }
            },
            {
                selector: '.nodes',
                style: {
                    'label': 'data(id)',
                    'color': NODE_FONT_COLOR,
                    'font-size': NODE_FONT_SIZE,
                    'height': NORMAL_NODE_SIZE,
                    'width': NORMAL_NODE_SIZE,
                    'background-color': '#6DD0CD',
                }
            },
            {
                selector: '.edges',
                style: {
                    'curve-style': EDGE_CURVE_STYLE,
                    'target-arrow-shape': EDGE_TARGET_ARROW_SHAPE,
                    'color': EDGE_FONT_COLOR,
                    'font-size': EDGE_FONT_SIZE,
                    'text-margin-y': EDGE_MARGIN_Y,
                    'line-style': NORMAL_LINE_STYLE,
                    'line-dash-pattern': NORMAL_LINE_DASH_PATTERN
                }
            },
            {
                selector: ":selected",
                style: {
                    'background-color': '#999999',
                }
            }
        ],
        minZoom: MIN_ZOOM_VALUE,
        maxZoom: MAX_ZOOM_VALUE,
        elements: [
            {
                data: { id: 'TotalSourceGroup' },
                style: {
                    'label': '樣本族群'
                },
                classes: 'TotalSourceGroup'
            }
        ]
    });

    cy.on('mouseover', 'node', function(e) {
        
    });
    cy.on('mouseout', 'node', function(e) {
        
    });
}

/**
 * 新增節點
 * @param {*} nodeName string 節點名稱(Id)
 * @param {*} hasParent boolean 是否為TotalSourceGroup的Child
 */
function addNode(nodeName, hasParent) {
    if (!hasParent) {
        if (nodeName == '999999') {
            cy.add({
                data: { id: nodeName },
                classes: 'nodes',
                style: {
                    'height': SPECIAL_NODE_SIZE,
                    'width': SPECIAL_NODE_SIZE,
                    'background-color': TARGET_DISEASE_NODE_COLOR,
                    'label': TARGET_LABEL
                }
            });
        }
        else {
            let label = nodeName.length == 6 ? nodeName : "0" + nodeName;
            label = label.substr(0, 3) + " - " + label.substr(3);
            cy.add({
                data: { id: nodeName },
                classes: 'nodes',
                style: {
                    'label': label
                }
            });
        }
    }
    else {
        cy.add({
            data: { id: nodeName, parent: 'TotalSourceGroup' },
            classes: 'nodes',
            style: {
                'height': SPECIAL_NODE_SIZE,
                'width': SPECIAL_NODE_SIZE,
                'label': START_LABEL
            }
        });
    }
}

/**
 * 新增邊
 * @param {*} edgeName string 邊名稱(Id)
 * @param {*} sourceNode string 源節點名稱(Id)
 * @param {*} targetNode string 靶節點名稱(Id)
 * @param {*} numOfPeople string | number 邊標籤
 */
function addEdge(edgeName, sourceNode, targetNode, numOfPeople) {
    cy.add({
        data: {
            id: edgeName,
            source: sourceNode,
            target: targetNode
        },
        classes: 'edges'
    });
    cy.style()
        .selector(getElementById(edgeName))
        .style({
            // 'label': numOfPeople
            // 'label': Math.floor(Math.random() * 50 ) + 10 + Math.floor(Math.random() * 50 ) + 10 + Math.floor(Math.random() * 50 ) + 10
        })
        .update()
        ;
}

/**
 * 調用佈局
 * @param {*} layoutKind string 佈局類型 null | random | preset | grid | circle | concentric | breadthfirst | cose
 */
function runLayout(layoutKind) {
    cy.layout({
        name: layoutKind
    }).run();
}

/**
 * 取得CY元件
 * @param {*} elementId string 元件Id
 */
function getElementById(elementId) {
    return cy.$id(elementId);
}

/**
 * 設定已患疾病節點
 * @param {*} nodeId string 節點Id
 */
function setSufferDiseaseNode(nodeId) {
    cy.style()
        .selector(getElementById(nodeId))
        .style({
            'background-color': SUFFER_DISEASE_NODE_COLOR
        })
        .update()
        ;
}

/**
 * 設定關鍵路徑邊
 * @param {*} edgeId string 邊Id
 */
function setKeyPathway(edgeId) {
    cy.style()
        .selector(getElementById(edgeId))
        .style({
            'width': KEY_PATHWAY_EDGE_WIDTH,
            'line-color': KEY_PATHWAY_EDGE_LINE_COLOR,
            'target-arrow-color': KEY_PATHWAY_EDGE_TARGET_ARROW_COLOR,
            'line-style': KEY_PATHWAY_LINE_STYLE,
            'arrow-scale': 2
        })
        .update()
        ;
}

/**
 * 設定獨特基因
 * @param {*} nodeId string 節點Id
 */
function setDistinctGene(nodeId) {
    cy.style()
        .selector(getElementById(nodeId))
        .style({
            'shape': DISTINCT_GENE_SHAPE,
        })
        .update()
        ;
}

/**
 * 設定QTip
 */
function setQTip() {
    cy.elements('node[id != "TotalSourceGroup"]').qtip({
        content: function(){ 
            return ICD9_DICT_CH[this.id()]
        },
        position: {
            my: 'top center',
            at: 'bottom center'
        },
        style: {
            classes: 'qtip-bootstrap',
            tip: {
                width: 16,
                height: 8
            }
        }
    });
}

/**
 * 設定重要節點
 * @param {*} nodeId string 節點Id
 * @param {*} borderColor float 節點邊顏色
 */
function setImportantNode(nodeId, borderColor) {
    cy.style()
        .selector(getElementById(nodeId))
        .style({
            'border-width': IMPORTANT_NODE_BORDER_WIDTH,
            'border-style': IMPORTANT_NODE_BORDER_STYLE,
            'border-color': 'rgb(255, ' + borderColor + ', ' + borderColor + ')'
        })
        .update()
        ;
}

/**
 * 疾病軌跡模式網路創建
 * @param {*} jsonData 疾病軌跡模式網路數據資料
 */
function networkCreate(jsonData) {
    cyInitialize();

    let baseNetwork = jsonData['baseNetwork'];
    let sufferDisease = jsonData['sufferDisease'];
    let distinctGene = jsonData['distinctGene'];
    let keyPathway = jsonData['keyPathway'];
    let importantNode = jsonData['importantNode'];

    for (let i = 0; i < baseNetwork.length; i++) {
        if (getElementById(baseNetwork[i].sourceNode).same(cy.collection())) addNode(baseNetwork[i].sourceNode, baseNetwork[i].sourceNode != '999001' ? false : true);
        if (getElementById(baseNetwork[i].targetNode).same(cy.collection())) addNode(baseNetwork[i].targetNode);
        addEdge(baseNetwork[i].sourceNode + '_' + baseNetwork[i].targetNode, baseNetwork[i].sourceNode, baseNetwork[i].targetNode, baseNetwork[i].numOfPeople);
    }
    for (let i = 0; i < sufferDisease.length; i++) setSufferDiseaseNode(sufferDisease[i]);
    for (let i = 0; i < distinctGene.length; i++) setDistinctGene(distinctGene[i]);
    for (let i = 0; i < keyPathway.length; i++) setKeyPathway(keyPathway[i]);
    for (let i = 0; i < importantNode.length; i++) setImportantNode(importantNode[i], 200 / (importantNode.length - 1) * i)

    setQTip();

    runLayout('circle');
}

/**
 * 測試用
 * @param {*} or number 勝算比
 */
function demoForOr(or) {
    let jsonData = or == 6 ? PREMATURE_BIRTH_GRAPH_ODDS_RATIO_6 : or == 5 ? PREMATURE_BIRTH_GRAPH_ODDS_RATIO_5 : PREMATURE_BIRTH_GRAPH_ODDS_RATIO_4;
    networkCreate(jsonData);
}
