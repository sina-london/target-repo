// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetThemeSettingsCollection on Isar {
  IsarCollection<ThemeSettings> get themeSettings => this.collection();
}

const ThemeSettingsSchema = CollectionSchema(
  name: r'ThemeSettings',
  id: 815540309993789807,
  properties: {
    r'amoled': PropertySchema(
      id: 0,
      name: r'amoled',
      type: IsarType.bool,
    ),
    r'appBarOpacity': PropertySchema(
      id: 1,
      name: r'appBarOpacity',
      type: IsarType.double,
    ),
    r'blendLevel': PropertySchema(
      id: 2,
      name: r'blendLevel',
      type: IsarType.long,
    ),
    r'bottomBarOpacity': PropertySchema(
      id: 3,
      name: r'bottomBarOpacity',
      type: IsarType.double,
    ),
    r'colorScheme': PropertySchema(
      id: 4,
      name: r'colorScheme',
      type: IsarType.string,
    ),
    r'defaultRadius': PropertySchema(
      id: 5,
      name: r'defaultRadius',
      type: IsarType.double,
    ),
    r'flexSchemeEnum': PropertySchema(
      id: 6,
      name: r'flexSchemeEnum',
      type: IsarType.byte,
      enumMap: _ThemeSettingsflexSchemeEnumEnumValueMap,
    ),
    r'flexTabBarStyleEnum': PropertySchema(
      id: 7,
      name: r'flexTabBarStyleEnum',
      type: IsarType.byte,
      enumMap: _ThemeSettingsflexTabBarStyleEnumEnumValueMap,
    ),
    r'surfaceModeDark': PropertySchema(
      id: 8,
      name: r'surfaceModeDark',
      type: IsarType.double,
    ),
    r'surfaceModeLight': PropertySchema(
      id: 9,
      name: r'surfaceModeLight',
      type: IsarType.double,
    ),
    r'swapDarkColors': PropertySchema(
      id: 10,
      name: r'swapDarkColors',
      type: IsarType.bool,
    ),
    r'swapLightColors': PropertySchema(
      id: 11,
      name: r'swapLightColors',
      type: IsarType.bool,
    ),
    r'tabBarOpacity': PropertySchema(
      id: 12,
      name: r'tabBarOpacity',
      type: IsarType.double,
    ),
    r'tabBarStyle': PropertySchema(
      id: 13,
      name: r'tabBarStyle',
      type: IsarType.string,
    ),
    r'themeMode': PropertySchema(
      id: 14,
      name: r'themeMode',
      type: IsarType.string,
    ),
    r'tooltipsMatchBackground': PropertySchema(
      id: 15,
      name: r'tooltipsMatchBackground',
      type: IsarType.bool,
    ),
    r'transparentStatusBar': PropertySchema(
      id: 16,
      name: r'transparentStatusBar',
      type: IsarType.bool,
    ),
    r'useAppbarColors': PropertySchema(
      id: 17,
      name: r'useAppbarColors',
      type: IsarType.bool,
    ),
    r'useKeyColors': PropertySchema(
      id: 18,
      name: r'useKeyColors',
      type: IsarType.bool,
    ),
    r'useMaterial3': PropertySchema(
      id: 19,
      name: r'useMaterial3',
      type: IsarType.bool,
    ),
    r'useSubThemes': PropertySchema(
      id: 20,
      name: r'useSubThemes',
      type: IsarType.bool,
    ),
    r'useTertiary': PropertySchema(
      id: 21,
      name: r'useTertiary',
      type: IsarType.bool,
    ),
    r'useTextTheme': PropertySchema(
      id: 22,
      name: r'useTextTheme',
      type: IsarType.bool,
    )
  },
  estimateSize: _themeSettingsEstimateSize,
  serialize: _themeSettingsSerialize,
  deserialize: _themeSettingsDeserialize,
  deserializeProp: _themeSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _themeSettingsGetId,
  getLinks: _themeSettingsGetLinks,
  attach: _themeSettingsAttach,
  version: '3.1.0+1',
);

