xml.instruct!
xml.rss :version => '2.0', 'xmlns' => 'http://backend.userland.com/rss2' do
  xml.channel do
    xml.title @title
    xml.link current_site.the_url
    xml.description current_site.the_excerpt

    for note in @notes
      xml.item do
        xml.title sanitize(note.title, tags: [])
        xml.link "#{current_site.the_url}#{note.slug}"
        xml.description sanitize(note.content.truncate(200), tags: [])
        xml.pubDate note.created_at.to_s(:rfc822)
        xml.fulltext { |xml| xml.cdata!(cama_strip_shortcodes(note.content)) }
        xml.RemoveChild ("[slider]")
      end
    end
  end
end


    