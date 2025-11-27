import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class DetailTitle extends StatelessWidget{
  final AppPokemonDetail pokemon;

  const DetailTitle({super.key, required this.pokemon});

  Widget _titleSmall() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pokemon.pokenumber,
          maxLines: 1,
          textAlign: TextAlign.end,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: DimenRes.size_20,
              color: ColorRes.black.withAlpha(60),
              overflow: TextOverflow.ellipsis
          ),
        ),
        Text(pokemon.name.firstLetterUpperCase,
          maxLines: 1,
          style: const TextStyle(
              fontSize: DimenRes.size_20,
              fontWeight: FontWeight.bold,
              color: ColorRes.white,
              overflow: TextOverflow.ellipsis
          ),
        ),
        const SizedBox(height: DimenRes.size_8,),
        AppChipList(
          appOrientation: Axis.vertical,
          spacing: DimenRes.size_4,
          bgColor: ColorRes.white.withAlpha(30),
          chipDataList: pokemon.types,
          textStyle: const TextStyle(
            color: ColorRes.white,
            fontSize: DimenRes.size_10,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _titleNormal() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pokemon.name.firstLetterUpperCase,
                maxLines: 1,
                style: const TextStyle(
                    fontSize: DimenRes.size_20,
                    fontWeight: FontWeight.bold,
                    color: ColorRes.white,
                    overflow: TextOverflow.ellipsis
                ),
              ),
              const SizedBox(height: DimenRes.size_8,),
              AppChipList(
                appOrientation: Axis.horizontal,
                spacing: DimenRes.size_4,
                bgColor: ColorRes.white.withAlpha(30),
                chipDataList: pokemon.types,
                textStyle: const TextStyle(
                  color: ColorRes.white,
                  fontSize: DimenRes.size_10,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        Text(
          pokemon.pokenumber,
          maxLines: 1,
          textAlign: TextAlign.end,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: DimenRes.size_20,
              color: ColorRes.black.withAlpha(60),
              overflow: TextOverflow.ellipsis

          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MinimumWidth(
        minWidth: DimenRes.size_200,
        onSmall: _titleSmall(),
        child: _titleNormal()
    );
  }

}