int _themeSettingsEstimateSize(
  ThemeSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.colorScheme.length * 3;
  bytesCount += 3 + object.tabBarStyle.length * 3;
  bytesCount += 3 + object.themeMode.length * 3;
  return bytesCount;
}

void _themeSettingsSerialize(
  ThemeSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.amoled);
  writer.writeDouble(offsets[1], object.appBarOpacity);
  writer.writeLong(offsets[2], object.blendLevel);
  writer.writeDouble(offsets[3], object.bottomBarOpacity);
  writer.writeString(offsets[4], object.colorScheme);
  writer.writeDouble(offsets[5], object.defaultRadius);
  writer.writeByte(offsets[6], object.flexSchemeEnum.index);
  writer.writeByte(offsets[7], object.flexTabBarStyleEnum.index);
  writer.writeDouble(offsets[8], object.surfaceModeDark);
  writer.writeDouble(offsets[9], object.surfaceModeLight);
  writer.writeBool(offsets[10], object.swapDarkColors);
  writer.writeBool(offsets[11], object.swapLightColors);
  writer.writeDouble(offsets[12], object.tabBarOpacity);
  writer.writeString(offsets[13], object.tabBarStyle);
  writer.writeString(offsets[14], object.themeMode);
  writer.writeBool(offsets[15], object.tooltipsMatchBackground);
  writer.writeBool(offsets[16], object.transparentStatusBar);
  writer.writeBool(offsets[17], object.useAppbarColors);
  writer.writeBool(offsets[18], object.useKeyColors);
  writer.writeBool(offsets[19], object.useMaterial3);
  writer.writeBool(offsets[20], object.useSubThemes);
  writer.writeBool(offsets[21], object.useTertiary);
  writer.writeBool(offsets[22], object.useTextTheme);
}

ThemeSettings _themeSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ThemeSettings(
    amoled: reader.readBoolOrNull(offsets[0]) ?? false,
    appBarOpacity: reader.readDoubleOrNull(offsets[1]) ?? 1.0,
    blendLevel: reader.readLongOrNull(offsets[2]) ?? 0,
    bottomBarOpacity: reader.readDoubleOrNull(offsets[3]) ?? 1.0,
    colorScheme: reader.readStringOrNull(offsets[4]) ?? 'red',
    defaultRadius: reader.readDoubleOrNull(offsets[5]) ?? 12.0,
    surfaceModeDark: reader.readDoubleOrNull(offsets[8]) ?? 0,
    surfaceModeLight: reader.readDoubleOrNull(offsets[9]) ?? 0,
    swapDarkColors: reader.readBoolOrNull(offsets[10]) ?? false,
    swapLightColors: reader.readBoolOrNull(offsets[11]) ?? false,
    tabBarOpacity: reader.readDoubleOrNull(offsets[12]) ?? 1.0,
    tabBarStyle: reader.readStringOrNull(offsets[13]) ?? 'forBackground',
    themeMode: reader.readStringOrNull(offsets[14]) ?? 'system',
    tooltipsMatchBackground: reader.readBoolOrNull(offsets[15]) ?? false,
    transparentStatusBar: reader.readBoolOrNull(offsets[16]) ?? false,
    useAppbarColors: reader.readBoolOrNull(offsets[17]) ?? false,
    useKeyColors: reader.readBoolOrNull(offsets[18]) ?? true,
    useMaterial3: reader.readBoolOrNull(offsets[19]) ?? true,
    useSubThemes: reader.readBoolOrNull(offsets[20]) ?? true,
    useTertiary: reader.readBoolOrNull(offsets[21]) ?? true,
    useTextTheme: reader.readBoolOrNull(offsets[22]) ?? true,
  );
  object.id = id;
  return object;
}

