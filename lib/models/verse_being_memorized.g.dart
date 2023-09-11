// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse_being_memorized.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVerseBeingMemorizedCollection on Isar {
  IsarCollection<VerseBeingMemorized> get verseBeingMemorizeds =>
      this.collection();
}

const VerseBeingMemorizedSchema = CollectionSchema(
  name: r'VerseBeingMemorized',
  id: 2845526988554141954,
  properties: {
    r'percentMemorized': PropertySchema(
      id: 0,
      name: r'percentMemorized',
      type: IsarType.long,
    ),
    r'percentRemoved': PropertySchema(
      id: 1,
      name: r'percentRemoved',
      type: IsarType.long,
    ),
    r'reference': PropertySchema(
      id: 2,
      name: r'reference',
      type: IsarType.string,
    ),
    r'stage': PropertySchema(
      id: 3,
      name: r'stage',
      type: IsarType.long,
    ),
    r'verseText': PropertySchema(
      id: 4,
      name: r'verseText',
      type: IsarType.string,
    ),
    r'version': PropertySchema(
      id: 5,
      name: r'version',
      type: IsarType.string,
    ),
    r'wordsInVerse': PropertySchema(
      id: 6,
      name: r'wordsInVerse',
      type: IsarType.long,
    ),
    r'wordsRemoved': PropertySchema(
      id: 7,
      name: r'wordsRemoved',
      type: IsarType.long,
    )
  },
  estimateSize: _verseBeingMemorizedEstimateSize,
  serialize: _verseBeingMemorizedSerialize,
  deserialize: _verseBeingMemorizedDeserialize,
  deserializeProp: _verseBeingMemorizedDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'passagesWithin': LinkSchema(
      id: 6141477599186331529,
      name: r'passagesWithin',
      target: r'PassageBeingMemorized',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _verseBeingMemorizedGetId,
  getLinks: _verseBeingMemorizedGetLinks,
  attach: _verseBeingMemorizedAttach,
  version: '3.1.0+1',
);

int _verseBeingMemorizedEstimateSize(
  VerseBeingMemorized object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.reference.length * 3;
  bytesCount += 3 + object.verseText.length * 3;
  bytesCount += 3 + object.version.length * 3;
  return bytesCount;
}

void _verseBeingMemorizedSerialize(
  VerseBeingMemorized object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.percentMemorized);
  writer.writeLong(offsets[1], object.percentRemoved);
  writer.writeString(offsets[2], object.reference);
  writer.writeLong(offsets[3], object.stage);
  writer.writeString(offsets[4], object.verseText);
  writer.writeString(offsets[5], object.version);
  writer.writeLong(offsets[6], object.wordsInVerse);
  writer.writeLong(offsets[7], object.wordsRemoved);
}

VerseBeingMemorized _verseBeingMemorizedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VerseBeingMemorized(
    percentMemorized: reader.readLong(offsets[0]),
    reference: reader.readString(offsets[2]),
    stage: reader.readLong(offsets[3]),
    verseText: reader.readString(offsets[4]),
    version: reader.readString(offsets[5]),
    wordsRemoved: reader.readLong(offsets[7]),
  );
  object.wordsInVerse = reader.readLong(offsets[6]);
  return object;
}

P _verseBeingMemorizedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _verseBeingMemorizedGetId(VerseBeingMemorized object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _verseBeingMemorizedGetLinks(
    VerseBeingMemorized object) {
  return [object.passagesWithin];
}

void _verseBeingMemorizedAttach(
    IsarCollection<dynamic> col, Id id, VerseBeingMemorized object) {
  object.passagesWithin.attach(
      col, col.isar.collection<PassageBeingMemorized>(), r'passagesWithin', id);
}

extension VerseBeingMemorizedQueryWhereSort
    on QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QWhere> {
  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VerseBeingMemorizedQueryWhere
    on QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QWhereClause> {
  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterWhereClause>
      idBetween(
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

extension VerseBeingMemorizedQueryFilter on QueryBuilder<VerseBeingMemorized,
    VerseBeingMemorized, QFilterCondition> {
  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
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

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      percentMemorizedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'percentMemorized',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      percentMemorizedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'percentMemorized',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      percentMemorizedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'percentMemorized',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      percentMemorizedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'percentMemorized',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      percentRemovedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'percentRemoved',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      percentRemovedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'percentRemoved',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      percentRemovedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'percentRemoved',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      percentRemovedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'percentRemoved',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      referenceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      referenceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      referenceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      referenceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reference',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      referenceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      referenceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      referenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      referenceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reference',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      referenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reference',
        value: '',
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      referenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reference',
        value: '',
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      stageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stage',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      stageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stage',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      stageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stage',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      stageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      verseTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      verseTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      verseTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      verseTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verseText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      verseTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      verseTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      verseTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      verseTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'verseText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      verseTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseText',
        value: '',
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      verseTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'verseText',
        value: '',
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      versionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      versionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      versionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      versionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'version',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      versionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      versionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      versionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      versionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'version',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      versionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: '',
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      versionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'version',
        value: '',
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      wordsInVerseEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordsInVerse',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      wordsInVerseGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wordsInVerse',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      wordsInVerseLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wordsInVerse',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      wordsInVerseBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wordsInVerse',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      wordsRemovedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordsRemoved',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      wordsRemovedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wordsRemoved',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      wordsRemovedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wordsRemoved',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      wordsRemovedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wordsRemoved',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension VerseBeingMemorizedQueryObject on QueryBuilder<VerseBeingMemorized,
    VerseBeingMemorized, QFilterCondition> {}

extension VerseBeingMemorizedQueryLinks on QueryBuilder<VerseBeingMemorized,
    VerseBeingMemorized, QFilterCondition> {
  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      passagesWithin(FilterQuery<PassageBeingMemorized> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'passagesWithin');
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      passagesWithinLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'passagesWithin', length, true, length, true);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      passagesWithinIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'passagesWithin', 0, true, 0, true);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      passagesWithinIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'passagesWithin', 0, false, 999999, true);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      passagesWithinLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'passagesWithin', 0, true, length, include);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      passagesWithinLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'passagesWithin', length, include, 999999, true);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterFilterCondition>
      passagesWithinLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'passagesWithin', lower, includeLower, upper, includeUpper);
    });
  }
}

