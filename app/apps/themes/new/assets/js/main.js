//= require jquery
//= require camaleon_cms/bootstrap.min
//= require jquery.flexslider-min
//= require magnific-popup
//= require datepicker
//= require jquery.mmenu.all

$.extend({
  replaceTag: function (currentElem, newTagObj, keepProps) {
    var $currentElem = $(currentElem);
    var i, $newTag = $(newTagObj).clone();
    if (keepProps) {
      newTag = $newTag[0];
      newTag.className = currentElem.className;
      $.extend(newTag.classList, currentElem.classList);
      $.extend(newTag.attributes, currentElem.attributes);
    }
    $currentElem.wrapAll($newTag);
    $currentElem.contents().unwrap();
    return this;
  }
});
$.fn.extend({
  replaceTag: function (newTagObj, keepProps) {
    return this.each(function() {
      jQuery.replaceTag(this, newTagObj, keepProps);
    });
  }
});
(function ($) {
  $(document).ready(function () {
    $('.bvi-panel-open').bvi('Init');

    if ($(window).width() < 1200) {
      $('.container').removeClass('container').addClass('container-fluid');
    }
    else {
      $('.container-fluid').removeClass('container-fluid').addClass('container');
    }
    if ($(window).width() < 768) {
      $('td').attr('width', '');
    }
    $(window).resize(function() {
      if ($(window).width() < 1200) {
        $('.container').removeClass('container').addClass('container-fluid');
      }
      else {
        $('.container-fluid').removeClass('container-fluid').addClass('container');
      }
    });

    $('#carousel-header .carousel-inner .item:first-of-type').addClass("active");
    $('#carousel-posts .carousel-inner .item:first-of-type').addClass("active");
    $('#carousel-budget .carousel-inner .item:first-of-type').addClass("active");
    $('#carousel-post .carousel-inner .item:first-of-type').addClass("active");
    $('#carousel-sec-post .carousel-inner .item:first-of-type').addClass("active");
    $('.vc_tta-container .vc_tta-tabs-list li:first-of-type').addClass("active");
    $('.cstmn-flex-tab-row .vc_tta-tabs-list li:first-of-type').addClass("active");
    $('.cstmn-flex-tab-row .tab-content .tab-pane:first-of-type').addClass("in active");

    var imgArray = $(".td-slider .td-slide-item img").map(function() {
      return $(this).attr("src");
    }).get();

    $('.td-slide-item').each(function(x) {
      $(this).replaceTag("<li data-thumb=" + imgArray[x] +">", true);
    });

    $('.td-doubleSlider-1').replaceTag('<div class="flexslider">', false);
    $('.td-slider').replaceTag('<ul class="slides">', false);

    var imgArraySec = $(".wpb_gallery_slides .slides li img").map(function() {
      return $(this).attr("src");
    }).get();

    $('.wpb_gallery_slides .slides li').each(function(x) {
      $(this).replaceTag("<li data-thumb=" + imgArraySec[x] +">", true);
    });

    $('.wpb_gallery_slides').replaceTag('<div class="flexslider">', false);

    $('.flexslider').flexslider({
      animation: "slide",
      controlNav: "thumbnails",
    });

    $('.vc_toggle_title').click(function() {
      $(this).parent().find('.vc_toggle_content').toggle();
      $(this).parent().siblings().find('.vc_toggle_content').hide();
    });
    
    elem.addEventListener('touchstart', fn,
    detectIt.passiveEvents ? {passive:true} : false);

    $(".post-content a.href-to-block").click(function(event){
      var full_url = $(this).data('scroll');
      var parts = full_url.split("#");
      var trgt = parts[1];

      var target_offset = $("#" + trgt).offset();
      var target_top = target_offset.top;

      if (trgt) {
        event.preventDefault();
      }

      $('html, body').animate({scrollTop: target_top}, 800);
    });

    $('.my-special-container .tab-pane.fade-title').click(function() {
      $(this).parent().parent().find('.fade-body').toggle();
      $(this).parent().parent().siblings().find('.fade-body').hide();
    });

    var hash = window.location.hash;
    hash && $('ul.vc_tta-tabs-list a[href="' + hash + '"]').tab('show');

    $('ul.vc_tta-tabs-list a').click(function (e) {
      window.location.hash = this.hash;
    });

    var btn = $('#scroll-up-btn');
    btn.hide();
    $(window).scroll(function() {
      if ($(window).scrollTop() > 300) {
        btn.show();
      } else {
        btn.hide();
      }
    });

    btn.on('click', function(e) {
      e.preventDefault();
      $('html, body').animate({scrollTop:0}, '300');
    });
    
    $('.popup-link').magnificPopup({
      type: 'image',
      cimage: {
        verticalFit: true
      },
      gallery: {
        enabled: true
      }
    });
    
    $('.popup-link_a4').magnificPopup({
      type: 'image',
      cimage: {
        verticalFit: true
      },
      gallery: {
        enabled: true
      }
    });

    var monthList = ['Січ', 'Лют', 'Бер', 'Кві', 'Тра', 'Чер', 'Лип', 'Сер', 'Вер', 'Жов', 'Лис', 'Гру'];
    var monthListFull = ['Січень', 'Лютий', 'Березень', 'Квітень', 'Травень', 'Червень', 'Липень', 'Серпень', 'Вересень', 'Жовтень', 'Листопад', 'Грудень'];
    var daysList = ['Нд', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'];

    $('.posts-archive-datepick').datepicker({
      weekStart: 1,
      format: 'DD/MM/YYYY',
      monthsShort: monthList,
      months:  monthListFull,
      daysMin: daysList
    });

    $('.docs-datepicker').datepicker({
      weekStart: 1,
      format: 'DD/MM/YYYY',
      monthsShort: monthList,
      months:  monthListFull,
      daysMin: daysList
    });
    $(function(){
      var coverflow = $("#coverflow").flipster({
          // Container for the flippin' items.
  itemContainer:    'ul', 

  // Selector for children of itemContainer to flip
  itemSelector:     'li', 

  // 'coverflow' or 'carousel' or 'flat' or 'wheel'
  style:'flat', 

  // Starting item. Set to 0 to start at the first, 'center' to start in the middle or the index of the item you want to start with.
  start:'center', 

  // Fading speed
  fadeIn: 4000,

  // Infinite loop
  loop: false,

  // Enable autoplay
  autoplay: false,

  // Enable pause on hover
  pauseOnHover: true,

  // Space between items
  spacing: -0.25,

  // Switch between items with click
  click: true,

  // Enable left/right arrow navigation
  keyboard:   true, 

  // Enable scrollwheel navigation (up = left, down = right)
  scrollwheel: true, 

  // Enable swipe navigation for touch devices
  touch:      true, 

  // If true, flipster will insert an unordered list of the slides
  nav:        false, 

  // If true, flipster will insert Previous / Next buttons
  buttons: true, 

  // Changes the text for the Previous button
  buttonPrev:         'Previous',       

  // Changes the text for the Next button
  buttonNext:         'next'

  // Callback function when items are switches
   });
    });
    $('form.railscf-form').submit(function() {
      if(typeof jQuery.data(this, "disabledOnSubmit") == 'undefined') {
        jQuery.data(this, "disabledOnSubmit", { submited: true });
        $('input[type=submit], input[type=button]', this).each(function() {
          $(this).attr("disabled", "disabled");
        });
        return true;
      }
      else
      {
        return false;
      }
    });
  });
}(window.jQuery || window.$));

