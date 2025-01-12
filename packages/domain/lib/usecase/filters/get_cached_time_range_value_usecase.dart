import 'package:domain/entity/time_range/time_range.dart';
import 'package:domain/storage/filters_storage.dart';
import 'package:injectable/injectable.dart';

/// Юзкейс получения закешированного значение временного промежутка для фильтра
@injectable
class GetCachedTimeRangeValueUsecase {
  final FiltersStorage _storage;

  const GetCachedTimeRangeValueUsecase(this._storage);

  Future<TimeRange?> call() => _storage.getTimeRangeValue();
}