P _themeSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 1:
      return (reader.readDoubleOrNull(offset) ?? 1.0) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readDoubleOrNull(offset) ?? 1.0) as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? 'red') as P;
    case 5:
      return (reader.readDoubleOrNull(offset) ?? 12.0) as P;
    case 6:
      return (_ThemeSettingsflexSchemeEnumValueEnumMap[
              reader.readByteOrNull(offset)] ??
          FlexScheme.material) as P;
    case 7:
      return (_ThemeSettingsflexTabBarStyleEnumValueEnumMap[
              reader.readByteOrNull(offset)] ??
          FlexTabBarStyle.forAppBar) as P;
    case 8:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 9:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 10:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 11:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 12:
      return (reader.readDoubleOrNull(offset) ?? 1.0) as P;
    case 13:
      return (reader.readStringOrNull(offset) ?? 'forBackground') as P;
    case 14:
      return (reader.readStringOrNull(offset) ?? 'system') as P;
    case 15:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 16:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 17:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 18:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 19:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 20:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 21:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 22:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ThemeSettingsflexSchemeEnumEnumValueMap = {
  'material': 0,
  'materialHc': 1,
  'blue': 2,
  'indigo': 3,
  'hippieBlue': 4,
  'aquaBlue': 5,
  'brandBlue': 6,
  'deepBlue': 7,
  'sakura': 8,
  'mandyRed': 9,
  'red': 10,
  'redWine': 11,
  'purpleBrown': 12,
  'green': 13,
  'money': 14,
  'jungle': 15,
  'greyLaw': 16,
  'wasabi': 17,
  'gold': 18,
  'mango': 19,
  'amber': 20,
  'vesuviusBurn': 21,
  'deepPurple': 22,
  'ebonyClay': 23,
  'barossa': 24,
  'shark': 25,
  'bigStone': 26,
  'damask': 27,
  'bahamaBlue': 28,
  'mallardGreen': 29,
  'espresso': 30,
  'outerSpace': 31,
  'blueWhale': 32,
  'sanJuanBlue': 33,
  'rosewood': 34,
  'blumineBlue': 35,
  'flutterDash': 36,
  'materialBaseline': 37,
  'verdunHemlock': 38,
  'dellGenoa': 39,
  'redM3': 40,
  'pinkM3': 41,
  'purpleM3': 42,
  'indigoM3': 43,
  'blueM3': 44,
  'cyanM3': 45,
  'tealM3': 46,
  'greenM3': 47,
  'limeM3': 48,
  'yellowM3': 49,
  'orangeM3': 50,
  'deepOrangeM3': 51,
  'blackWhite': 52,
  'greys': 53,
  'sepia': 54,
  'custom': 55,
};
const _ThemeSettingsflexSchemeEnumValueEnumMap = {
  0: FlexScheme.material,
  1: FlexScheme.materialHc,
  2: FlexScheme.blue,
  3: FlexScheme.indigo,
  4: FlexScheme.hippieBlue,
  5: FlexScheme.aquaBlue,
  6: FlexScheme.brandBlue,
  7: FlexScheme.deepBlue,
  8: FlexScheme.sakura,
  9: FlexScheme.mandyRed,
  10: FlexScheme.red,
  11: FlexScheme.redWine,
  12: FlexScheme.purpleBrown,
  13: FlexScheme.green,
  14: FlexScheme.money,
  15: FlexScheme.jungle,
  16: FlexScheme.greyLaw,
  17: FlexScheme.wasabi,
  18: FlexScheme.gold,
  19: FlexScheme.mango,
  20: FlexScheme.amber,
  21: FlexScheme.vesuviusBurn,
  22: FlexScheme.deepPurple,
  23: FlexScheme.ebonyClay,
  24: FlexScheme.barossa,
  25: FlexScheme.shark,
  26: FlexScheme.bigStone,
  27: FlexScheme.damask,
  28: FlexScheme.bahamaBlue,
  29: FlexScheme.mallardGreen,
  30: FlexScheme.espresso,
  31: FlexScheme.outerSpace,
  32: FlexScheme.blueWhale,
  33: FlexScheme.sanJuanBlue,
  34: FlexScheme.rosewood,
  35: FlexScheme.blumineBlue,
  36: FlexScheme.flutterDash,
  37: FlexScheme.materialBaseline,
  38: FlexScheme.verdunHemlock,
  39: FlexScheme.dellGenoa,
  40: FlexScheme.redM3,
  41: FlexScheme.pinkM3,
  42: FlexScheme.purpleM3,
  43: FlexScheme.indigoM3,
  44: FlexScheme.blueM3,
  45: FlexScheme.cyanM3,
  46: FlexScheme.tealM3,
  47: FlexScheme.greenM3,
  48: FlexScheme.limeM3,
  49: FlexScheme.yellowM3,
  50: FlexScheme.orangeM3,
  51: FlexScheme.deepOrangeM3,
  52: FlexScheme.blackWhite,
  53: FlexScheme.greys,
  54: FlexScheme.sepia,
  55: FlexScheme.custom,
};
const _ThemeSettingsflexTabBarStyleEnumEnumValueMap = {
  'forAppBar': 0,
  'forBackground': 1,
  'flutterDefault': 2,
  'universal': 3,
};
const _ThemeSettingsflexTabBarStyleEnumValueEnumMap = {
  0: FlexTabBarStyle.forAppBar,
  1: FlexTabBarStyle.forBackground,
  2: FlexTabBarStyle.flutterDefault,
  3: FlexTabBarStyle.universal,
};

