# frozen_string_literal: true

require "rack"
require "rack/url_repeated_string_validator"

RSpec.describe Rack::UrlRepeatedStringValidator do # rubocop:disable Metrics/BlockLength
  let(:app) do
    Rack::Builder.new do
      use Rack::UrlRepeatedStringValidator, invalid_keys: ["amp;"], max_repeated: 3
      run ->(_env) { [200, { "Content-Type" => "text/plain" }, ["OK"]] }
    end
  end

  it "has a version number" do
    expect(Rack::UrlRepeatedStringValidator::VERSION).not_to be nil
  end

  context "when query parameters are valid" do
    it "calls the app" do
      env = Rack::MockRequest.env_for("/?valid_key=value")
      status, _headers, _body = app.call(env)

      expect(status).to eq(200)
    end
  end

  describe "query parameter contains a string to be excluded" do
    context "has excluded strings Less than maximum allowed" do
      it "returns a 200 status" do
        env = Rack::MockRequest.env_for("/?amp;amp;amp;foo=bar")
        status, _headers, _body = app.call(env)

        expect(status).to eq(200)
      end
    end

    context "has excluded strings more than maximum allowed" do
      it "returns a 400 status" do
        env = Rack::MockRequest.env_for("/?amp;amp;amp;amp;foo=bar")
        status, _headers, _body = app.call(env)

        expect(status).to eq(400)
      end
    end

    context "If any one of the query parameters exceeds the maximum allowed" do
      it "returns a 400 status" do
        env = Rack::MockRequest.env_for("/?category%5B%5D=257&amp;amp;amp;searchKey=&amp;amp;amp;amp;topCategoryId=4")
        status, _headers, _body = app.call(env)

        expect(status).to eq(400)
      end
    end
  end

  describe "multiple invalid keys" do # rubocop:disable Metrics/BlockLength
    def app_with_multiple_invalid_keys
      Rack::Builder.new do
        use Rack::UrlRepeatedStringValidator, invalid_keys: %w[foo bar], max_repeated: 3
        run ->(_env) { [200, { "Content-Type" => "text/plain" }, ["OK"]] }
      end
    end

    describe "valid url" do
      it "returns a 200 status" do
        env = Rack::MockRequest.env_for("/?foofoofoo=bar")
        status, _headers, _body = app_with_multiple_invalid_keys.call(env)

        expect(status).to eq(200)
      end
    end

    describe "invalid url patterns" do
      describe "has one invalid key in url" do
        it "returns a 400 status" do
          env = Rack::MockRequest.env_for("/?foofoofoofoo=bar")
          status, _headers, _body = app_with_multiple_invalid_keys.call(env)

          expect(status).to eq(400)
        end
      end
      describe "has all invalid key in url" do
        it "returns a 400 status" do
          env = Rack::MockRequest.env_for("/?foofoofoofoo=barbarbarbar")
          status, _headers, _body = app_with_multiple_invalid_keys.call(env)

          expect(status).to eq(400)
        end
      end
    end
  end
end
