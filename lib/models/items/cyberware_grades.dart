import 'package:flutter/foundation.dart'; // For @required if using an older Flutter version, otherwise just use nullable types

/// Represents the properties of a cyberware/bioware grade.
class Grade {
  final String id;
  final String name;
  final double ess;
  final double cost;
  final int deviceRating;
  final String avail; // Kept as String due to "+", "-", and numbers
  final String source;
  final int page;

  const Grade({
    required this.id,
    required this.name,
    required this.ess,
    required this.cost,
    required this.deviceRating,
    required this.avail,
    required this.source,
    required this.page,
  });

  @override
  String toString() {
    return 'Grade(name: $name, id: $id, ess: $ess, cost: $cost, deviceRating: $deviceRating, avail: $avail, source: $source, page: $page)';
  }
}

/// Enum representing different grades of cyberware/bioware.
enum GradeType {
  // Bioware grades (existing - DO NOT CHANGE)
  none,
  standard,
  standardBurnoutsWay,
  used,
  alphaware,
  betaware,
  deltaware,
  gammaware,
  omegaware,
  
  // Cyberware grades
  cyberwareNone,
  cyberwareStandard,
  cyberwareStandardBurnoutsWay,
  cyberwareUsed,
  cyberwareAlphaware,
  cyberwareBetaware,
  cyberwareDeltaware,
  cyberwareGammaware,
  cyberwareOmegaware,
  cyberwareGreyware,
  cyberwareStandardAdapsin,
  cyberwareStandardBurnoutsWayAdapsin,
  cyberwareUsedAdapsin,
  cyberwareAlphawareAdapsin,
  cyberwareBetawareAdapsin,
  cyberwareDeltawareAdapsin,
  cyberwareGammawareAdapsin,
  cyberwareOmegawareAdapsin,
  cyberwareGreywareAdapsin,
}

