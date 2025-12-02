import '../entity/pokemon_detail_entity.dart';
import '../entity/pokemon_view_entity.dart';

abstract class PokemonDetailDatasource {
  Future<void> save(PokemonDetailEntity entity);
  Future<PokemonViewEntity?> getViewById(int id);
  Future<void> deleteAll();
}