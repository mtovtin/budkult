module ApplicationHelper
	module CamaleonCms::Frontend::ApplicationHelper

		def get_sidebar_menu(key = 'main_menu', class_name = "navigation")
			#draw_menu({menu_slug: key, container_class: class_name})
			cama_menu_parse_items(current_site.nav_menus.find_by_slug('sidebar-left'), -1)
		end

		def cat_url(cat)
			cama_new_category_path(cat.slug)
		end

		def post_url(post)
			return "/post/#{post.slug}"
		end

		def pet_url(pet)
			return "/petition/#{pet.slug}"
		end

		def tag_url(tag)
			cama_new_tag_path(tag.slug)
		end

		def cama_do_pagination(items, *will_paginate_options)
			will_paginate_options = will_paginate_options.extract_options!
			custom_class = will_paginate_options[:panel_class]
			will_paginate_options.delete(:panel_class)
			"<div class='row #{custom_class} pagination_panel cama_ajax_request'>
			<div class='col-md-9'>
			#{will_paginate(items, will_paginate_options) rescue '' }
			</div>
			<div class='col-md-3 text-right total-items'>
			<strong>Сторінка: #{items.current_page} із #{items.total_pages}</strong>
			</div>
			</div>"
		end

		# Returns a list of dates with beginning_of_day and end_of_day.
		# @param [String] start_date
		# @param [String] end_date
		# @return [Array<String>]
		def get_date_range(start_date, end_date)
			start_date =
				begin
					Date.parse(start_date).beginning_of_day
				rescue StandardError
					Date.today.beginning_of_day
				end
			end_date =
				begin
					Date.parse(end_date).end_of_day
				rescue StandardError
					Date.today.end_of_day
				end
			[start_date, end_date]
		end
	end
end