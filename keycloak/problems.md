3 problems currently
1. /login 500 Internal Server Error - openidc.lua:1475: authenticate(): request to the redirect_uri path but there's no session state found
    1. apisix / lua-resty-session cookie expiration and /login redirect
    2. keycloak Your login attempt timed out. Login will start from the beginning. - and generation of a new state / session code (not matching apisix / lua-resty-session)
2. keycloak logout Missing parameters: id_token_hint
    1. https://github.com/keycloak/keycloak/issues/10164#issuecomment-1494221704
    2. should be fixed in keycloak 21.1.0
3. keycloak - You are already logged in.
    1. https://github.com/keycloak/keycloak/issues/12406#issuecomment-1251994343