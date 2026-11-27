import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

const _paper = Color(0xfff7f4e9);
const _ink = Color(0xff1e2928);
const _mint = Color(0xffd9f599);
const _field = Color(0xff123e3d);
const _orange = Color(0xfff29369);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'HexaBlock',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: _field),
      scaffoldBackgroundColor: _paper,
    ),
    home: const _Home(),
  );
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: _PageBody(
      children: [
        const Text(
          'HexaBlock',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 46,
            letterSpacing: -2.8,
            color: _ink,
          ),
        ),
        const Divider(color: _ink),
        const SizedBox(height: 18),
        const Text(
          'Elige un juego',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Material(
          color: _field,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (_) => const _Lines())),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _BoardPrint(),
                Padding(
                  padding: EdgeInsets.fromLTRB(22, 8, 18, 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Hexa Lines',
                          style: TextStyle(
                            fontSize: 32,
                            color: _paper,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward, color: _mint),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (final game in ['Hexa Sort', 'Hexa Merge'])
          ListTile(
            contentPadding: EdgeInsets.zero,
            enabled: false,
            leading: Icon(
              game == 'Hexa Sort'
                  ? Icons.layers_outlined
                  : Icons.filter_2_outlined,
            ),
            title: Text(
              game,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            trailing: const Text(
              'Próximamente',
              style: TextStyle(color: Color(0xff586461)),
            ),
            shape: const Border(bottom: BorderSide(color: Color(0xffcccfc3))),
          ),
      ],
    ),
  );
}

class _Lines extends StatelessWidget {
  const _Lines();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: _paper,
      foregroundColor: _ink,
      title: const Text('Hexa Lines'),
    ),
    body: const _PageBody(
      children: [
        Text(
          'Cómo jugar',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: _ink,
            letterSpacing: -1.8,
          ),
        ),
        SizedBox(height: 18),
        ColoredBox(color: _field, child: _BoardPrint()),
        SizedBox(height: 20),
        Text(
          'Completa líneas en tres direcciones',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Gira una pieza de la bandeja y colócala en un espacio libre. Cuando llenas una línea de borde a borde, sus fichas desaparecen.',
          style: TextStyle(fontSize: 18, height: 1.5),
        ),
        SizedBox(height: 24),
        Divider(color: Color(0xffcccfc3)),
        Text(
          'Partida próximamente disponible.',
          style: TextStyle(color: Color(0xff53605b)),
        ),
      ],
    ),
  );
}

class _PageBody extends StatelessWidget {
  const _PageBody({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
          children: children,
        ),
      ),
    ),
  );
}

/// Decorative axial-grid print. The raised tiles trace a complete row.
class _BoardPrint extends StatelessWidget {
  const _BoardPrint();

  @override
  Widget build(BuildContext context) =>
      const SizedBox(height: 155, child: CustomPaint(painter: _TilePrint()));
}

class _TilePrint extends CustomPainter {
  const _TilePrint();

  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.height / 8.6, size.width / 12);
    final origin = Offset(size.width / 2, size.height / 2);
    final fill = Paint();
    for (var r = -2; r <= 2; r++) {
      for (var q = -2; q <= 2; q++) {
        if ((q + r).abs() > 2) continue;
        final center =
            origin +
            Offset(math.sqrt(3) * radius * (q + r / 2), 1.5 * radius * r);
        final tile = Path();
        for (var i = 0; i < 6; i++) {
          final angle = math.pi * (i / 3 - 1 / 6);
          final x = center.dx + (radius - 1.5) * math.cos(angle);
          final y = center.dy + (radius - 1.5) * math.sin(angle);
          if (i == 0) {
            tile.moveTo(x, y);
          } else {
            tile.lineTo(x, y);
          }
        }
        tile.close();
        canvas.drawPath(
          tile.shift(const Offset(0, 4)),
          fill..color = const Color(0xff092b2b),
        );
        fill.color = r == 0
            ? (q == 2 ? _orange : _mint)
            : const Color(0xff336360);
        canvas.drawPath(tile, fill);
      }
    }
  }

  @override
  bool shouldRepaint(_TilePrint oldDelegate) => false;
}
