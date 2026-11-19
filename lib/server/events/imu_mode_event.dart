class ImuModeEvent {
  /// true: o movimento do celular controla o Nunchuk (Wiimote travado)
  /// false: o movimento do celular controla o Wiimote
  final bool nunchukActive;

  ImuModeEvent(this.nunchukActive);
}