Id _themeSettingsGetId(ThemeSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _themeSettingsGetLinks(ThemeSettings object) {
  return [];
}

void _themeSettingsAttach(
    IsarCollection<dynamic> col, Id id, ThemeSettings object) {
  object.id = id;
}

extension ThemeSettingsQueryWhereSort
    on QueryBuilder<ThemeSettings, ThemeSettings, QWhere> {
  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ThemeSettingsQueryWhere
    on QueryBuilder<ThemeSettings, ThemeSettings, QWhereClause> {
  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ThemeSettingsQueryFilter
    on QueryBuilder<ThemeSettings, ThemeSettings, QFilterCondition> {
  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      amoledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amoled',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      appBarOpacityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appBarOpacity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      appBarOpacityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appBarOpacity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      appBarOpacityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appBarOpacity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      appBarOpacityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appBarOpacity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      blendLevelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blendLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      blendLevelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blendLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      blendLevelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blendLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      blendLevelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blendLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      bottomBarOpacityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bottomBarOpacity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      bottomBarOpacityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bottomBarOpacity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      bottomBarOpacityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bottomBarOpacity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      bottomBarOpacityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bottomBarOpacity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      colorSchemeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorScheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      colorSchemeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorScheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      colorSchemeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorScheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      colorSchemeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorScheme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      colorSchemeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'colorScheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      colorSchemeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'colorScheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      colorSchemeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'colorScheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      colorSchemeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'colorScheme',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      colorSchemeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorScheme',
        value: '',
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      colorSchemeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'colorScheme',
        value: '',
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      defaultRadiusEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultRadius',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      defaultRadiusGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultRadius',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      defaultRadiusLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultRadius',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      defaultRadiusBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultRadius',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      flexSchemeEnumEqualTo(FlexScheme value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'flexSchemeEnum',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      flexSchemeEnumGreaterThan(
    FlexScheme value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'flexSchemeEnum',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      flexSchemeEnumLessThan(
    FlexScheme value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'flexSchemeEnum',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      flexSchemeEnumBetween(
    FlexScheme lower,
    FlexScheme upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'flexSchemeEnum',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      flexTabBarStyleEnumEqualTo(FlexTabBarStyle value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'flexTabBarStyleEnum',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      flexTabBarStyleEnumGreaterThan(
    FlexTabBarStyle value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'flexTabBarStyleEnum',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      flexTabBarStyleEnumLessThan(
    FlexTabBarStyle value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'flexTabBarStyleEnum',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      flexTabBarStyleEnumBetween(
    FlexTabBarStyle lower,
    FlexTabBarStyle upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'flexTabBarStyleEnum',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      surfaceModeDarkEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surfaceModeDark',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      surfaceModeDarkGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surfaceModeDark',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      surfaceModeDarkLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surfaceModeDark',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      surfaceModeDarkBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surfaceModeDark',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      surfaceModeLightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surfaceModeLight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      surfaceModeLightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surfaceModeLight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      surfaceModeLightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surfaceModeLight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      surfaceModeLightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surfaceModeLight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      swapDarkColorsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'swapDarkColors',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      swapLightColorsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'swapLightColors',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      tabBarOpacityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tabBarOpacity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      tabBarOpacityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tabBarOpacity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      tabBarOpacityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tabBarOpacity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      tabBarOpacityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tabBarOpacity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      tabBarStyleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tabBarStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      tabBarStyleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tabBarStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      tabBarStyleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tabBarStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      tabBarStyleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tabBarStyle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      tabBarStyleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tabBarStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      tabBarStyleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tabBarStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      tabBarStyleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tabBarStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      tabBarStyleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tabBarStyle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      tabBarStyleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tabBarStyle',
        value: '',
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      tabBarStyleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tabBarStyle',
        value: '',
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeModeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeModeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'themeMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeModeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'themeMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeModeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'themeMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeModeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'themeMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeModeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'themeMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeModeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'themeMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeModeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'themeMode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeMode',
        value: '',
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'themeMode',
        value: '',
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      tooltipsMatchBackgroundEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tooltipsMatchBackground',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      transparentStatusBarEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transparentStatusBar',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      useAppbarColorsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useAppbarColors',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      useKeyColorsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useKeyColors',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      useMaterial3EqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useMaterial3',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      useSubThemesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useSubThemes',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      useTertiaryEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useTertiary',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      useTextThemeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useTextTheme',
        value: value,
      ));
    });
  }
}

extension ThemeSettingsQueryObject
    on QueryBuilder<ThemeSettings, ThemeSettings, QFilterCondition> {}

extension ThemeSettingsQueryLinks
    on QueryBuilder<ThemeSettings, ThemeSettings, QFilterCondition> {}

extension ThemeSettingsQuerySortBy
    on QueryBuilder<ThemeSettings, ThemeSettings, QSortBy> {
  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> sortByAmoled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amoled', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> sortByAmoledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amoled', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByAppBarOpacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appBarOpacity', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByAppBarOpacityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appBarOpacity', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> sortByBlendLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blendLevel', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByBlendLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blendLevel', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByBottomBarOpacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bottomBarOpacity', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByBottomBarOpacityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bottomBarOpacity', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> sortByColorScheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorScheme', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByColorSchemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorScheme', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByDefaultRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultRadius', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByDefaultRadiusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultRadius', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByFlexSchemeEnum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexSchemeEnum', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByFlexSchemeEnumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexSchemeEnum', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByFlexTabBarStyleEnum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexTabBarStyleEnum', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByFlexTabBarStyleEnumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexTabBarStyleEnum', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortBySurfaceModeDark() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surfaceModeDark', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortBySurfaceModeDarkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surfaceModeDark', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortBySurfaceModeLight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surfaceModeLight', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortBySurfaceModeLightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surfaceModeLight', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortBySwapDarkColors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swapDarkColors', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortBySwapDarkColorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swapDarkColors', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortBySwapLightColors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swapLightColors', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortBySwapLightColorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swapLightColors', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByTabBarOpacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tabBarOpacity', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByTabBarOpacityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tabBarOpacity', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> sortByTabBarStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tabBarStyle', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByTabBarStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tabBarStyle', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> sortByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByTooltipsMatchBackground() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tooltipsMatchBackground', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByTooltipsMatchBackgroundDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tooltipsMatchBackground', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByTransparentStatusBar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transparentStatusBar', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByTransparentStatusBarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transparentStatusBar', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByUseAppbarColors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useAppbarColors', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByUseAppbarColorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useAppbarColors', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByUseKeyColors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useKeyColors', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByUseKeyColorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useKeyColors', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByUseMaterial3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMaterial3', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByUseMaterial3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMaterial3', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByUseSubThemes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useSubThemes', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByUseSubThemesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useSubThemes', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> sortByUseTertiary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useTertiary', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByUseTertiaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useTertiary', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByUseTextTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useTextTheme', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByUseTextThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useTextTheme', Sort.desc);
    });
  }
}

extension ThemeSettingsQuerySortThenBy
    on QueryBuilder<ThemeSettings, ThemeSettings, QSortThenBy> {
  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenByAmoled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amoled', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenByAmoledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amoled', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByAppBarOpacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appBarOpacity', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByAppBarOpacityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appBarOpacity', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenByBlendLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blendLevel', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByBlendLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blendLevel', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByBottomBarOpacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bottomBarOpacity', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByBottomBarOpacityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bottomBarOpacity', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenByColorScheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorScheme', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByColorSchemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorScheme', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByDefaultRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultRadius', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByDefaultRadiusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultRadius', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByFlexSchemeEnum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexSchemeEnum', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByFlexSchemeEnumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexSchemeEnum', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByFlexTabBarStyleEnum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexTabBarStyleEnum', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByFlexTabBarStyleEnumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexTabBarStyleEnum', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenBySurfaceModeDark() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surfaceModeDark', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenBySurfaceModeDarkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surfaceModeDark', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenBySurfaceModeLight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surfaceModeLight', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenBySurfaceModeLightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surfaceModeLight', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenBySwapDarkColors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swapDarkColors', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenBySwapDarkColorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swapDarkColors', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenBySwapLightColors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swapLightColors', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenBySwapLightColorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swapLightColors', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByTabBarOpacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tabBarOpacity', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByTabBarOpacityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tabBarOpacity', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenByTabBarStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tabBarStyle', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByTabBarStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tabBarStyle', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByTooltipsMatchBackground() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tooltipsMatchBackground', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByTooltipsMatchBackgroundDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tooltipsMatchBackground', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByTransparentStatusBar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transparentStatusBar', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByTransparentStatusBarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transparentStatusBar', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByUseAppbarColors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useAppbarColors', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByUseAppbarColorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useAppbarColors', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByUseKeyColors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useKeyColors', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByUseKeyColorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useKeyColors', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByUseMaterial3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMaterial3', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByUseMaterial3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMaterial3', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByUseSubThemes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useSubThemes', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByUseSubThemesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useSubThemes', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenByUseTertiary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useTertiary', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByUseTertiaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useTertiary', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByUseTextTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useTextTheme', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByUseTextThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useTextTheme', Sort.desc);
    });
  }
}

