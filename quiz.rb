require 'mechanize'
require 'nokogiri'

class Quiz
  EMAIL = 'test@example.com'
  PASSWORD = 'secret'

  def run
    report(login)
  end

  private

  def login
    mechanize = Mechanize.new
    login_page = mechanize.get("https://staqresults.herokuapp.com/")
    login_page.forms.first.fields[0].value = EMAIL
    login_page.forms.first.fields[1].value = PASSWORD
    login_page.forms.first
  end

  def report(login_page)
    report_page = login_page.submit
    get_values(report_page)
  end

  def get_values(report_page)
    result = {}
    report_page.search('tbody').each do |tbody|
      tbody.search('tr').each do |tr|
        text = tr.text.split("\n")
        result[get_key(text)] = set_structure(text)
      end
    end
    result
  end

  def get_key(text)
    text[1]
  end

  def set_structure(text)
    { tests: text[2], passes: text[3], failures: text[4], pending: text[5], coverage: text[6] }
  end
end