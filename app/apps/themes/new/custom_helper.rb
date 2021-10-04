module Themes::New::CustomHelper
	def theme_custom_settings(theme)
		case params[:action_name]
		when "settings"
			render "themes/new/views/admin/settings"
		when "save_settings"
			theme.set_field_values(params[:field_options])
			flash[:notice] = "Settings saved!"
			redirect_to action: :settings, action_name: "settings"
		end
	end

	def theme_custom_on_install_theme(theme)
		pt = current_site.post_types.find_by(name: "Post")
		if pt
			pt.update(slug: "aparat", name: "Апарат МР")
		else
			pt = current_site.post_types.find_by(slug: "aparat")
		end
		pt.set_settings({has_category: true, has_tags: true, has_seo: false, has_summary: false, has_content: true, has_picture: true, has_template: false, has_keywords: false, has_comments: false})
		pt.add_field({"name" => "Посада", "slug" =>'aparat-posada'}, {"field_key" => "text_box"})
		pt.add_field({"name" => "Адреса", "slug" => 'aparat-adresa'}, {"field_key" => "text_box"})
		pt.add_field({"name" => "Email", "slug" => 'aparat-email'}, {"field_key" => "email"})
		pt.add_field({"name" => "Телефон", "slug" => 'aparat-telefon'}, {"field_key" => "phone"})
		pt.add_field({"name" => "Додатково", "slug" => 'aparat-dodatkovo'}, {"field_key" => "text_area"})
		pt.add_field({"name" => "Час прийому", "slug" => 'aparat-chas-priyomu'}, {"field_key" => "text_box"})
		pt.add_field({"name" => "Дні прийому", "slug" => 'aparat-dni-priyomu'}, {"field_key" => "text_box"})
		pt.add_field({"name" => "Сторінка декларації", "slug" => 'aparat-storinka-deklaratsii'}, {"field_key" => "posts", "post_types": ["7"]})

		unless theme.get_field_groups.where(slug: "theme_new_fields").any?
			slider_group = theme.add_custom_field_group({name: "Слайдер", slug: "theme_new_fields", "is_repeat": true})
			slider_group.add_manual_field({"name" => "Зображення", "slug" => "bg-image"},{field_key: "image"})

			sidebar_r_group = theme.add_custom_field_group({name: "Sidebar-right contacts", slug: "_group-sidebar-right-contacts"})
			sidebar_r_group.add_manual_field({"name" => "Контактна інформація (верх)", "slug" => "kontaktna-informatsiya-top"},{field_key: "editor"})
			sidebar_r_group.add_manual_field({"name" => "Контактна інформація", "slug" => "kontaktna-informatsiya"},{field_key: "editor"})

			sidebar_r_baner_group = theme.add_custom_field_group({name: "Sidebar right baners", slug: "_group-sidebar-right-baners", "is_repeat": true})
			sidebar_r_baner_group.add_manual_field({"name" => "Банер", "slug" => "sidebar-right-baner"},{field_key: "image"})
			sidebar_r_baner_group.add_manual_field({"name" => "Посилання на банер", "slug" => "baner-link"},{field_key: "url"})

			partners_group = theme.add_custom_field_group({name: "Партнери", slug: "_group-", "is_repeat": true})
			partners_group.add_manual_field({"name" => "Лого", "slug" => "partner-logo"},{field_key: "image"})
			partners_group.add_manual_field({"name" => "Посилання", "slug" => "partner-url"},{field_key: "text_box"})

			sites_group = theme.add_custom_field_group({name: "Сайти обласних центрів", slug: "_group-regional-sites", "is_repeat": true})
			sites_group.add_manual_field({"name" => "Назва", "slug" => "regional-site-name"},{field_key: "text_box"})
			sites_group.add_manual_field({"name" => "Посилання", "slug" => "regional-site-link"},{field_key: "text_box"})
			sites_group.add_manual_field({"name" => "Жирний?", "slug" => "regional-site-bold"},{field_key: "radio", "multiple_options":[{"title":"Ні","value":"1","default":"1"},{"title":"Так","value":"2"}]})

			footer_group = theme.add_custom_field_group({name: "Футер", slug: "_group-footer-contacts"})
			footer_group.add_manual_field({"name" => "Контакти", "slug" => "footer-contacts"},{field_key: "editor"})
			footer_group.add_manual_field({"name" => "Про права", "slug" => "footer-rights"},{field_key: "editor"})
			footer_group.add_manual_field({"name" => "Розробка", "slug" => "footer-development"},{field_key: "text_box"})

			budget_group = theme.add_custom_field_group({name: "Budget slider", slug: "_group-budget-slider", "is_repeat": true})
			budget_group.add_manual_field({"name" => "Slide", "slug" => "_group-budget-slider-index"},{field_key: "image"})

			group = theme.add_custom_field_group({name: "E-сервіси", slug: "_group-e-services", "is_repeat": true})
			group.add_manual_field({"name" => "Назва", "slug" => "e-service-name"}, {field_key: "text_box"})
			group.add_manual_field({"name" => "Посилання", "slug" => "e-service-link"}, {field_key: "text_box"})
			group.add_manual_field({"name" => "Зображення", "slug" => "e-service-thumb"}, {field_key: "image"})
		end

		unless theme.site.nav_menus.where(slug: "main_menu").any?
			theme.site.nav_menus.create(name: "Main Menu", slug: "main_menu")
		end

		unless theme.site.nav_menus.where(slug: "header-menu").any?
			theme.site.nav_menus.create(name: "Header Menu", slug: "header-menu")
		end

		unless theme.site.nav_menus.where(slug: "sidebar-left").any?
			theme.site.nav_menus.create(name: "Sidebar Left", slug: "sidebar-left")
		end

		unless theme.site.nav_menus.where(slug: "sidebar-right").any?
			theme.site.nav_menus.create(name: "Sidebar Right", slug: "sidebar-right")
		end

		unless theme.site.nav_menus.where(slug: "petitsii").any?
			theme.site.nav_menus.create(name: "Петиції", slug: "petitsii")
		end

		unless theme.site.nav_menus.where(slug: "departments").any?
			theme.site.nav_menus.create(name: "Відділи", slug: "departments")
		end

		menu = theme.site.nav_menus.find_by(slug: "sidebar-right")
		group = menu.add_field_group({name: "Custom sidebar-right", slug: "_group-custom-sidebar-right"})
		group.add_field({"name" => "Font-icon", "slug" =>'font-icon'}, {"field_key" => "text_box"})
		group.add_field({"name" => "Фон", "slug" =>'bg-color'}, {"field_key" => "colorpicker"})
		group.add_field({"name" => "Рамка", "slug" =>'border-color'}, {"field_key" => "colorpicker"})

		menu = theme.site.nav_menus.find_by(slug: "sidebar-left")
		group = menu.add_field_group({name: "Custom sidebar img", slug: "_group-custom-sidebar-img"})
		group.add_field({"name" => "Font-icon", "slug" =>'font-icon'}, {"field_key" => "text_box"})
		group.add_field({"name" => "Фон", "slug" =>'bg-color'}, {"field_key" => "colorpicker"})
		group.add_field({"name" => "Рамка", "slug" =>'border-color'}, {"field_key" => "colorpicker"})
	end

	def theme_custom_on_uninstall_theme(theme)
		#theme.get_field_groups().destroy_all
		#theme.destroy
	end

	def my_helper_before_app_load
		shortcode_add('slider', theme_view('partials/flex_slider'), 'Слайдер для фото, sample: [slider]')
		shortcode_add('short_slider', theme_view('partials/short_slider'), 'Слайдер для фото, sample: [slider images="/media/1/sss.jpg"]')
		shortcode_add('rada_docs', theme_view('partials/docs_shortcode'), 'Документи, [rada_docs docs="1,12,67"]')
		shortcode_add('rada_notes', theme_view('partials/notes_shortcode'), 'Записи, [rada_notes notes="1,12,67"]')
	end

	def dispay_requests
		sub_items_doc = [
			{icon: "list", title: 'Всі елементи', url: cama_cama_admin_docs_path},
			{icon: "plus", title: 'Додати', url: new_cama_cama_admin_doc_path},
			{icon: "folder-open", title: 'Категорії', url: cama_cama_admin_doc_categories_path},
			{icon: "tag", title: 'Теги', url: "/admin/docs/doc_tags"}
		]

		sub_items_note = [
			{icon: "list", title: 'Всі елементи', url: cama_cama_admin_notes_path},
			{icon: "plus", title: 'Додати', url: new_cama_cama_admin_note_path},
			{icon: "folder-open", title: 'Категорії', url: cama_cama_admin_note_categories_path},
			{icon: "tag", title: 'Теги', url: "/admin/notes/note_tags"}
		]

		sub_items_req = [
			{icon: "list", title: 'Старі', url: cama_cama_admin_requests_path},
			{icon: "tag", title: 'Запити', url: cama_cama_admin_requests_new_pub_path},
			{icon: "folder-open", title: 'Звернення', url: cama_cama_admin_requests_new_req_path},
		]

		admin_menu_insert_menu_after("content", "my_plugin_menu", {icon: 'envelope-open-o', title: 'Ел. запити', items: sub_items_req})
		admin_menu_insert_menu_after("content", "my_plugin_menu_pet", {icon: 'list-alt', title: 'Петиції', url: cama_cama_admin_petitions_path})
		admin_menu_insert_menu_after("content", "docs_menu", {icon: 'file', title: 'Документи', url: '#', items: sub_items_doc})
		admin_menu_insert_menu_after("dashboard", "notes_menu", {icon: 'book', title: 'Записи', url: '#', items: sub_items_note})
	end

	def camaleon_cms_contact_render(args)
		args[:submit] = "
		<div class='fl-end-row'>
		<button class='cf-submit' type='submit'>Надіслати</button>
		</div>"
	end
end