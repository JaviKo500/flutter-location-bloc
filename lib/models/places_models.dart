// To parse this JSON data, do
//
//     final placesResponse = placesResponseFromMap(jsonString);

import 'dart:convert';

class PlacesResponse {
    PlacesResponse({
        required this.type,
        // required this.query,
        required this.features,
        required this.attribution,
    });

    final String type;
    // final List<String> query;
    final List<Feature> features;
    final String attribution;

    factory PlacesResponse.fromJson(String str) => PlacesResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PlacesResponse.fromMap(Map<String, dynamic> json) => PlacesResponse(
        type: json["type"],
        // query: List<String>.from(json["query"].map((x) => x)),
        features: List<Feature>.from(json["features"].map((x) => Feature.fromMap(x))),
        attribution: json["attribution"],
    );

    Map<String, dynamic> toMap() => {
        "type": type,
        // "query": List<dynamic>.from(query.map((x) => x)),
        "features": List<dynamic>.from(features.map((x) => x.toMap())),
        "attribution": attribution,
    };
}

class Feature {
    Feature({
      required  this.id,
      required  this.type,
      required  this.placeType,
      required  this.properties,
      required  this.textEs,
      required  this.languageEs,
      required  this.placeNameEs,
      required  this.text,
      required  this.language,
      required  this.placeName,
      required  this.center,
      required  this.geometry,
      required  this.context,
      required  this.matchingText,
      required  this.matchingPlaceName,
    });

    final String id;
    final String type;
    final List<String> placeType;
    final Properties properties;
    final String textEs;
    final Language? languageEs;
    final String placeNameEs;
    final String text;
    final Language? language;
    final String placeName;
    final List<double> center;
    final Geometry geometry;
    final List<Context> context;
    final String? matchingText;
    final String? matchingPlaceName;

    factory Feature.fromJson(String str) => Feature.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Feature.fromMap(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        properties: Properties.fromMap(json["properties"]),
        textEs: json["text_es"],
        languageEs: json["language_es"] == null ? null : languageValues.map[json["language_es"]],
        placeNameEs: json["place_name_es"],
        text: json["text"],
        language: json["language"] == null ? null : languageValues.map[json["language"]],
        placeName: json["place_name"],
        center: List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: Geometry.fromMap(json["geometry"]),
        context: List<Context>.from(json["context"].map((x) => Context.fromMap(x))),
        matchingText: json["matching_text"],
        matchingPlaceName: json["matching_place_name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "properties": properties.toMap(),
        "text_es": textEs,
        "language_es": languageEs == null ? null : languageValues.reverse[languageEs],
        "place_name_es": placeNameEs,
        "text": text,
        "language": language == null ? null : languageValues.reverse[language],
        "place_name": placeName,
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toMap(),
        "context": List<dynamic>.from(context.map((x) => x.toMap())),
        "matching_text": matchingText,
        "matching_place_name": matchingPlaceName,
    };

    @override
  String toString() {
    // TODO: implement toString
    return 'Feature: $text';
  }
}

class Context {
    Context({
      required this.id,
      required this.textEs,
      required this.text,
      required this.wikidata,
      required this.languageEs,
      required this.language,
      required this.shortCode,
    });

    final Id id;
    final Text_place textEs;
    final Text_place text;
    final Wikidata? wikidata;
    final Language? languageEs;
    final Language? language;
    final ShortCode? shortCode;

    factory Context.fromJson(String str) => Context.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Context.fromMap(Map<String, dynamic> json) => Context(
        id: idValues.map[json["id"]]!,
        textEs: textValues.map[json["text_es"]]!,
        text: textValues.map[json["text"]]!,
        wikidata: json["wikidata"] == null ? null : wikidataValues.map[json["wikidata"]],
        languageEs: json["language_es"] == null ? null : languageValues.map[json["language_es"]],
        language: json["language"] == null ? null : languageValues.map[json["language"]],
        shortCode: json["short_code"] == null ? null : shortCodeValues.map[json["short_code"]],
    );

    Map<String, dynamic> toMap() => {
        "id": idValues.reverse[id],
        "text_es": textValues.reverse[textEs],
        "text": textValues.reverse[text],
        "wikidata": wikidata == null ? null : wikidataValues.reverse[wikidata],
        "language_es": languageEs == null ? null : languageValues.reverse[languageEs],
        "language": language == null ? null : languageValues.reverse[language],
        "short_code": shortCode == null ? null : shortCodeValues.reverse[shortCode],
    };
}

enum Id { POSTCODE_4912821565726190, PLACE_7360325534437990, REGION_8891273556815980, COUNTRY_17210117100747030, POSTCODE_8644471447210010 }

final idValues = EnumValues({
    "country.17210117100747030": Id.COUNTRY_17210117100747030,
    "place.7360325534437990": Id.PLACE_7360325534437990,
    "postcode.4912821565726190": Id.POSTCODE_4912821565726190,
    "postcode.8644471447210010": Id.POSTCODE_8644471447210010,
    "region.8891273556815980": Id.REGION_8891273556815980
});

enum Language { ES }

final languageValues = EnumValues({
    "es": Language.ES
});

enum ShortCode { EC_A, EC }

final shortCodeValues = EnumValues({
    "ec": ShortCode.EC,
    "EC-A": ShortCode.EC_A
});

enum Text_place { THE_0101, CANTN_CUENCA, PROVINCIA_DE_AZUAY, ECUADOR, THE_0102 }

final textValues = EnumValues({
    "Cantón Cuenca": Text_place.CANTN_CUENCA,
    "Ecuador": Text_place.ECUADOR,
    "Provincia de Azuay": Text_place.PROVINCIA_DE_AZUAY,
    "0101": Text_place.THE_0101,
    "0102": Text_place.THE_0102
});

enum Wikidata { Q629038, Q220451, Q736 }

final wikidataValues = EnumValues({
    "Q220451": Wikidata.Q220451,
    "Q629038": Wikidata.Q629038,
    "Q736": Wikidata.Q736
});

class Geometry {
    Geometry({
      required  this.coordinates,
      required  this.type,
    });

    final List<double> coordinates;
    final String type;

    factory Geometry.fromJson(String str) => Geometry.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Geometry.fromMap(Map<String, dynamic> json) => Geometry(
        coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
        type: json["type"],
    );

    Map<String, dynamic> toMap() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "type": type,
    };
}

class Properties {
    Properties({
      required  this.foursquare,
      required  this.landmark,
      required  this.wikidata,
      required  this.address,
      required  this.category,
      required  this.maki,
    });

    final String foursquare;
    final bool landmark;
    final String? wikidata;
    final String? address;
    final String category;
    final String? maki;

    factory Properties.fromJson(String str) => Properties.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Properties.fromMap(Map<String, dynamic> json) => Properties(
        foursquare: json["foursquare"],
        landmark: json["landmark"],
        wikidata: json["wikidata"],
        address: json["address"],
        category: json["category"],
        maki: json["maki"],
    );

    Map<String, dynamic> toMap() => {
        "foursquare": foursquare,
        "landmark": landmark,
        "wikidata": wikidata,
        "address": address,
        "category": category,
        "maki": maki,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String>? reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
      reverseMap ??= map.map((k, v) => MapEntry(v, k));
      return reverseMap!;
    }
}
