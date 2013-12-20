class Importer
  def initialize
    @agent = Mechanize.new do |a|
      a.user_agent_alias = 'Mac Safari'
    end
  end

  def import_show_times(day)
    @day = day

    #visit site
    url = build_url
    page = @agent.get(url)
    movie_infos = parse_container(page).select do |movie|
      movie[:showtimes].select{|times|times[:dates].select{|d|d.day == @day.day && d.month == @day.month}.any?}.any?
    end
    movie_infos
    #list todays showing
    #add movie, times, cinemas
    #repeate for next n days
  end

  def build_url
    "http://www.cinema.com.hk/revamp/html/movie_ticketing.php?cinema_id=undefined&lang=e&yy=#{@day.year - 2000}&mm=#{@day.month}&dd=#{@day.day}"
  end
  
  private

  def parse_container(page)
    containers = page.search('tr.listingbg')
    containers.map do |c|
      {
        name:c.at('table.movie_list .movie_title_listing').text,
        logo:c.at('table.movie_list img')['src'],
        showtimes:parse_cinemas(c)
      }
    end
  end

  def parse_cinemas(container)
    times = container.search('select.movie_listbox')
    times.map do |drop|
      cinema = drop.parent.parent.search('td a').text
      dates = drop.search('option').select{|op|!op.text.start_with?('--')}.map{|v|parse_time_values(v.text)}
      {cinema:cinema,dates:dates}
    end
  end

  def parse_time_values(select_value)
    values = select_value.split(' ')
    date_info = values[0].split('/').map{|v|v.to_i}
    "#{@day.year}-#{date_info[1]}-#{date_info[0]} #{values[1]}".to_datetime
  end
end