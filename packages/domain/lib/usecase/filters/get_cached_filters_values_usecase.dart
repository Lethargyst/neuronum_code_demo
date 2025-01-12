import 'package:domain/entity/response/prop.dart';
import 'package:domain/storage/filters_storage.dart';
import 'package:injectable/injectable.dart';

/// Юзкейс получения закешированных значений фильтров
@injectable
class GetCachedFiltersValuesUsecase {
  final FiltersStorage _storage;

  const GetCachedFiltersValuesUsecase(this._storage);

  Future<List<Prop>?> call() => _storage.getFilterValues();
}
