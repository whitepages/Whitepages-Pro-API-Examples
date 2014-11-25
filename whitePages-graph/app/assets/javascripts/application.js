// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function() {
    $('#clear_phone_btn').live( "click", function() {
        $("input#api_key").val("");
        $("input#phone_number").val("");
    });

    $('#clear_address_btn').live( "click", function() {
        $("input#api_key").val("");
        $("input#address_street_line_1").val("");
        $("input#address_city").val("");
    });

    $('#clear_person_btn').live( "click", function() {
        $("input#api_key").val("");
        $("input#person_first_name").val("");
        $("input#person_last_name").val("");
        $("input#person_where").val("");
    });


    $('#clear_business_btn').live( "click", function() {
        $("input#api_key").val("");
        $("input#business_name").val("");
        $("input#city").val("");
        $("input#state").val("");
    });

    // When the back button triggers
    $(window).on("popstate", function() {
        var req_url = location.href;
        if (req_url.indexOf("#") > -1) {
            var url = req_url.split('#')[1];
            var req_url = url;
            var req_action = searchLink;
            if (url.indexOf("&type=") > -1) {
                var search_type = url.split('&type=');
                req_url = search_type[0];
                req_action = searchForm;
            }
            $("#overlay").show();
            $.post(req_action,{ url: req_url} ,function(result){ });
        }else{
            window.location =  location.href;
        }
    });

    $(".tab-menu li").click(function(e){
        $("div#search_form").hide();
    });

});