/// Extension on GradeType to provide grade details and parsing from string.
extension GradeTypeDetails on GradeType {
  Grade get details {
    switch (this) {
      case GradeType.none:
        return const Grade(
          id: '9352d1b0-5288-4bbf-82b5-00073f7effc2',
          name: 'None',
          ess: 1.0,
          cost: 1.0,
          deviceRating: 0,
          avail: '0',
          source: 'SR5',
          page: 1,
        );
      case GradeType.standard:
        return const Grade(
          id: 'f0a67dc0-6b0a-43fa-b389-a110ba1dd59d',
          name: 'Standard',
          ess: 1.0,
          cost: 1.0,
          deviceRating: 0,
          avail: '0',
          source: 'SR5',
          page: 451,
        );
      case GradeType.standardBurnoutsWay:
        return const Grade(
          id: '9166244c-440b-44a1-8795-4917b53e6101',
          name: 'Standard (Burnout\'s Way)',
          ess: 0.8,
          cost: 1.0,
          deviceRating: 0,
          avail: '0',
          source: 'SG',
          page: 177,
        );
      case GradeType.used:
        return const Grade(
          id: 'c4bbffe4-5818-4055-bc5e-f44562bde855',
          name: 'Used',
          ess: 1.25,
          cost: 0.75,
          deviceRating: 0,
          avail: '-4',
          source: 'SR5',
          page: 451,
        );
      case GradeType.alphaware:
        return const Grade(
          id: 'c2c6a3cc-c4bf-42c8-9260-868fd44d34ce',
          name: 'Alphaware',
          ess: 0.8,
          cost: 1.2,
          deviceRating: 0,
          avail: '+2',
          source: 'SR5',
          page: 451,
        );
      case GradeType.betaware:
        return const Grade(
          id: '9e24f0ce-b41e-496f-844a-82805fcb65a9',
          name: 'Betaware',
          ess: 0.7,
          cost: 1.5,
          deviceRating: 0,
          avail: '+4',
          source: 'SR5',
          page: 451,
        );
      case GradeType.deltaware:
        return const Grade(
          id: '2b599ecd-4e80-4669-a78e-4db232c80a83',
          name: 'Deltaware',
          ess: 0.5,
          cost: 2.5,
          deviceRating: 0,
          avail: '+8',
          source: 'SR5',
          page: 451,
        );
      case GradeType.gammaware:
        return const Grade(
          id: '0c86e85c-7e3e-4b6f-aa4b-26d8b379a7c9',
          name: 'Gammaware',
          ess: 0.4,
          cost: 5.0,
          deviceRating: 0,
          avail: '+12',
          source: 'CF',
          page: 72,
        );
      case GradeType.omegaware:
        return const Grade(
          id: 'a6fba72c-9fbe-41dc-8310-cd047b50c81e',
          name: 'Omegaware',
          ess: 1.0,
          cost: 0.75,
          deviceRating: 0,
          avail: '-4',
          source: 'CF',
          page: 71,
        );
      
      // Cyberware grades
      case GradeType.cyberwareNone:
        return const Grade(
          id: '9352d1b0-5288-4bbf-82b5-00073f7effc2',
          name: 'None',
          ess: 1.0,
          cost: 1.0,
          deviceRating: 2,
          avail: '0',
          source: 'SR5',
          page: 1,
        );
      case GradeType.cyberwareStandard:
        return const Grade(
          id: '23382221-fd16-44ec-8da7-9b935ed2c1ee',
          name: 'Standard',
          ess: 1.0,
          cost: 1.0,
          deviceRating: 2,
          avail: '0',
          source: 'SR5',
          page: 451,
        );
      case GradeType.cyberwareStandardBurnoutsWay:
        return const Grade(
          id: '62dd61be-f1c4-4310-8545-73a4a4645393',
          name: 'Standard (Burnout\'s Way)',
          ess: 0.8,
          cost: 1.0,
          deviceRating: 2,
          avail: '0',
          source: 'SG',
          page: 177,
        );
      case GradeType.cyberwareUsed:
        return const Grade(
          id: 'a9aec622-410a-444a-a569-c8d8cc0457b4',
          name: 'Used',
          ess: 1.25,
          cost: 0.75,
          deviceRating: 2,
          avail: '-4',
          source: 'SR5',
          page: 451,
        );
      case GradeType.cyberwareAlphaware:
        return const Grade(
          id: '75da0ff2-4137-4990-85e6-331977564712',
          name: 'Alphaware',
          ess: 0.8,
          cost: 1.2,
          deviceRating: 3,
          avail: '+2',
          source: 'SR5',
          page: 451,
        );
      case GradeType.cyberwareBetaware:
        return const Grade(
          id: 'b1b679e8-72ff-46b5-bd9d-652914731b17',
          name: 'Betaware',
          ess: 0.7,
          cost: 1.5,
          deviceRating: 4,
          avail: '+4',
          source: 'SR5',
          page: 451,
        );
      case GradeType.cyberwareDeltaware:
        return const Grade(
          id: '7ea3a157-867f-4c66-9f62-66b14b36b763',
          name: 'Deltaware',
          ess: 0.5,
          cost: 2.5,
          deviceRating: 5,
          avail: '+8',
          source: 'SR5',
          page: 451,
        );
      case GradeType.cyberwareGammaware:
        return const Grade(
          id: '81b6d909-699b-4fa5-8bb8-a5b2f3996da7',
          name: 'Gammaware',
          ess: 0.4,
          cost: 5.0,
          deviceRating: 6,
          avail: '+12',
          source: 'CF',
          page: 72,
        );
      case GradeType.cyberwareOmegaware:
        return const Grade(
          id: 'dcecd7e5-8cf1-4f83-89fa-177e28cfba03',
          name: 'Omegaware',
          ess: 1.0,
          cost: 0.75,
          deviceRating: 2,
          avail: '-4',
          source: 'CF',
          page: 71,
        );
      case GradeType.cyberwareGreyware:
        return const Grade(
          id: 'e77b7a1f-1c7b-4494-b9b5-6dcb5b61010b',
          name: 'Greyware',
          ess: 0.75,
          cost: 1.3,
          deviceRating: 2,
          avail: '0',
          source: 'BTB',
          page: 158,
        );
      case GradeType.cyberwareStandardAdapsin:
        return const Grade(
          id: '5fc14253-7bf8-4266-af24-072607a86d45',
          name: 'Standard (Adapsin)',
          ess: 0.9,
          cost: 1.0,
          deviceRating: 2,
          avail: '0',
          source: 'SR5',
          page: 451,
        );
      case GradeType.cyberwareStandardBurnoutsWayAdapsin:
        return const Grade(
          id: '4db89466-a1e7-4507-9849-9ce3eef56fc9',
          name: 'Standard (Burnout\'s Way) (Adapsin)',
          ess: 0.7,
          cost: 1.0,
          deviceRating: 2,
          avail: '0',
          source: 'SG',
          page: 177,
        );
      case GradeType.cyberwareUsedAdapsin:
        return const Grade(
          id: 'f248cee4-4629-40ca-83c6-fbf6422d0cd9',
          name: 'Used (Adapsin)',
          ess: 1.125,
          cost: 0.75,
          deviceRating: 2,
          avail: '-4',
          source: 'SR5',
          page: 451,
        );
      case GradeType.cyberwareAlphawareAdapsin:
        return const Grade(
          id: 'aa2393f5-0d01-4b93-988c-d743c35ec22b',
          name: 'Alphaware (Adapsin)',
          ess: 0.7,
          cost: 1.2,
          deviceRating: 3,
          avail: '+2',
          source: 'SR5',
          page: 451,
        );
      case GradeType.cyberwareBetawareAdapsin:
        return const Grade(
          id: '0b15b0c5-4b98-4884-b080-e55a93491507',
          name: 'Betaware (Adapsin)',
          ess: 0.6,
          cost: 1.5,
          deviceRating: 4,
          avail: '+4',
          source: 'SR5',
          page: 451,
        );
      case GradeType.cyberwareDeltawareAdapsin:
        return const Grade(
          id: 'ccb47e88-b940-41de-85fd-8d0f52c04c6e',
          name: 'Deltaware (Adapsin)',
          ess: 0.4,
          cost: 2.5,
          deviceRating: 5,
          avail: '+8',
          source: 'SR5',
          page: 451,
        );
      case GradeType.cyberwareGammawareAdapsin:
        return const Grade(
          id: '210703b8-6df1-4d1b-b5e7-7f1f8a167f74',
          name: 'Gammaware (Adapsin)',
          ess: 0.3,
          cost: 5.0,
          deviceRating: 6,
          avail: '+12',
          source: 'CF',
          page: 72,
        );
      case GradeType.cyberwareOmegawareAdapsin:
        return const Grade(
          id: '453dcb77-f1b2-46d6-9e96-227ecb053297',
          name: 'Omegaware (Adapsin)',
          ess: 0.9,
          cost: 0.75,
          deviceRating: 2,
          avail: '-4',
          source: 'CF',
          page: 71,
        );
      case GradeType.cyberwareGreywareAdapsin:
        return const Grade(
          id: 'c4d67932-0de4-4206-91b6-f3fd504c382f',
          name: 'Greyware (Adapsin)',
          ess: 0.65,
          cost: 1.3,
          deviceRating: 2,
          avail: '0',
          source: 'BTB',
          page: 158,
        );
    }
  }

