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

module SetupFixture
  macro included
    let(response) { File.new(fixture) }
    before_each { WebMock.stub(:any, /.*api\.bamboohr\.com/).to_return(response) }
    after_each { response.close }
  end
end

module Mocks
  macro included
    include SetupWebMock
    include MockClient
  end
end
