// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Section _$SectionFromJson(Map<String, dynamic> json) => Section(
      id: json['id'] as int,
      titre: json['titre'] as String,
      contenu: json['contenu'] as String,
      imageUrl: json['imageUrl'] as String? ?? 'images/profileIcon.png',
      ordre_affichage: json['ordre_affichage'] as int,
      individu: Individu.fromJson(json['individu'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SectionToJson(Section instance) => <String, dynamic>{
      'id': instance.id,
      'titre': instance.titre,
      'contenu': instance.contenu,
      'imageUrl': instance.imageUrl,
      'ordre_affichage': instance.ordre_affichage,
      'individu': instance.individu,
    };
