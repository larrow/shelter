# this module is designed for delegation of http client
module WebVisitor
  def new_session
    old_agent = @agent
    @agent = nil
    yield
  ensure
    @agent = old_agent
  end

  def new_session!
    @agent = nil
  end

  def visit url
    agent.get url
  end

  # example:
  #    submit_form( action: action ){|f| f['field1'] = value1}
  #    submit_form( id: id ) {|f| f['field2'] = value2 }
  def submit_form args
    page.form_with(args).tap do |form|
      expect(form).should_not be_nil
      yield form
    end.submit
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

  def page
    agent.page
  end

  def agent
    @agent ||= Mechanize.new.tap{|a| a.get 'http://proxy/'}
  end

  def _inner_post url, params, options
    csrf_key = page.at('meta[name="csrf-param"]')[:content]
    csrf_token = page.at('meta[name="csrf-token"]')[:content]
    agent.post(url, params.update(csrf_key => csrf_token), options)
  end

end
