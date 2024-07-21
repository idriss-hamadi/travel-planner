import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_maps/maps.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<Model> data;
  late MapShapeSource _mapSource;

  @override
  void initState() {
    data = <Model>[
      Model('United States', Color.fromRGBO(255, 215, 0, 1.0), 'USA'),
      Model('Brazil', Color.fromRGBO(72, 209, 204, 1.0), 'Brazil'),
      Model('Russia', Colors.red.withOpacity(0.85), 'Russia'),
      Model('India', Color.fromRGBO(171, 56, 224, 0.75), 'India'),
      Model('China', Color.fromRGBO(126, 247, 74, 0.75), 'China'),
      Model('Australia', Color.fromRGBO(79, 60, 201, 0.7), 'Australia'),
      Model('Canada', Color.fromRGBO(99, 164, 230, 1), 'Canada'),
      Model('South Africa', Colors.teal, 'South Africa')
    ];

    _mapSource = MapShapeSource.asset(
      'assets/world_map.json',
      shapeDataField: 'name',
      dataCount: data.length,
      primaryValueMapper: (int index) => data[index].country,
      dataLabelMapper: (int index) => data[index].countryCode,
      shapeColorValueMapper: (int index) => data[index].color,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Container(
        height: 520,
        child: Center(
          child: SfMaps(
            layers: <MapShapeLayer>[
              MapShapeLayer(
                source: _mapSource,
                legend: MapLegend(MapElement.shape),
                showDataLabels: true,
                shapeTooltipBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(7),
                    child: Text(data[index].countryCode,
                        style: themeData.textTheme.bodySmall!
                            .copyWith(color: themeData.colorScheme.surface)),
                  );
                },
                tooltipSettings: MapTooltipSettings(
                    color: Colors.grey[700],
                    strokeColor: Colors.white,
                    strokeWidth: 2),
                strokeColor: Colors.white,
                strokeWidth: 0.5,
                dataLabelSettings: MapDataLabelSettings(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: themeData.textTheme.bodySmall!.fontSize)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Model {
  Model(this.country, this.color, this.countryCode);

  String country;
  Color color;
  String countryCode;
}