var browserHeight = '';
var midpoint = '';
var quarterpoint = '';
var currentItem = '';
var padding = '';
var previousHeight = '';
var prevItem = '';
var numPosts = '';
thisHeight = new Array();
prevHeight = new Array();
var prevFocus = '';
var heightText = '';
var logger = '';
var postOrder = new Array();
var scrollPosition = $('#window').scrollTop();
var http = false;

http = (navigator.appName == "Microsoft Internet Explorer") ? http = new
 ActiveXObject("Microsoft.XMLHTTP") : http = new XMLHttpRequest(); 

function resetParams() {
   browserHeight = window.innerHeight; // 600
   midpoint = browserHeight / 2; // 300
   quarterpoint = (midpoint / 2) + midpoint // 450
   currentItem = 0;
   padding = 5;
   previousHeight = 1; 
   prevItem = 0;
   numPosts = 10;
   thisHeight = [];
   prevHeight = [];
   prevFocus = 0;
   heightText = '';
   logger = 0;
   postOrder = [];
   scrollPosition = $('#window').scrollTop(); // 0
}

function log(action, object) {
  //var url = "ajax.html?action=" + escape(action) + "&amp;object=" + escape(object);
  //http.open("GET", url, true);
  //http.onreadystatechange=function() {
    //if(http.readyState == 4) { window.location=url; }
    //}
    //http.send(null);
}

function ajax(action, object) {
  var url = "ajax.html?action=" + escape(action) + 
    "&amp;object=" + escape(object);
  http.open("GET", url, true);
  http.onreadystatechange=function() {
    if(http.readyState == 4) {
      if (http.responseText == "Refresh") {
        window.location.reload();
      }
    }
  }
  http.send(null);
}

function animateScroll(where) {
   if ($('#c' + where).offset() != null) {
     $('#window').animate({
       scrollTop: $('#c' + where).offset().top
     }, 2000);
   }
   else {
     var url = "ajax.html?action=" + escape('get post ID from comment ID') + 
       "&amp;object=" + escape(where);
     http.open("GET", url, true);
     http.onreadystatechange=function() {
       if(http.readyState == 4) {
         window.location = 'index.html?post_id=' + http.responseText;
       }
     }
     http.send(null);
   }
}

function getHeights() {
   var total = 0;
   for (var i=0; i &lt; numPosts; i++) {
      total = total + itemHeight(i);
      thisHeight[i] = itemHeight(i);
      prevHeight[i] = total - itemHeight(i);
   }
}

function itemHeight(div) {
   return $('#' + postOrder[div]).outerHeight(); // 100 + 5
}

function whereFocus(scroll) {
   var total = 0;
      for (var i=0; i &lt; numPosts; i++) {
         if (prevHeight[i] &lt; (scroll + browserHeight/4) &amp;&amp; 
prevHeight[i+1] &gt;= (scroll + browserHeight/4)) {
            prevItem = currentItem;
            focusCurrentItem(i);
         }
      }
}

function evalScroll() {
   newPosition = $('#window').scrollTop(); // 15
   prevNum = currentItem - 1;
   whereFocus(newPosition); 
}

function focusCurrentItem(num) {
   $('.post').removeClass('shadow');
   $('#' + postOrder[num]).addClass('shadow');
   if (currentItem != num) {
      log('focus', $('#' + postOrder[num]).attr('id') );
   }
   currentItem = num;
}

