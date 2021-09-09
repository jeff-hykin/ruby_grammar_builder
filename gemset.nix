{
  deep_clone = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["http://rubygems.org"];
      sha256 = "003iqvmxxcm7p6qr2aafi1p5djm6ycvwzrjk6shc9wvybkvbckmz";
      type = "gem";
    };
    version = "0.0.1";
  };
  gem-release = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["http://rubygems.org"];
      sha256 = "108rrfaiayi14zrqbb6z0cbwcxh8n15am5ry2a86v7c8c3niysq9";
      type = "gem";
    };
    version = "2.2.2";
  };
  ruby_grammar_builder = {
    dependencies = ["deep_clone"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["http://rubygems.org"];
      sha256 = "1m1ynjjcv7kf8414qnq5am3k6f1kajc76gbrwrxyhyc31j0n7sag";
      type = "gem";
    };
    version = "0.0.4";
  };
}