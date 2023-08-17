import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'energy_data.dart';

class EnergyDataTable extends ConsumerWidget {
  const EnergyDataTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final energyData = ref.watch(energyDataProvider);

    return Column(
      children: [
        Table(
          border: TableBorder.all(color: Colors.black),
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.black),
              children: [
                _buildStyledCell('Hours', header: true),
                _buildStyledCell('GF', header: true),
                _buildStyledCell('LF', header: true),
                _buildStyledCell('WF', header: true),
                _buildStyledCell('SF', header: true),
                _buildStyledCell('ES', header: true),
              ],
            ),
          ],
        ),
        Expanded(
            child: ListView.builder(
              itemCount: energyData.hours.length,
              itemBuilder: (context, index) {
                return Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(children: [
                      _buildStyledCell(energyData.hours[index].toString()),
                      _buildStyledCell(energyData.loadGeneration[index].toString()),
                      _buildStyledCell(energyData.loadForecast[index].toString()),
                      _buildStyledCell(energyData.windForecast[index].toString()),
                      _buildStyledCell(energyData.solarForecast[index].toString()),
                      _buildStyledCell(energyData.energyStorage[index].toString()),
                    ]),
                  ],
                );
              },
            )
        )
      ],
    );
  }

  Widget _buildStyledCell(String text, {bool header = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: header ? Color(0xFF009899) : Colors.black,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
