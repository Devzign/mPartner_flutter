enum LuminuousUserType {
  ALL,
  DISTY,
  DEALER,
  ELECTRICIAN,
}

Map<LuminuousUserType, List<LuminuousUserType>> listOfRoles = {
  LuminuousUserType.DISTY: [
    LuminuousUserType.ALL,
    LuminuousUserType.DISTY,
    LuminuousUserType.DEALER,
    LuminuousUserType.ELECTRICIAN,
  ],
  LuminuousUserType.DEALER: [
    LuminuousUserType.ALL,
    LuminuousUserType.DEALER,
    LuminuousUserType.ELECTRICIAN,
  ],
  LuminuousUserType.ELECTRICIAN: [
    LuminuousUserType.ALL,
  ]
};
