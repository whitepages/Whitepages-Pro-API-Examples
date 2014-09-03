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





//    var activeTabIndex = -1;
//    var tabNames = ["fnumber","faddress","fperson", "fbusiness"];
//
//    $(".tab-menu > li").click(function(e){
//        for(var i=0;i<tabNames.length;i++) {
//            if(e.target.id == tabNames[i]) {
//                activeTabIndex = i;
//            } else {
//                $("#"+tabNames[i]).removeClass("active");
//                $("#"+tabNames[i]+"-tab").css("display", "none");
//            }
//        }
//        $("#"+tabNames[activeTabIndex]+"-tab").fadeIn();
//        $("#"+tabNames[activeTabIndex]).addClass("active");
//        //return false;
//    });






    $(document).on('click','svg a',function(){

        var req_url = $(this).attr('xlink:href');
        req_url =  req_url.substring(1);
        if (req_url != "#"){
            $("#overlay").show();

            var phone_number =  $("#phone_number").val();
            $.post(graphSearch,{ url: req_url,phone:phone_number} ,function(result){
                // $("#svgload").html(result);
            });

        }

    });


    $(".tab-menu li").click(function(e){
        $("div#search_form").hide();
    });

    $(".find_btn").live( "click", function() {
        $("#overlay").show();
    });



});
