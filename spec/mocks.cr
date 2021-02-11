module SetupWebMock
  macro included
    before_each { WebMock.reset }
  end
end

module MockClient
  macro included
    let(client) { Bamboozled.client("x", "x") }
  end
end

module Mocks
  macro included
    include SetupWebMock
    include MockClient
  end

  macro fixture(path, status = 200, headers = nil)
    let(response) { File.new({{path.stringify.id}}) }
    before_each {
      WebMock.stub(:any, /.*api\.bamboohr\.com/).to_return(
        body_io: response, status: {{status}}, headers: {{headers}}
      )
    }
    after_each { response.close }
  end
end
