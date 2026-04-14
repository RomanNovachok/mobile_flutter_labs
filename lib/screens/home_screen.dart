import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/cubit/home_cubit.dart';
import 'package:mobile_flutter_lab1/cubit/home_state.dart';
import 'package:mobile_flutter_lab1/cubit/machine_events_cubit.dart';
import 'package:mobile_flutter_lab1/routes/app_routes.dart';
import 'package:mobile_flutter_lab1/widgets/home_screen_content.dart';
import 'package:mobile_flutter_lab1/widgets/machine_events_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listenWhen: (previous, current) =>
              previous.notificationMessage != current.notificationMessage &&
              current.notificationMessage != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.notificationMessage!)),
            );
            context.read<HomeCubit>().clearNotification();
          },
        ),
        BlocListener<HomeCubit, HomeState>(
          listenWhen: (previous, current) =>
              previous.hasInternet != current.hasInternet &&
              current.hasInternet,
          listener: (context, state) {
            context.read<MachineEventsCubit>().loadEvents(
              hasInternet: true,
            );
          },
        ),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final mqttLabel = _mqttLabel(state.mqttIndicator);
          final mqttColor = _mqttColor(state.mqttIndicator);

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'LatheGuard IoT',
                style: TextStyle(fontSize: context.sp(20)),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: context.sp(8)),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.profile);
                    },
                    icon: Icon(
                      Icons.account_circle,
                      size: context.sp(32),
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(context.sp(20)),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: context.isTablet ? 700 : double.infinity,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HomeGreetingSection(
                        user: state.user,
                        hasInternet: state.hasInternet,
                        mqttStatusLabel: mqttLabel,
                        mqttStatusColor: mqttColor,
                      ),
                      SizedBox(height: context.sp(20)),
                      const HomeMachineOverviewCard(),
                      SizedBox(height: context.sp(20)),
                      HomeStatusGrid(
                        floodStatus: state.floodStatus,
                        latheSpeed: state.latheSpeed,
                      ),
                      SizedBox(height: context.sp(24)),
                      const HomeQuickControlsSection(),
                      SizedBox(height: context.sp(24)),
                      HomeLastEventCard(lastEvent: state.lastEvent),
                      SizedBox(height: context.sp(24)),
                      MachineEventsSection(hasInternet: state.hasInternet),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String? _mqttLabel(HomeMqttIndicator indicator) {
    switch (indicator) {
      case HomeMqttIndicator.connecting:
        return 'Connecting...';
      case HomeMqttIndicator.connected:
        return 'Connected!';
      case HomeMqttIndicator.none:
        return null;
    }
  }

  Color? _mqttColor(HomeMqttIndicator indicator) {
    switch (indicator) {
      case HomeMqttIndicator.connecting:
        return Colors.orange;
      case HomeMqttIndicator.connected:
        return Colors.green;
      case HomeMqttIndicator.none:
        return null;
    }
  }
}
