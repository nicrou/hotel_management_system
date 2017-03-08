var invoices = {
  initWidgets: function(){
    initCheckbox($('.swal2-content .js-invoice-is-paid'));
    
    if ($(".swal2-content .js-bootstrap-table").hasClass("applied") == false) {
      $(".swal2-content .js-bootstrap-table").bootstrapTable();
      //if ($(window).width() <= 680) {
      //  $(".panel .js-bootstrap-table").bootstrapTable('toggleView');
      //}
      $(".swal2-content .js-bootstrap-table").bootstrapTable('toggleView');
      $(".swal2-content .js-bootstrap-table").addClass("applied");
    }
  }
}
