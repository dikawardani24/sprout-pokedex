import '../entity/pokemon_detail_entity.dart';
import '../entity/pokemon_entity.dart';
import '../entity/pokemon_view_entity.dart';

abstract class PokemonDatasource {
  Future<void> save(PokemonEntity entity);
  Future<void> saveBulk(List<PokemonEntity> entities);
  Future<void> saveDetail(PokemonDetailEntity entity);
  Future<List<PokemonEntity>> getPokemonList(int limit, int offset);
  Future<PokemonDetailEntity?> getPokemon(int id);
  Future<PokemonViewEntity> getViewById(int id);
}
