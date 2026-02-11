import 'dart:developer';

import 'package:equatable/equatable.dart';

import '../../../domain/entities/tv_series/series.dart';
import '../../../domain/entities/tv_series/series_detail.dart';

class TvSeriesTable extends Equatable {
  final int id;
  final String? originalName;
  final String? posterPath;
  final String? overview;

  const TvSeriesTable({
    required this.id,
    required this.originalName,
    required this.posterPath,
    required this.overview,
  });

  factory TvSeriesTable.fromEntity(TvSeriesDetail series) {
    log("zzzz masuk${series.originalName!}");
    return TvSeriesTable(
      id: series.id!,
      originalName: series.originalName,
      posterPath: series.posterPath,
      overview: series.overview,
    );
  }

  factory TvSeriesTable.fromMap(Map<String, dynamic> map) => TvSeriesTable(
        id: map['id'],
        originalName: map['original_name'],
        posterPath: map['posterPath'],
        overview: map['overview'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'original_name': originalName,
        'posterPath': posterPath,
        'overview': overview,
      };

  TvSeries toEntity() => TvSeries.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        originalName: originalName,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [id, originalName, posterPath, overview];
}
