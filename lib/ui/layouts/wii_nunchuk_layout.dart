import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wiimote_dsu/ui/a_b_buttons.dart';
import 'package:wiimote_dsu/ui/analog_thumbstick.dart';
import 'package:wiimote_dsu/ui/buttons/button_rectangle.dart';
import 'package:wiimote_dsu/ui/buttons/button_round.dart';
import 'package:wiimote_dsu/ui/dpad.dart';
import 'package:wiimote_dsu/ui/imu_toggle_button.dart';
import 'package:wiimote_dsu/ui/layouts/device_layout.dart';
import 'package:wiimote_dsu/ui/minus_home_plus_buttons.dart';
import 'package:wiimote_dsu/ui/one_two_buttons.dart';

/// Wii Remote + Nunchuk.
///
/// Botões do Wiimote iguais ao layout "WiiMoteDSU" (A/B/1/2/-/Home/+/D-pad/
/// recenter) mais o Nunchuk: stick analógico esquerdo, C, Z e SHAKE.
///
/// Mapeamento DSU (casa com WiiMoteDSU-Nunchuk.ini):
///   stick -> Left X/Y, C -> R1, Z -> L1, SHAKE -> R3
///
/// O botão "MOTION" alterna o movimento do celular entre o Wiimote e o
/// Nunchuk (ver ImuToggleButton).
class WiiNunchukLayout extends StatelessWidget implements DeviceLayout {
  static const String name = "WiiMote+Nunchuk";
  static const DeviceOrientation preferredOrientation =
      DeviceOrientation.portraitUp;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final h = screenSize.height;
    final w = screenSize.width;
    final double stickRadius = min(60.0, max(40.0, h * 0.09));

    return SizedBox(
      width: w,
      height: h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // espaço para os ícones de settings/slot no topo da tela
          SizedBox(height: h * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Dpad(size: h * 0.2),
              ABButtons(width: h * 0.07, height: h * 0.18),
            ],
          ),
          SizedBox(height: h * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              PadRectangleButton(
                btnType: "recenter",
                width: w * 0.4,
                height: h * 0.05,
              ),
              PadRectangleButton(
                btnType: "SHAKE",
                width: w * 0.3,
                height: h * 0.05,
              ),
            ],
          ),
          SizedBox(height: h * 0.015),
          ImuToggleButton(width: w * 0.7, height: h * 0.05),
          SizedBox(height: h * 0.015),
          SizedBox(
            width: h * 0.15,
            height: h * 0.15 / 4,
            child: MinusHomePlusButtons(
              width: h * 0.15,
              height: h * 0.15 / 4,
            ),
          ),
          SizedBox(height: h * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Stick do Nunchuk
              AnalogThumbStick(
                radius: stickRadius,
                stickRadius: stickRadius * 0.7,
              ),
              // C (redondo) e Z (gatilho) do Nunchuk
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  PadRoundButton(
                    btnType: "C",
                    width: h * 0.07,
                    height: h * 0.07,
                  ),
                  SizedBox(height: h * 0.015),
                  PadRectangleButton(
                    btnType: "Z",
                    width: h * 0.07,
                    height: h * 0.07,
                  ),
                ],
              ),
              // 1 e 2 do Wiimote
              OneTwoButtons(
                width: h * 0.15 / 2.5,
                height: h * 0.15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
