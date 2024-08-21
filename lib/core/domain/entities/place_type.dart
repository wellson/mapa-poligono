enum PlaceType {
  other('Não especificado'),
  park('Parque'),
  restaurant('Restaurante'),
  store('Loja');

  const PlaceType(
    this.param,
  );

  final String param;

  bool get isOther => this == PlaceType.other;
  bool get isPark => this == PlaceType.park;
  bool get isRestaurant => this == PlaceType.restaurant;
  bool get isStore => this == PlaceType.store;

  static PlaceType fromParam(String param) {
    return PlaceType.values.firstWhere((e) => e.param == param, orElse: () => PlaceType.other);
  }
}
