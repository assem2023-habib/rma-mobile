import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/routes_bloc.dart';
import '../bloc/routes_event.dart';
import '../bloc/routes_state.dart';
import '../widgets/route_card.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  @override
  void initState() {
    super.initState();
    context.read<RoutesBloc>().add(GetRoutesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المسارات المتاحة', style: AppTypography.heading2),
      ),
      body: BlocBuilder<RoutesBloc, RoutesState>(
        builder: (context, state) {
          if (state is RoutesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RoutesError) {
            return Center(child: Text(state.message));
          } else if (state is RoutesLoaded) {
            if (state.routes.isEmpty) {
              return const Center(child: Text('لا توجد مسارات حالياً'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.spacing4),
              itemCount: state.routes.length,
              itemBuilder: (context, index) {
                final route = state.routes[index];
                return RouteCard(
                  route: route,
                  onTap: () {
                    context.push('/route-detail', extra: route);
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