extension VerseBeingMemorizedQuerySortBy
    on QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QSortBy> {
  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      sortByPercentMemorized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentMemorized', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      sortByPercentMemorizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentMemorized', Sort.desc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      sortByPercentRemoved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentRemoved', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      sortByPercentRemovedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentRemoved', Sort.desc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      sortByReference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      sortByReferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.desc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      sortByStage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stage', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      sortByStageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stage', Sort.desc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      sortByVerseText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseText', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      sortByVerseTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseText', Sort.desc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      sortByWordsInVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordsInVerse', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      sortByWordsInVerseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordsInVerse', Sort.desc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      sortByWordsRemoved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordsRemoved', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      sortByWordsRemovedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordsRemoved', Sort.desc);
    });
  }
}

extension VerseBeingMemorizedQuerySortThenBy
    on QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QSortThenBy> {
  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByPercentMemorized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentMemorized', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByPercentMemorizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentMemorized', Sort.desc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByPercentRemoved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentRemoved', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByPercentRemovedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentRemoved', Sort.desc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByReference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByReferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.desc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByStage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stage', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByStageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stage', Sort.desc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByVerseText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseText', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByVerseTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseText', Sort.desc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByWordsInVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordsInVerse', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByWordsInVerseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordsInVerse', Sort.desc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByWordsRemoved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordsRemoved', Sort.asc);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QAfterSortBy>
      thenByWordsRemovedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordsRemoved', Sort.desc);
    });
  }
}

extension VerseBeingMemorizedQueryWhereDistinct
    on QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QDistinct> {
  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QDistinct>
      distinctByPercentMemorized() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'percentMemorized');
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QDistinct>
      distinctByPercentRemoved() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'percentRemoved');
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QDistinct>
      distinctByReference({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reference', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QDistinct>
      distinctByStage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stage');
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QDistinct>
      distinctByVerseText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QDistinct>
      distinctByVersion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QDistinct>
      distinctByWordsInVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wordsInVerse');
    });
  }

  QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QDistinct>
      distinctByWordsRemoved() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wordsRemoved');
    });
  }
}

extension VerseBeingMemorizedQueryProperty
    on QueryBuilder<VerseBeingMemorized, VerseBeingMemorized, QQueryProperty> {
  QueryBuilder<VerseBeingMemorized, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VerseBeingMemorized, int, QQueryOperations>
      percentMemorizedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'percentMemorized');
    });
  }

  QueryBuilder<VerseBeingMemorized, int, QQueryOperations>
      percentRemovedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'percentRemoved');
    });
  }

  QueryBuilder<VerseBeingMemorized, String, QQueryOperations>
      referenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reference');
    });
  }

  QueryBuilder<VerseBeingMemorized, int, QQueryOperations> stageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stage');
    });
  }

  QueryBuilder<VerseBeingMemorized, String, QQueryOperations>
      verseTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseText');
    });
  }

  QueryBuilder<VerseBeingMemorized, String, QQueryOperations>
      versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }

  QueryBuilder<VerseBeingMemorized, int, QQueryOperations>
      wordsInVerseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wordsInVerse');
    });
  }

  QueryBuilder<VerseBeingMemorized, int, QQueryOperations>
      wordsRemovedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wordsRemoved');
    });
  }
}