  /// Returns the GradeType enum value corresponding to the given string name.
  /// Case-insensitive. Handles both bioware and cyberware grades.
  /// If both bioware and cyberware have the same name, specify isCyberware parameter.
  static GradeType fromName(String name, {bool isCyberware = false}) {
    // Normalize the input name for easier matching
    final normalizedName = name.toLowerCase().trim();

    // First check for exact matches in all types
    for (var type in GradeType.values) {
      if (type.details.name.toLowerCase() == normalizedName) {
        // If we have both bioware and cyberware versions, prefer based on isCyberware flag
        if(normalizedName == "none") {
          return isCyberware ? GradeType.cyberwareNone : GradeType.none;
        } else if (normalizedName == "standard") {
          return isCyberware ? GradeType.cyberwareStandard : GradeType.standard;
        } else if (normalizedName == "standard (burnout's way)") {
          return isCyberware ? GradeType.cyberwareStandardBurnoutsWay : GradeType.standardBurnoutsWay;
        } else if (normalizedName == "used") {
          return isCyberware ? GradeType.cyberwareUsed : GradeType.used;
        } else if (normalizedName == "alphaware") {
          return isCyberware ? GradeType.cyberwareAlphaware : GradeType.alphaware;
        } else if (normalizedName == "betaware") {
          return isCyberware ? GradeType.cyberwareBetaware : GradeType.betaware;
        } else if (normalizedName == "deltaware") {
          return isCyberware ? GradeType.cyberwareDeltaware : GradeType.deltaware;
        } else if (normalizedName == "gammaware") {
          return isCyberware ? GradeType.cyberwareGammaware : GradeType.gammaware;
        } else if (normalizedName == "omegaware") {
          return isCyberware ? GradeType.cyberwareOmegaware : GradeType.omegaware;
        }
        // For unique names, return the match
        return type;
      }
    }
    // Return default based on type
    return isCyberware ? GradeType.cyberwareStandard : GradeType.standard;
  }
}