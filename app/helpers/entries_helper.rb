module EntriesHelper

  # Takes an entry and returns a string of the html that makes up the entry's content
  # but this time with pictures too!
  def formatted_entry_w_pictures(entry)
    total_pictures = entry.pictures.count
    # No need for fancy formatting if there are no pictures. Just return.
    return entry.text_content.to_trix_html if total_pictures == 0
    # Divide the entry html into workable segments
    segments = segmentize(entry.text_content.to_trix_html)

    total_chars_in_entry = segments.join.length
    optimal_chars_in_segment = total_chars_in_entry / total_pictures

    # Initialize the PictureIterator
    picture_iterator = PictureIterator.new entry
    # If the entry is too short, put all pictures at the end
    if total_chars_in_entry < 600
      segments += all_picture_html
    end

    # If the entry is long enough to fit all pictures inside, fit them
    if optimal_chars_in_segment < 600
      # Place a picture every 600 characters
      milestone = 600
    else
      # Place a picture after every optimal_chars_in_segment characters
      milestone = optimal_chars_in_segment
    end
    running_total = 0
    segments.each_with_index do |s, i|
      next if s == picture_html(picture_iterator.current)
      running_total += s.length
      if running_total >= milestone
        segments.insert i+1, picture_html(picture_iterator.next)
        running_total = 0
      end
    end.join
  end

  # Takes a string of html and breaks it up for use by the formatted_entry_w_pictures method
  def segmentize(html_string)
    doc = Nokogiri::HTML(html_string)
    
    segments = []
    
    doc.at('body').children.each do |node|
      next unless node.element?
      segment = "<#{node.name}>#{node.inner_html}</#{node.name}>"
      if segment.include? '<br>'
        segment.split('<br>').each do |s|
          segments << "#{s}<br>"
        end
      else
        segments << segment
      end
    end
    segments
  end

  class PictureIterator
    def initialize(entry)
      @current = 0
      @arr = entry.pictures.to_a
    end

    def next
      @current += 1
      @arr[@current]
    end

    def current
      @arr[@current]
    end
  end
end
