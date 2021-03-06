describe AuthorizationEndpoint, '.discover' do
  let(:url) { 'https://example.com' }

  let(:endpoint) { 'https://example.com/authorization_endpoint' }

  let :http_response_headers do
    { 'Content-Type': 'text/html' }
  end

  context 'when given a URL that does not advertise an endpoint' do
    before do
      stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
    end

    it 'returns nil' do
      expect(described_class.discover(url)).to be_nil
    end
  end

  context 'when given a URL advertising its endpoint in an HTTP Link header' do
    # Similar to https://webmention.rocks/test/1
    context 'when the HTTP Link header references a relative URL and the `rel` parameter is unquoted' do
      before do
        stub_request(:get, url).to_return(headers: { 'Link': '</authorization_endpoint>; rel=authorization_endpoint' })
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(endpoint)
      end
    end

    # Similar to https://webmention.rocks/test/2
    context 'when the HTTP Link header references an absolute URL and the `rel` parameter is unquoted' do
      before do
        stub_request(:get, url).to_return(headers: { 'Link': %(<#{endpoint}>; rel=authorization_endpoint) })
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(endpoint)
      end
    end

    # Similar to https://webmention.rocks/test/7
    context 'when the HTTP Link header has strange casing' do
      before do
        stub_request(:get, url).to_return(headers: { 'LinK' => %(<#{endpoint}>; rel=authorization_endpoint) })
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(endpoint)
      end
    end

    # Similar to https://webmention.rocks/test/8
    context 'when the `rel` parameter is quoted' do
      before do
        stub_request(:get, url).to_return(headers: { 'Link': %(<#{endpoint}>; rel="authorization_endpoint") })
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(endpoint)
      end
    end

    # Similar to https://webmention.rocks/test/10
    context 'when the `rel` parameter contains multiple space-separated values' do
      before do
        stub_request(:get, url).to_return(headers: { 'Link': %(<#{endpoint}>; rel="authorization_endpoint somethingelse") })
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(endpoint)
      end
    end

    # Similar to https://webmention.rocks/test/18
    context 'when the response includes multiple HTTP Link headers' do
      before do
        stub_request(:get, url).to_return(headers: { 'Link': [%(<#{endpoint}>; rel="authorization_endpoint"), '</authorization_endpoint/error>; rel="other"'] })
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(endpoint)
      end
    end

    # Similar to https://webmention.rocks/test/19
    context 'when the HTTP Link header contains multiple comma-separated values' do
      before do
        stub_request(:get, url).to_return(headers: { 'Link': %(</authorization_endpoint/error>; rel="other", <#{endpoint}>; rel="authorization_endpoint") })
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(endpoint)
      end
    end

    # Similar to https://webmention.rocks/test/23
    context 'when the HTTP Link header redirects to a relative URL' do
      let(:url) { 'https://example.com/page' }

      let(:endpoint) { 'https://example.com/page/authorization_endpoint/endpoint' }

      before do
        stub_request(:get, url).to_return(headers: { 'Location': 'page/authorization_endpoint' }, status: 302)

        stub_request(:get, "#{url}/authorization_endpoint").to_return(headers: http_response_headers.merge('Link': "<#{endpoint}>; rel=authorization_endpoint"))
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(endpoint)
      end
    end
  end

  context 'when given a URL advertising its endpoint in an HTML `link` element' do
    # Similar to https://webmention.rocks/test/3
    context 'when the `link` element references a relative URL' do
      let(:url) { 'https://example.com/link_element_relative_url' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(endpoint)
      end
    end

    # Similar to https://webmention.rocks/test/4
    context 'when the `link` element references an absolute URL' do
      let(:url) { 'https://example.com/link_element_absolute_url' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(endpoint)
      end
    end

    # Similar to https://webmention.rocks/test/9
    context 'when the `rel` attribute contains multiple space-separated values' do
      let(:url) { 'https://example.com/link_element_multiple_rel_values' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(endpoint)
      end
    end

    # Similar to https://webmention.rocks/test/12
    context 'when the `rel` attribute contains similar values' do
      let(:url) { 'https://example.com/link_element_exact_match' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(endpoint)
      end
    end

    # Similar to https://webmention.rocks/test/13
    context 'when the HTML contains an endpoint in an HTML comment' do
      let(:url) { 'https://example.com/link_element_html_comment' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(endpoint)
      end
    end

    # Similar to https://webmention.rocks/test/15
    context 'when the `href` attribute is empty' do
      let(:url) { 'https://example.com/link_element_empty_href' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(url)
      end
    end

    # Similar to https://webmention.rocks/test/20
    context 'when the `href` attribute does not exist' do
      let(:url) { 'https://example.com/link_element_no_href' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(endpoint)
      end
    end

    # Similar to https://webmention.rocks/test/21
    context 'when `link` element references a URL with a query string' do
      let(:url) { 'https://example.com/link_element_query_string' }

      let(:endpoint) { 'https://example.com/authorization_endpoint?query=yes' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(endpoint)
      end
    end

    # Similar to https://webmention.rocks/test/22
    context 'when the `link` element references a URL relative to the page' do
      let(:url) { 'https://example.com/link_element/relative_path' }

      let(:endpoint) { 'https://example.com/link_element/relative_path/authorization_endpoint' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns the endpoint' do
        expect(described_class.discover(url)).to eq(endpoint)
      end
    end

    context 'when the `link` element references an invalid URL' do
      let(:url) { 'https://example.com/link_element/invalid_href' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'raises an InvalidURIError' do
        expect { described_class.discover(url) }.to raise_error(AuthorizationEndpoint::InvalidURIError)
      end
    end
  end

  # Similar to https://webmention.rocks/test/11
  context 'when given a URL advertising multiple endpoints' do
    let(:url) { 'https://example.com/multiple_endpoints' }

    before do
      stub_request(:get, url).to_return(headers: http_response_headers.merge('Link': %(<#{endpoint}>; rel="authorization_endpoint")), body: read_fixture(url))
    end

    it 'returns the endpoint' do
      expect(described_class.discover(url)).to eq(endpoint)
    end
  end
end