extension ThemeSettingsQueryWhereDistinct
    on QueryBuilder<ThemeSettings, ThemeSettings, QDistinct> {
  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct> distinctByAmoled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amoled');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctByAppBarOpacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appBarOpacity');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct> distinctByBlendLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blendLevel');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctByBottomBarOpacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bottomBarOpacity');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct> distinctByColorScheme(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorScheme', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctByDefaultRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultRadius');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctByFlexSchemeEnum() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'flexSchemeEnum');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctByFlexTabBarStyleEnum() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'flexTabBarStyleEnum');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctBySurfaceModeDark() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surfaceModeDark');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctBySurfaceModeLight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surfaceModeLight');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctBySwapDarkColors() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'swapDarkColors');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctBySwapLightColors() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'swapLightColors');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctByTabBarOpacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tabBarOpacity');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct> distinctByTabBarStyle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tabBarStyle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct> distinctByThemeMode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeMode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctByTooltipsMatchBackground() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tooltipsMatchBackground');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctByTransparentStatusBar() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transparentStatusBar');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctByUseAppbarColors() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useAppbarColors');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctByUseKeyColors() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useKeyColors');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctByUseMaterial3() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useMaterial3');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctByUseSubThemes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useSubThemes');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctByUseTertiary() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useTertiary');
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct>
      distinctByUseTextTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useTextTheme');
    });
  }
}

