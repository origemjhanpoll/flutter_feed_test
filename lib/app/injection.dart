import 'package:flutter_feed_test/app/repositories/i_repository.dart';
import 'package:flutter_feed_test/app/repositories/repository.dart';
import 'package:flutter_feed_test/app/services/local_service.dart';
import 'package:flutter_feed_test/app/services/remote_service.dart';
import 'package:flutter_feed_test/app/viewmodel/post_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final di = GetIt.instance;

Future<void> init() async {
  di.registerLazySingleton<http.Client>(() => http.Client());
  di.registerLazySingleton<RemoteService>(() => RemoteService(http.Client()));
  di.registerLazySingleton<LocalService>(() => LocalService());
  di.registerLazySingleton<IRepository>(
    () => Repository(
      remoteService: di<RemoteService>(),
      localService: di<LocalService>(),
    ),
  );
  di.registerFactory<PostCubit>(() => PostCubit(repository: di<IRepository>()));
}
