{{#http_with_auth}}import 'package:core/service/http/http_auth.dart';{{/http_with_auth}}
{{^http_with_auth}}import 'package:core/service/http/http_unauth.dart';{{/http_with_auth}}
import 'package:core/ typedefs.dart'; 
import 'package:injectable/injectable.dart';

@injectable
class {{repository_name.pascalCase()}}Api {
  {{#http_with_auth}}final HttpAuth _http;{{/http_with_auth}}
  {{^http_with_auth}}final HttpUnauth _http;{{/http_with_auth}}

  const {{repository_name.pascalCase()}}Api(this._http);

  ApiRequest exampleMethod() async => _http.get(
        uri: "/",
      );
}
