module WebVisitor
  def agent
    @agent ||= Mechanize.new.tap{|a| a.get 'http://proxy/'}
  end

  def page
    @page
  end

  def visit url
    @page = agent.get url
  end

  def fill_in id
    form = page.forms.select{|f| f.id == id}
    yield form
    agent.submit form
  end

  def find_link label
    page
      .links
      .select{|link| link.text.downcase == label.downcase}
      .first
  end

  def web_delete url
    _inner_post(
      url,
      {'_method' => 'delete'},
      {'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8'}
    )
  end

  def _inner_post url, params, options
    csrf_key = page.at('meta[name="csrf-param"]')[:content]
    csrf_token = page.at('meta[name="csrf-token"]')[:content]
    agent.post(url, params.update(csrf_key => csrf_token), options)
  end

  def new_session
    old_agent = @agent
    @agent = nil
    yield
    @agent = old_agent
  end

  def new_session!
    @agent = nil
  end
end
