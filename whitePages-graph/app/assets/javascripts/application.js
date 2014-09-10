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
    // When the back button triggers
    $(window).on("popstate", function() {
        var req_url = location.href;
        if (req_url.indexOf("#") > -1) {
            var url =   req_url.split('#')[1];
            $("#overlay").show();
            $.post(graphSearch,{ url: url} ,function(result){ });
        }else{
            window.location =  location.href;
        }
    });

    $(".tab-menu li").click(function(e){
        $("div#search_form").hide();
    });

});
