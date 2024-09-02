class WebLandingContentModel {
  String? responseCode;
  String? message;
  WebLandingContent? content;

  WebLandingContentModel(
      {this.responseCode, this.message, this.content});

  WebLandingContentModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    content =
    json['content'] != null ? WebLandingContent.fromJson(json['content']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['message'] = message;
    if (content != null) {
      data['content'] = content!.toJson();
    }

    return data;
  }
}

class WebLandingContent {
  String? topImage1;
  String? topImage2;
  String? topImage3;
  String? topImage4;
  String? supportSectionImage;
  String? downloadSectionImage;
  String? featureSectionImage;

  List<TextContent>? textContent;
  List<Testimonial>? testimonial;
  List<SocialMedia>? socialMedia;

  WebLandingContent(this.topImage1, this.topImage2, this.topImage3, this.topImage4, this.supportSectionImage, this.downloadSectionImage, this.featureSectionImage,
      {this.textContent, this.testimonial});

  WebLandingContent.fromJson(Map<String, dynamic> json) {

    topImage1 = json['top_image_1'];
    topImage2 = json['top_image_2'];
    topImage3 = json['top_image_3'];
    topImage4 = json['top_image_4'];

    supportSectionImage = json['support_section_image'];
    downloadSectionImage = json['download_section_image'];
    featureSectionImage = json['feature_section_image'];


    if (json['text_content'] != null) {
      textContent = <TextContent>[];
      json['text_content'].forEach((v) {
        textContent!.add(TextContent.fromJson(v));
      });
    }
    if (json['testimonial'] != null) {
      testimonial = <Testimonial>[];
      json['testimonial'].forEach((v) {
        testimonial!.add(Testimonial.fromJson(v));
      });
    }

    if (json['social_media'] != null) {
      socialMedia = <SocialMedia>[];
      json['social_media'].forEach((v) {
        socialMedia!.add(SocialMedia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (textContent != null) {
      data['text_content'] = textContent!.map((v) => v.toJson()).toList();
    }

    if (testimonial != null) {
      data['testimonial'] = testimonial!.map((v) => v.toJson()).toList();
    }

    if (socialMedia != null) {
      data['social_media'] = socialMedia!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerImage {
  String? keyName;
  String? liveValues;
  String? liveValuesFullPath;

  BannerImage({this.keyName, this.liveValues, this.liveValuesFullPath});

  BannerImage.fromJson(Map<String, dynamic> json) {
    keyName = json['key_name'];
    liveValues = json['live_values'];
    liveValuesFullPath = json['live_values_full_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_name'] = keyName;
    data['live_values'] = liveValues;
    data['live_values_full_path'] = liveValuesFullPath;
    return data;
  }
}

class TextContent {
  String? keyName;
  String? liveValues;

  TextContent({this.keyName, this.liveValues});

  TextContent.fromJson(Map<String, dynamic> json) {
    keyName = json['key'];
    liveValues = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = keyName;
    data['value'] = liveValues;
    return data;
  }
}
class ImageContent {
  String? keyName;
  String? liveValues;
  String? liveValuesFullPath;

  ImageContent({this.keyName, this.liveValues, this.liveValuesFullPath});

  ImageContent.fromJson(Map<String, dynamic> json) {
    keyName = json['key_name'];
    liveValues = json['live_values'];
    liveValuesFullPath = json['live_values_full_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_name'] = keyName;
    data['live_values'] = liveValues;
    data['live_values_full_path'] = liveValuesFullPath;
    return data;
  }
}

class Testimonial {
  String? id;
  String? name;
  String? designation;
  String? review;
  String? image;
  String? imageFullPath;

  Testimonial({this.id, this.name, this.designation, this.review, this.image, this.imageFullPath});

  Testimonial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    designation = json['designation'];
    review = json['review'];
    image = json['image'];
    imageFullPath = json['image_full_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['designation'] = designation;
    data['review'] = review;
    data['image'] = image;
    data['image_full_path'] = imageFullPath;
    return data;
  }
}

class SocialMedia {
  String? id;
  String? media;
  String? link;

  SocialMedia({this.id, this.media, this.link});

  SocialMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    media = json['media'];
    link = json['link'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['media'] = media;
    data['link'] = link;
    return data;
  }
}
class FeaturesImages {
  String? id;
  String? title;
  String? subTitle;
  String? image1;
  String? image2;

  FeaturesImages(
      {this.id, this.title, this.subTitle, this.image1, this.image2});

  FeaturesImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subTitle = json['sub_title'];
    image1 = json['image_1'];
    image2 = json['image_2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['sub_title'] = subTitle;
    data['image_1'] = image1;
    data['image_2'] = image2;
    return data;
  }
}
