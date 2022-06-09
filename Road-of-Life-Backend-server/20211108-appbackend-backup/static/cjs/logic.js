/**
 * 配合所選疾病修改 or select option
 */
function dynaOr() {
    let targetDisease = $('#target_disease option:selected').text();

    jQuery("#oddsRatioSelect").empty();

    if (targetDisease == '- - -') {
        jQuery("#oddsRatioSelect").append("<option>- - -</option>");
    }
    if (targetDisease == '早產') {
        jQuery("#oddsRatioSelect").append("<option>6</option>");
        jQuery("#oddsRatioSelect").append("<option>5</option>");
        jQuery("#oddsRatioSelect").append("<option>4</option>");
    }
    if (targetDisease == '心衰') {
        jQuery("#oddsRatioSelect").append("<option>5</option>");
        jQuery("#oddsRatioSelect").append("<option>4</option>");
    }
}

/**
 * 勝算比滑桿監聽事件
 */
function orSliderOnChange() {
    let orValue = $('.orSlider').slider('value') + OR_BIAS;
    // let orText = "OddsRatio:　" + orValue;
    // $('.orSliderTextStyle').text(orText);

    // demoForOr(orValue);

    let targetDisease = $('#target_disease option:selected').text();
    if (targetDisease == '- - -') {
        alert('請選擇目標疾病');
        return;
    }

    let patientId = $('#patient_id').val();
    if (patientId == '') {
        alert('請選擇患者身份證字號');
        return;
    }

    $.post('http://localhost:8000/web/httpPostkeyPathwayAnalysis/', {"targetDisease": targetDisease, "patientId": patientId, "oddsRatio": orValue}, function(response) {
        networkCreate(response);
    }, 'json');
}

/**
 * 風險係數按鈕監聽事件
 */
function riskFactorBtnClick() {
    let targetDisease = $('#target_disease option:selected').text();
    if (targetDisease == '- - -') {
        alert('請選擇目標疾病');
        return;
    }

    let patientId = $('#patient_id').val();
    if (patientId == '') {
        alert('請選擇患者身份證字號');
        return;
    }

    $('#analysisItemTitle').text('風險係數');
    $('#oddsRatioItemTitle').hide();
    $('#oddsRatioItemTitle').text('');
    $('#oddsRatioSlider').hide();
}

/**
 * 關鍵路徑按鈕監聽事件
 */
function keyPathwayBtnClick() {
    let targetDisease = $('#target_disease option:selected').text();
    if (targetDisease == '- - -') {
        alert('請選擇目標疾病');
        return;
    }
    // let targetDisease = "早產"

    let patientId = $('#patient_id').val();
    if (patientId == '') {
        alert('請選擇患者身份證字號');
        return;
    }

    // let orValue = $('.orSlider').slider('value') + OR_BIAS;
    let orValue = $('#oddsRatioSelect').val();

    // $('#analysisItemTitle').text('關鍵路徑');
    // $('#oddsRatioItemTitle').text("目標疾病: " + $('#target_disease option:selected').text());
    // $('#oddsRatioItemTitle').show();
    // $('#oddsRatioSlider').show();

    $.post('http://localhost:8000/web/httpPostkeyPathwayAnalysis/', {"targetDisease": targetDisease, "patientId": patientId, "oddsRatio": orValue}, function(response) {
        networkCreate(response);
    }, 'json');
}

/**
 * 患者身份證字號查詢監聽事件
 */
function patientIdSearchChange() {
    let patientId = $('#patient_id').val();
    let docter_id = $('#docter_id').val();
    if (patientId == '') {
        // $('#patient_id_list').empty();
        // $('#patient_id_list').append("<option>- - -</option>");
        return;
    }
    $.post('http://localhost:8000/web/searchPatient/', {"patientId": patientId, "docter_id": docter_id}, function(response) {
        // $('#patient_id_list').empty();
        // $('#patient_id_list').append("<option>- - -</option>");
        // response.patientIdList.forEach(function(i) {
            // $('#patient_id_list').append("<option>" + i + "</option>");
        // });
        $('#patient_id').autocomplete({source: response.patientIdList});
    }, 'json');
}
