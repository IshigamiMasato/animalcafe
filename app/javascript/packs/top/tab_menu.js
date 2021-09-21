$(function() {
  $(".tab_content div").hide();
  $(".tab_content div").first().show();
  $('.tab_btns span').on("click", function() {
    const thisClass = $(this).attr('class');
    const newClass = `lamp_${thisClass}`;
    $('#lamp').removeClass().addClass(newClass);
    $(".tab_content div").each(function() {
      if($(this).hasClass(thisClass)) {
        $(this).fadeIn();
      } else {
        $(this).hide();
      }
    });
  });
});