function postComment(post_id) {
   var commentText = $('#comment-text-' + post_id).val();
   var url = "ajax.html?action=postComment&amp;post_id=" + post_id + 
"&amp;text=" + escape(commentText);
   http.open("GET", url, true);
   http.onreadystatechange=function() {
     if(http.readyState == 4) {
        var newText = commentText.replace("\n\n", "<br><br>");
        newText = newText.replace("\n", "<br>");
        $('#comment-text-' + post_id).before( '<div class="comment-box" id="c'" +="" http.responsetext="" '=""><div style="float:right; width:100px; z-index:7; margin-right:-10px; margin-top:-10px"><object data="scripts2_files/mugshot.svg" type="image/svg+xml"><h3></h3><br>' + newText + '' );
        $('#comment-text-' + post_id).val('');
     }
   }
   http.send(null);   
}

placeholderID = new Array();
function placeholder(item) {
   if (placeholderID[item] != 1) {
      item.value = '';
      item.style.color = '#000';
      placeholderID[item] = 1;
   }
}

function checkEnter(e) {
 $('#q').keydown(function(e) {
   e = e || event;
   if(e.keyCode==13){
      window.location = 'index.html?q=' + escape($('#q').val());
   }
 });
}

function cooptSpacebar() {
 document.onkeydown=function(e){
   e = e || event;
   if(e.keyCode==74){
      if (currentItem &lt; numPosts-1) { 
         currentItem++;
         focusCurrentItem(currentItem);
         $('#window').scrollTop(prevHeight[currentItem] - 100);
      }
      return false;
   }
   if(e.keyCode==75){
      if (currentItem &gt; 0) { 
         currentItem--;
         focusCurrentItem(currentItem);
         $('#window').scrollTop(prevHeight[currentItem] - 100);
      }
      return false;
   }   
   if(e.keyCode==33) {
      // Page up
      var h = $('#window').outerHeight();
      var currentScrollPosition = $('#window').scrollTop();
      var newScrollPosition = currentScrollPosition - h;
      $('#window').scrollTop(newScrollPosition);
      return false;
   }
   if(e.keyCode==34 || e.keyCode==32) {
      // Page down
      var h = $('#window').outerHeight();
      var currentScrollPosition = $('#window').scrollTop();
      var newScrollPosition = currentScrollPosition + h;
      $('#window').scrollTop(newScrollPosition);
      return false;
   }
   if(e.keyCode==38) {
      // Up arrow
      var currentScrollPosition = $('#window').scrollTop();
      var newScrollPosition = currentScrollPosition - 15;
      $('#window').scrollTop(newScrollPosition);
      return false;
   }
   if(e.keyCode==40) {
      // Down arrow
      var currentScrollPosition = $('#window').scrollTop();
      var newScrollPosition = currentScrollPosition + 15;
      $('#window').scrollTop(newScrollPosition);
      return false;
   }


 };
}

function releaseSpacebar() {
 document.onkeydown=function(e) {
   if(e.keyCode==33) {
      // Page up
      var h = $('#window').outerHeight();
      var currentScrollPosition = $('#window').scrollTop();
      var newScrollPosition = currentScrollPosition - h;
      $('#window').scrollTop(newScrollPosition);
      return false;
   }
   if(e.keyCode==34) {
      // Page down
      var h = $('#window').outerHeight();
      var currentScrollPosition = $('#window').scrollTop();
      var newScrollPosition = currentScrollPosition + h;
      $('#window').scrollTop(newScrollPosition);
      return false;
   }
 }
}

$(document).ready(function() {
  resetParams();
  log('load');
  cooptSpacebar();
  $('textarea, input').each( function() {
     $(this).focus(releaseSpacebar );
     $(this).blur(cooptSpacebar );
  });

  if (post_id == '') {
     postListeners();
  }
  
  $('a').each(function() {
     $(this).bind('click', function() {
        log('click', $(this).attr('href'));
     });
  });

});

function postListeners() {
  $('.post').each(
    function(intIndex){
      postOrder[intIndex] = $(this).attr('id');
    }
  );
  $('#window').scroll(evalScroll);
  getHeights();
  log('focus', $('#' + postOrder[0]).attr('id') );
  $('#' + postOrder[0]).addClass('shadow');
}

if (window.attachEvent) {
  window.attachEvent('unload', function() { log('unload'); }, true);
}
else {
  window.addEventListener('unload', function() { log('unload'); }, true);
}
