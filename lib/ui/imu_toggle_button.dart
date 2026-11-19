import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wiimote_dsu/server/events/imu_mode_event.dart';
import 'package:wiimote_dsu/ui/theme/wii_controller_theme.dart';

/// Alterna quem recebe o movimento do celular (giroscópio/acelerômetro):
///  - MOTION: WIIMOTE  -> o celular move o Wiimote (padrão)
///  - MOTION: NUNCHUK  -> o Wiimote fica travado (giroscópio zerado,
///                        acelerômetro congelado) e o celular move o Nunchuk
///
/// O movimento do Nunchuk sai num pad DSU virtual extra (DSUClient/1 quando o
/// pad principal está no slot 0).
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

  @override
  void initState() {
    super.initState();
    _port = context.read<SendPort>();
    // Sempre começa no modo Wiimote.
    _port.send(ImuModeEvent(false));
  }

  @override
  void dispose() {
    // Ao sair do layout, devolve o movimento ao Wiimote.
    _port.send(ImuModeEvent(false));
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.mediumImpact();
    setState(() {
      _nunchuk = !_nunchuk;
    });
    _port.send(ImuModeEvent(_nunchuk));
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
