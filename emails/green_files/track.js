(function(a,e,f){var h=null,g;a.WebVersion={setup:function(a){g=a.LikeActionBase;f.Event.subscribe("xfbml.render",function(){e("#facebox iframe").css("height","80px")});e(document).bind("reveal.facebox",function(){f.XFBML.parse()});f.Event.subscribe("edge.create",function(){e.ajax({url:h,cache:!1})});e('a[rel="cs_facebox"]').each(function(){var a=e(this),f=a.attr("href").replace(/http:\/\/[^\/]*/g,"");a.attr("href",f+"?act=wv");a.facebox();a.attr("cs_likeurl",f+"?act=like");a.click(function(){h=e(this).attr("cs_likeurl");
return!1})});a=/#f([a-z]+)$/.exec(window.location);a!==null&&(a=e('a[href*="'+g+a[1]+'"]:first'),a.length===0&&(a=e("a[href*="+g+"]:first")),a.click())}}})(window.CS=window.CS||{},jQuery,FB);(function(a){function e(b){if(a.facebox.settings.inited)return!0;else a.facebox.settings.inited=!0;a(document).trigger("init.facebox");g();var c=a.facebox.settings.imageTypes.join("|");a.facebox.settings.imageTypesRegexp=RegExp(".("+c+")$","i");b&&a.extend(a.facebox.settings,b);a("body").append(a.facebox.settings.faceboxHtml);var d=[new Image,new Image];d[0].src=a.facebox.settings.closeImage;d[1].src=a.facebox.settings.loadingImage;a("#facebox").find(".b:first, .bl").each(function(){d.push(new Image);
d.slice(-1).src=a(this).css("background-image").replace(/url\((.+)\)/,"$1")});a("#facebox .close").click(a.facebox.close)}function f(){var a,c;if(self.pageYOffset)c=self.pageYOffset,a=self.pageXOffset;else if(document.documentElement&&document.documentElement.scrollTop)c=document.documentElement.scrollTop,a=document.documentElement.scrollLeft;else if(document.body)c=document.body.scrollTop,a=document.body.scrollLeft;return[a,c]}function h(){var a;if(self.innerHeight)a=self.innerHeight;else if(document.documentElement&&
document.documentElement.clientHeight)a=document.documentElement.clientHeight;else if(document.body)a=document.body.clientHeight;return a}function g(){var b=a.facebox.settings;b.loadingImage=b.loading_image||b.loadingImage;b.closeImage=b.close_image||b.closeImage;b.imageTypes=b.image_types||b.imageTypes;b.faceboxHtml=b.facebox_html||b.faceboxHtml}function i(b,c){if(b.match(/#/)){var d=window.location.href.split("#")[0],d=b.replace(d,"");d!="#"&&a.facebox.reveal(a(d).html(),c)}else b.match(a.facebox.settings.imageTypesRegexp)?
j(b,c):k(b,c)}function j(b,c){var d=new Image;d.onload=function(){a.facebox.reveal('<div class="image"><img src="'+d.src+'" /></div>',c)};d.src=b}function k(b,c){a.get(b,function(b){a.facebox.reveal(b,c)})}function l(){return a.facebox.settings.overlay==!1||a.facebox.settings.opacity===null}function m(){if(!l())return a("#facebox_overlay").length==0&&a("body").append('<div id="facebox_overlay" class="facebox_hide"></div>'),a("#facebox_overlay").hide().addClass("facebox_overlayBG").css("opacity",a.facebox.settings.opacity).click(function(){a(document).trigger("close.facebox")}).fadeIn(200),
!1}function n(){if(!l())return a("#facebox_overlay").fadeOut(200,function(){a("#facebox_overlay").removeClass("facebox_overlayBG");a("#facebox_overlay").addClass("facebox_hide");a("#facebox_overlay").remove()}),!1}a.facebox=function(b,c){a.facebox.loading();b.ajax?k(b.ajax,c):b.image?j(b.image,c):b.div?i(b.div,c):a.isFunction(b)?b.call(a):a.facebox.reveal(b,c)};a.extend(a.facebox,{settings:{opacity:0.2,overlay:!0,loadingImage:"/facebox/loading.gif",closeImage:"/facebox/closelabel.png",imageTypes:["png",
"jpg","jpeg","gif"],faceboxHtml:'    <div id="facebox" style="display:none;">       <div class="popup">         <div class="content">         </div>         <div id="closeBox">           <a href="#" class="close">Close</a>         </div>       </div>     </div>'},loading:function(){e();if(a("#facebox .loading").length==1)return!0;m();a("#facebox .content").empty();a("#facebox .body").children().hide().end().append('<div class="loading"></div>');a("#facebox").css({top:f()[1]+h()/10,left:a(window).width()/
2-205}).show();a(document).bind("keydown.facebox",function(b){b.keyCode==27&&a.facebox.close();return!0});a(document).trigger("loading.facebox")},reveal:function(b,c){a(document).trigger("beforeReveal.facebox");c&&a("#facebox .content").addClass(c);a("#facebox .content").append(b);a("#facebox .loading").remove();a("#facebox .body").children().fadeIn("normal");a("#facebox").css("left",a(window).width()/2-a("#facebox .popup").width()/2);a(document).trigger("reveal.facebox").trigger("afterReveal.facebox")},
close:function(){a(document).trigger("close.facebox");return!1}});a.fn.facebox=function(b){if(a(this).length!=0)return e(b),this.bind("click.facebox",function(){a.facebox.loading(!0);var b=this.rel.match(/facebox\[?\.(\w+)\]?/);b&&(b=b[1]);i(this.href,b);return!1})};a(document).bind("close.facebox",function(){a(document).unbind("keydown.facebox");a("#facebox").fadeOut(function(){a("#facebox .content").removeClass().addClass("content");a("#facebox .loading").remove();a(document).trigger("afterClose.facebox")});
n()})})(jQuery);