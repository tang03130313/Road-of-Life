window.addEventListener('load', function () {
    // $('#oddsRatioItemTitle').hide();
    // $('#oddsRatioSlider').hide();

    // $('.orSlider').slider({
    //     max: OR_SLIDER_MAX_VALUE,
    //     value: OR_SLIDER_VALUE,
    //     change: orSliderOnChange
    // });

    // var handle = $("#custom-handle");
    // $("#oddsRatioSlider").slider({
    //   create: function() {
    //     handle.text("OR " + $(this).slider("value"));
    //   },
    //   slide: function(event, ui) {
    //     handle.text("OR " + (ui.value + 4));
    //   }
    // });
    // handle.text("OR " + 6);

    // $('#keyPathwayBtn').mouseover(function() {
    //     var pop1 = $('.pop1');
    //     pop1.show();
    // });
    // $('#keyPathwayBtn').mouseout(function() {
    //     var pop1 = $('.pop1');
    //     pop1.hide();
    // });

    // $('#riskFactorBtn').click(function(){riskFactorBtnClick();});
    $('#keyPathwayBtn').click(function(){keyPathwayBtnClick();});
    $('#patient_id').keyup(function(){patientIdSearchChange();});
    $('#target_disease').click(function(){dynaOr();});
});
