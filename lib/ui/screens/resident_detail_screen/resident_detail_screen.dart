import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_motion.dart';
import 'package:care_senior_study/routing/args/resident_detail_screen_arguments.dart';
import 'package:care_senior_study/ui/screens/resident_detail_screen/resident_detail_screen_view_model.dart';
import 'package:care_senior_study/ui/screens/resident_detail_screen/widgets/resident_activities_tab.dart';
import 'package:care_senior_study/ui/screens/resident_detail_screen/widgets/resident_clinic_tab.dart';
import 'package:care_senior_study/ui/screens/resident_detail_screen/widgets/resident_health_tab.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_navigation_bar/app_navigation_bar.dart';

class ResidentDetailScreen extends StatefulWidget {
  const ResidentDetailScreen({super.key, required this.args});

  final ResidentDetailScreenArguments args;

  @override
  State<ResidentDetailScreen> createState() => _ResidentDetailScreenState();
}

class _ResidentDetailScreenState extends State<ResidentDetailScreen>
    with SingleTickerProviderStateMixin {
  late final viewModel = ResidentDetailScreenViewModel(
    residentId: widget.args.residentId,
    viewerRole: widget.args.viewerRole,
  );
  int selectedIndex = 0;
  late final _tabFade = AnimationController(
    vsync: this,
    duration: AppMotion.fast,
    value: 1,
  );

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
          title: viewModel.resident?.name ?? 'Detalhes do idoso',
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
                        ResidentActivitiesTab(
                          activities: viewModel.activities,
                          residentId: viewModel.residentId,
                          completedCount: viewModel.completedCount,
                          totalCount: viewModel.totalCount,
                          isStaff: viewModel.isStaff,
                          onScheduleActivity: () =>
                              viewModel.scheduleActivity(context),
                          onView: (activity) =>
                              viewModel.viewActivityDetail(context, activity),
                        ),
                        ResidentHealthTab(
                          resident: viewModel.resident,
                          medications: viewModel.medications,
                          records: viewModel.healthRecords,
                          showAddButton: viewModel.isStaff,
                          onAddMedication: () =>
                              viewModel.navigateToAddMedication(context),
                          onAdd: () =>
                              viewModel.navigateToAddHealthRecord(context),
                        ),
                        ResidentClinicTab(
                          clinic: viewModel.clinic,
                          resident: viewModel.resident,
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
