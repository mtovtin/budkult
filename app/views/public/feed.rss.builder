xml.instruct!
xml.rss :version => '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
  xml.channel do
    xml.title @title
    xml.description current_site.the_excerpt
    xml.link current_site.the_url
    xml.language 'uk'
    xml.tag! 'atom:link', :rel => 'self', :type => 'application/atom+xml', :href => feed_url

    for note in @notes
      xml.item do
        xml.title note.title
        xml.link "#{current_site.the_url}#{note.slug}"
        xml.pubDate note.created_at.to_s(:rfc822)
        xml.guid "#{current_site.the_url}#{note.slug}"
        xml.description note.content
      end
    end
  end
end