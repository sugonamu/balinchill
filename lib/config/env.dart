import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env') // Specify the location of your .env file
class Env {
  @EnviedField(varName: 'API_BASE_URL') // Bind the API_BASE_URL from the .env file
  static const String apiBaseUrl = '';
}
