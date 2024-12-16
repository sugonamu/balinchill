import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')  
class Env {
  @EnviedField(varName: 'BACKEND_URL')  
  static const String backendUrl = _Env.backendUrl;
}
