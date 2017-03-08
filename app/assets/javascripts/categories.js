var categories = {
  initDropzone: function(request, title){
    Dropzone.autoDiscover = false;
    var AUTH_TOKEN = $('meta[name="csrf-token"]').attr('content');

    var dropzone = new Dropzone("div#dropzone", {
        url: window.base_uri + request + "/upload",
        autoProcessQueue: false,
        uploadMultiple: false,
        addRemoveLinks: true,
        dictCancelUpload: true,
        parallelUploads: 1,
        maxFiles: 10,
        maxFilesize: 512,
        params: {
          'authenticity_token':  AUTH_TOKEN,
          'file_category': title
        },
        successmultiple: function(data, response){
          $('#msgBoard').html(response.message).addClass("alert alert-success");
          $('#msgBoard').delay(3000).fadeOut();
        },
      })

      $("button.clear-all").click(function(){
        dropzone.removeAllFiles(true);
      })

      $("button.clear-completed").click(function(){
        dropzone.removeAllFiles()
      })

      $("button.swal2-confirm").click(function(event){
        event.preventDefault();
        if(dropzone.getQueuedFiles().length > 0){
          dropzone.processQueue();
        }
      })
    },
    beautifyTags: function(){
      // Available rooms deck view.
      $(".thumbnail-items label.tag").addClass("alert-warning");
      // Categories show view [ administration panel ].
      $(".panel label.tag").addClass("alert-help");


      $("label.tag").each(function(){
        var tag = $(this).text();
        if (tag.match(/ *[Aa][Ii][Rr].[Cc][Oo][Nn][Dd][Ii][Tt][Ii][Oo][Nn][Ii][Nn][Gg]/g)){
          $(this).prepend('<i class="fa fa-snowflake-o"><i/>');
        }
        else if (tag.match(/ *[Ff][Ll][Aa][Tt].[Ss][Cc][Rr][Ee][Ee][Nn].[Tt][Vv]/g)){
          $(this).prepend('<i class="fa fa-television"><i/>')
        }
        else if (tag.match(/ *[Ss][Hh][Oo][Ww][Ee][Rr]/g)){
          $(this).prepend('<i class="fa fa-shower"><i/>')
        }
        else if (tag.match(/ *[Bb][Aa][Tt][Hh][Tt][Uu][Bb]/g)){
          $(this).prepend('<i class="fa fa-bath"><i/>')
        }
        else if (tag.match(/ *[Tt][Ee][Ll][Ee][Pp][Hh][Oo][Nn][Ee]/g)){
          $(this).prepend('<i class="fa fa-phone"><i/>')
        }
        else if (tag.match(/ *[Dd][Vv][Dd].[Pp][Ll][Aa][Yy][Ee][Rr]/g)){
          $(this).prepend('<i class="fa fa-dot-circle-o"><i/>')
        }
        else if (tag.match(/ *[Ww][Ii][Ff][Ii]/g)){
          $(this).prepend('<i class="fa fa-wifi"><i/>' )
        }
        else if (tag.match(/ *[Vv][Ii][Ee][Ww]/g)){
          $(this).prepend('<i class="fa fa-eye"><i/>')
        }
        else if (tag.match(/ *[Ff][Aa][Xx]/g)){
          $(this).prepend('<i class="fa fa-fax"><i/>')
        }
        else if (tag.match(/ *[Ww][Aa][Kk][Ee].[Uu][Pp].[Ss][Ee][Rr][Vv][Ii][Cc][Ee]/g)){
          $(this).prepend('<i class="fa fa-coffee"><i/>')
        }
        else {

        }
      })
    }
}
