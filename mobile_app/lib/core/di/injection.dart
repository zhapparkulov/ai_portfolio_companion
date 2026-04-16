import 'package:get_it/get_it.dart';

import '../../features/chat/data/datasources/chat_remote_datasource.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/send_message_stream.dart';
import '../../features/portfolio/data/datasources/portfolio_mock_datasource.dart';
import '../../features/portfolio/data/repositories/portfolio_repository_impl.dart';
import '../../features/portfolio/domain/repositories/portfolio_repository.dart';
import '../../features/portfolio/domain/usecases/get_portfolio.dart';

/// Service locator. Registrations are kept flat and ordered by layer:
/// data sources -> repositories -> use cases. Cubits are provided at the
/// widget tree boundary via BlocProvider, not registered here.
final GetIt sl = GetIt.instance;

void configureDependencies() {
  // Data sources
  sl.registerLazySingleton<PortfolioMockDataSource>(
    () => PortfolioMockDataSource(),
  );
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSource(),
  );

  // Repositories
  sl.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(sl<PortfolioMockDataSource>()),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl<ChatRemoteDataSource>()),
  );

  // Use cases
  sl.registerFactory<GetPortfolio>(
    () => GetPortfolio(sl<PortfolioRepository>()),
  );
  sl.registerFactory<SendMessageStream>(
    () => SendMessageStream(sl<ChatRepository>()),
  );
}
