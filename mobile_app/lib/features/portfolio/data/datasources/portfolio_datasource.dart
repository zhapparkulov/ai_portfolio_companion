import '../models/portfolio_model.dart';

abstract class PortfolioDataSource {
  Future<PortfolioModel> fetchPortfolio();
}
