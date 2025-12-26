import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/parcels_bloc.dart';
import '../bloc/parcels_event.dart';
import '../bloc/parcels_state.dart';
import '../widgets/parcel_card.dart';

class ParcelsPage extends StatefulWidget {
  const ParcelsPage({super.key});

  @override
  State<ParcelsPage> createState() => _ParcelsPageState();
}

class _ParcelsPageState extends State<ParcelsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ParcelsBloc>().add(GetParcelsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طرودي', style: AppTypography.heading2),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing4),
            child: TextField(
              onChanged: (value) {
                context.read<ParcelsBloc>().add(SearchParcelsEvent(value));
              },
              decoration: const InputDecoration(
                hintText: 'البحث عن طرد برقم التتبع أو الاسم...',
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing4,
                  vertical: AppDimensions.spacing3,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ParcelsBloc, ParcelsState>(
              builder: (context, state) {
                if (state is ParcelsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ParcelsError) {
                  return Center(child: Text(state.message));
                } else if (state is ParcelsLoaded) {
                  if (state.parcels.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: AppColors.slate300,
                          ),
                          const SizedBox(height: AppDimensions.spacing4),
                          Text(
                            'لا توجد طرود حالياً',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.slate500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing4,
                    ),
                    itemCount: state.parcels.length,
                    itemBuilder: (context, index) {
                      return ParcelCard(
                        parcel: state.parcels[index],
                        onTap: () {
                          // TODO: Navigate to details
                        },
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
