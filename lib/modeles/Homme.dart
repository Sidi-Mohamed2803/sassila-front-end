// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_initializing_formals
// ignore_for_file: file_names, non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'package:sassila_mobile_ui/modeles/Femme.dart';
import 'package:sassila_mobile_ui/modeles/Individu.dart';

part 'Homme.g.dart';
//flutter pub run build_runner watch --delete-conflicting-outputs
// flutter pub run build_runner build --delete-conflicting-outputs

@JsonSerializable()
class Homme extends Individu {
  @JsonKey(defaultValue: [])
  List<Femme>? epouses;

  Homme(
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
      List<Femme>? epouses)
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
    this.epouses = epouses;
  }

  factory Homme.fromJson(Map<String, dynamic> json) => _$HommeFromJson(json);

  Map<String, dynamic> toJson() => _$HommeToJson(this);

  @override
  String toString() => super.toString() + 'Homme(epouses: $epouses)';
}
