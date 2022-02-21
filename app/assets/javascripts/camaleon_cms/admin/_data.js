function cama_get_tinymce_settings(settings){
  if(!settings) settings = {};
  var def = {
    selector: ".tinymce_textarea",
    theme: "modern",
    skin: "lightgray",
    plugins: "advlist autolink lists link image charmap print preview hr anchor pagebreak searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking save table directionality emoticons template paste textcolor colorpicker textpattern filemanager advcode codemagic",
    menubar: "edit insert view format table tools",
    image_advtab: true,
    statusbar: true,
    paste: true,
    toolbar_items_size: 'small',
    content_css: tinymce_global_settings["custom_css"].join(","),
    convert_urls: false,
    extended_valid_elements: 'i[*],div[*],p[*],li[*],a[*],ol[*],ul[*],span[*]',
    toolbar: "bold italic | alignleft aligncenter alignright alignjustify | fontselect fontsizeselect | bullist numlist | outdent indent | undo redo | link unlink image media | forecolor backcolor | styleselect customInsertSlider customInsertAccordion customInsertTabs customInsertTabs1 customInsertDocs customInsertNotes customInsertFrame codemagic "+tinymce_global_settings["custom_toolbar"].join(","),
    image_caption: true,
    language: CURRENT_LOCALE,
    relative_urls: false,
    paste_as_text: false,
    remove_script_host: false,
    browser_spellcheck : true,
    language_url: tinymce_global_settings["language_url"],
    content_css : "/assets/tinymce/custom_tiny_content.css",
    file_browser_callback: function(field_name, url, type, win) {
      $.fn.upload_filemanager({
        formats: type,
        selected: function(file, response){
          $('#' + field_name).val(file.url);
        }
      });
    },
    fix_list_elements: true,
    setup: function (editor) {
      editor.addButton('customInsertAccordion', {
        text: 'Спойлер',
        onclick: function () {
          editor.windowManager.open({
            title: 'Введіть заголовок',
            body: [
            {type: 'textbox', name: 'my_acc_txt', label: 'Заголовок'},
            ],
            onsubmit: function(e) {
              var randStr = Math.random().toString(36).substring(2);
              var tag = editor.dom.create('div');
              tag.innerHTML = `<p></p><div class="vc_toggle">
              <a class="vc_general vc_btn3 vc_btn3-size-md vc_btn3-shape-rounded vc_btn3-style-3d vc_btn3-block vc_btn3-color-green" data-toggle="collapse" data-target="#${randStr}">${e.data.my_acc_txt}</a>
              <div class="vc_toggle_content collapse" id="${randStr}" class="collapse">
              <p>Ввести текст!</p>
              </div>
              </div><p></p>`;
              var oferta = editor.dom.create('div');
              oferta.appendChild(tag);
              var divs = editor.dom.select('.vc_toggle');
              tinyMCE.execCommand('mceInsertContent', false, oferta.outerHTML);
              editor.selection.collapse(true);
            }
          })
        }
      }),
      editor.addButton('customInsertTabs1', {
        text: 'Верхні вкладки',
        onclick: function () {
          editor.windowManager.open({
            title: 'Введіть назву вкладки',
            body: [
            {type: 'textbox', name: 'my_tab_name', label: 'Назва'}
            ],
            onsubmit: function(e) {
              var randStr = Math.random().toString(36).substring(2);
              var randColor = "#"+((1<<24)*Math.random()|0).toString(16);
              var list_item = editor.dom.create('li', {style: `border-color: ${randColor}`});
              list_item.innerHTML = `<a class="href-to-block" href="#${randStr}">${e.data.my_tab_name}</a>`;
              var tab_item = editor.dom.create('div', {class: 'tabs__content tab-pane', id: randStr, style: `border-color: ${randColor}`});
              tab_item.innerHTML = `<p>Опис для "${e.data.my_tab_name}"</p>`;

              var tag = editor.dom.create('div', {class: "tabs"});
              tag.innerHTML = `<p></p>
              <ul class="tabs__caption">
              <li style="border-color: ${randColor}"><a class="href-to-block" href="#${randStr}">${e.data.my_tab_name}</a></li>
              </ul>
              </div>
              <div class="tabs__content active tab-pane" id="${randStr}" style="border-color: ${randColor}">
              <p>Опис для "${e.data.my_tab_name}"</p>
              </div>
              </div>
              </div>
              <p></p>`;
              var parent = editor.dom.create('div');
              parent.appendChild(tag);

              var list_items = editor.dom.select('.tabs__caption li');
              var content_tabs = editor.dom.select('.tab-pane');

              if (list_items && list_items.length > 0) {
                editor.dom.insertAfter(list_item, list_items[list_items.length - 1]);
                editor.dom.insertAfter(tab_item, content_tabs[content_tabs.length - 1]);
              } else {
                tinyMCE.execCommand('mceInsertContent', false, tag.outerHTML);
              }
              editor.selection.collapse(true);
            }
          })
        }
      }),
      editor.addButton('customInsertTabs', {
        text: 'Бокові вкладки',
        onclick: function () {
          editor.windowManager.open({
            title: 'Введіть назву вкладки',
            body: [
            {type: 'textbox', name: 'my_tab_name', label: 'Назва'}
            ],
            onsubmit: function(e) {
              var randStr = Math.random().toString(36).substring(2);
              var randColor = "#"+((1<<24)*Math.random()|0).toString(16);
              var list_item = editor.dom.create('li', {style: `border-color: ${randColor}`});
              list_item.innerHTML = `<a class="href-to-block" href="#${randStr}" data-scroll="#scroll-container" data-toggle="tab">${e.data.my_tab_name}</a>`;
              var tab_item = editor.dom.create('div', {class: 'tab-pane fade', id: randStr, style: `border-color: ${randColor}`});
              tab_item.innerHTML = `<p>Опис для "${e.data.my_tab_name}"</p>`;

              var tag = editor.dom.create('div', {class: "cstmn-flex-tab-row"});
              tag.innerHTML = `<p></p><div class="vc_tta-tabs vc_tta-tabs-position-left"><div class="vc_tta-tabs-container">
              <ul class="vc_tta-tabs-list">
              <li style="border-color: ${randColor}"><a class="href-to-block" href="#${randStr}" data-toggle="tab">${e.data.my_tab_name}</a></li>
              </ul>
              </div>

              <div class="tab-content-container">
              <div class="tab-content" id="scroll-container">
              <div class="tab-pane fade" id="${randStr}" style="border-color: ${randColor}">
              <p>Опис для "${e.data.my_tab_name}"</p>
              </div>
              </div>
              </div>
              </div>
              <p></p>`;
              var parent = editor.dom.create('div');
              parent.appendChild(tag);

              var list_items = editor.dom.select('.vc_tta-tabs-list li');
              var content_tabs = editor.dom.select('.tab-pane');

              if (list_items && list_items.length > 0) {
                editor.dom.insertAfter(list_item, list_items[list_items.length - 1]);
                editor.dom.insertAfter(tab_item, content_tabs[content_tabs.length - 1]);
              } else {
                tinyMCE.execCommand('mceInsertContent', false, tag.outerHTML);
              }
              editor.selection.collapse(true);
            }
          })
        }
      }),
      editor.addButton('customInsertDocs', {
        text: 'Документи',
        onClick: function () {
          editor.windowManager.open({
            title: 'Список документів',
            body: [
            {type: 'textbox', name: 'my_slider_docs', label: 'Список id через кому', id: 'my-slider-docs'},
            {type: 'textbox', name: 'my_slider_cats', label: 'Список категорій (id)', id: 'my-slider-cats'},
            {type: 'textbox', name: 'my_slider_tags', label: 'Список тегів (id)', id: 'my-slider-tags'}
            ],
            onsubmit: function(e) {
              var docs = e.data.my_slider_docs;
              var cats = e.data.my_slider_cats;
              var tags = e.data.my_slider_tags;
              editor.insertContent('<p>[rada_docs docs="' + docs + '" cats="' + cats + '" tags="' + tags + '"]</p>');
            }
          });
        }
      }),
      editor.addButton('customInsertFrame', {
        text: 'Фрейм',
        onClick: function () {
          editor.windowManager.open({
            title: 'Посилання',
            body: [
            {type: 'textbox', name: 'my_frame_url', label: 'Посилання'},
            ],
            onsubmit: function(e) {
              var url = e.data.my_frame_url;
              editor.insertContent('<iframe style="border: none; width: 100%; height: 1050px;" src=' + url + '></iframe>');
            }
          });
        }
      }),
      editor.addButton('customInsertNotes', {
        text: 'Записи',
        onClick: function () {
          editor.windowManager.open({
            title: 'Список записів',
            body: [
            {type: 'textbox', name: 'my_slider_notes', label: 'Список id через кому', id: 'my-slider-notes'},
            {type: 'textbox', name: 'my_slider_cats', label: 'Список категорій (id)', id: 'my-slider-cats'},
            {type: 'textbox', name: 'my_slider_tags', label: 'Список тегів (id)', id: 'my-slider-tags'}
            ],
            onsubmit: function(e) {
              var notes = e.data.my_slider_notes;
              var cats = e.data.my_slider_cats;
              var tags = e.data.my_slider_tags;
              editor.insertContent('<p>[rada_notes notes="' + notes + '" cats="' + cats + '" tags="' + tags + '"]</p>');
            }
          });
        }
      }),

      editor.on('blur', function () {
        tinymce.triggerSave();
        $('textarea#'+editor.id).trigger('change');
      });
      
      editor.on('PostProcess', function (ed) {
        ed.content = ed.content.replace(/(<p><\/p>)/gi,'<br />');
      });

      editor.addMenuItem('append_line', {
        text: 'New line at the end',
        context: 'insert',
        onclick: function () { editor.dom.add(editor.getBody(), 'p', {}, '-New line-');  }
      });
      editor.addMenuItem('add_line', {
        text: 'New line',
        context: 'insert',
        onclick: function () { editor.insertContent('<p>-New line-</p>');  }
      });

            // eval all extra setups
            for(var ff in tinymce_global_settings["setups"]) tinymce_global_settings["setups"][ff](editor);

              editor.on('postRender', function(e) {
                editor.settings.onPostRender(editor);
                // eval all extra setups
                for(var ff in tinymce_global_settings["post_render"]) tinymce_global_settings["post_render"][ff](editor);
              });

            editor.on('init', function(e) {
              for(var ff in tinymce_global_settings["init"]) tinymce_global_settings["init"][ff](editor);
            });
          },
          onPostRender: function(editor){}
        };
        for(var ff in tinymce_global_settings["settings"]) tinymce_global_settings["settings"][ff](settings, def);
          return $.extend({}, def, settings);
      }