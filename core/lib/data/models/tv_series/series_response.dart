import 'package:equatable/equatable.dart';

import 'series_model.dart';

class TvSeriesResponse extends Equatable {
  final List<TvSeriesModel> tvSerieslist;

  const TvSeriesResponse({required this.tvSerieslist});

  factory TvSeriesResponse.fromJson(Map<String, dynamic> json) =>
      TvSeriesResponse(
        tvSerieslist: List<TvSeriesModel>.from((json["results"] as List)
            .map((x) => TvSeriesModel.fromJson(x))
            .where((element) => element.posterPath != null)),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(tvSerieslist.map((x) => x.toJson())),
      };

  @override
  List<Object> get props => [tvSerieslist];
}
