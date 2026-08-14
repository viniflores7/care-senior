import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_motion.dart';

/// Barra de navegação inferior inspirada no design de círculo flutuante.
/// O item selecionado ganha um fundo circular que transborda a barra,
/// e o ícone desliza para cima para se encaixar nele.
class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;

  static const double barHeight = 72;
  static const double _circleSize = 64;
  static const double _circleTop = -20;
  static const double _barCornerRadius = 24;
  static const double _circleBorderWidth = 6;
  static const Color _shadowColor = Color(0x0D000000);

  @override
  Widget build(BuildContext context) {
    // O fundo branco fica FORA do SafeArea de propósito: assim ele também
    // pinta a faixa de inset inferior (gesto/home indicator do celular) em
    // vez de deixar essa faixa transparente e mostrar o fundo do Scaffold.
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(_barCornerRadius),
        ),
        boxShadow: const [
          BoxShadow(color: _shadowColor, blurRadius: 10, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: barHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / destinations.length;
              final circleLeft =
                  itemWidth * selectedIndex + itemWidth / 2 - _circleSize / 2;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  _FloatingCircle(left: circleLeft),
                  _DestinationsRow(
                    destinations: destinations,
                    selectedIndex: selectedIndex,
                    onDestinationSelected: onDestinationSelected,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Círculo animado que desliza entre as abas, acompanhando o item selecionado.
class _FloatingCircle extends StatelessWidget {
  const _FloatingCircle({required this.left});

  final double left;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: AppMotion.medium,
      curve: AppMotion.curve,
      left: left,
      top: AppNavigationBar._circleTop,
      width: AppNavigationBar._circleSize,
      height: AppNavigationBar._circleSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColor.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColor.primary.withValues(alpha: 0.15),
            width: AppNavigationBar._circleBorderWidth,
          ),
        ),
      ),
    );
  }
}

class _DestinationsRow extends StatelessWidget {
  const _DestinationsRow({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < destinations.length; i++)
          Expanded(
            child: _NavItem(
              destination: destinations[i],
              selected: i == selectedIndex,
              onTap: () => onDestinationSelected(i),
            ),
          ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final NavigationDestination destination;
  final bool selected;
  final VoidCallback onTap;

  static const double _iconTopSelected = -2;
  static const double _iconTopUnselected = 16;
  static const double _labelBottom = 12;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? AppColor.primary
        : AppColor.textDark.withValues(alpha: 0.6);

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        height: AppNavigationBar.barHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: AppMotion.medium,
              curve: AppMotion.curve,
              top: selected ? _iconTopSelected : _iconTopUnselected,
              child: IconTheme(
                data: IconThemeData(color: color, size: 26),
                child: selected
                    ? (destination.selectedIcon ?? destination.icon)
                    : destination.icon,
              ),
            ),
            AnimatedPositioned(
              duration: AppMotion.medium,
              curve: AppMotion.curve,
              bottom: _labelBottom,
              child: Text(
                destination.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
