var components = {
  initButtons: function(){
    $(".js-bootstrap-table-toolbar").on("click", "button", function(){
      var title = $(this).attr("data-title");
      swal({
        title: title,
        input: 'text',
        showCloseButton: true,
        preConfirm: function () {
          return new Promise(function () {
            var link = $('.swal2-input').val();
            $.ajax({
              type: "post",
              url: window.base_uri + "/components",
              data: { component:
                {
                  title: title,
                  is_social_link: true,
                  is_editable: false, content: $('.swal2-input').val()
                }
              },
              success: function(data){
                swal("Completed", $('.swal2-input').val() + " module created successfully.", "success");
                indexRefresh();
              },
              error: function(data){
                swal("Error", $('.swal2-input').val() + " an error occured.", "error");
              }
            })
          })
        }
      })
    })
  }
}
