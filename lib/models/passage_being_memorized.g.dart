// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passage_being_memorized.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPassageBeingMemorizedCollection on Isar {
  IsarCollection<PassageBeingMemorized> get passageBeingMemorizeds =>
      this.collection();
}

const PassageBeingMemorizedSchema = CollectionSchema(
  name: r'PassageBeingMemorized',
  id: 8232367936659434993,
  properties: {
    r'percentMemorized': PropertySchema(
      id: 0,
      name: r'percentMemorized',
      type: IsarType.long,
    ),
    r'reference': PropertySchema(
      id: 1,
      name: r'reference',
      type: IsarType.string,
    ),
    r'version': PropertySchema(
      id: 2,
      name: r'version',
      type: IsarType.string,
    )
  },
  estimateSize: _passageBeingMemorizedEstimateSize,
  serialize: _passageBeingMemorizedSerialize,
  deserialize: _passageBeingMemorizedDeserialize,
  deserializeProp: _passageBeingMemorizedDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'versesInPassage': LinkSchema(
      id: -7858184371296727142,
      name: r'versesInPassage',
      target: r'VerseBeingMemorized',
      single: false,
      linkName: r'passagesWithin',
    )
  },
  embeddedSchemas: {},
  getId: _passageBeingMemorizedGetId,
  getLinks: _passageBeingMemorizedGetLinks,
  attach: _passageBeingMemorizedAttach,
  version: '3.1.0+1',
);

int _passageBeingMemorizedEstimateSize(
  PassageBeingMemorized object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.reference.length * 3;
  bytesCount += 3 + object.version.length * 3;
  return bytesCount;
}

void _passageBeingMemorizedSerialize(
  PassageBeingMemorized object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.percentMemorized);
  writer.writeString(offsets[1], object.reference);
  writer.writeString(offsets[2], object.version);
}

PassageBeingMemorized _passageBeingMemorizedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PassageBeingMemorized(
    reference: reader.readString(offsets[1]),
    version: reader.readStringOrNull(offsets[2]) ?? "NKJV",
  );
  return object;
}

P _passageBeingMemorizedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? "NKJV") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _passageBeingMemorizedGetId(PassageBeingMemorized object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _passageBeingMemorizedGetLinks(
    PassageBeingMemorized object) {
  return [object.versesInPassage];
}

void _passageBeingMemorizedAttach(
    IsarCollection<dynamic> col, Id id, PassageBeingMemorized object) {
  object.versesInPassage.attach(
      col, col.isar.collection<VerseBeingMemorized>(), r'versesInPassage', id);
}

extension PassageBeingMemorizedQueryWhereSort
    on QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QWhere> {
  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PassageBeingMemorizedQueryWhere on QueryBuilder<PassageBeingMemorized,
    PassageBeingMemorized, QWhereClause> {
  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterWhereClause>
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterWhereClause>
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

extension PassageBeingMemorizedQueryFilter on QueryBuilder<
    PassageBeingMemorized, PassageBeingMemorized, QFilterCondition> {
  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> percentMemorizedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'percentMemorized',
        value: value,
      ));
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> percentMemorizedGreaterThan(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> percentMemorizedLessThan(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> percentMemorizedBetween(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> referenceEqualTo(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> referenceGreaterThan(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> referenceLessThan(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> referenceBetween(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> referenceStartsWith(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> referenceEndsWith(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
          QAfterFilterCondition>
      referenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
          QAfterFilterCondition>
      referenceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reference',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> referenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reference',
        value: '',
      ));
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> referenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reference',
        value: '',
      ));
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> versionEqualTo(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> versionGreaterThan(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> versionLessThan(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> versionBetween(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> versionStartsWith(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> versionEndsWith(
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

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
          QAfterFilterCondition>
      versionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
          QAfterFilterCondition>
      versionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'version',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> versionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: '',
      ));
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> versionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'version',
        value: '',
      ));
    });
  }
}

extension PassageBeingMemorizedQueryObject on QueryBuilder<
    PassageBeingMemorized, PassageBeingMemorized, QFilterCondition> {}

extension PassageBeingMemorizedQueryLinks on QueryBuilder<PassageBeingMemorized,
    PassageBeingMemorized, QFilterCondition> {
  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
          QAfterFilterCondition>
      versesInPassage(FilterQuery<VerseBeingMemorized> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'versesInPassage');
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> versesInPassageLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'versesInPassage', length, true, length, true);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> versesInPassageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'versesInPassage', 0, true, 0, true);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> versesInPassageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'versesInPassage', 0, false, 999999, true);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> versesInPassageLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'versesInPassage', 0, true, length, include);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> versesInPassageLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'versesInPassage', length, include, 999999, true);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized,
      QAfterFilterCondition> versesInPassageLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'versesInPassage', lower, includeLower, upper, includeUpper);
    });
  }
}

extension PassageBeingMemorizedQuerySortBy
    on QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QSortBy> {
  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterSortBy>
      sortByPercentMemorized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentMemorized', Sort.asc);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterSortBy>
      sortByPercentMemorizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentMemorized', Sort.desc);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterSortBy>
      sortByReference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.asc);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterSortBy>
      sortByReferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.desc);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterSortBy>
      sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterSortBy>
      sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension PassageBeingMemorizedQuerySortThenBy
    on QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QSortThenBy> {
  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterSortBy>
      thenByPercentMemorized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentMemorized', Sort.asc);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterSortBy>
      thenByPercentMemorizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentMemorized', Sort.desc);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterSortBy>
      thenByReference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.asc);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterSortBy>
      thenByReferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.desc);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterSortBy>
      thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QAfterSortBy>
      thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension PassageBeingMemorizedQueryWhereDistinct
    on QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QDistinct> {
  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QDistinct>
      distinctByPercentMemorized() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'percentMemorized');
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QDistinct>
      distinctByReference({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reference', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PassageBeingMemorized, PassageBeingMemorized, QDistinct>
      distinctByVersion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version', caseSensitive: caseSensitive);
    });
  }
}

extension PassageBeingMemorizedQueryProperty on QueryBuilder<
    PassageBeingMemorized, PassageBeingMemorized, QQueryProperty> {
  QueryBuilder<PassageBeingMemorized, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PassageBeingMemorized, int, QQueryOperations>
      percentMemorizedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'percentMemorized');
    });
  }

  QueryBuilder<PassageBeingMemorized, String, QQueryOperations>
      referenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reference');
    });
  }

  QueryBuilder<PassageBeingMemorized, String, QQueryOperations>
      versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }
}
