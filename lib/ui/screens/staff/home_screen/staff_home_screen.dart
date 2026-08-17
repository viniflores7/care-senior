import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_motion.dart';
import 'package:care_senior_study/ui/screens/account/account_tab.dart';
import 'package:care_senior_study/ui/screens/staff/home_screen/staff_home_screen_view_model.dart';
import 'package:care_senior_study/ui/screens/staff/home_screen/widgets/clinic_agenda_tab.dart';
import 'package:care_senior_study/ui/screens/staff/home_screen/widgets/clinic_health_tab.dart';
import 'package:care_senior_study/ui/screens/staff/home_screen/widgets/clinic_info_tab.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_navigation_bar/app_navigation_bar.dart';
import 'package:care_senior_study/ui/widgets/app_notification_bell/app_notification_bell.dart';

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({super.key});

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen>
    with SingleTickerProviderStateMixin {
  final viewModel = StaffHomeScreenViewModel();
  int selectedIndex = 0;
  late final _tabFade = AnimationController(
    vsync: this,
    duration: AppMotion.fast,
    value: 1,
  );

  static const _titles = ['Agenda', 'Saúde', 'Clínica', 'Perfil'];

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
        return AppBasePage(
          title: _titles[selectedIndex],
          actions: [
            AppNotificationBell(
              hasUnread: viewModel.hasUnreadNotifications,
              onTap: () => viewModel.navigateToNotifications(context),
            ),
          ],
          bottomNavigationBar: AppNavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: _selectTab,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.event_note_outlined),
                selectedIcon: Icon(Icons.event_note),
                label: 'Agenda',
              ),
              NavigationDestination(
                icon: Icon(Icons.monitor_heart_outlined),
                selectedIcon: Icon(Icons.monitor_heart),
                label: 'Saúde',
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
            ],
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
                      children: [
                        ClinicAgendaTab(
                          todayActivities: viewModel.todayActivities,
                          tomorrowActivities: viewModel.tomorrowActivities,
                          onScheduleActivity: () =>
                              viewModel.navigateToScheduleActivity(context),
                          onView: (activity) => viewModel
                              .navigateToActivityDetail(context, activity),
                        ),
                        ClinicHealthTab(
                          medications: viewModel.medications,
                          records: viewModel.healthRecords,
                          residents: viewModel.residents,
                          onAddMedication: (residentId) => viewModel
                              .navigateToAddMedication(context, residentId),
                          onAddRecord: (residentId) => viewModel
                              .navigateToAddHealthRecord(context, residentId),
                        ),
                        ClinicInfoTab(
                          clinic: viewModel.clinic,
                          residents: viewModel.residents,
                          onViewResident: (residentId) => viewModel
                              .navigateToResidentDetail(context, residentId),
                          onAddGuardian: () =>
                              viewModel.navigateToAddGuardian(context),
                          canManageRequests: viewModel.canManageRequests,
                          pendingLinkRequestsCount:
                              viewModel.pendingLinkRequestsCount,
                          onViewLinkRequests: () =>
                              viewModel.navigateToLinkRequests(context),
                          pendingOutingRequestsCount:
                              viewModel.pendingOutingRequestsCount,
                          onViewOutingRequests: () =>
                              viewModel.navigateToOutingRequests(context),
                        ),
                        AccountTab(
                          name: viewModel.staffName,
                          subtitle: viewModel.staffEmail,
                          photoPath: viewModel.staffPhotoPath,
                          onSecurityTap: () =>
                              viewModel.navigateToAccountSecurity(context),
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
