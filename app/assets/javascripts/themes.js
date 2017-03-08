var themes = {
  initIndex: function(){
    $(".js-thumbnail").addClass("animated");
    $(".js-thumbnail").hover(
      function(){
        var pickers = $(this).find(".pick-a-color-markup");
        var active = $(this).hasClass("active");
        if (pickers.length == 0 && active == false){
          $(this).removeClass('flip');
          $(this).addClass('pulse');
        }
      },
      function(){
        $(this).removeClass('pulse');
      }
    )
    $(".js-thumbnail").on("click", function(){
      var active = $(this).hasClass("active");
      if (active == false){
        $(".js-thumbnail").removeClass("active");
        $(this).removeClass('pulse');
        $(this).addClass('flip');
        $(this).addClass("active");
      }
      else {
        $(this).removeClass('flip');
        $(this).addClass('pulse');
      }
    })
    $('.js-new').click(function(e){
      swal({
        title: 'Create',
        input: 'text',
        showCloseButton: true,
        preConfirm: function () {
          return new Promise(function () {
            var title = $('.swal2-input').val();
            $.ajax({
              type: "post",
              url: window.base_uri + "/themes",
              data: { title: title },
              success: function(data){
                swal("Completed", $('.swal2-input').val() + " created successfully.", "success");
              }
            })
          })
        }
      })
    })
    $('a.js-update').click(function(){

      var thumbnail = $(this).siblings(".js-thumbnail");
      var id = $(this).data("id");
      if (thumbnail.hasClass("active")){
        var selected = 1;
      }
      $.ajax({
        type: "patch",
        url: window.base_uri + "/themes/"+ id,
        data: {
                navbar: thumbnail.find('.js-pick-a-color[data-color="1"]').first().val(),
                module: thumbnail.find('.js-pick-a-color[data-color="2"]').first().val(),
                footer: thumbnail.find('.js-pick-a-color[data-color="3"]').first().val(),
                content: thumbnail.find('.js-pick-a-color[data-color="4"]').first().val(),
                selected: selected
              },
        success: function(data){
          swal("Completed!", "Theme has been updated.", "success");
        }
      })
    })
    $('a.js-rename').click(function(){
      var id = $(this).data("id");
      var title_old = $(this).data("name");

      swal({
        title: 'Rename',
        input: 'text',
        inputValue: title_old,
        showCloseButton: true,
        preConfirm: function () {
          return new Promise(function () {
            var title = $('.swal2-input').val();
            $.ajax({
              type: "patch",
              url: window.base_uri + "/themes/"+ id,
              data: { title: title },
              success: function(data){
                swal("Completed!", title_old + " updated successfully to " + $('.swal2-input').val(), "success");
              }
            })
          })
        }
      })
    })
    $(".js-edit").on("click", function(){
      var theme = $(this).siblings(".js-thumbnail");
      var inputs = theme.find(".js-pick-a-color");
      $(theme).removeClass("animated pulse flip");
      inputs.each(function(){
        if ($(this).hasClass("applied") == false) {
          $(this).pickAColor();
          $(this).addClass("applied");

          $(this).on("change", function () {
            $(this).closest(".js-part").css("background-color", "#" + $(this).val());
            $(this).val("#" + $(this).val())
          });
        }
        else {
          $(theme).addClass("animated");
          $(this).closest(".js-part").html('<input type="text" data-color="1" class="js-pick-a-color hidden">');
        }
      })
      themes.initColor(theme);
    })
  },
  initColor: function(thumbnail){
    var parts = thumbnail.find(".js-part");
    parts.each(function(){
      var input = $(this).find(".js-pick-a-color");
      var rgb = $(this).css("background-color");

      $(this).find(".color-preview.current-color").css("background-color", rgb);
    })
  }
}
