class Cloverly::Source
  include Cloverly::Base

  class << self
    def retrieve(slug)
      Cloverly::Source.parse(Cloverly.default, Cloverly.default.get("/2019-03-beta/recs/#{slug}"))
    end

    def list
      Cloverly::Source.parse(Cloverly.default, Cloverly.default.get("/2019-03-beta/recs"))
    end
  end

end
