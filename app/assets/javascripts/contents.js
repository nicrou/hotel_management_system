var contents = {
  initControls: function(){
    if ($(".selectpicker").hasClass("applied") == false) {
      $(".selectpicker").selectpicker();
      $(".selectpicker").addClass("applied");
    }

    if ($(".content-wysihtml5").hasClass("applied") == false) {
      $(".content-wysihtml5").wysihtml5({
        toolbar:{
          "fa": true,
          "color": true,
          "html": true,
          "smallmodals": false
         }
      });
      $(".content-wysihtml5").addClass("applied");
    }
  },
}
