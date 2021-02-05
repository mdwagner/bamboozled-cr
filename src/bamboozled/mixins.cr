module Bamboozled
  module Mixins
    record Response, headers : HTTP::Headers, json : JSON::Any? = nil

    enum HttpMethod
      Get
      Post
      Put
      Delete

      def name
        case self
        when .get?
          "GET"
        when .post?
          "POST"
        when .put?
          "PUT"
        when .delete?
          "DELETE"
        end.not_nil!
      end
    end
  end
end
