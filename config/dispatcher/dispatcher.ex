defmodule Dispatcher do
  use Matcher
  define_accept_types [
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ],
    any: ["*/*"]
  ]

  @any %{}
  @json %{ accept: %{ json: true } }
  @html %{ accept: %{ html: true } }

  define_layers [ :static, :services, :fall_back, :not_found ]

  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule:
  #
  # match "/themes/*path", @json do
  #   Proxy.forward conn, path, "http://resource/themes/"
  # end
  #
  # Run `docker-compose restart dispatcher` after updating
  # this file.

  match "/personen/*path", %{layer: :services, accept: %{json: true}} do
    forward(conn, path, "http://resource/personen/")
  end

  match "/geslacht-codes/*path", %{layer: :services, accept: %{json: true}} do
    forward(conn, path, "http://resource/geslacht-codes/")
  end

  match "/nationalities/*path", %{layer: :services, accept: %{json: true}} do
    Proxy.forward(conn, path, "http://resource/nationalities/")
  end

  match "/concepts/*path", %{layer: :services, accept: %{json: true}} do
    Proxy.forward(conn, path, "http://resource/concepts/")
  end

  match "/concept-schemes/*path", %{layer: :services, accept: %{json: true}} do
    Proxy.forward(conn, path, "http://resource/concept-schemes/")
  end

  match "/identificatoren/*path", %{layer: :services, accept: %{json: true}} do
    forward(conn, path, "http://resource/identificatoren/")
  end

  match "/form-content/*path", %{layer: :services, accept: %{any: true}} do
    forward(conn, path, "http://form-content/")
  end

  match "/mock/sessions/*path" do
    forward(conn, path, "http://mocklogin/sessions/")
  end

  match "/gebruikers/*path", %{layer: :services, accept: %{any: true}} do
    forward(conn, path, "http://resource/gebruikers/")
  end

  match "/accounts/*path", %{layer: :services, accept: %{any: true}} do
    forward(conn, path, "http://resource/accounts/")
  end

  match "/sessions/*path", %{layer: :services, accept: %{any: true}} do
    Proxy.forward(conn, path, "http://login/sessions/")
  end

  match "/bestuurseenheden/*path", %{layer: :services, accept: %{any: true}} do
    forward(conn, path, "http://resource/bestuurseenheden/")
  end

  match "/*_", %{ layer: :not_found } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end
end
