
RSpec.describe Gotenberg::Client do
  let (:client) { described_class.new("http://gotenberg.example.com") }
  before do
    stub_request(:post, "http://gotenberg.example.com/forms/chromium/convert/html")
  end

  context "service down" do
    before do
      stub_request(:get, "http://gotenberg.example.com/health").to_return(status: 502, body: 'Bad Gateway')
    end

    describe "#up?" do
      it "returns false" do
        client_status = client.up?

        expect(client_status).to eq(false)
      end
    end

    describe "#html" do
      it "returns early without doing a request" do
        result = client.html("<html />", StringIO.new)

        expect(result).to eq(false)
        expect(a_request(:post, "http://gotenberg.example.com/forms/chromium/convert/html")).not_to have_been_made

      end
    end
  end

  context "service up" do
    before do
      stub_request(:get, "http://gotenberg.example.com/health").to_return(status: 200, body: '{"status": "up"}')
    end

    describe '#up?' do
      it "returns true if service is up" do
        client_status = client.up?

        expect(client_status).to eq(true)
      end
    end

    describe "#html" do
      it "does a request" do
        result = client.html("<html />", StringIO.new)

        expect(result).not_to eq(false)
        expect(a_request(:post, "http://gotenberg.example.com/forms/chromium/convert/html")).to have_been_made
      end

      it "forwards options to the API" do
        result = client.html("<html />", StringIO.new, preferCssPageSize: true)

        expect(WebMock).to have_requested(:post, "http://gotenberg.example.com/forms/chromium/convert/html")
        .with { |request|
          parsed_request = parse_multipart_message(request)
          interesting_part = parsed_request[:parts].find { _1[:part].name == "preferCssPageSize" }
          expect(interesting_part[:body]).to eq(["true"])
        }
      end
    end
  end
end
