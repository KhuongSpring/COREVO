import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hit_tech/model/response/training/training_schedule_response.dart';

import '../../../core/constants/app_assets.dart';

class TrainingDayStartTrainingScreen extends StatefulWidget {
  final TrainingScheduleResponse schedule;

  const TrainingDayStartTrainingScreen({super.key, required this.schedule});

  @override
  State<TrainingDayStartTrainingScreen> createState() =>
      _TrainingDayStartTrainingScreenState();
}

class _TrainingDayStartTrainingScreenState
    extends State<TrainingDayStartTrainingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        title: Center(child: Text(widget.schedule.name)),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              '00:00',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              TrainingAssets.mainBackground,
              fit: BoxFit.cover,
            ),
          ),


        ],
      ),
    );
  }
}