extension ThemeSettingsQueryProperty
    on QueryBuilder<ThemeSettings, ThemeSettings, QQueryProperty> {
  QueryBuilder<ThemeSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ThemeSettings, bool, QQueryOperations> amoledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amoled');
    });
  }

  QueryBuilder<ThemeSettings, double, QQueryOperations>
      appBarOpacityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appBarOpacity');
    });
  }

  QueryBuilder<ThemeSettings, int, QQueryOperations> blendLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blendLevel');
    });
  }

  QueryBuilder<ThemeSettings, double, QQueryOperations>
      bottomBarOpacityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bottomBarOpacity');
    });
  }

  QueryBuilder<ThemeSettings, String, QQueryOperations> colorSchemeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorScheme');
    });
  }

  QueryBuilder<ThemeSettings, double, QQueryOperations>
      defaultRadiusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultRadius');
    });
  }

  QueryBuilder<ThemeSettings, FlexScheme, QQueryOperations>
      flexSchemeEnumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'flexSchemeEnum');
    });
  }

  QueryBuilder<ThemeSettings, FlexTabBarStyle, QQueryOperations>
      flexTabBarStyleEnumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'flexTabBarStyleEnum');
    });
  }

  QueryBuilder<ThemeSettings, double, QQueryOperations>
      surfaceModeDarkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surfaceModeDark');
    });
  }

  QueryBuilder<ThemeSettings, double, QQueryOperations>
      surfaceModeLightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surfaceModeLight');
    });
  }

  QueryBuilder<ThemeSettings, bool, QQueryOperations> swapDarkColorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'swapDarkColors');
    });
  }

  QueryBuilder<ThemeSettings, bool, QQueryOperations>
      swapLightColorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'swapLightColors');
    });
  }

  QueryBuilder<ThemeSettings, double, QQueryOperations>
      tabBarOpacityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tabBarOpacity');
    });
  }

  QueryBuilder<ThemeSettings, String, QQueryOperations> tabBarStyleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tabBarStyle');
    });
  }

  QueryBuilder<ThemeSettings, String, QQueryOperations> themeModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeMode');
    });
  }

  QueryBuilder<ThemeSettings, bool, QQueryOperations>
      tooltipsMatchBackgroundProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tooltipsMatchBackground');
    });
  }

  QueryBuilder<ThemeSettings, bool, QQueryOperations>
      transparentStatusBarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transparentStatusBar');
    });
  }

  QueryBuilder<ThemeSettings, bool, QQueryOperations>
      useAppbarColorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useAppbarColors');
    });
  }

  QueryBuilder<ThemeSettings, bool, QQueryOperations> useKeyColorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useKeyColors');
    });
  }

  QueryBuilder<ThemeSettings, bool, QQueryOperations> useMaterial3Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useMaterial3');
    });
  }

  QueryBuilder<ThemeSettings, bool, QQueryOperations> useSubThemesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useSubThemes');
    });
  }

  QueryBuilder<ThemeSettings, bool, QQueryOperations> useTertiaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useTertiary');
    });
  }

  QueryBuilder<ThemeSettings, bool, QQueryOperations> useTextThemeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useTextTheme');
    });
  }
}
