var bookings = {
  initControls: function (){
    // Monkey fix for back-forth cache issue on rebinding .js-datepicker. Removes leftover .datepicker-dropdown that may have been left open and cached.
    $(".datepicker-dropdown").remove();

    $('.js-datepicker').datepicker({
      format: "dd/mm/yyyy",
      startDate: '0d',
    	endDate: '+8m',
    	clearBtn: true
    });

    $(function(){
      $(".js-search").on("click", function(){
        $.ajax({
          type: "get",
          url: window.base_uri + "/bookings/result",
      		data: {
      			start_date: $(".js-start-date").val(),
      			end_date: $(".js-end-date").val()
      		}
      	})
      })
    })

    $(function(){
      $(".js-confirm-booking").on("click", function(){
        $("#new_invoice").submit();
      })
    })

    $(function(){
      var control = $('.js-datepicker.js-start-date');
      control.on('changeDate', function (e) {
        control.val(e.format(0, "dd MM yyyy"));
        bookings.validate();
      });
    })

    $(function(){
      var control = $('.js-datepicker.js-end-date');
      control.on('changeDate', function (e) {
        control.val(e.format(0, "dd MM yyyy"));
        bookings.validate();
      });
    })
    var today = moment();
    var tommorow = moment().add(1, 'days');
    $(".js-start-date").val(today.format('D MMMM YYYY'));
    $(".js-end-date").val(tommorow.format('D MMMM YYYY'));
  },

  validate: function (){
    var start = new Date($(".js-start-date").val());
    var end = new Date($(".js-end-date").val());

    if (+end == +start){ // Since two objects are never equal to each other coercing them to number does the trick.
      end.setDate(end.getDate() + 1);
      $('.js-datepicker.js-end-date').datepicker('setDate', end);
    }

    if (end < start){
      $('.js-datepicker.js-start-date').datepicker('setDate', end);
      $('.js-datepicker.js-end-date').datepicker('setDate', start);
    }
  },

  initFormControls: function(){
    $('.js-datepicker').datepicker({
      format: "dd/mm/yyyy",
      startDate: '0d',
    	endDate: '+8m',
    	clearBtn: true
    });

    $("button.swal2-confirm").click(function(event){
      $(".swal2-content form").submit();
    })
  },

  initDeckControls: function(){
    $('.js-selectpicker').selectpicker();
    $(':checkbox').checkboxpicker();
    $(':checkbox').checkboxpicker().change(function() {
      var thumbnail = $(this).closest(".js-thumbnail");
      if ($(this).is(':checked')){
        thumbnail.removeClass("alert-warning");
        thumbnail.find(".js-thumbnail-items").removeClass("alert-warning");
        thumbnail.find(".tag").removeClass("alert-warning");
        thumbnail.addClass("alert-info");
        thumbnail.find(".js-thumbnail-items").addClass("alert-info");
        thumbnail.find(".tag").addClass("alert-info");
      }
      else {
        thumbnail.removeClass("alert-info");
        thumbnail.find(".js-thumbnail-items").removeClass("alert-info");
        thumbnail.find(".tag").removeClass("alert-info");
        thumbnail.addClass("alert-warning");
        thumbnail.find(".js-thumbnail-items").addClass("alert-warning");
        thumbnail.find(".tag").addClass("alert-warning");
      }
    });

    $('.js-thumbnail-description').matchHeight();
    $('.js-thumbnail-subtitle').matchHeight();
    $('.js-thumbnail-items').matchHeight();
  }
}
