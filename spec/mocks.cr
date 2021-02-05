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
end
