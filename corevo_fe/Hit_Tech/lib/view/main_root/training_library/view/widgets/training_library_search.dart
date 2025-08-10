import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';

class TrainingLibrarySearch extends StatefulWidget {
  const TrainingLibrarySearch({super.key});

  @override
  State<TrainingLibrarySearch> createState() => _TrainingLibrarySearchState();
}

class _TrainingLibrarySearchState extends State<TrainingLibrarySearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              TrainingAssets.libraryBackground2,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
