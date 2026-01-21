import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/local_data_source.dart';
import '../../data/local/hive_data_source.dart';

part 'data_providers.g.dart';

/// Provider for LocalDataSource (Hive implementation)
/// Using keepAlive to maintain the singleton instance
@Riverpod(keepAlive: true)
LocalDataSource localDataSource(LocalDataSourceRef ref) {
  return HiveDataSource();
}
