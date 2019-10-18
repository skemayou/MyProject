import 'package:flutter/material.dart';



class Jobs  {
  Jobs({
    @required this.id,
    this.url,
    this.type,
    this.createdAt,
    this.company,
    this.companyUrl,
    this.location,
    this.title,
    this.description,
    this.howToApply,
    this.companyLogo,
  });

   Jobs.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        url = json['url'],
        type = json['type'],
        createdAt = json['created_at'],
        company = json['company'],
        companyUrl = json['company_url'],
        location = json['location'],
        title = json['title'],
        description = json['description'],
        howToApply = json['how_to_apply'],
        companyLogo = json['company_logo'];

final String id;

  bool isLoading = false;
  String url = '';
  String type = '';
  String  createdAt = '';
  String company = '';
  String companyUrl = '';
  String location = '';
  String title = '';
  String description = '';
  String howToApply = '';
  String companyLogo = '';

 
}