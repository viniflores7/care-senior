import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_motion.dart';
import 'package:care_senior_study/ui/screens/account/account_tab.dart';
import 'package:care_senior_study/ui/screens/guardian/home_screen/guardian_home_screen_view_model.dart';
import 'package:care_senior_study/ui/screens/guardian/home_screen/widgets/clinic_discovery_tab.dart';
import 'package:care_senior_study/ui/screens/guardian/home_screen/widgets/guardian_clinic_tab.dart';
import 'package:care_senior_study/ui/screens/guardian/home_screen/widgets/guardian_residents_tab.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_navigation_bar/app_navigation_bar.dart';
import 'package:care_senior_study/ui/widgets/app_notification_bell/app_notification_bell.dart';

class GuardianHomeScreen extends StatefulWidget {
  const GuardianHomeScreen({super.key});

  @override
  State<GuardianHomeScreen> createState() => _GuardianHomeScreenState();
}

class _GuardianHomeScreenState extends State<GuardianHomeScreen>
    with SingleTickerProviderStateMixin {
  final viewModel = GuardianHomeScreenViewModel();
  int selectedIndex = 0;
  late final _tabFade = AnimationController(
    vsync: this,
    duration: AppMotion.fast,
    value: 1,
  );

  static const _linkedTitles = ['Meus idosos', 'Clínica', 'Perfil'];
  static const _unlinkedTitles = ['Clínicas', 'Perfil'];

  static const _linkedDestinations = [
    NavigationDestination(
      icon: Icon(Icons.people_outline),
      selectedIcon: Icon(Icons.people),
      label: 'Meus idosos',
    ),
    NavigationDestination(
      icon: Icon(Icons.apartment_outlined),
      selectedIcon: Icon(Icons.apartment),
      label: 'Clínica',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Perfil',
    ),
  ];

  static const _unlinkedDestinations = [
    NavigationDestination(
      icon: Icon(Icons.apartment_outlined),
      selectedIcon: Icon(Icons.apartment),
      label: 'Clínicas',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Perfil',
    ),
  ];

  @override
  void initState() {
    super.initState();
    viewModel.loadData();
  }

  void _selectTab(int index) {
    setState(() => selectedIndex = index);
    _tabFade.forward(from: 0);
  }

  @override
  void dispose() {
    _tabFade.dispose();
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final isLinked = viewModel.isLinked;
        final titles = isLinked ? _linkedTitles : _unlinkedTitles;

        return AppBasePage(
          title: titles[selectedIndex],
          actions: [
            AppNotificationBell(
              hasUnread: viewModel.hasUnreadNotifications,
              onTap: () => viewModel.navigateToNotifications(context),
            ),
          ],
          bottomNavigationBar: AppNavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: _selectTab,
            destinations: isLinked
                ? _linkedDestinations
                : _unlinkedDestinations,
          ),
          body: AnimatedSwitcher(
            duration: AppMotion.medium,
            child: viewModel.isLoading
                ? const Center(
                    key: ValueKey('loading'),
                    child: CircularProgressIndicator(),
                  )
                : FadeTransition(
                    key: const ValueKey('content'),
                    opacity: _tabFade,
                    child: IndexedStack(
                      index: selectedIndex,
                      children: isLinked
                          ? [
                              GuardianResidentsTab(
                                residents: viewModel.residents,
                                onView: (residentId) =>
                                    viewModel.navigateToResidentDetail(
                                      context,
                                      residentId,
                                    ),
                              ),
                              GuardianClinicTab(
                                clinics: viewModel.linkedClinics,
                              ),
                              AccountTab(
                                name: viewModel.guardianName,
                                subtitle: viewModel.guardianEmail,
                                photoPath: viewModel.guardianPhotoPath,
                                showNotifications: true,
                                onSecurityTap: () => viewModel
                                    .navigateToAccountSecurity(context),
                                onLogout: () => viewModel.logout(context),
                              ),
                            ]
                          : [
                              ClinicDiscoveryTab(
                                clinics: viewModel.clinicsToContact,
                                contactedClinics: viewModel.contactedClinics,
                                onContact: viewModel.contactViaWhatsApp,
                              ),
                              AccountTab(
                                name: viewModel.guardianName,
                                subtitle: viewModel.guardianEmail,
                                photoPath: viewModel.guardianPhotoPath,
                                showNotifications: false,
                                onSecurityTap: () => viewModel
                                    .navigateToAccountSecurity(context),
                                onLogout: () => viewModel.logout(context),
                              ),
                            ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
