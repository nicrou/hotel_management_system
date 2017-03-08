$(document).on('turbolinks:load', function () {
  $("a.fancybox").each(function(){
    if ($(this).hasClass("applied") == false) {
      $(this).fancybox();
      $(this).addClass("applied");
    }
  })
})

var files = {
  initControls: function(){
    $("a.fancy-image").click(function(e){
      e.preventDefault();
      swal({
        showCloseButton: true,
        imageUrl: window.base_uri + $(this).attr('href'),
      })
    });

    $('button.add-new-directory').click(function(){

      var file_location = $('input.js-dir-location').attr('value');

      swal({
        title: 'Create',
        input: 'text',
        showCloseButton: true,
        preConfirm: function () {
          return new Promise(function () {
            var file_new = $('.swal2-input').val();
            $.ajax({
              type: "get",
              url: window.base_uri + "/files/create",
              data: { file_location: file_location, file_new: file_new },
              success: function(data){
                swal("Completed", $('.swal2-input').val() + " created successfully.", "success");
              }
            })
          })
        }
      })
    })

    $('a.rename-file').click(function(){
      var file_orig = $(this).data("file-name");
      var file_location = $('input.js-dir-location').attr('value');

      swal({
        title: 'Update',
        input: 'text',
        inputValue: file_orig,
        showCloseButton: true,
        preConfirm: function () {
          return new Promise(function () {
            var file_new = $('.swal2-input').val();
            $.ajax({
              type: "get",
              url: window.base_uri + "/files/update",
              data: { file_location: file_location, file_orig : file_orig, file_new: file_new },
              success: function(data){
                swal("Completed!", file_orig + " updated successfully to " + $('.swal2-input').val(), "success");
              }
            })
          })
        }
      })
    })
  },
  initDropzone: function(){
    Dropzone.autoDiscover = false;
    var AUTH_TOKEN = $('meta[name="csrf-token"]').attr('content');

    var dropzone = new Dropzone("div#dropzone", {
        url: window.base_uri + "/files/upload",
        autoProcessQueue: true,
        uploadMultiple: true,
        addRemoveLinks: true,
        dictCancelUpload: true,
        //acceptedFiles: "image/jpg, image/png, image/bmp, image/svg",
        parallelUploads: 5,
        maxFiles: 20,
        maxFilesize: 512,
        params:{
          'authenticity_token':  AUTH_TOKEN,
          'file_location': $('.js-dir-location input').attr('value')
        },
        successmultiple: function(data, response){
          $('#msgBoard').html(response.message).addClass("alert alert-success");
          $('#msgBoard').delay(3000).fadeOut();
          files.loadThumbnails('.dz-preview');

          $.ajax({ type: "get", url: window.base_uri + "/files/show", data: { 'file_location': $('input.js-dir-location').attr('value') } })
        },
    })

    dropzone.on("addedfile", function(file) {
      dropzone.options.params.file_location = $('input.js-dir-location').attr('value');
    });

    $("button.clear-all").click(function(){
      dropzone.removeAllFiles(true);
    })

    $("button.clear-completed").click(function(){
      dropzone.removeAllFiles()
    })
  },
  loadThumbnails: function(class_name) {
    $(class_name).each(function(){
      var name = $(this).find('div[class*="filename"]>span').html();

      var name_array = name.split('.');
      if (name_array.length > 1) {
        var ext = name_array.pop();
        if (ext == "png" || ext == "jpg" || ext == "jpeg" || ext == "tiff" || ext == "bmp" || ext == "svg") {
          $(this).find('img').addClass('img-frame');
        }
        else {
          var src = "/assets/icons/file_management/" + ext + ".ico";
          $(this).find("img").attr("src", src);
        }
      }
      else {
        var src = "/assets/icons/file_management/" + "live_back" + ".ico";
        $(this).find("img").attr("src", src);
      }
    })
  }
}
