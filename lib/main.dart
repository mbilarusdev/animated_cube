import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CubeInherited(
      notifier: CubeNotifier(),
      child: Builder(builder: (context) {
        CubeNotifier cubeInherited = CubeInherited.of(context);
        final size = MediaQuery.sizeOf(context);
        final width = size.width;
        final height = size.height;
        final dx = (width / 2) - AnimatedCube.width;
        final dy = (height / 2) - AnimatedCube.height;

        cubeInherited.setStartPosition(Offset(dx, dy));
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Stack(
              children: [
                Positioned(
                  bottom: 10.0,
                  left: 10.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (cubeInherited.alignment != Alignment.centerLeft)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextButton(
                            onPressed: () {
                              cubeInherited.goToLeft();
                            },
                            child: const Text('Left'),
                          ),
                        ),
                      if (cubeInherited.alignment != Alignment.centerRight)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextButton(
                            onPressed: () {
                              cubeInherited.goToRight();
                            },
                            child: const Text('Right'),
                          ),
                        ),
                    ],
                  ),
                ),
                const AnimatedCube(),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// Notifier for [AnimatedCube]
///
/// Notifies for cube position changes
class CubeNotifier extends ChangeNotifier {
  /// Start position of cube
  Offset? startPosition;

  /// Current position of cube
  Offset? _position;

  Offset? get position => _position;

  /// Current cube alignment
  Alignment alignment = Alignment.center;

  /// Sets start position of cube
  void setStartPosition(Offset? position) {
    if (startPosition == null) {
      startPosition = position;
      _position = startPosition;
    }
  }

  /// Animate cube to left
  void goToLeft() {
    alignment = Alignment.centerLeft;
    _position = Offset(0, startPosition!.dy);
    notifyListeners();
  }

  /// Animate cube to right
  void goToRight() {
    alignment = Alignment.centerRight;
    _position = Offset(
      ((startPosition!.dx + AnimatedCube.width) * 2) - AnimatedCube.height,
      startPosition!.dy,
    );
    notifyListeners();
  }
}

/// Inherited widget with [CubeNotifier]
class CubeInherited extends InheritedNotifier<CubeNotifier> {
  const CubeInherited({super.key, required super.child, required super.notifier});

  static CubeNotifier of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CubeInherited>()!.notifier!;
  }
}

/// Cube with animated changes of position
///
/// Changes position from center to left or right.
class AnimatedCube extends StatefulWidget {
  const AnimatedCube({super.key});

  @override
  State<AnimatedCube> createState() => _AnimatedCubeState();

  /// Width of cube
  static double get width => 100;

  /// Height of cube
  static double get height => 100;
}

class _AnimatedCubeState extends State<AnimatedCube> {
  CubeNotifier? cubeInherited;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: cubeInherited!.position!.dy,
      left: cubeInherited!.position!.dx,
      duration: const Duration(seconds: 1),
      child: Container(
        width: AnimatedCube.width,
        height: AnimatedCube.height,
        color: Colors.orange,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    cubeInherited = CubeInherited.of(context);
    super.didChangeDependencies();
  }
}
