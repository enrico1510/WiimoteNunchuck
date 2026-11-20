import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wiimote_dsu/models/device_settings.dart';
import 'package:wiimote_dsu/server/events/button_event.dart';
import 'package:wiimote_dsu/ui/theme/wii_controller_theme.dart';

/// Botão liga/desliga "MOTION": fica travado enviando L3 enquanto estiver em
/// NUNCHUK. O Dolphin usa esse sinal (L3) numa expressão `if(...)` para zerar o
/// giroscópio/acelerômetro do Wiimote e liberar o acelerômetro do Nunchuk
/// (ver WiiMoteDSU-Nunchuk.ini). O app não envia mais nada além do L3.
class ImuToggleButton extends StatefulWidget {
  final double width;
  final double height;

  const ImuToggleButton({Key? key, this.width = 160.0, this.height = 40.0})
      : super(key: key);

  @override
  State<ImuToggleButton> createState() => _ImuToggleButtonState();
}

class _ImuToggleButtonState extends State<ImuToggleButton> {
  bool _nunchuk = false;
  late final SendPort _port;
  late final int _slot;

  @override
  void initState() {
    super.initState();
    _port = context.read<SendPort>();
    _slot = context.read<DeviceSettings>().slot;
    // Sempre começa no modo Wiimote (L3 solto).
    _send(false);
  }

  @override
  void dispose() {
    // Ao sair do layout, solta o L3.
    _send(false);
    super.dispose();
  }

  void _send(bool on) {
    _port.send(ButtonEvent(_slot, "MOTION", on ? 0xFF : 0x00));
  }

  void _toggle() {
    HapticFeedback.mediumImpact();
    setState(() {
      _nunchuk = !_nunchuk;
    });
    _send(_nunchuk);
  }

  @override
  Widget build(BuildContext context) {
    final wiiTheme = context.wiiControllerTheme;
    final scheme = Theme.of(context).colorScheme;
    final fg = _nunchuk ? scheme.onPrimary : wiiTheme.buttonForeground;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: MaterialButton(
        padding: const EdgeInsets.all(0.0),
        onPressed: _toggle,
        color: _nunchuk ? scheme.primary : wiiTheme.buttonColor,
        height: widget.height,
        minWidth: widget.width,
        child: Text(
          _nunchuk ? 'MOTION: NUNCHUK' : 'MOTION: WIIMOTE',
          style: TextStyle(
            fontSize: widget.height * 0.32,
            fontWeight: FontWeight.bold,
            color: fg,
          ),
        ),
      ),
    );
  }
}
