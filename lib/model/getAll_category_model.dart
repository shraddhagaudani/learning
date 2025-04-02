
// Model for the GetAllCategoryModel
class GetAllCategoryModel {
  bool? success;
  List<FilterCategory>? data;

  GetAllCategoryModel({
    this.success,
    this.data,
  });

  factory GetAllCategoryModel.fromJson(Map<String, dynamic> json) {
    return GetAllCategoryModel(
      success: json['success'],
      data: (json['data'] as List?)
          ?.map((item) => FilterCategory.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

// Model for FilterCategory (which contains filters)
class FilterCategory {
  String? id;
  List<Filter>? filters;

  FilterCategory({
    this.id,
    this.filters,
  });

  factory FilterCategory.fromJson(Map<String, dynamic> json) {
    return FilterCategory(
      id: json['_id'],
      filters: (json['filters'] as List?)
          ?.map((item) => Filter.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'filters': filters?.map((item) => item.toJson()).toList(),
    };
  }
}

class Filter {
  String? id;
  String? subCategoryId;
  String? image;
  String? name;
  String? modelName;
  String? mode;
  String? duration;
  String? prompt;
  int? gender;
  DateTime? createdAt;
  DateTime? updatedAt;
  SubCategoryDetails? subCategoryDetails;

  Filter({
    this.id,
    this.subCategoryId,
    this.image,
    this.name,
    this.modelName,
    this.mode,
    this.duration,
    this.prompt,
    this.gender,
    this.createdAt,
    this.updatedAt,
    this.subCategoryDetails,
  });

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
      id: json['_id'],
      subCategoryId: json['subcategory_id'],
      image: json['image'],
      name: json['name'],
      modelName: json['model_name'],
      mode: json['mode'],
      duration: json['duration'],
      prompt: json['prompt'],
      gender: json['gender'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      subCategoryDetails: json['subcategory_details'] != null
          ? SubCategoryDetails.fromJson(json['subcategory_details'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'subcategory_id': subCategoryId,
      'image': image,
      'name': name,
      'model_name': modelName,
      'mode': mode,
      'duration': duration,
      'prompt': prompt,
      'gender': gender,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'subcategory_details': subCategoryDetails?.toJson(),
    };
  }
}

// Model for SubCategoryDetails
class SubCategoryDetails {
  String? id;
  String? aiAnimatorId;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  SubCategoryDetails({
    this.id,
    this.aiAnimatorId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory SubCategoryDetails.fromJson(Map<String, dynamic> json) {
    return SubCategoryDetails(
      id: json['_id'],
      aiAnimatorId: json['aiAnimator_id'],
      name: json['name'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'aiAnimator_id': aiAnimatorId,
      'name': name,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
