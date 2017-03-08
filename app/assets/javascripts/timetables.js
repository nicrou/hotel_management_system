function refresh(){
  $.ajax({
    type: "get",
    url: window.base_uri + "/timetables/index.js",
    data: {
      month: $(".js-month").val(),
      category: $(".js-selectpicker").val()
    }
  })
}

function initEvents(date) {
  var CurrentDate = new Date(date);

  $(function(){
    var controls = $(".js-selectpicker");
    controls.on('changed.bs.select', function (e) {
      refresh();
    });
  })

  $(function(){
    var controls = $(".js-previous");
    controls.on("click", function(){
      CurrentDate.setMonth(CurrentDate.getMonth() -1);
      $(".js-month").val(CurrentDate);
      refresh();
    })
  })

  $(function(){
    var controls = $(".js-next");
    controls.on("click", function(){
      CurrentDate.setMonth(CurrentDate.getMonth() +1);
      $(".js-month").val(CurrentDate);
      refresh();
    })
  })
}

/*function initSelect(){

  if ($(".js-selectpicker").attr("data-initialized") == 0) {
    if( /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) ) {
      $('.js-selectpicker').selectpicker('mobile');
    } else {
      $(".js-selectpicker").selectpicker();
    }
      $(".js-selectpicker").attr("data-initialized", 1);
  }
} */

function initTimetable() {
  $(function(){
    $(".timetable").each(function(){
      if ($(this).hasClass("applied") == false) {
        $(this).bootstrapTable();
        $(this).addClass("applied");
      }
    })

    $("td").has(".js-links").css("min-width", "100px");

    $('[data-toggle="tooltip"]').tooltip();
  })
}
