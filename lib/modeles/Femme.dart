// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_initializing_formals
// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

import 'package:sassila_mobile_ui/modeles/Homme.dart';
import 'package:sassila_mobile_ui/modeles/Individu.dart';

part 'Femme.g.dart';

@JsonSerializable()
class Femme extends Individu {
  @JsonKey(defaultValue: null)
  Homme? epoux;

  Femme(
      int id,
      String key_,
      String nom,
      String prenom,
      String surnom,
      DateTime date_naissance,
      String lieu_naissance,
      String residence_actuelle,
      DateTime? date_deces,
      String? lieu_deces,
      String? cause_deces,
      String imageUrl,
      List<Individu> enfants,
      Homme? epoux)
      : super(
            id,
            key_,
            nom,
            prenom,
            surnom,
            date_naissance,
            lieu_naissance,
            residence_actuelle,
            date_deces,
            lieu_deces,
            cause_deces,
            imageUrl,
            enfants) {
    this.epoux = epoux;
  }

  factory Femme.fromJson(Map<String, dynamic> json) => _$FemmeFromJson(json);

  Map<String, dynamic> toJson() => _$FemmeToJson(this);
}
