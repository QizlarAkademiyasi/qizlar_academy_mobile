enum StoreProductType {
  physical,
  promocode;

  static StoreProductType fromString(String value) {
    return switch (value.toUpperCase()) {
      'PROMOCODE' => StoreProductType.promocode,
      _ => StoreProductType.physical,
    };
  }

  String toApiValue() => name.toUpperCase();
}
