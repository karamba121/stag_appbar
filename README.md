# stag_appbar

A customizable Flutter app bar designed to complement [stag_sidebar](https://pub.dev/packages/stag_sidebar). Both share dark and light palettes, rounded corners and shadows. The packages can be used independently.

## Installation

Add `stag_appbar` to your dependencies. Before publishing, use a local path or Git dependency:

```yaml
dependencies:
  stag_appbar:
    path: ../stag_appbar
  stag_sidebar: ^0.2.1
```

## Usage

`StagAppBar` implements `PreferredSizeWidget`, so it can be used directly in a `Scaffold`:

```dart
Scaffold(
  appBar: StagAppBar(
    title: const Text('Dashboard', overflow: TextOverflow.ellipsis),
    leading: const Icon(Icons.dashboard_outlined),
    actions: [
      IconButton(
        tooltip: 'Notifications',
        onPressed: () {},
        icon: const Icon(Icons.notifications_outlined),
      ),
    ],
  ),
  body: const Center(child: Text('Content')),
)
```

The `title`, optional `leading` and `actions` accept Flutter widgets. Actions scroll horizontally when space is limited; use an ellipsis or another constrained widget for long titles. Set `height` to change the toolbar height.

## Using both components

Use `StagAppBarLayout` inside a bounded area, such as a `Scaffold` body. It accepts any sidebar widget and does not depend on `stag_sidebar`.

```dart
StagAppBarLayout(
  // The default is aboveSidebar; use besideSidebar for the other layout.
  mode: StagAppBarLayoutMode.aboveSidebar,
  appBar: const StagAppBar(title: Text('Dashboard')),
  sidebar: StagSidebar(
    selectedId: selectedId,
    onItemSelected: onItemSelected,
    sections: sections,
  ),
  body: page,
)
```

`aboveSidebar` places the app bar across the top, with the sidebar and page below. `besideSidebar` places the sidebar on the left and the app bar above the page to its right. Change `mode` to switch layouts and `spacing` to adjust the gaps. Wrap the layout in `SafeArea` and `Padding` if needed. Provide a sidebar width appropriate for the available screen width; the layout does not automatically collapse it.
Use `StagAppBarStyle()` and `StagSidebarStyle()` for the dark palette, or their `.light()` constructors for the light palette. Override the app bar style's colors, text style, padding, corner radius and shadows to match your application's branding.

## Example

The example includes both packages, navigation selection, a layout switch and a light/dark toggle. To run it, generate platform files once and start Flutter:

```bash
cd example
flutter create --platforms=web .
flutter run -d chrome
```

