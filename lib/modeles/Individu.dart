// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_initializing_formals
// ignore_for_file: prefer_final_fields, file_names, non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'Individu.g.dart';

@JsonSerializable()
class Individu {
  late int id;
  late String key_;
  late String nom;
  late String prenom;
  late String surnom;
  late DateTime date_naissance;
  late String lieu_naissance;
  late String residence_actuelle;
  @JsonKey(defaultValue: null)
  DateTime? date_deces;
  @JsonKey(defaultValue: "")
  String? lieu_deces;
  @JsonKey(defaultValue: "")
  String? cause_deces;
  @JsonKey(defaultValue: "")
  late String imageUrl;
  @JsonKey(defaultValue: [])
  late List<Individu> enfants;
  Individu(
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
  ) {
    this.id = id;
    this.key_ = key_;
    this.nom = nom;
    this.prenom = prenom;
    this.surnom = surnom;
    this.date_naissance = date_naissance;
    this.lieu_naissance = lieu_naissance;
    this.residence_actuelle = residence_actuelle;
    this.date_deces = date_deces;
    this.lieu_deces = lieu_deces;
    this.cause_deces = cause_deces;
    this.imageUrl = imageUrl;
    this.enfants = enfants;
  }

  factory Individu.fromJson(Map<String, dynamic> json) =>
      _$IndividuFromJson(json);

  Map<String, dynamic> toJson() => _$IndividuToJson(this);

  @override
  String toString() {
    return 'Individu(key_: $key_, nom: $nom, prenom: $prenom, surnom: $surnom, date_naissance: $date_naissance, lieu_naissance: $lieu_naissance, residence_actuelle: $residence_actuelle, date_deces: $date_deces, lieu_deces: $lieu_deces, cause_deces: $cause_deces, imageUrl: $imageUrl, enfants: $enfants)';
  }
}
