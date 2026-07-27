// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notes_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotesModel {

@JsonKey(includeIfNull: false) String? get id;@JsonKey(name: 'user_id') String get userId; String get title; String get content;@JsonKey(name: 'is_pinned') bool get isPinned;@JsonKey(name: 'created_at', includeIfNull: false) DateTime? get createdAt;@JsonKey(name: 'updated_at', includeIfNull: false) DateTime? get updatedAt;
/// Create a copy of NotesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotesModelCopyWith<NotesModel> get copyWith => _$NotesModelCopyWithImpl<NotesModel>(this as NotesModel, _$identity);

  /// Serializes this NotesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotesModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,content,isPinned,createdAt,updatedAt);

@override
String toString() {
  return 'NotesModel(id: $id, userId: $userId, title: $title, content: $content, isPinned: $isPinned, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $NotesModelCopyWith<$Res>  {
  factory $NotesModelCopyWith(NotesModel value, $Res Function(NotesModel) _then) = _$NotesModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeIfNull: false) String? id,@JsonKey(name: 'user_id') String userId, String title, String content,@JsonKey(name: 'is_pinned') bool isPinned,@JsonKey(name: 'created_at', includeIfNull: false) DateTime? createdAt,@JsonKey(name: 'updated_at', includeIfNull: false) DateTime? updatedAt
});




}
/// @nodoc
class _$NotesModelCopyWithImpl<$Res>
    implements $NotesModelCopyWith<$Res> {
  _$NotesModelCopyWithImpl(this._self, this._then);

  final NotesModel _self;
  final $Res Function(NotesModel) _then;

/// Create a copy of NotesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = null,Object? title = null,Object? content = null,Object? isPinned = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotesModel].
extension NotesModelPatterns on NotesModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotesModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotesModel value)  $default,){
final _that = this;
switch (_that) {
case _NotesModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotesModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotesModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? id, @JsonKey(name: 'user_id')  String userId,  String title,  String content, @JsonKey(name: 'is_pinned')  bool isPinned, @JsonKey(name: 'created_at', includeIfNull: false)  DateTime? createdAt, @JsonKey(name: 'updated_at', includeIfNull: false)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotesModel() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.content,_that.isPinned,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? id, @JsonKey(name: 'user_id')  String userId,  String title,  String content, @JsonKey(name: 'is_pinned')  bool isPinned, @JsonKey(name: 'created_at', includeIfNull: false)  DateTime? createdAt, @JsonKey(name: 'updated_at', includeIfNull: false)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _NotesModel():
return $default(_that.id,_that.userId,_that.title,_that.content,_that.isPinned,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeIfNull: false)  String? id, @JsonKey(name: 'user_id')  String userId,  String title,  String content, @JsonKey(name: 'is_pinned')  bool isPinned, @JsonKey(name: 'created_at', includeIfNull: false)  DateTime? createdAt, @JsonKey(name: 'updated_at', includeIfNull: false)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _NotesModel() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.content,_that.isPinned,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotesModel implements NotesModel {
  const _NotesModel({@JsonKey(includeIfNull: false) this.id, @JsonKey(name: 'user_id') required this.userId, required this.title, required this.content, @JsonKey(name: 'is_pinned') this.isPinned = false, @JsonKey(name: 'created_at', includeIfNull: false) this.createdAt, @JsonKey(name: 'updated_at', includeIfNull: false) this.updatedAt});
  factory _NotesModel.fromJson(Map<String, dynamic> json) => _$NotesModelFromJson(json);

@override@JsonKey(includeIfNull: false) final  String? id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String title;
@override final  String content;
@override@JsonKey(name: 'is_pinned') final  bool isPinned;
@override@JsonKey(name: 'created_at', includeIfNull: false) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', includeIfNull: false) final  DateTime? updatedAt;

/// Create a copy of NotesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotesModelCopyWith<_NotesModel> get copyWith => __$NotesModelCopyWithImpl<_NotesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotesModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotesModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,content,isPinned,createdAt,updatedAt);

@override
String toString() {
  return 'NotesModel(id: $id, userId: $userId, title: $title, content: $content, isPinned: $isPinned, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$NotesModelCopyWith<$Res> implements $NotesModelCopyWith<$Res> {
  factory _$NotesModelCopyWith(_NotesModel value, $Res Function(_NotesModel) _then) = __$NotesModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeIfNull: false) String? id,@JsonKey(name: 'user_id') String userId, String title, String content,@JsonKey(name: 'is_pinned') bool isPinned,@JsonKey(name: 'created_at', includeIfNull: false) DateTime? createdAt,@JsonKey(name: 'updated_at', includeIfNull: false) DateTime? updatedAt
});




}
/// @nodoc
class __$NotesModelCopyWithImpl<$Res>
    implements _$NotesModelCopyWith<$Res> {
  __$NotesModelCopyWithImpl(this._self, this._then);

  final _NotesModel _self;
  final $Res Function(_NotesModel) _then;

/// Create a copy of NotesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = null,Object? title = null,Object? content = null,Object? isPinned = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_NotesModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
