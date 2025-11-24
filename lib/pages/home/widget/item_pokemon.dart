import 'package:flutter/material.dart';
import 'package:sprout_pokedex/res/color_res.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/res/image_res.dart';
import 'package:sprout_pokedex/util/string_ext.dart';
import 'package:sprout_pokedex/widgets/app_card.dart';
import 'package:sprout_pokedex/widgets/app_chip_list.dart';
import 'package:sprout_pokedex/widgets/app_network_image.dart';

class ItemPokemon extends StatelessWidget {
  final String id;
  final String name;
  final List<String> types;
  final Color color;
  final String imageUrl;
  final _titleSize = DimenRes.size_16;
  final double _imageSize = DimenRes.size_100;
  final double _padding = DimenRes.size_16;

  const ItemPokemon({
    super.key,
    required this.id,
    required this.name,
    required this.types,
    required this.color,
    required this.imageUrl
  });

  Widget _buildInfo() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(left: _padding, right: _padding, bottom: _padding, top: DimenRes.size_30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                name.firstLetterUpperCase,
                maxLines: 1,
                style: TextStyle(
                  color: ColorRes.white,
                  fontSize: _titleSize,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                )
            ),
            const SizedBox(height: DimenRes.size_8),
            AppChipList(
              appOrientation: Axis.vertical,
              spacing: DimenRes.size_4,
              bgColor: ColorRes.white.withAlpha(30),
              chipDataList: types,
              textStyle: const TextStyle(
                  color: ColorRes.white,
                  fontSize: DimenRes.size_10,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    const scale = 0.6;

    return Align(
      alignment: Alignment.bottomRight,
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: scale,
            heightFactor: scale,
            child: Image.asset(
              ImageRes.pokeBall,
              fit: BoxFit.fill,
              color: ColorRes.white.withAlpha(80),
            ),
          ),
          FractionallySizedBox(
            widthFactor: scale,
            heightFactor: scale,
            child: AppNetworkImage(
              imageUrl: imageUrl,
              imageErrSize: DimenRes.size_60,
              imageSize: DimenRes.size_80
            ),
          )
        ],
      ),
    );
  }

  Widget _buildId() => Align(
    alignment: Alignment.topRight,
    child: Padding(
      padding: const EdgeInsetsGeometry.only(top: DimenRes.size_16, right: DimenRes.size_16, bottom: DimenRes.size_10),
      child: Text(
        id,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: DimenRes.size_12,
            color: ColorRes.black.withAlpha(60)
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: _imageSize,
        maxHeight: _imageSize
      ),
      child: AppCard(
        color: color,
        child: SizedBox(
          height: _imageSize,
          child: Stack(
            children: [
              _buildId(),
              _buildInfo(),
              _buildImage()
            ],
          ),
        ),
      ),
    );
  }
}
