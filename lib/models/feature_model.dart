class FeatureModel {

  String _title;
  String _description;
  String _thumbnail;

  FeatureModel(this._title, this._description, this._thumbnail);


  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }


  String get thumbnail => _thumbnail;

  set assets(String value) {
    _thumbnail = value;
  }


}