// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_initializing_formals
// ignore_for_file: prefer_final_fields, file_names, non_constant_identifier_names

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:sassila_mobile_ui/modeles/Individu.dart';

part 'Section.g.dart';

@JsonSerializable()
class Section {
  late int id;
  late String titre;
  late String contenu;
  @JsonKey(defaultValue: "images/profileIcon.png")
  String imageUrl;
  late int ordre_affichage;
  late Individu individu;

  Section({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.imageUrl,
    required this.ordre_affichage,
    required this.individu,
  });

  Map<String, dynamic> toJson() => _$SectionToJson(this);

  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);
}
