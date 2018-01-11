# Monkeypatch for CoverThing service trying to redirect HTTP -> HTTPS with XHR
CoverThing.class_eval do
  def initialize(config)
    @display_name = "LibraryThing"
    @base_url = 'https://covers.librarything.com/devkey/';
    @lt404url = 'https://www.librarything.com/coverthing404.php'

    @credits = {
      "LibraryThing" => "http://www.librarything.com/"
    }

    super(config)
  end
end
