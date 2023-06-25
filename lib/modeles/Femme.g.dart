// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Femme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Femme _$FemmeFromJson(Map<String, dynamic> json) => Femme(
      json['id'] as int,
      json['key_'] as String,
      json['nom'] as String,
      json['prenom'] as String,
      json['surnom'] as String,
      DateTime.parse(json['date_naissance'] as String),
      json['lieu_naissance'] as String,
      json['residence_actuelle'] as String,
      json['date_deces'] == null
          ? null
          : DateTime.parse(json['date_deces'] as String),
      json['lieu_deces'] as String? ?? '',
      json['cause_deces'] as String? ?? '',
      json['imageUrl'] as String? ?? '',
      (json['enfants'] as List<dynamic>?)
              ?.map((e) => Individu.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      json['epoux'] == null
          ? null
          : Homme.fromJson(json['epoux'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FemmeToJson(Femme instance) => <String, dynamic>{
      'id': instance.id,
      'key_': instance.key_,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'surnom': instance.surnom,
      'date_naissance': instance.date_naissance.toIso8601String(),
      'lieu_naissance': instance.lieu_naissance,
      'residence_actuelle': instance.residence_actuelle,
      'date_deces': instance.date_deces?.toIso8601String(),
      'lieu_deces': instance.lieu_deces,
      'cause_deces': instance.cause_deces,
      'imageUrl': instance.imageUrl,
      'enfants': instance.enfants,
      'epoux': instance.epoux,
    };
