import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stag_appbar/stag_appbar.dart';

void main() {
  testWidgets('works in Scaffold and invokes actions', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: StagAppBar(
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                onPressed: () => taps++,
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Dashboard'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.search));
    expect(taps, 1);
    expect(tester.getSize(find.byType(StagAppBar)).height, 64);
  });

  testWidgets('light style and narrow layouts work', (tester) async {
    tester.view.physicalSize = const Size(240, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: StagAppBar(
            title: const Text('A long title', overflow: TextOverflow.ellipsis),
            style: const StagAppBarStyle.light(),
            actions: List.generate(
              5,
              (_) => const IconButton(onPressed: null, icon: Icon(Icons.star)),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsWidgets);
  });
  testWidgets('positions app bar relative to sidebar in both modes', (
    tester,
  ) async {
    Future<void> pumpLayout(StagAppBarLayoutMode mode) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StagAppBarLayout(
              mode: mode,
              appBar: const StagAppBar(key: Key('bar'), title: Text('Title')),
              sidebar: const SizedBox(key: Key('sidebar'), width: 100),
              body: const SizedBox.expand(key: Key('body')),
            ),
          ),
        ),
      );
    }

    await pumpLayout(StagAppBarLayoutMode.aboveSidebar);
    final barAbove = tester.getRect(find.byKey(const Key('bar')));
    final sidebarBelow = tester.getRect(find.byKey(const Key('sidebar')));
    expect(barAbove.left, sidebarBelow.left);
    expect(barAbove.bottom, lessThan(sidebarBelow.top));
    expect(barAbove.right, tester.getRect(find.byKey(const Key('body'))).right);

    await pumpLayout(StagAppBarLayoutMode.besideSidebar);
    final barBeside = tester.getRect(find.byKey(const Key('bar')));
    final sidebarBeside = tester.getRect(find.byKey(const Key('sidebar')));
    expect(barBeside.top, sidebarBeside.top);
    expect(barBeside.left, greaterThan(sidebarBeside.right));
    expect(
      tester.getRect(find.byKey(const Key('body'))).top,
      greaterThan(barBeside.bottom),
    );
    expect(tester.takeException(), isNull);
  });
}
