import '../entity/pokemon_entity.dart';

abstract class PokemonDatasource {
  Future<void> save(PokemonEntity entity);
  Future<void> saveBulk(List<PokemonEntity> entities);
  Future<List<PokemonEntity>> findByLimitAndOffset(int limit, int offset);
  Future<void> deleteAll();
}
