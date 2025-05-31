import 'dart:math';

import 'package:fantasy_rice/widgets/dock/dock.dart';
import 'package:fantasy_rice/widgets/lock/lock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayland_shell/wayland_shell.dart';
import 'package:widget_mask/widget_mask.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = useState(<String, int>{});
    final pausedScreen = useState<int?>(null);
    final ac = useAnimationController(initialValue: 0.0);

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Dock(),
            if (pausedScreen.value != null)
              AnimatedBuilder(
                  animation: ac,
                  child: null,
                  builder: (context, child) {
                    return Container(
                      color: Colors.black
                          .withValues(alpha: ac.value == 0.0 ? 0.0 : 1.0),
                      child: Stack(
                        children: [
                          if (ac.value != 0.0)
                            Positioned.fill(
                              child: Image(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  "assets/purple_oil_background.jpg",
                                ),
                              ),
                            ),
                          if (ac.value != 0.0)
                            Transform.scale(
                              scale: 0.8 + 0.2 * (1 - ac.value),
                              child: Container(
                                foregroundDecoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(100 * ac.value),
                                  color: const Color.fromARGB(255, 0, 0, 0)
                                      .withValues(alpha: 0.5 * ac.value),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(100 * ac.value),
                                  border: Border.all(
                                    width: 5.0 * ac.value,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(100 * ac.value),
                                  child: Texture(
                                    textureId: pausedScreen.value!,
                                  ),
                                ),
                              ),
                            ),
                          LockOverlay(progress: ac.value)
                        ],
                      ),
                    );
                  }),
            Center(
              child: Container(
                color: Colors.transparent,
                height: 200,
                child: Column(
                  children: [
                    InputRegion(
                      child: Container(
                        height: 50,
                        width: 120,
                        padding: EdgeInsets.all(10),
                        color: Colors.amber,
                        child: TextButton(
                          onPressed: () async {
                            final b = (await const MethodChannel("general")
                                .invokeMethod('get_single_screen') as int);

                            pausedScreen.value = b;
                            ac.animateTo(1.0,
                                curve: Curves.easeOutExpo,
                                duration: Duration(milliseconds: 500));

                            await Future.delayed(Duration(seconds: 2));

                            // pausedScreen.value = null;
                            ac.animateTo(0.0,
                                curve: Curves.easeOutExpo,
                                duration: Duration(milliseconds: 500));

                            // final a = (await const MethodChannel("general")
                            //             .invokeMethod('get_window_textures')
                            //         as Map<Object?, Object?>)
                            //     .map(
                            //   (key, value) => MapEntry(
                            //     key as String,
                            //     value as int,
                            //   ),
                            // );
                            // a.addAll({"screen": b});
                            // counter.value = a;
                          },
                          child: Text("Hello"),
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      color: Colors.transparent,
                      child: Row(
                        children: counter.value.entries
                            .map(
                              (e) => Container(
                                width: 100,
                                height: 100,
                                color: Colors.blue,
                                child: Texture(
                                  textureId: e.value,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     WaylandShell.clearInputRegions();

//     super.initState();
//   }

//   bool e = true;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Center(
//           child: InputRegion(
//             enabled: e,
//             child: Container(
//               padding: const EdgeInsets.all(16.0),
//               color: Colors.white.withValues(alpha: 0.2),
//               child: TextButton(
//                 child: const Text(
//                   'Hello, World!',
//                   style: TextStyle(
//                     color: Colors.redAccent,
//                     fontSize: 32.0,
//                     // backgroundColor: Colors.greenAccent,
//                   ),
//                 ),
//                 onPressed: () async {
//                   print("Pressed");

//                   (await const MethodChannel("general").invokeMethod('get_window_textures') as Map<Object?, Object?>).map(                       
//                     (key, value) => MapEntry(                                                                                                          
//                       key as String,                                                                                                                   
//                       value as int,                                                                                                                    
//                     ),                                                                                                                                 
//                   );                                                                                                                                   

          
//                   setState(() {
//                     e = false;
//                   });
//                   await Future.delayed(const Duration(seconds: 1));
//                   setState(() {
//                     e = true;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
