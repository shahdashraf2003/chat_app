import 'package:chat_app/core/cache_helper.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setUpServiceLocator() {
  getIt.registerLazySingleton<CacheHelper>(() => CacheHelper());
}
