import 'package:database/db_init.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'tables/pokemon_view.dart';
import 'tables/table_pokemon.dart';
import 'tables/table_pokemon_detail.dart';

@injectable
class DbOpenHelper {
  final DbInit _dbInit;
  final _dbName = "pokedex.db";
  final _version = 1;

  DbOpenHelper(this._dbInit);

  Future<Database> get db async {
    await _dbInit.initialize();
    return await openDatabase(
      join(await getDatabasesPath(), _dbName),
      version: _version,
      onCreate: _onCreate,
    );
  }

  OnDatabaseCreateFn get _onCreate => (db, _) {
    _createTablePokemon(db);
    _createTablePokemonDetail(db);
    _createPokemonView(db);
  };

  void _createTablePokemon(Database db) {
    final sql = """
    CREATE TABLE ${TablePokemon.name} (
    ${TablePokemon.colId} INTEGER PRIMARY KEY,
    ${TablePokemon.colName} TEXT,
    ${TablePokemon.colTypes} TEXT
    )
    """;
    db.execute(sql);
  }

  void _createTablePokemonDetail(Database db) {
    final sql = """
    CREATE TABLE ${TablePokemonDetail.name} (
    ${TablePokemonDetail.colId} INTEGER PRIMARY KEY,
    ${TablePokemonDetail.colName} TEXT,
    ${TablePokemonDetail.colTypes} TEXT,
    ${TablePokemonDetail.colSpeciesName} TEXT,
    ${TablePokemonDetail.colSpeciesDes} TEXT,
    ${TablePokemonDetail.colHeight} INTEGER,
    ${TablePokemonDetail.colWeight} INTEGER,
    ${TablePokemonDetail.colCatchRate} INTEGER,
    ${TablePokemonDetail.colBaseExp} INTEGER,
    ${TablePokemonDetail.colGrowRate} TEXT,
    ${TablePokemonDetail.colEggGroups} TEXT,
    ${TablePokemonDetail.eggCycles} INTEGER,
    ${TablePokemonDetail.colStats} TEXT,
    ${TablePokemonDetail.colAbilities} TEXT,
    ${TablePokemonDetail.colWeaknesses} TEXT
    )
    """;
    db.execute(sql);
  }

  void _createPokemonView(Database db) {
    final sql = """
  CREATE VIEW IF NOT EXISTS ${PokemonView.name} AS
  SELECT 
    p.${TablePokemon.colId} as ${TablePokemon.colId},
    COALESCE(pd.${TablePokemonDetail.colName}, p.${TablePokemon.colName}) as ${TablePokemon.colName},
    p.${TablePokemon.colTypes} as ${TablePokemon.colTypes},
    pd.${TablePokemonDetail.colSpeciesName} as ${TablePokemonDetail.colSpeciesName},
    pd.${TablePokemonDetail.colSpeciesDes} as ${TablePokemonDetail.colSpeciesDes},
    pd.${TablePokemonDetail.colHeight} as ${TablePokemonDetail.colHeight},
    pd.${TablePokemonDetail.colWeight} as ${TablePokemonDetail.colWeight},
    pd.${TablePokemonDetail.colCatchRate} as ${TablePokemonDetail.colCatchRate},
    pd.${TablePokemonDetail.colBaseExp} as ${TablePokemonDetail.colBaseExp},
    pd.${TablePokemonDetail.colGrowRate} as ${TablePokemonDetail.colGrowRate},
    pd.${TablePokemonDetail.colEggGroups} as ${TablePokemonDetail.colEggGroups},
    pd.${TablePokemonDetail.eggCycles} as ${TablePokemonDetail.eggCycles},
    pd.${TablePokemonDetail.colStats} as ${TablePokemonDetail.colStats},
    pd.${TablePokemonDetail.colAbilities} as ${TablePokemonDetail.colAbilities},
    pd.${TablePokemonDetail.colWeaknesses} as ${TablePokemonDetail.colWeaknesses}
  FROM ${TablePokemon.name} p
  LEFT JOIN ${TablePokemonDetail.name} pd ON p.${TablePokemon.colId} = pd.${TablePokemonDetail.colId}
  """;
    db.execute(sql);
  }
}