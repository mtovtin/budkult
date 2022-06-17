xml.instruct! :xml, :version => "1.0", :encoding => "windows-1251"
xml.rss :version => '2.0', 'xmlns' => 'http://backend.userland.com/rss2' do
  xml.instruct! :xml, :version => "1.0"
  xml.rss :version => '2.0'
      xml.channel do
        xml.title @title
        xml.link current_site.the_url
        xml.description current_site.the_excerpt

        for note in @notes
          xml.item do
            xml.title note.title
            xml.link "#{current_site.the_url}#{note.slug}"
            xml.description { |xml| xml.cdata! (note.content).truncate(200)}
            xml.pubDate note.created_at.to_s(:rfc822)
            xml.fulltext note.content + "#{note.post_imported_thumb.present? ? '<img src="' + current_site.the_url + note.post_imported_thumb + '"  + >' : ''}"
            xml.RemoveChild ("[slider]")
          end
        end
      end
    end