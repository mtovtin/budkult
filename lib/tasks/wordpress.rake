require 'action_view'
require 'open-uri'
require 'uri'
require 'net/http'
require 'json'
require 'find'

namespace :wp do
	task import_posts: :environment do |_, _args|
		cats = []
		tags = []
		file = File.read('lib/posts/posts-1.json')
		items = JSON.parse(file)
		items['posts'].each do |item|
			if !item['categories'].nil?
				item['categories'].each do |x|
					cats.push({name: x['title'], slug: x['slug']})
				end
			end
			if !item['tags'].nil?
				item['tags'].each do |x|
					tags.push({name: x['title'], slug: x['slug']})
				end
			end
		end

		if cats.length > 0
			uniq_cats = cats.uniq! {|e| e[:slug] }
			uniq_cats.each do |cat|
				mycat = CamaleonCms::NoteCategory.find_or_create_by!(
					name: cat[:name],
					slug: cat[:slug]
					)
			end
		end

		if tags.length > 0
			uniq_tags = tags.uniq! {|e| e[:slug] }
			uniq_tags.each do |tag|
				mytag = CamaleonCms::NoteTag.find_or_create_by!(
					name: tag[:name],
					slug: tag[:slug]
					)
			end
		end

		items['posts'].each do |item|
			if item['status'] == 'publish'
				ex_post = CamaleonCms::Site.first.notes.find_by(slug: item['slug'])
				if !ex_post
					post = CamaleonCms::Site.first.notes.create!(
						title: item['title'],
						slug: item['slug'],
						content: item['content'],
						published_at: item['date'].to_datetime,
						created_at: item['date'].to_datetime,
						updated_at: item['modified'].to_datetime
						)

					if !item['categories'].nil?
						if item['categories'].length == 0
							post_cat = CamaleonCms::NoteCategory.find_or_create_by!(
								name: "Без категорії",
								slug: "uncategorized"
								)
							post.note_cattings.new(note_category_id: post_cat.id)
						else
							item['categories'].each do |x|
								post_cat = CamaleonCms::NoteCategory.find_by(name: x['title'])
								post.note_cattings.new(note_category_id: post_cat.id)
							end
						end
					end

					if !item['tags'].nil?
						item['tags'].each do |x|
							post_tag = CamaleonCms::NoteTag.find_by(name: x['title'])
							post.note_taggings.new(note_tag_id: post_tag.id)
						end
					end

					if item['thumbnail']
						if item['thumbnail'].include? 'https://'
							new_value = item['thumbnail'].gsub('https://rada-uzhgorod.gov.ua', '')
						else
							new_value = item['thumbnail'].gsub('http://rada-uzhgorod.gov.ua', '')
						end
						post.update(post_imported_thumb: new_value)
					end

					post.save
					puts "#{post[:title]}: #{post[:created_at]}"
				end
			end
		end
	end

	task import_petitions: :environment do |_, _args|
		File.open('lib/petition.xml') do |file|
			items = Nokogiri::XML(file).xpath('//channel//item')
			items.each do |item|
				if item.at_xpath('wp:status').text == 'publish'
					post = CamaleonCms::Site.first.petitions
					.create!(
						title: item.at_xpath('title').text.strip,
						slug: item.at_xpath('wp:post_name').text,
						content: item.at_xpath('content:encoded').text,
						created_at: item.at_xpath('wp:post_date').text.to_datetime,
						updated_at: item.at_xpath('wp:post_date').text.to_datetime
						)

					item.xpath('category').each do |x|
						if x['nicename'] == 'arhiv'
							post.update(status_archive: x.text)
						end
						if x['nicename'] == 'nadana-vidpovid'
							post.update(status_answer: x.text)
						end
					end

					item.xpath('wp:postmeta').each do |x|
						key = x.at_xpath('wp:meta_key').text
						value = x.at_xpath('wp:meta_value').text
						if key == 'petition_card_number'
							post.update(number: value)
						end
						if key == 'petition_card_deadline'
							post.update(deadline: value)
						end
						if key == 'petition_card_votes_need'
							post.update(votes_need: value)
						end
						if key == 'p_votes'
							post.update(real_votes: value)
						end
						if key == 'petition_card_answer'
							post.update(answer: value)
						end
					end

					post.save
					puts "#{post[:title]}"
				end
			end
		end
	end

	task import_docs: :environment do |_, _args|
		cats = []
		tags = []
		docs_file = 'lib/docs/10-2000-docs.xml'
		File.open(docs_file) do |file|
			items = Nokogiri::XML(file).xpath('//channel//item')
			items.each do |item|
				item.xpath('category').each do |x|
					if x['domain'] == 'rada_docs_taxonomy' || x['domain'] == 'rada_docs_t'
						cats.push({name: x.text, slug: x['nicename']})
					end
					if x['domain'] == 'aparat_mr'
						tags.push({name: x.text, slug: x['nicename']})
					end
				end
			end
		end

		uniq_cats = cats.uniq! {|e| e[:slug]}
		uniq_cats.each do |cat|
			mycat = CamaleonCms::DocCategory.find_or_create_by!(
				name: cat[:name],
				slug: cat[:slug]
				)
		end

		uniq_tags = tags.uniq! {|e| e[:slug]}
		uniq_tags.each do |tag|
			mytag = CamaleonCms::DocTag.find_or_create_by!(
				name: tag[:name],
				slug: tag[:slug]
				)
		end

		File.open(docs_file) do |file|
			items = Nokogiri::XML(file).xpath('//channel//item')
			items.each do |item|
				if item.at_xpath('wp:status').text == 'publish'
					ex_doc = CamaleonCms::Site.first.docs.find_by(slug: item.at_xpath('wp:post_name').text)
					if !ex_doc
						post = CamaleonCms::Site.first.docs.create!(
							title: item.at_xpath('title').text.strip,
							slug: item.at_xpath('wp:post_name').text,
							content: item.at_xpath('content:encoded').text,
							created_at: item.at_xpath('wp:post_date').text.to_datetime,
							updated_at: item.at_xpath('wp:post_date').text.to_datetime
							)

						item.xpath('wp:postmeta').each do |x|
							key = x.at_xpath('wp:meta_key').text
							value = x.at_xpath('wp:meta_value').text
							if key == 'rada_docs_url' && !value.to_s.empty?
								if value.include? 'https://'
									new_value = value.gsub('https://rada-uzhgorod.gov.ua', '')
								else
									new_value = value.gsub('http://rada-uzhgorod.gov.ua', '')
								end
								post.update(rada_docs_url: new_value)
							end
						end

						unless item.xpath('category').text.blank?
							item.xpath('category').each do |x|
								if x['domain'] == 'rada_docs_taxonomy'
									post_cat = CamaleonCms::DocCategory.find_by(name: x.text)
									post.categorizations.new(doc_category_id: post_cat.id)
								end
								if x['domain'] == 'rada_docs_t'
									post_cat = CamaleonCms::DocCategory.find_by(name: x.text)
									post.categorizations.new(doc_category_id: post_cat.id)
								end
								if x['domain'] == 'aparat_mr'
									post_tag = CamaleonCms::DocTag.find_by(name: x.text)
									post.taggings.new(doc_tag_id: post_tag.id)
								end
							end
						end

						post.save
						puts "#{post[:title]}: #{post[:created_at]}"
					end
				end
			end
		end
	end

	task find: :environment do |_, _args|
		thumb = "https://rada-uzhgorod.gov.ua/uploads/sites/2/2018/07/reg_dil.jpg"
		new_thumb = thumb.gsub('https://rada-uzhgorod.gov.ua/uploads', '')
		Find.find('/home/deploy/rada/shared/public/uploads') do |path|
			puts path.gsub("/home/deploy/rada/shared/public", "") if path.include? new_thumb
			next unless File.file?(path)
		end
	end

	task delete_docs: :environment do |_, _args|
		CamaleonCms::Site.first.docs.destroy_all
	end

	task delete_docs_old: :environment do |_, _args|
		post_type = CamaleonCms::Site.first.post_types.find_by(slug: 'rada_docs')
		post_type.posts.destroy_all
		post_type.categories.where("slug != ?",'uncategorized').destroy_all
		post_type.post_tags.where("slug != ?",'tag').destroy_all
	end

	task delete_aparat: :environment do |_, _args|
		post_type = CamaleonCms::Site.first.post_types.find_by(slug: 'aparat')
		post_type.posts.destroy_all
		post_type.categories.where("slug != ?",'uncategorized').destroy_all
		post_type.post_tags.where("slug != ?",'tag').destroy_all
	end

	task delete_posts: :environment do |_, _args|
		post_type = CamaleonCms::Site.first.post_types.find_by(slug: 'post')
		post_type.posts.destroy_all
		post_type.categories.where("slug != ?",'uncategorized').destroy_all
		post_type.post_tags.where("slug != ?",'tag').destroy_all
	end

	task delete_pages: :environment do |_, _args|
		post_type = CamaleonCms::Site.first.post_types.find_by(slug: 'page')
		post_type.posts.destroy_all
	end

	task delete_requests: :environment do |_, _args|
		CamaleonCms::Site.first.requests.destroy_all
	end

	task delete_petitions: :environment do |_, _args|
		CamaleonCms::Site.first.petitions.destroy_all
	end

	task split: :environment do |_, _args|
		File.open('lib/documents.xml', "r:UTF-8") do |file|
			items = Nokogiri::XML(file).xpath('//channel//item')
			items.each_slice(2000).with_index do |item, i|
				File.open("lib/docs/#{i}-2000-docs.xml", "w:UTF-8") do |f|
					item.each do |sliced|
						f.write(sliced.to_xml)
					end
				end
			end
		end
	end

	task docs_count: :environment do |_, _args|
		File.open('lib/docs/5-2000-docs.xml', "r:UTF-8") do |file|
			items = Nokogiri::XML(file).xpath('//channel//item')
			i = 0
			items.each do |item|
				if item.at_xpath('wp:status').text == 'publish'
					i += 1
				end
			end
			puts i
		end
	end

	task import_requests: :environment do |_, _args|
		File.open('lib/requests.xml') do |file|
			items = Nokogiri::XML(file).xpath('//channel//item')
			items.each do |item|
				ex_request = CamaleonCms::Site.first.requests.find_by(title: item.at_xpath('title').text.strip)
				if !ex_request
					post = CamaleonCms::Site.first.requests.create!(
						title: item.at_xpath('title').text.strip,
						content: item.at_xpath('content:encoded').text,
						created_at: item.at_xpath('wp:post_date').text.to_datetime)
					post.save
					puts "#{post[:title]}: #{post[:published_at]}"
				end
			end
		end
	end

	task import_posts_old: :environment do |_, _args|
		post_type = CamaleonCms::Site.first.post_types.find_by(slug: 'post')
		CamaleonCms::Post.transaction do
			user_id = CamaleonCms::User.first[:id]
			cats = []
			tags = []
			file = File.read('lib/posts/posts-7.json')
			items = JSON.parse(file)
			items['posts'].each do |item|
				if !item['categories'].nil?
					item['categories'].each do |x|
						cats.push({name: x['title'], slug: x['slug']})
					end
				end
				if !item['tags'].nil?
					item['tags'].each do |x|
						tags.push({name: x['title'], slug: x['slug']})
					end
				end
			end

			if cats.length > 0
				uniq_cats = cats.uniq! {|e| e[:slug] }
				uniq_cats.each do |cat|
					mycat = CamaleonCms::Category.find_or_create_by!(
						taxonomy: "category",
						parent_id: post_type.id,
						name: cat[:name],
						slug: cat[:slug]
						)
				end
			end

			if tags.length > 0
				uniq_tags = tags.uniq! {|e| e[:slug]}
				uniq_tags.each do |tag|
					mytag = CamaleonCms::PostTag.find_or_create_by!(
						taxonomy: "post_tag",
						parent_id: post_type.id,
						name: tag[:name],
						slug: tag[:slug]
						)
				end
			end

			items['posts'].each do |item|
				if item['status'] == 'publish'
					ex_post = post_type.posts.find_by(slug: item['slug'])
					if ex_post
						if !item['categories'].nil?
							item['categories'].each do |x|
								post_cat = CamaleonCms::Category.find_by(name: x['title'])
								ex_post.assign_category([post_cat.id])
							end
						end

						ex_post.save
						puts "#{ex_post[:title]}: #{ex_post[:published_at]}"
					end

					if !ex_post
						post = post_type.posts.create!(
							title: item['title'],
							slug: item['slug'],
							content: item['content'],
							content_filtered: item['content'].strip_tags,
							status: "published",
							published_at: item['date'].to_datetime,
							post_parent: nil,
							visibility: "public",
							visibility_value: nil,
							post_class: "Post",
							created_at: item['date'].to_datetime,
							updated_at: item['modified'].to_datetime,
							user_id: user_id,
							taxonomy_id: post_type.id,
							is_feature: false)

						if !item['categories'].nil?
							item['categories'].each do |x|
								post_cat = CamaleonCms::Category.find_by(name: x['title'])
								post.assign_category([post_cat.id])
							end
						end

						if !item['tags'].nil?
							item['tags'].each do |x|
								post_tag = CamaleonCms::PostTag.find_by(name: x['title'])
								post.assign_tags(x['title'])
							end
						end

						if item['thumbnail']
							if item['thumbnail'].include? 'https://'
								new_value = item['thumbnail'].gsub('https://rada-uzhgorod.gov.ua', '')
							else
								new_value = item['thumbnail'].gsub('http://rada-uzhgorod.gov.ua', '')
							end
							post.set_field_value('post_imported_thumb', new_value)
						end

						post.save
						puts "#{post[:title]}: #{post[:published_at]}"
					end
				end
			end
		end
	end

	task import_pages: :environment do |_, _args|
		post_type = CamaleonCms::Site.first.post_types.find_by(slug: 'page')
		CamaleonCms::Post.transaction do
			user_id = CamaleonCms::User.first[:id]
			file = File.read('lib/pages.json')
			items = JSON.parse(file)

			items['pages'].each do |item|
				ex_post = post_type.posts.find_by(slug: item['slug'])
				if !ex_post
					post = post_type.posts.create!(
						title: item['title'],
						slug: item['slug'],
						content: item['content'],
						content_filtered: item['content'].strip_tags,
						status: "published",
						published_at: item['date'].to_datetime,
						post_parent: nil,
						visibility: "public",
						visibility_value: nil,
						post_class: "Post",
						created_at: item['date'].to_datetime,
						updated_at: item['modified'].to_datetime,
						user_id: user_id,
						taxonomy_id: post_type.id,
						is_feature: false)

					post.save
					puts "#{post[:title]}: #{post[:published_at]}"
				end
			end
		end
	end

	task update_aparat: :environment do |_, _args|
		post_type = CamaleonCms::Site.first.post_types.find_by(slug: 'aparat')
		CamaleonCms::Post.transaction do
			file = File.read('lib/aparat.json')
			items = JSON.parse(file)

			items['posts'].each do |item|
				if item['status'] == 'publish'
					post = post_type.posts.find_by(slug: item['slug'])

					if item['thumbnail']
						if item['thumbnail'].include? 'https://'
							new_value = item['thumbnail'].gsub('https://rada-uzhgorod.gov.ua', '')
						else
							new_value = item['thumbnail'].gsub('http://rada-uzhgorod.gov.ua', '')
						end
						post.set_thumb(new_value)
					end

					post.save
					puts "#{post[:title]}: #{post[:published_at]}"
				end
			end
		end
	end

	task import_aparat: :environment do |_, _args|
		post_type = CamaleonCms::Site.first.post_types.find_by(slug: 'aparat')
		CamaleonCms::Post.transaction do
			user_id = CamaleonCms::User.first[:id]
			cats = []
			tags = []
			File.open('lib/aparat.xml') do |file|
				items = Nokogiri::XML(file).xpath('//channel//item')
				items.each do |item|
					item.xpath('category').each do |x|
						if x['domain'] == 'aparat_mr'
							cats.push({name: x.text, slug: x['nicename']})
						end
						if x['domain'] == 'parties'
							tags.push({name: x.text, slug: x['nicename']})
						end
					end
				end
			end

			uniq_cats = cats.uniq! {|e| e[:slug]}
			uniq_cats.each do |cat|
				mycat = CamaleonCms::Category.find_or_create_by!(
					taxonomy: "category",
					parent_id: post_type.id,
					name: cat[:name],
					slug: cat[:slug]
					)
			end

			uniq_tags = tags.uniq! {|e| e[:slug]}
			uniq_tags.each do |tag|
				mytag = CamaleonCms::PostTag.find_or_create_by!(
					taxonomy: "post_tag",
					parent_id: post_type.id,
					name: tag[:name],
					slug: tag[:slug]
					)
			end

			File.open('lib/aparat.xml') do |file|
				items = Nokogiri::XML(file).xpath('//channel//item')
				items.each do |item|
					if item.at_xpath('wp:status').text == 'publish'
						post = post_type.posts.create!(
							title: item.at_xpath('title').text.strip,
							slug: item.at_xpath('wp:post_name').text,
							content: item.at_xpath('content:encoded').text,
							content_filtered: item.at_xpath('content:encoded').text.strip_tags,
							status: "published",
							published_at: item.at_xpath('pubDate').text.to_datetime,
							post_parent: nil,
							visibility: "public",
							visibility_value: nil,
							post_class: "Post",
							created_at: item.at_xpath('wp:post_date').text.to_datetime,
							updated_at: item.at_xpath('wp:post_date').text.to_datetime,
							user_id: user_id,
							post_order: item.at_xpath('wp:menu_order').text.to_i,
							taxonomy_id: post_type.id,
							is_feature: false)

						item.xpath('wp:postmeta').each do |x|
							key = x.at_xpath('wp:meta_key').text
							value = x.at_xpath('wp:meta_value').text
							if key == 'aparat_info_aparat_posada'
								post.set_field_value('aparat-posada', value)
							end
							if key == 'aparat_info_aparat_adr'
								post.set_field_value('aparat-adresa', value)
							end
							if key == 'aparat_info_aparat_email'
								post.set_field_value('aparat-email', value)
							end
							if key == 'aparat_info_aparat_tel'
								post.set_field_value('aparat-telefon', value)
							end
							if key == 'aparat_info_aparat_moreinfo'
								post.set_field_value('aparat-dodatkovo', value)
							end
							if key == 'aparat_info_aparat_time'
								post.set_field_value('aparat-chas-priyomu', value)
							end
							if key == 'aparat_info_aparat_date'
								post.set_field_value('aparat-dni-priyomu', value)
							end
						end

						unless item.xpath('category').text.blank?
							item.xpath('category').each do |x|
								if x['domain'] == 'aparat_mr'
									post_cat = CamaleonCms::Category.find_by(name: x.text)
									post.assign_category([post_cat.id])
								end
								if x['domain'] == 'parties'
									post_tag = CamaleonCms::PostTag.find_by(name: x.text)
									post.assign_tags(x.text)
								end
							end
						end

						post.save
						puts "#{post[:title]}: #{post[:published_at]}"
					end
				end
			end
		end
	end

	task import_docs_old: :environment do |_, _args|
		post_type = CamaleonCms::Site.first.post_types.find_by(slug: 'rada_docs')
		CamaleonCms::Post.transaction do
			user_id = CamaleonCms::User.first[:id]
			cats = []
			tags = []
			File.open('lib/docs/10-2000-docs.xml') do |file|
				items = Nokogiri::XML(file).xpath('//channel//item')
				items.each do |item|
					item.xpath('category').each do |x|
						if x['domain'] == 'rada_docs_taxonomy'
							cats.push({name: x.text, slug: x['nicename']})
						end
						if x['domain'] == 'rada_docs_t'
							cats.push({name: x.text, slug: x['nicename']})
						end
						if x['domain'] == 'aparat_mr'
							tags.push({name: x.text, slug: x['nicename']})
						end
					end
				end
			end

			uniq_cats = cats.uniq! {|e| e[:slug]}
			uniq_cats.each do |cat|
				mycat = CamaleonCms::Category.find_or_create_by!(
					taxonomy: "category",
					parent_id: post_type.id,
					name: cat[:name],
					slug: cat[:slug]
					)
			end

			uniq_tags = tags.uniq! {|e| e[:slug]}
			uniq_tags.each do |tag|
				mytag = CamaleonCms::PostTag.find_or_create_by!(
					taxonomy: "post_tag",
					parent_id: post_type.id,
					name: tag[:name],
					slug: tag[:slug]
					)
			end

			File.open('lib/docs/10-2000-docs.xml') do |file|
				items = Nokogiri::XML(file).xpath('//channel//item')
				items.each do |item|
					if item.at_xpath('wp:status').text == 'publish'
						ex_doc = post_type.posts.find_by(slug: item.at_xpath('wp:post_name').text)
						if ex_doc
							post = post_type.posts.find_by(slug: item.at_xpath('wp:post_name').text)
							unless item.xpath('category').text.blank?
								item.xpath('category').each do |x|
									if x['domain'] == 'rada_docs_t'
										post_cat = CamaleonCms::Category.find_by(name: x.text)
										post.assign_category([post_cat.id])
									end
								end
							end

							post.save
							puts "#{post[:title]}: #{post[:published_at]}"
						end
						if !ex_doc
							post = post_type.posts.create!(
								title: item.at_xpath('title').text.strip,
								slug: item.at_xpath('wp:post_name').text,
								status: "published",
								published_at: item.at_xpath('pubDate').text.to_datetime,
								post_parent: nil,
								visibility: "public",
								visibility_value: nil,
								post_class: "Post",
								created_at: item.at_xpath('wp:post_date').text.to_datetime,
								updated_at: item.at_xpath('wp:post_date').text.to_datetime,
								user_id: user_id,
								post_order: item.at_xpath('wp:menu_order').text.to_i,
								taxonomy_id: post_type.id,
								is_feature: false)

							item.xpath('wp:postmeta').each do |x|
								include Rails.application.routes.url_helpers
								include CamaleonCms::CustomUploaderHelper
								key = x.at_xpath('wp:meta_key').text
								value = x.at_xpath('wp:meta_value').text
								if key == 'rada_docs_url' && !value.to_s.empty?
									if value.include? 'https://'
										new_value = value.gsub('https://rada-uzhgorod.gov.ua', '')
									else
										new_value = value.gsub('http://rada-uzhgorod.gov.ua', '')
									end
									post.set_field_value('rada_docs_url', new_value)
								end
							end

							unless item.xpath('category').text.blank?
								item.xpath('category').each do |x|
									if x['domain'] == 'rada_docs_taxonomy' || x['domain'] == 'rada_docs_t'
										post_cat = CamaleonCms::Category.find_by(name: x.text)
										post.assign_category([post_cat.id])
									end
									if x['domain'] == 'rada_docs_t'
										post_cat = CamaleonCms::Category.find_by(name: x.text)
										post.assign_category([post_cat.id])
									end
									if x['domain'] == 'aparat_mr'
										post_tag = CamaleonCms::PostTag.find_by(name: x.text)
										post.assign_tags(x.text)
									end
								end
							end

							post.save
							puts "#{post[:title]}: #{post[:published_at]}"
						end
					end
				end
			end
		end
	end

	task upload: :environment do |_, _args|
		include Rails.application.routes.url_helpers
		include CamaleonCms::CustomUploaderHelper
		url = 'https://rada-uzhgorod.gov.ua/uploads/sites/2/2016/04/MAKARA-Olena-Myhajlivna.jpg'
		filename = File.basename(URI.parse(url).path)
		puts upload_file(url, {formats: "*"})
		if item['thumbnail']
			include Rails.application.routes.url_helpers
			include CamaleonCms::CustomUploaderHelper
			url = URI.parse(URI.encode(item['thumbnail'].gsub(' ', '%20')))
			req = Net::HTTP.get_response(url)
			res = req
			if res.code == "200"
				filename = File.basename(url.path)
				media = CamaleonCms::Media.find_by(name: filename)
				if media
					post.set_thumb(media.url)
				else
					new_file = upload_file(item['thumbnail'], {formats: "*"})
					post.set_thumb(new_file['url'].gsub('/?locale=false', ''))
				end
			end
		end
	end
end